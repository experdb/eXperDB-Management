package com.k4m.dx.tcontrol.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.apache.log4j.Logger;

import com.k4m.dx.tcontrol.db.datastructure.ConfigInfo;

public class DBCPPoolManager {
	private static Logger log = Logger.getLogger(DBCPPoolManager.class);
	
	public static ConcurrentHashMap<String, ConfigInfo> ConnInfoList = new ConcurrentHashMap<String, ConfigInfo>();
	
	public static void setupDriver(String driver, String url, String user, String password, String poolName, int maxActive) throws Exception {
		log.info("************************************************************");
		log.info("DBCPPool을 생성합니다. ["+poolName+"]");		
		
		// JDBC 클래스 로딩
		try {
			//log.info("driver 11111111111" + driver);
			Class.forName(driver);
			//log.info("driver 2222222222");
			//DB 연결대기 시간
			DriverManager.setLoginTimeout(5);
			
	        // DB URI
	        String connectURI = url;
	        
	        // ID and Password
	        Properties props = new Properties();
	        props.put("user", user);
	        props.put("password", password);	        
	        
	        // 커넥션 풀로 사용할 commons-collections의 genericOjbectPool을 생성 
	        GenericObjectPool connectionPool = new GenericObjectPool(null);
	        
	        // Pool에서 Connection을 받아와 DB에 Query문을 날리기 전에
	        // 해당 Connection이 Active한지 Check하고 
	        // Active하지 않으면 해당 Connection을 다시 생성합니다
	        connectionPool.setTestOnBorrow(true);
	        connectionPool.setTestOnReturn(true);
	        connectionPool.setTestWhileIdle(true);
	        connectionPool.setMaxActive(maxActive);	        
	        
	        connectionPool.setMinEvictableIdleTimeMillis(30 * 1000);
	        connectionPool.setTimeBetweenEvictionRunsMillis(30 * 1000);
	        
	        // 풀이 커넥션을 생성하는데 사용하는 DriverManagerConnectionFactory를 생성
	        ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(connectURI, props);
	        
	        // ConnectionFactory의 래퍼 클래스인 PoolableConnectionFactory를 생성
            PoolableConnectionFactory poolableConnectionFactory =
                    new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true);	    
            
            //log.info("11111111111");	
	        
            //PoolingDriver 자신을 로딩
            Class.forName("org.apache.commons.dbcp.PoolingDriver");
            PoolingDriver pDriver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
            
           // log.info("222222222222222");
            
            //Pool 등록
            pDriver.registerPool(poolName, connectionPool);
            
            //log.info("3333333333333333");
            
		} catch (Exception e) {
			//log.info("4444444444444444"  + e.toString());
			throw e;
		}
		
		log.info("DBCPPool 생성 완료 하였습니다. ["+poolName+"]");
		log.info("************************************************************");		
	}
	
	public static void shutdownDriver(String poolName) throws Exception {
		PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
		driver.closePool(poolName);
	}
	
    public static void printDriverStats(String poolName) throws Exception {
        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
        ObjectPool connectionPool = driver.getConnectionPool(poolName);
        
        log.debug("["+poolName+"] NumActive: [" + connectionPool.getNumActive() + "] NumIdle: [" + connectionPool.getNumIdle() + "]");
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
    
    /*
     * 풀에 해당하는 DB정보 (ConfigInfo) 추출
     */
    public static ConfigInfo getConfigInfo(String poolName) throws Exception {
    	if (ConnInfoList.containsKey(poolName)){
    		return ConnInfoList.get(poolName);
    	}else{
    		return null;
    	}
    }
    
    /*
     * 풀에 해당하는 ConnectionString
     */
    public static String getConnectionString(String poolName) throws Exception {
    	if (ConnInfoList.containsKey(poolName)){
    		ConfigInfo configInfo = ConnInfoList.get(poolName);
    		String connectURI = "jdbc:sqlserver://"+configInfo.SERVERIP+":"+configInfo.PORT+";databaseName="+configInfo.DBNAME+";user=" + configInfo.USERID + ";password=" + configInfo.DB_PW;
    		return connectURI;
    	}else{
    		return null;
    	}
    }
    
    /*
     * 풀이 존재하는지 확인
     */
    public static boolean ContaintPool(String poolName) throws Exception {
    	if (ConnInfoList.containsKey(poolName)){
    		return true;    		
    	}else{
    		return false;
    	}
    }
    
    public static String[] GetPoolNameList() throws Exception {
    	PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
    	return driver.getPoolNames();
    }
    
    public static int getPoolCount() {
    	return ConnInfoList.size(); 
    }
    
    public static void main(String args[]) {
    	try {
    		ConfigInfo config = new ConfigInfo();
    		config.SERVERIP = "222.110.153.162";
    		config.DBNAME = "ibizspt";
    		config.DB_TYPE = Constant.DB_TYPE.POG;
    		config.SCHEMA_NAME = "ibizspt";
    		config.USERID = "ibizspt";
    		config.SERVER_NAME = "ibizspt";
    		config.PORT = "5432";
    		config.DB_PW = "ibizspt";
    		
    		//DBCPPoolManager.setupDriver(config, "TEST", 2);

    		/*
    		Connection conn = DBCPPoolManager.getConnection("TEST");
    		java.sql.PreparedStatement ps = conn.prepareStatement("select db_name()");
    		java.sql.ResultSet rs = ps.executeQuery();

    		if (rs.next()){
        		String dbname = rs.getString(1);
        		System.out.println("DBNAME = " + dbname);
    		}
    		
    		com.dxmig.db.datastructure.DataTable dt = WebDbCtl.GetCommonData("TEST", WebSqlID.GetTblOwner, null);
    		
    		if (dt.getRows().size() > 0) {
    			for(java.util.Map map : dt.getRows()){
        			String sc = (String)map.get("GRANTED_SCHEMA_NM");
        			System.out.println("SCHEMA : " + sc);
    			}

    		}
    		*/
    		System.out.println("end!!!");
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    }
}
