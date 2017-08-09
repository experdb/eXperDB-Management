package com.k4m.dx.tcontrol.admin.agentmonitoring.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("agentMonitoringDAO")
public class AgentMonitoringDAO extends EgovAbstractMapper{
	
	
	/**
	 * Agent 조회
	 * 
	 * @param param
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<AgentMonitoringVO> selectAgentMonitoringList(AgentMonitoringVO vo ) throws SQLException{
		return (List<AgentMonitoringVO>) list("agentMonitoringSql.selectAgentMonitoringList", vo);
	}


}
