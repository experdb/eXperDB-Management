package com.k4m.dx.tcontrol.db2pg.monitoring.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.monitoring.service.Db2pgMonitoringVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("db2pgMonitoringDAO")
public class Db2pgMonitoringDAO extends EgovAbstractMapper{

	public List<Map<String, Object>> selectExeWork() {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("db2pgMonitoringSql.selectExeWork", null);
		return sl;
	}
	
	
	public List<Db2pgMonitoringVO> selectDb2pgMonitoring(Db2pgMonitoringVO mVo) {
		List<Db2pgMonitoringVO> result = null;
		result = (List<Db2pgMonitoringVO>) list("db2pgMonitoringSql.selectDb2pgMonitoring", mVo);
		return result;
	}



}
