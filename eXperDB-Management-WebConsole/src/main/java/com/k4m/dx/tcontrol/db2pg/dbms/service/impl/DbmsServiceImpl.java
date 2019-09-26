package com.k4m.dx.tcontrol.db2pg.dbms.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("dbmsServiceImpl")
public class DbmsServiceImpl extends EgovAbstractServiceImpl implements DbmsService{

	@Resource(name = "DbmsDAO")
	private DbmsDAO dbmsDAO;
	
	@Override
	public List<Map<String, Object>> selectDbmsGrb() throws Exception {
		return dbmsDAO.selectDbmsGrb();
	}

}
