package com.k4m.dx.tcontrol.db2pg.dbms.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("DbmsDAO")
public class DbmsDAO extends EgovAbstractMapper{

	public List<Map<String, Object>> selectDbmsGrb() {
		
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("dbmsSQL.selectDbmsGrb", null);		
		return sl;
	}

}
