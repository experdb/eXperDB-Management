package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.lang.ref.WeakReference;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.SqlSessionManager;
import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.ServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.NetworkUtil;
import com.k4m.dx.tcontrol.util.RunCommandExec;
import com.k4m.dx.tcontrol.util.TransRunCommandExec;

/**
 * 	테이블 스페이스 정보
 *
 * @author 변승우
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2020.08.26   변승우 최초 생성
 * </pre>
 */

public class DxT042 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	
	private String strCmd = "df -hT | grep ^/dev | grep -v efi";
	
	
	public DxT042(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT042.execute : " + strDxExCode);
		
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		HashMap resultHP = new HashMap();
		JSONObject outputObj = new JSONObject();
		
		try {
			//파일시스템정보
			CommonUtil util = new CommonUtil();
			String strFileSystem = util.getCmdExec(strCmd);
			
			ArrayList<HashMap<String, String>> flist = fileSystemList(strFileSystem);			
			ArrayList<HashMap<String, String>> mappingList = mappingSystem(flist);
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, mappingList);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT042 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT039);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT039);
			outputObj.put(ProtocolID.ERR_MSG, "DxT042 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} finally {
			
			outputObj = null;
			sendBuff = null;
		}	

	}
	
	

	
	
	

	
	private ArrayList fileSystemList(String strFileSystem) throws Exception {
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		
		System.out.println("### strFileSystem : " + strFileSystem);
		
		if(strFileSystem.length() > 0) {
			String[] arrFileSystem = strFileSystem.split("\n");
			int intFileI = 0;
			for(String st: arrFileSystem) {
				//System.out.println("### intFileI : " + intFileI);
				if(intFileI >= 0) {
					HashMap hp = new HashMap();
			    	  String[] arrStr = st.split(" ");
			    	  int lineT = 0;
			    	  for(int i=0; i<arrStr.length; i++) {
			    		  if(!arrStr[i].toString().trim().equals("")) {
				    		  if(lineT == 0) {
				    			  hp.put("filesystem", arrStr[i].toString());
				    		  } else if(lineT == 1) {
				    			  hp.put("type", arrStr[i].toString());
				    		  } else if(lineT == 2) {
				    			  hp.put("size", arrStr[i].toString());
				    		  } else if(lineT == 3) {
				    			  hp.put("used", arrStr[i].toString());
				    		  } else if(lineT == 4) {
				    			  hp.put("avail", arrStr[i].toString());
				    		  } else if(lineT == 5) {
				    			  hp.put("use", arrStr[i].toString());
				    		  }	else if(lineT == 6) {
				    			  hp.put("mounton", arrStr[i].toString());
				    		  }					    
	
				    		  lineT = lineT + 1;
			    		  }
			    	  }
			    	  list.add(hp);
				}			
				intFileI++;
			}
		}		
		return list;
	}
	
	
	
	/*
	 * 파일시스템 정보, 테이블스페이스 정보 매핑
	 * @param flist
	 * @param listTableSpaceInfo
	 * @return
	 * @throws Exception
	 */
	private ArrayList<HashMap<String, String>> mappingSystem(ArrayList<HashMap<String, String>> flist
			) throws Exception {
		
		ArrayList<HashMap<String, String>> arrMapping = new ArrayList<HashMap<String, String>>();
		
		for(HashMap hp:flist) {
			
			String mounton = (String) hp.get("mounton");
			String use = (String) hp.get("use");
			String avail = (String) hp.get("avail");
			String used = (String) hp.get("used");
			String filesystem = (String) hp.get("filesystem");
			String fsize = (String) hp.get("size");
			String type = (String) hp.get("type");
	
			HashMap hpMapping = new HashMap();
			
			hpMapping.put("mounton", mounton);
			hpMapping.put("type", type);
			hpMapping.put("use", use);
			hpMapping.put("avail", avail);
			hpMapping.put("used", used);
			hpMapping.put("filesystem", filesystem);
			hpMapping.put("fsize", fsize);
			
			arrMapping.add(hpMapping);
		}

		return arrMapping;
	}

}


