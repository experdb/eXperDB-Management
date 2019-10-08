package com.k4m.dx.tcontrol.db2pg.dbms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("dbmsServiceImpl")
public class DbmsServiceImpl extends EgovAbstractServiceImpl implements DbmsService{

	@Resource(name = "DbmsDAO")
	private DbmsDAO dbmsDAO;

	@Override
	public List<Map<String, Object>> selectCharSetList(HashMap<String, Object> paramvalue) throws Exception {
		return dbmsDAO.selectCharSetList(paramvalue);
	}

	@Override
	public int db2pg_sys_nmCheck(String db2pg_sys_nm) throws Exception {
		return dbmsDAO.db2pg_sys_nmCheck(db2pg_sys_nm);
	}

	@Override
	public void insertDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception {
		dbmsDAO.insertDb2pgDBMS(db2pgSysInfVO);
		
	}

	@Override
	public List<Db2pgSysInfVO> selectDb2pgDBMS(Db2pgSysInfVO db2pgSysInfVO) throws Exception {
		return dbmsDAO.selectDb2pgDBMS(db2pgSysInfVO);		
	}

	@Override
	public List<Map<String, Object>> dbmsGrb() throws Exception {
		return dbmsDAO.dbmsGrb();		
	}

	@Override
	public List<Map<String, Object>> dbmsListDbmsGrb() throws Exception {
		return dbmsDAO.dbmsListDbmsGrb();	
	}
	


}
