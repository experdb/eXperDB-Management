package com.k4m.dx.tcontrol.db2pg.cmmn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.dbcp.PoolingDriver;
import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;


public class DBCPPoolManager {
	
	static String DBMS_TYPE = "";
	static String conn_time = "";
	
	public DBCPPoolManager(){}

	public static  Map<String, Object> setupDriver(JSONObject serverObj) throws Exception {
		System.out.println( "/************************************************************/");
		System.out.println( "Database Connectioning . . . ");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		Connection conn = null;
				try {
				conn  = makeConnection(serverObj);
		
	            conn.setAutoCommit(false);
	           
	            String Server = "Server :  "+DBMS_TYPE+" "+conn.getMetaData().getDatabaseMajorVersion()+"."+conn.getMetaData().getDatabaseMinorVersion();
	            String Driver = "Driver :  "+conn.getMetaData().getDriverName()+" "+conn.getMetaData().getDriverVersion();
	            String Connected = "Connected   ("+conn_time+")";
	            
	            System.out.println(Server);
	            System.out.println(Driver);

	            System.out.println(Connected);
	            
	            System.out.println( "Database Connection Success!");
				System.out.println( "/************************************************************/");
				
	            result.put("RESULT_CODE", 0);
	            result.put("RESULT_Conn", Server+"\n"+Driver+"\n\n"+Connected);
         
				} catch (Exception e) {
					System.out.println( "Database Connection fail!");
					//shutdownDriver(poolName);

					if (e.toString() != null) {
						result.put("ERR_MSG", e.toString() );
					} else {
						result.put("ERR_MSG", "Database Connection fail!");
					}
					
					result.put("RESULT_CODE", 1);
					return result;	
	
				}
				return result;	
	}
	
	
	
	
	/*
	 * 풀명에 해당한는 풀 및 DB정보 close
	 */
    private static void shutdownDriver(String poolName) throws Exception {
		PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
		driver.closePool(poolName);
	}
    
    
	/*
	 * connection get
	 */
    public static Connection getConnection(String poolName) throws Exception {
    	Connection conn = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
    	/*
    	switch (getConfigInfo(poolName).DB_TYPE){
    		case Constant.DB_TYPE.ASE :
    			conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
    	}
    	*/
    	conn.setAutoCommit(false);
    	
    	return conn;
    }
    
    
    
    /**
	 * 커넥션을 취득해 반환 DB커넥션 취득
	 * 
	 * @param userId
	 * @param userPw
	 * @param dbName
	 * @param host
	 * @return conn 커넥션
	 */
	public static Connection makeConnection(JSONObject serverObj) throws SQLException {
		
		// TODO Auto-generated method stub
		Connection conn = null;
 
		String driver = "";
		 String connectURI = "";
		 Properties props = new Properties();
		String DB_TYPE = serverObj.get("DB_TYPE").toString();
		
		try {
			
			switch (DB_TYPE) {
				//오라클
				case "TC002201" :
					DBMS_TYPE = "Oracle";
					System.out.println("DB_TYPE.ORACLE");
					driver = "oracle.jdbc.driver.OracleDriver";
					connectURI = "jdbc:oracle:thin:@"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+"/"+serverObj.get("DATABASE_NAME");
					break;
					
				//MS-SQL
				case "TC002202" :
					DBMS_TYPE = "MS-SQL";
					System.out.println("DB_TYPE.MS-SQL");
					driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
					connectURI = "jdbc:sqlserver://"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+";databaseName="+serverObj.get("DATABASE_NAME");
					break;

				//MySQL
				case "TC002203" :
					DBMS_TYPE = "MySQL";
					driver ="com.mysql.jdbc.Driver";
					connectURI = "jdbc:mysql://"+serverObj.get("SERVER_IP")+"/"+serverObj.get("DATABASE_NAME");
					break;		
					
				//PostgreSQL		
				case "TC002204" :
					DBMS_TYPE = "PostgreSQL";
					System.out.println("DB_TYPE.PostgreSQL");
					driver = "org.postgresql.Driver" ;
					connectURI = "jdbc:postgresql://"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+"/"+serverObj.get("DATABASE_NAME");
					break;
					
					//DB2		
				case "TC002205" :
					DBMS_TYPE = "DB2";
					System.out.println("DB_TYPE.DB2");
					driver = "com.ibm.db2.jcc.DB2Driver" ;
					connectURI = "jdbc:db2://"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+"/"+serverObj.get("DATABASE_NAME");
					System.setProperty("db2.jcc.charsetDecoderEncoder", "3");
					break;
					
				//SyBaseASE	
				case "TC002206" :
					DBMS_TYPE = "Sybase ASE";
					System.out.println("DB_TYPE.Sybase ASE");
					driver = "com.sybase.jdbc4.jdbc.SybDriver" ;
					connectURI = "jdbc:sybase:Tds:"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+"/"+serverObj.get("DATABASE_NAME");

				/*	props.put("DATABASE", configInfo.DBNAME);
					if (configInfo.LOAD_MODE != null && configInfo.LOAD_MODE.equals(Constant.DIRECT_PATH_LOAD)){
						props.put("ENABLE_BULK_LOAD", "ARRAYINSERT_WITH_MIXED_STATEMENTS");
						Log.info(0, DBCPPoolManager.class, "PROPERTY : ENABLE_BULK_LOAD=ARRAYINSERT_WITH_MIXED_STATEMENTS");
					}*/
					break;
					
				//CUBRID	
				case "TC002207" :
					DBMS_TYPE = "CUBRID";
					System.out.println("DB_TYPE.CUBRID");
					System.out.println("DB_TYPE =" + DB_TYPE);
					driver = "cubrid.jdbc.driver.CUBRIDDriver";
					connectURI = "jdbc:CUBRID:"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+":"+serverObj.get("DATABASE_NAME")+":"+serverObj.get("USER_ID")+"::";
					break;		
								
				//Tibero		
				case "TC002208" :
					System.out.println("DB_TYPE.Tibero");
					System.out.println("DB_TYPE =" + DB_TYPE);
					driver = "com.tmax.tibero.jdbc.TbDriver";
					connectURI = "jdbc:tibero:thin:@"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+":"+serverObj.get("DATABASE_NAME");
					break;								
					
				//MariaDB
				case "TC002209" :
					DBMS_TYPE = "MariaDB";
					driver ="org.mariadb.jdbc.Driver";
					connectURI = "jdbc:mariadb://"+serverObj.get("SERVER_IP")+":"+serverObj.get("SERVER_PORT")+"/"+serverObj.get("DATABASE_NAME");
					break;		
					
    			}
			
			// 1. JDBC 드라이버 로드
			Class.forName(driver);

			//DB 연결대기 시간
			DriverManager.setLoginTimeout(5);
			
	        // ID and Password
	        props.put("user", serverObj.get("USER_ID"));
	        props.put("password", serverObj.get("USER_PWD"));

			// 2. DriverManager.getConnection()를 이용하여 Connection 인스턴스 생성
	        long start = System.currentTimeMillis();
			conn = DriverManager.getConnection(connectURI, props);
			long end = System.currentTimeMillis();
			conn_time=( end - start )/1000.0 +" ms";

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return conn;
	}
    
    

	@SuppressWarnings("unchecked")
	public static void main(String args[]) {
    	JSONObject serverObj = new JSONObject();
    	
		try {
			
			//DB2
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "60000");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "inst10");
			serverObj.put(ClientProtocolID.USER_ID, "inst10");
			serverObj.put(ClientProtocolID.USER_PWD, "inst10");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002205");*/
			
			//MS-SQL
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "10.1.21.28");
			serverObj.put(ClientProtocolID.SERVER_IP, "10.1.21.28");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1444");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "mizuho");
			serverObj.put(ClientProtocolID.USER_ID, "mizuho");
			serverObj.put(ClientProtocolID.USER_PWD, "mizuho");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002202");*/
			
			//Oracle
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.117");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.117");
			serverObj.put(ClientProtocolID.SERVER_PORT, "1521");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "orcl");
			serverObj.put(ClientProtocolID.USER_ID, "ibizspt");
			serverObj.put(ClientProtocolID.USER_PWD, "ibizspt");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002201");*/
			
			//PostgreSQL
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.112");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5432");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "kimjy");
			serverObj.put(ClientProtocolID.USER_ID, "kimjy");
			serverObj.put(ClientProtocolID.USER_PWD, "kimjy");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");*/
			
			//SyBaseASE
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.200");
			serverObj.put(ClientProtocolID.SERVER_PORT, "5000");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "db2pg");
			serverObj.put(ClientProtocolID.USER_ID, "sa");
			serverObj.put(ClientProtocolID.USER_PWD, "sa0225!!");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002206");*/
					
			//CUBRID
			serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_PORT, "3306");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "experdb");
			serverObj.put(ClientProtocolID.USER_ID, "experdb");
			serverObj.put(ClientProtocolID.USER_PWD, "experdb");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002209");
			
			//Tibero
			/*serverObj.put(ClientProtocolID.SERVER_NAME, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_IP, "192.168.56.105");
			serverObj.put(ClientProtocolID.SERVER_PORT, "8629");
			serverObj.put(ClientProtocolID.DATABASE_NAME, "tibero");
			serverObj.put(ClientProtocolID.USER_ID, "test");
			serverObj.put(ClientProtocolID.USER_PWD, "test");
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002208");*/
			
			Map<String, Object> result = DBCPPoolManager.setupDriver(serverObj);
			
			System.out.println(result.get("RESULT_CODE"));
			System.out.println(result.get("ERR_MSG"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
