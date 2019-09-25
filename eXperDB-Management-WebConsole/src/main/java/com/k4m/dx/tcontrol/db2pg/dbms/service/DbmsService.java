package com.k4m.dx.tcontrol.db2pg.dbms.service;

import java.util.List;
import java.util.Map;

public interface DbmsService {

	/**
	 * DB2PG DBMS구분
	 */
	List<Map<String, Object>> selectDbmsGrb()  throws Exception;;

}
