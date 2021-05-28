package com.experdb.management.backup.cmmn;

import java.io.*;
import java.sql.ResultSet;
import java.sql.Statement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.db2pg.cmmn.DBCPPoolManager;

public class Node {
	
	static String sql = "";
	static int i = 0;

	
	/**
	 * addNode 노드 추가
	 * @param  TargetMachineVO targetMachineVO 
	 * @return 
	 */
	public static JSONObject addNode(TargetMachineVO targetMachineVO) {
		
		JSONObject result = new JSONObject();		
		CmmnUtil cmmUtil = new CmmnUtil();
		
		String path = "/opt/Arcserve/d2dserver/bin";
		String cmd =null;
		
		try {
			//사용자유저 사용 체크하지 않았을시
			if(targetMachineVO.getIsUser().equals("false")){
				cmd = "./d2dnode --add=" + targetMachineVO.getName() + " --user=" + targetMachineVO.getUser() + " --password=" + targetMachineVO.getPassword() + " --description="+targetMachineVO.getDescription()+" --force";
			}else{		
				/*--user=username
				루트가 아닌 사용자의 이름을 지정합니다.				
				--password=password
				루트가 아닌 사용자의 암호를 지정합니다. 				
				--rootuser=rootaccount
				루트 사용자의 이름을 지정합니다.				
				--rootpwd=rootpassword
				루트 사용자의 암호를 지정합니다. */
				cmd = "./d2dnode --add=" + targetMachineVO.getName() + " --user=" + targetMachineVO.getUserName()+ " --password=" + targetMachineVO.getUserPw() + " --rootuser=" + targetMachineVO.getUser() + " --rootpwd=" + targetMachineVO.getPassword() + " --description="+targetMachineVO.getDescription()+" --force";
			}
			String strCmd = "cd " + path + ";" + cmd;

			System.out.println("노드 등록 명령어 = " + strCmd);
		
			result = cmmUtil.execute(strCmd,"node");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}
	
	
	
	/**
	 * modifyNode 노드 수정
	 * @param  TargetMachineVO targetMachineVO  
	 * @return 
	 */
	public static JSONObject modifyNode(TargetMachineVO targetMachineVO) {
		
		JSONObject result = new JSONObject();		
		CmmnUtil cmmUtil = new CmmnUtil();
		
		String path = "/opt/Arcserve/d2dserver/bin";
		String cmd =null;
		
		try {
			//사용자유저 사용 체크하지 않았을시
			if(targetMachineVO.getIsUser().equals("false")){
				cmd = "./d2dnode --modify=" + targetMachineVO.getName() + " --user=" + targetMachineVO.getUser() + " --password=" + targetMachineVO.getPassword() + " --description="+targetMachineVO.getDescription()+ " --force";
			}else{		
				/*--user=username
				루트가 아닌 사용자의 이름을 지정합니다.				
				--password=password
				루트가 아닌 사용자의 암호를 지정합니다. 				
				--rootuser=rootaccount
				루트 사용자의 이름을 지정합니다.				
				--rootpwd=rootpassword
				루트 사용자의 암호를 지정합니다. */
				cmd = "./d2dnode --modify=" + targetMachineVO.getName() + " --user=" + targetMachineVO.getUserName()+ " --password=" + targetMachineVO.getUserPw() + " --rootuser=" + targetMachineVO.getUser() + " --rootpwd=" + targetMachineVO.getPassword() + " --description="+targetMachineVO.getDescription()+" --force";
			}
			String strCmd = "cd " + path + ";" + cmd;

			System.out.println("노드 수정 명령어 = " + strCmd);
		
			result = cmmUtil.execute(strCmd,"node");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}
	
	
	
	/**
	 * deleteNode 노드 삭제
	 * @param  host  
	 * @param  username 
	 * @param  password
	 * @return 
	 */
	public static JSONObject deleteNode(String host) {
		
		JSONObject result = new JSONObject();	
		CmmnUtil cmmUtil = new CmmnUtil();
		
		String xmlFile = host.replace(".", "_").trim()+".xml";
		File f = new File(ServiceContext.getInstance().getHomePath() + "/bin/jobs/" +xmlFile);
		System.out.println("xml파일 경로 : " + ServiceContext.getInstance().getHomePath() + "/bin/jobs/" +xmlFile);
		System.out.println("xml 파일이 존재?? : " + f.exists());
		
		try {
			if(f.exists()){
				String path = "/opt/Arcserve/d2dserver/bin";
				String cmd = "./d2dnode --delete=" + host;
				String delCmd = "rm -rf "+ServiceContext.getInstance().getHomePath()+"/bin/jobs/"+xmlFile;
				String strCmd = "cd " + path + ";" + cmd + ";" + delCmd;
				System.out.println("노드/파일 삭제  명령어 = " + strCmd);
				result = cmmUtil.execute(strCmd,"node");
			}else{
				String path = "/opt/Arcserve/d2dserver/bin";
				String cmd = "./d2dnode --delete=" + host;
				String strCmd = "cd " + path + ";" + cmd;
				System.out.println("노드 삭제 명령어 = " + strCmd);
				result = cmmUtil.execute(strCmd,"node");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}

	

	/**
	 * getNodeList 노드리스트 조회
	 * @param serverObj
	 */
	public static  TargetMachineVO getOneNodeList(JSONObject serverObj, String name) throws Exception {
		
		//Arcserve repoDB 정보
		serverObj.put(ClientProtocolID.SERVER_NAME, "Postgresql");
		serverObj.put(ClientProtocolID.SERVER_IP, "192.168.50.130");
		serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
		serverObj.put(ClientProtocolID.DATABASE_NAME, "ARCserveLinuxD2D");
		serverObj.put(ClientProtocolID.USER_ID, "d2duser");
		serverObj.put(ClientProtocolID.USER_PWD, "");
		serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");
		
		java.sql.Connection conn = null;
		
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		TargetMachineVO target = new TargetMachineVO();
		
		try{
			conn  = DBCPPoolManager.makeConnection(serverObj);
			Statement stmt = conn.createStatement();
			
			sql = "SELECT *"
					+ " FROM TargetMachine"
					+ " WHERE name = '" +name+ "'" ;
			ResultSet rs = stmt.executeQuery(sql);				
			i = 0;
			while (rs.next()) {
				i++;
				
				target.setRownum(i);
				target.setName(rs.getString("name"));
				target.setUser(rs.getString("user"));
				target.setPassword(rs.getString("password"));
				target.setOperatingSystem(rs.getString("operatingsystem"));
				target.setDescription(rs.getString("description"));
				target.setIsProtected(rs.getString("isprotected"));
				target.setJobName(rs.getString("jobname"));
				target.setConnectionStatus(Integer.parseInt(rs.getString("connectionstatus")));
				target.setLastResult(Integer.parseInt(rs.getString("lastresult")));
				target.setRecoveryPointCount(Integer.parseInt(rs.getString("recoverypointcount")));
				//target.setRecoverySetCount(Integer.parseInt(rs.getString("recoverysetcount")));
				target.setBackupLocationType(Integer.parseInt(rs.getString("backuplocationtype")));
				//target.setMachineType(Integer.parseInt(rs.getString("machinetype")));
				target.setUuid(rs.getString("uuid"));
				target.setLicenseStatus(Integer.parseInt(rs.getString("licensestatus")));
				//target.setExcludeVolumes(Integer.stringrs.getString("excludevolumes"));
			}

		}catch(Exception e){
			e.printStackTrace();
		}		
		return target;		
	}
	
	
	
	
	/**
	 * getNodeList 노드리스트 조회
	 * @param serverObj
	 */
	public static  JSONObject getNodeList(JSONObject serverObj) throws Exception {
		
		//Arcserve repoDB 정보
		serverObj.put(ClientProtocolID.SERVER_NAME, "Postgresql");
		serverObj.put(ClientProtocolID.SERVER_IP, "192.168.50.130");
		serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
		serverObj.put(ClientProtocolID.DATABASE_NAME, "ARCserveLinuxD2D");
		serverObj.put(ClientProtocolID.USER_ID, "d2duser");
		serverObj.put(ClientProtocolID.USER_PWD, "");
		serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");
		
		java.sql.Connection conn = null;
		
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		
		try{
			conn  = DBCPPoolManager.makeConnection(serverObj);
			Statement stmt = conn.createStatement();
			
			sql = "SELECT *"
					+ " FROM TargetMachine";

			ResultSet rs = stmt.executeQuery(sql);				
			i = 0;
			while (rs.next()) {
				i++;
				JSONObject jsonObj = new JSONObject();
					jsonObj.put("rownum",i);
					jsonObj.put("name", rs.getString("name"));
					jsonObj.put("user", rs.getString("user"));
					jsonObj.put("password", rs.getString("password"));
					jsonObj.put("operatingSystem", rs.getString("operatingsystem"));
					jsonObj.put("description", rs.getString("description"));
					jsonObj.put("isProtected", rs.getString("isprotected"));
					jsonObj.put("jobName", rs.getString("jobname"));
					jsonObj.put("licenseStatus", rs.getString("licensestatus"));
					jsonObj.put("connectionStatus", rs.getString("connectionstatus"));
					jsonObj.put("lastResult", rs.getString("lastresult"));
					jsonObj.put("recoveryPointCount", rs.getString("recoverypointCount"));
					jsonObj.put("recoverySetCount", rs.getString("recoverysetCount"));
					jsonObj.put("excludeVolumes", rs.getString("excludevolumes"));
					jsonObj.put("backupLocationType", rs.getString("backuplocationtype"));
					jsonObj.put("machineType", rs.getString("machinetype"));
					jsonObj.put("uuid", rs.getString("uuid"));
					
					jsonArray.add(jsonObj);
			}
			result.put("RESULT_CODE", 0);
			result.put("RESULT_DATA", jsonArray);
			
		}catch(Exception e){
			e.printStackTrace();
		}		
		return result;		
	}
	
	
	public static void main(String[] args) {
	
		Node node = new Node();
		
		JSONObject serverObj = new JSONObject();
		JSONObject nodeResult = new JSONObject();
		
		TargetMachineVO oneNodeResult = new TargetMachineVO();
		
		JSONObject result = new JSONObject();
		
		String host = "192.168.50.131";
		String username = "root";
		String password = "root0225a!!";

		try{
			oneNodeResult.setName("192.168.50.131");
			oneNodeResult.setUser("root");		
			oneNodeResult.setPassword("root0225a!!");
			
			//사용자계정 사용여부
			oneNodeResult.setIsUser("false");
			//root가 아닌 사용자 ID
			oneNodeResult.setUserName("experdb");
			//root가 아닌 사용자 PW
			oneNodeResult.setUserPw("experdb0225!!");
			
			//노드등록
			result = node.addNode(oneNodeResult);
			System.out.println("RESULT_CODE =" + result.get("RESULT_CODE"));
			System.out.println("RESULT_DATA =" + result.get("RESULT_DATA"));
			
			//노드삭제
			//result = node.deleteNode(host);
			//System.out.println("RESULT_CODE =" + result.get("RESULT_CODE"));
			//System.out.println("RESULT_DATA =" + result.get("RESULT_DATA"));
			
			
			//전체노드 조회
			//nodeResult = getNodeList(serverObj);
			//System.out.println("노드리스트  ="+ nodeResult.get("RESULT_DATA"));
			
			//선택노드 조회
			//String name = "192.168.20.128";
			//oneNodeResult = getOneNodeList(serverObj,name);
			//System.out.println("선택노드  ="+ oneNodeResult.getOperatingSystem());
			
		}catch(Exception e){
			e.printStackTrace();
		}

		
		// ./d2dnode --add=192.168.50.130 --user=root --password=root
		// --description="the description of that node"
		// cd /opt/Arcserve/d2dserver/bin

		// UUID one = UUID.randomUUID();
		// System.out.println("UUID One: " + one.toString());
	}

	
	


}
