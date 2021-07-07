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
	static String sql = "";
	static int i = 0;
	
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
					sql =  "SELECT A.OBJECT_NAME AS TABLE_NAME,  A.OBJECT_TYPE AS OBJECT_TYPE, B.COMMENTS AS COMMENTS "
							+ "FROM ALL_OBJECTS A,  ALL_TAB_COMMENTS B "
							+ "WHERE A.OWNER='" +serverObj.get("USER_ID").toString().toUpperCase() + "'"
							+ "AND B.OWNER='" +serverObj.get("USER_ID").toString().toUpperCase() + "'"
							+ "AND A.OBJECT_NAME = B.TABLE_NAME "
							+ "AND A.OBJECT_NAME NOT IN ('TOAD_PLAN_TABLE','PLAN_TABLE')  "
							+ "AND A.OBJECT_NAME NOT LIKE 'MDRT%' "
							+ "AND A.OBJECT_NAME NOT LIKE 'MDXT%' "		
							+ "AND A.OBJECT_TYPE LIKE '%"+serverObj.get("OBJECT_TYPE").toString().toUpperCase()+"%' "
							+ "AND A.OBJECT_NAME Like '%" +serverObj.get("TABLE_NM").toString().toUpperCase() + "%' "
							+ "AND A.OBJECT_TYPE IN ('TABLE', 'VIEW') ORDER BY 1 ";
							/*+ "AND A.OBJECT_TYPE IN ('TABLE') ORDER BY 1 ";*/
					
					ResultSet oraRs = stmt.executeQuery(sql);				
					int o = 0;
					while (oraRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", oraRs.getString("table_name"));
							jsonObj.put("obj_type", oraRs.getString("object_type"));
							jsonObj.put("obj_description",oraRs.getString("comments"));
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;

			//MS-SQL
				case "TC002202" :
					
					String table_type = serverObj.get("OBJECT_TYPE").toString();	

					if(serverObj.get("OBJECT_TYPE").toString().equals("TABLE")){
						table_type= "U";
					}else if(serverObj.get("OBJECT_TYPE").toString().equals("VIEW")){
						table_type= "V";
					}
											
					sql = /*"SELECT "
							+ "AA.TABLE_NAME, AA.TABLE_TYPE"
							+ "FROM ("*/
							 "SELECT LOWER(name) AS TABLE_NAME,"
							+ "(CASE WHEN TYPE = 'U' THEN 'TABLE' "
							+ "WHEN TYPE ='V' THEN 'VIEW' "
							+ "END)AS TABLE_TYPE "
							+ "FROM sys.objects A "
							+ "WHERE 1=1"
							+ "AND schema_id=(SELECT schema_id FROM sys.schemas WHERE name='"+serverObj.get("SCHEMA") +"') "												
							//+ "AND type in ('U') "
							+ "AND type in ('U', 'V')"			
							+ "AND LOWER(name) LIKE '%" + serverObj.get("TABLE_NM") + "%'"
							+ "AND TYPE LIKE '%" +table_type+ "%'"
							+ "ORDER BY 1";
			
			
					ResultSet msRs = stmt.executeQuery(sql);				
					i = 0;
					while (msRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", msRs.getString("table_name"));
							jsonObj.put("obj_type", msRs.getString("table_type"));
							jsonObj.put("obj_description","");
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;
					
			//MySQL
				case "TC002203" :

					sql = " SELECT table_name, table_type "
							+ "FROM information_schema.tables "
							+ "WHERE table_schema='"+serverObj.get("SCHEMA") +"' "													
//							+ "AND table_type IN ('BASE TABLE') "
							+ "AND table_type IN ('BASE TABLE','VIEW') "
							+ "AND table_type Like '%" + serverObj.get("OBJECT_TYPE").toString().toUpperCase() + "%' "
							+ "AND table_name Like '%"+ serverObj.get("TABLE_NM") +"%' ORDER BY 1";
					
					ResultSet mysRs = stmt.executeQuery(sql);				
					i = 0;
					while (mysRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", mysRs.getString("table_name"));
							jsonObj.put("obj_type", mysRs.getString("table_type"));
							jsonObj.put("obj_description","");
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;					
					
			//PostgreSQL		
				case "TC002204" :
					sql = "SELECT n.nspname, c.relname, obj_description(c.oid) "
							+ "FROM pg_catalog.pg_class c inner join pg_catalog.pg_namespace n on c.relnamespace=n.oid "
							+ "WHERE c.relkind = 'r' and nspname ='"+serverObj.get("SCHEMA") +"' and c.relname LIKE '%" + serverObj.get("TABLE_NM") + "%' ORDER BY c.relname";

					ResultSet rs = stmt.executeQuery(sql);				
					i = 0;
					while (rs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", rs.getString("relname"));
							jsonObj.put("obj_type", "");
							jsonObj.put("obj_description", rs.getString("obj_description"));
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;

			//DB2		
				case "TC002205" :
						sql = "		SELECT A.TABLE_NAME AS TABLE_NAME, A.TABLE_TYPE  AS TABLE_TYPE,  B.REMARKS AS COMMENTS "
								+ "FROM SYSIBM.TABLES A, SYSIBM.SYSTABLES B "
								+ "WHERE A.TABLE_SCHEMA = '" +serverObj.get("USER_ID").toString().toUpperCase() + "' "
								+ "AND A.TABLE_NAME = B.NAME "
								+ "AND A.TABLE_NAME LIKE '%" +serverObj.get("TABLE_NM").toString().toUpperCase() + "%' "
								+ "AND A.TABLE_TYPE LIKE '%" +serverObj.get("OBJECT_TYPE").toString().toUpperCase() + "%'"
								/*+ "AND A.TABLE_TYPE IN ('BASE TABLE') "*/
								+ "AND A.TABLE_TYPE IN ('BASE TABLE','VIEW')"
								+ "ORDER BY 1";
			
						ResultSet db2Rs = stmt.executeQuery(sql);				
						i = 0;
						while (db2Rs.next()) {
							i++;
							JSONObject jsonObj = new JSONObject();
								jsonObj.put("rownum",i);
								jsonObj.put("table_name", db2Rs.getString("table_name"));
								jsonObj.put("obj_type", db2Rs.getString("table_type"));
								jsonObj.put("obj_description", db2Rs.getString("comments"));
								jsonArray.add(jsonObj);
						}
						result.put("RESULT_CODE", 0);
						result.put("RESULT_DATA", jsonArray);
						
					break;			
					
			//SyBaseASE	
				case "TC002206" :
						sql = "		SELECT name AS table_name "
									+ "FROM sysobjects "
									+ "WHERE user_name(uid)='" +serverObj.get("USER_ID").toString().toUpperCase() + "' "
									+ "AND type in ('U')"
									+ "AND name LIKE '%" +serverObj.get("TABLE_NM").toString().toUpperCase()  + "%' "
									+ "ORDER BY 1";
						
						ResultSet syRs = stmt.executeQuery(sql);				
						i = 0;
						while (syRs.next()) {
							i++;
							JSONObject jsonObj = new JSONObject();
								jsonObj.put("rownum",i);
								jsonObj.put("table_name", syRs.getString("table_name"));
								jsonObj.put("obj_type", "");
								jsonObj.put("obj_description", "");
								jsonArray.add(jsonObj);
						}
						result.put("RESULT_CODE", 0);
						result.put("RESULT_DATA", jsonArray);
						
					break;
					
				//CUBRID
				case "TC002207" :
					String type = serverObj.get("OBJECT_TYPE").toString().toUpperCase();
					String ObjectSql = null;
					if(type.equals("TABLE")){
						ObjectSql = "AND class_type NOT LIKE '%V%' ";
					}else if(type.equals("VIEW")){
						ObjectSql = "AND class_type LIKE '%VCLASS%' ";
					}else{
						ObjectSql = "AND class_type LIKE '%%' ";
					}
					
					sql= "SELECT class_name AS table_name, case when class_type='CLASS' then 'TABLE' when class_type='VCLASS' then 'VIEW' end AS class_type "
						+ "FROM db_class "
						+ "WHERE owner_name ='" +serverObj.get("USER_ID").toString().toUpperCase() + "'"
						+ "AND is_system_class='NO' "
						+ "AND class_name LIKE '%" +serverObj.get("TABLE_NM").toString().toUpperCase()  + "%' "
						+ ObjectSql
						+ "ORDER BY class_name ASC";

					ResultSet cubRs = stmt.executeQuery(sql);				
					i = 0;
					while (cubRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", cubRs.getString("table_name"));
							jsonObj.put("obj_type", cubRs.getString("class_type"));
							jsonObj.put("obj_description","");
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;
			//Tibero		
				case "TC002208" :
					sql = "		SELECT OBJECT_NAME as TABLE_NAME , OBJECT_TYPE AS OBJECT_TYPE, SUBOBJECT_NAME AS COMMENTS FROM ALL_OBJECTS "
							+ "WHERE OWNER='" +serverObj.get("USER_ID").toString().toUpperCase() + "'"
							+ "AND OBJECT_NAME NOT IN ('TOAD_PLAN_TABLE','PLAN_TABLE') "
							+ "AND OBJECT_NAME NOT LIKE 'MDRT%'"
							+ "AND OBJECT_NAME NOT LIKE 'MDXT%'"
							+ "AND OBJECT_TYPE LIKE '%"+serverObj.get("OBJECT_TYPE").toString().toUpperCase()+"%' "
							+ "AND OBJECT_NAME LIKE '%" +serverObj.get("TABLE_NM").toString().toUpperCase()  + "%' "
							+ "AND OBJECT_TYPE IN ('TABLE', 'VIEW') ORDER BY 1 ";
					
					ResultSet tibRs = stmt.executeQuery(sql);				
					i = 0;
					while (tibRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", tibRs.getString("table_name"));
							jsonObj.put("obj_type", tibRs.getString("object_type"));
							jsonObj.put("obj_description",tibRs.getString("comments"));
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
					break;		
					
					
				//Maria
				case "TC002209" :

					sql = " SELECT table_name "
							+ "FROM information_schema.tables "
							+ "WHERE table_schema='"+serverObj.get("SCHEMA") +"' "													
//							+ "AND table_type IN ('BASE TABLE') "
							+ "AND table_type IN ('BASE TABLE','VIEW') "
							+ "AND table_name Like '%"+ serverObj.get("TABLE_NM") +"%' "
							+ "ORDER BY 1";
					
					ResultSet mariaRs = stmt.executeQuery(sql);				
					i = 0;
					while (mariaRs.next()) {
						i++;
						JSONObject jsonObj = new JSONObject();
							jsonObj.put("rownum",i);
							jsonObj.put("table_name", mariaRs.getString("table_name"));
							jsonObj.put("obj_type", "");
							jsonObj.put("obj_description","");
							jsonArray.add(jsonObj);
					}
					result.put("RESULT_CODE", 0);
					result.put("RESULT_DATA", jsonArray);
					
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
			serverObj.put(ClientProtocolID.SERVER_PORT, "60000");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "sample");
			serverObj.put(ClientProtocolID.USER_ID, "inst105");
			serverObj.put(ClientProtocolID.USER_PWD, "inst105");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002205");*/
			
			//MS-SQL
			serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.216");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.216");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1434");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "gs");
			serverObj.put(ClientProtocolID.SCHEMA, "dbo");
			serverObj.put(ClientProtocolID.USER_ID, "sa");
			serverObj.put(ClientProtocolID.USER_PWD, "sa0225!!");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002202");
			
			//Oracle
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.21.151");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.21.151");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1521");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "SUPER");
			serverObj.put(ClientProtocolID.USER_ID, "ORAFIV");
			serverObj.put(ClientProtocolID.USER_PWD, "ORAFIV");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002201");*/
			
			//PostgreSQL
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "experdb");
			serverObj.put(ClientProtocolID.USER_ID, "experdb");
			serverObj.put(ClientProtocolID.USER_PWD, "experdb");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");
			serverObj.put(ClientProtocolID.SCHEMA, "experdb_management");
			serverObj.put(ClientProtocolID.TABLE_NM, "t_adtcngdb_i");*/
			
			//CUBRID
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "33000");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "demodb");
			serverObj.put(ClientProtocolID.USER_ID, "db2pg");
			serverObj.put(ClientProtocolID.USER_PWD, "db2pg");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002207");*/
			
			//SyBaseASE
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5000");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "db2pg");
			serverObj.put(ClientProtocolID.USER_ID, "sa");
			serverObj.put(ClientProtocolID.USER_PWD, "sa0225!!");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002206");*/
			
			//Tibero
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_PORT, "8629");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "tibero");
			serverObj.put(ClientProtocolID.USER_ID, "test");
			serverObj.put(ClientProtocolID.USER_PWD, "test");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002208");*/
			
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1521");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "PIDSVR");
			serverObj.put(ClientProtocolID.USER_ID, "DB2PG");
			serverObj.put(ClientProtocolID.USER_PWD, "db2pg");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002201");*/

			JSONObject result = getTblList(serverObj);
			
			System.out.println(result.get("RESULT_CODE"));
			System.out.println(result.get("RESULT_DATA"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
