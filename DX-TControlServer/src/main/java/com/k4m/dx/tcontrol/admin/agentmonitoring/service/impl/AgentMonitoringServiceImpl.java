package com.k4m.dx.tcontrol.admin.agentmonitoring.service.impl;

import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringService;
import com.k4m.dx.tcontrol.admin.agentmonitoring.service.AgentMonitoringVO;

@Service("AgentMonitoringServiceImpl")
public class AgentMonitoringServiceImpl implements AgentMonitoringService{
	
	@Resource(name = "agentMonitoringDAO")
	private AgentMonitoringDAO agentMonitoringDAO;

	public List<AgentMonitoringVO> selectAgentMonitoringList(AgentMonitoringVO vo ) throws SQLException{
		return (List<AgentMonitoringVO>) agentMonitoringDAO.selectAgentMonitoringList(vo);
	}

}
