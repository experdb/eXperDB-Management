package com.k4m.dx.tcontrol.db2pg.monitoring.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.monitoring.service.Db2pgMonitoringService;
import com.k4m.dx.tcontrol.db2pg.monitoring.service.Db2pgMonitoringVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Db2pgMonitoringServiceImpl")
public class Db2pgMonitoringServiceImpl  extends EgovAbstractServiceImpl implements Db2pgMonitoringService{

	
	@Resource(name = "db2pgMonitoringDAO")
	private Db2pgMonitoringDAO db2pgMonitoringDAO;
	
	@Override
	public List<Map<String, Object>> selectExeWork() throws Exception {
		return db2pgMonitoringDAO.selectExeWork();
	}
	
	
	@Override
	public List<Db2pgMonitoringVO> selectDb2pgMonitoring(Db2pgMonitoringVO mVo) throws Exception {
		return db2pgMonitoringDAO.selectDb2pgMonitoring(mVo);
	}



}
