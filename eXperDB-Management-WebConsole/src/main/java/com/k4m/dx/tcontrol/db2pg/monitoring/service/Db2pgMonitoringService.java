package com.k4m.dx.tcontrol.db2pg.monitoring.service;

import java.util.List;
import java.util.Map;

public interface Db2pgMonitoringService {
	
	List<Map<String, Object>> selectExeWork() throws Exception;

	List<Db2pgMonitoringVO> selectDb2pgMonitoring(Db2pgMonitoringVO mVo) throws Exception;


}
