package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;

public class DatabaseTableInfo {
	
	public DatabaseTableInfo(){}
	
	
	public static  JSONObject getTblList(JSONObject serverObj) throws Exception {
		
		Connection conn = null;
		String DB_TYPE = serverObj.get("DB_TYPE").toString();
		
		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		
		try{
			conn  = DBCPPoolManager.makeConnection(serverObj);
			
			 System.out.println("DB_VERSION  = "+conn.getMetaData().getDatabaseMajorVersion());
	         System.out.println("ORG_SCHEMA_NM  = "+conn.getMetaData().getUserName());
	            
			Statement stmt = conn.createStatement();
			
			switch (DB_TYPE) {
			//오라클
				case "TC002201" :

					break;
			//PostgreSQL		
				case "TC002204" :
					String sql = "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='" +serverObj.get("USER_ID") +"' AND TABLE_NAME LIKE '%" + serverObj.get("TABLE_NM") + "%' ORDER BY TABLE_NAME";    				

					ResultSet rs = stmt.executeQuery(sql);				
					int i = 0;
					while (rs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", rs.getString("TABLE_NAME"));
							jsonObj.put("table_schema", rs.getString("TABLE_SCHEMA"));
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;
			//MS-SQL
				case "TC002202" :

					break;
			//SyBaseASE	
				case "TC002206" :

					break;
			//DB2		
				case "TC002205" :

					break;
			//Tibero		
				case "TC002208" :

					break;										
    			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}		
		return result;		
	}

	
	@SuppressWarnings("unchecked")
	public static void main(String args[]) {
    	JSONObject serverObj = new JSONObject();
    	
		try {
			
			//DB2
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "48789");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "db2");
			serverObj.put(ClientProtocolID.USER_ID, "db2");
			serverObj.put(ClientProtocolID.USER_PWD, "db20225!!");
			serverObj.put(ClientProtocolID.DB_TYPE, "DB2");*/		
			
			//MS-SQL
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "10.1.21.28");
			serverObj.put(ClientProtocolID.SERVER_IP, "10.1.21.28");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1444");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "mizuho");
			serverObj.put(ClientProtocolID.USER_ID, "mizuho");
			serverObj.put(ClientProtocolID.USER_PWD, "mizuho");
			serverObj.put(ClientProtocolID.DB_TYPE, "MSS");*/
			
			//Oracle
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.118");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.118");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1521");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "ora12c");
			serverObj.put(ClientProtocolID.USER_ID, "migrator");
			serverObj.put(ClientProtocolID.USER_PWD, "migrator");
			serverObj.put(ClientProtocolID.DB_TYPE, "ORA");*/
			
			//PostgreSQL
			serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "kimjy");
			serverObj.put(ClientProtocolID.USER_ID, "kimjy");
			serverObj.put(ClientProtocolID.USER_PWD, "kimjy");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");
			serverObj.put(ClientProtocolID.TABLE_NM, "test");
			
			JSONObject result = getTblList(serverObj);
			
			System.out.println(result.get("RESULT_CODE"));
			System.out.println(result.get("RESULT_DATA"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
