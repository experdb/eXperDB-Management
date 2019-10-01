package com.k4m.dx.tcontrol.db2pg.setting.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.Db2pgSettingService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Db2pgSettingServiceImpl")
public class Db2pgSettingServiceImpl extends EgovAbstractServiceImpl implements Db2pgSettingService {

	@Resource(name = "db2pgSettingDAO")
	private Db2pgSettingDAO db2pgSettingDAO;

	@Override
	public List<CodeVO> selectCode(String grp_cd) throws Exception {
		return db2pgSettingDAO.selectCode(grp_cd);
	}	

	
}
