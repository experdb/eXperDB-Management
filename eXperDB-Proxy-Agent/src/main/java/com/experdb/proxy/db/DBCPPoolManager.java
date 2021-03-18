package com.experdb.proxy.db;

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

import com.experdb.proxy.db.datastructure.ConfigInfo;

public class DBCPPoolManager {
	private Logger log = Logger.getLogger(DBCPPoolManager.class);
	
	public ConcurrentHashMap<String, ConfigInfo> ConnInfoList = new ConcurrentHashMap<String, ConfigInfo>();
	
	public void setupDriver(String driver, String url, String user, String password, String poolName, int maxActive) throws Exception {

		log.info("DBCPPool을 생성합니다. ["+poolName+"]");		
		
		// JDBC 클래스 로딩
		try {
			//log.info("driver 11111111111" + driver);
			//Class.forName(driver);
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

            //PoolingDriver 자신을 로딩
            Class.forName("org.apache.commons.dbcp.PoolingDriver");
            PoolingDriver pDriver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");

            //Pool 등록
            pDriver.registerPool(poolName, connectionPool);

            
		} catch (Exception e) {
			throw e;
		}
		
		log.info("DBCPPool 생성 완료 하였습니다. ["+poolName+"]");
		
	}
	
	public static void shutdownDriver(String poolName) throws Exception {
		PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
		driver.closePool(poolName);
	}
	
    public  void printDriverStats(String poolName) throws Exception {
        PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
        ObjectPool connectionPool = driver.getConnectionPool(poolName);
        
        log.debug("["+poolName+"] NumActive: [" + connectionPool.getNumActive() + "] NumIdle: [" + connectionPool.getNumIdle() + "]");
    }
    
    /*
	 * connection get
	 */
    public Connection getConnection(String poolName) throws Exception {
    	Connection conn = DriverManager.getConnection("jdbc:apache:commons:dbcp:" + poolName);
    	/*
    	switch (getConfigInfo(poolName).DB_TYPE){
    		case Constant.DB_TYPE.ASE :
    			conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
    	}
    	*/
    	conn.setAutoCommit(true);
    	
    	return conn;
    }
    
    /*
     * 풀에 해당하는 DB정보 (ConfigInfo) 추출
     */
    public ConfigInfo getConfigInfo(String poolName) throws Exception {
    	if (ConnInfoList.containsKey(poolName)){
    		return ConnInfoList.get(poolName);
    	}else{
    		return null;
    	}
    }
    
    /*
     * 풀에 해당하는 ConnectionString
     */
    public String getConnectionString(String poolName) throws Exception {
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
    public boolean ContaintPool(String poolName) throws Exception {
    	if (ConnInfoList.containsKey(poolName)){
    		return true;    		
    	}else{
    		return false;
    	}
    }
    
    public String[] GetPoolNameList() throws Exception {
    	PoolingDriver driver = (PoolingDriver) DriverManager.getDriver("jdbc:apache:commons:dbcp:");
    	return driver.getPoolNames();
    }
    
    public int getPoolCount() {
    	return ConnInfoList.size(); 
    }
    
    public static void main(String args[]) {
    	
    }
}
