package com.k4m.dx.tcontrol.admin.agentmonitoring.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

public interface AgentMonitoringService {
	
	/**
	 * Agent 조회
	 * @param param 
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	public List<AgentMonitoringVO> selectAgentMonitoringList(AgentMonitoringVO vo ) throws SQLException;
	
	
}
