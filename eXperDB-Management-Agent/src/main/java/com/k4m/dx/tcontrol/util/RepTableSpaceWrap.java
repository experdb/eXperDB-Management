package com.k4m.dx.tcontrol.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.server.SocketExt;
import com.k4m.dx.tcontrol.socket.ProtocolID;

public class RepTableSpaceWrap extends Thread {
	
	private JSONObject jObj;
	private String strPGRBAK;
	private String strRESTORE_DIR;
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public RepTableSpaceWrap(JSONObject jObj, String strPGRBAK, String strRESTORE_DIR){
		this.jObj = jObj;
		this.strPGRBAK = strPGRBAK;
		this.strRESTORE_DIR = strRESTORE_DIR;
	}
	
	public RepTableSpaceWrap(){}

	@Override
	public void run(){
		try {
			
			JSONObject objSERVER_INFO = new JSONObject(); 
			objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
			
			changeTableSpacePath(objSERVER_INFO, strPGRBAK, strRESTORE_DIR);
		} catch (Exception e) {
			errLogger.error("[changeTableSpacePath run] {} ", e.toString());
		}
	}
	
	
	private void changeTableSpacePath(JSONObject jObj, String strPGRBAK, String strRESTORE_DIR) throws Exception {
		SqlSessionFactory sqlSessionFactory = null;
		
		JSONObject resDataObj = new JSONObject();
		
		sqlSessionFactory = SqlSessionManager.getInstance();
		
		String poolName = "" + jObj.get(ProtocolID.SERVER_IP) + "_" + jObj.get(ProtocolID.DATABASE_NAME) + "_" + jObj.get(ProtocolID.SERVER_PORT);
		
		Connection connDB = null;
		SqlSession sessDB = null;
		List<Object> selectTablespaceLocationList = new ArrayList<Object>();
		
		
		try {
			
			SocketExt.setupDriverPool(jObj, poolName);

			try {
			//DB 컨넥션을 가져온다.
			connDB = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
			sessDB = sqlSessionFactory.openSession(connDB);
			
			} catch(Exception e) {

			}
			
			selectTablespaceLocationList = sessDB.selectList("app.selectTablespaceLocation");
			
			for(int i=0; i<selectTablespaceLocationList.size(); i++) {
				HashMap hp = new HashMap();
				hp = (HashMap) selectTablespaceLocationList.get(i);
				
				String tablespace_location = (String) hp.get("tablespace_location");
				String newTablespace_location = strRESTORE_DIR + tablespace_location;
				String strReplaceCmd = "find " + strPGRBAK + " -name \"mkdirs.sh\" -exec perl -pi -e 's/" + replaceSlash(tablespace_location) + "/" + replaceSlash(newTablespace_location) + "/g' {} \\;";
				
				
				socketLogger.info("rman replace command >> " + strReplaceCmd);
				
				if (!tablespace_location.equals("")) {

					ExecRmanReplaceTableSpace execRmanReplaceTableSpace = new ExecRmanReplaceTableSpace(strReplaceCmd);
					
					execRmanReplaceTableSpace.start();
					
					synchronized(execRmanReplaceTableSpace) {
						execRmanReplaceTableSpace.wait();
					}
				}
			}
			
		} catch (Exception e) {
			errLogger.error("[changeTableSpacePath] {} ", e.toString());

		} finally {

			if(sessDB !=null) sessDB.close();
			if(connDB !=null) connDB.close();		

		}	
	}
	
	
	private String replaceSlash(String strInput) throws Exception {
		String strResult = "";
		
		strResult = strInput.replaceAll("/", "\\\\/");
		return strResult;
	}
	
}
