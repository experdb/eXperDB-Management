package com.k4m.dx.tcontrol.transfer;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.db2pg.cmmn.DBCPPoolManager;

public class TransferSchemaInfo {


	public TransferSchemaInfo(){}
	static String sql = "";
	static int i = 0;
	
	public static  JSONObject getSchemaList(JSONObject serverObj) throws Exception {
		
		Connection conn = null;
		String DB_TYPE = serverObj.get("DB_TYPE").toString();	

		JSONArray jsonArray = new JSONArray(); // 객체를 담기위해 JSONArray 선언.
		JSONObject result = new JSONObject();
		
		try{
			conn  = DBCPPoolManager.makeConnection(serverObj);
			
			 System.out.println("DB_VERSION  = "+conn.getMetaData().getDatabaseMajorVersion());
			 
			Statement stmt = conn.createStatement();
			
			switch (DB_TYPE) {
			
			//오라클
				case "TC002201" :
			
					break;
					
			//MS-SQL
				case "TC002202" :
				
					break;
					
			//MySQL
				case "TC002203" :

					break;					
					
			//PostgreSQL		
				case "TC002204" :
					sql = "SELECT n.nspname"
							+ " FROM pg_catalog.pg_namespace n"
							+ " WHERE n.nspname !~ '^pg_' "
							+ " AND n.nspname <> 'information_schema' "
							+ " AND n.nspname LIKE '%"+serverObj.get("SCHEMA") + "%'"
							+ " ORDER BY 1";

					ResultSet rs = stmt.executeQuery(sql);				
					i = 0;
					while (rs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("schema_name", rs.getString("nspname"));
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;
					
			//DB2		
				case "TC002205" :
						
					break;			
					
			//SyBaseASE	
				case "TC002206" :
						
					break;
					
				//CUBRID
				case "TC002207" :
			
					
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
}
