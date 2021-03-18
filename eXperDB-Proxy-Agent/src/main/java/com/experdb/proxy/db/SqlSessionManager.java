package com.experdb.proxy.db;

import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.log4j.Logger;



public class SqlSessionManager {
	private static Logger log = Logger.getLogger(SqlSessionManager.class);
	
	private static SqlSessionFactory sqlSession = null;
	
	public static void initInstance() throws Exception {
		if (sqlSession != null) {
			log.info("SqlSessionManager가 이미 초기화되었습니다.");
			return;
		}

		log.info("SqlSessionManager를 초기화합니다.");
		
		String resource = "sql-mapper-config.xml";
		InputStream inputStream = Resources.getResourceAsStream(resource);
		
		sqlSession = new SqlSessionFactoryBuilder().build(inputStream);

		log.info("SqlSessionManager를 초기화하였습니다.");

	}
	
	public static SqlSessionFactory getInstance() {
		if (sqlSession == null) {
			try {
				initInstance();
			} catch (Exception e) {
				log.error("", e);
			}
		}
		
		return sqlSession;
	}	
}
