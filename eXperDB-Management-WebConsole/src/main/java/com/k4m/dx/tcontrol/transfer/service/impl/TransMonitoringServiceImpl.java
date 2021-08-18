package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.transfer.service.TransMonitoringService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("TransMonitoringServiceImpl")
public class TransMonitoringServiceImpl  extends EgovAbstractServiceImpl implements TransMonitoringService{

	@Resource(name = "TransMonitoringDAO")
	private TransMonitoringDAO transMonitoringDAO;

	@Override
	public List<Map<String, Object>> selectSrcConnectorList() {
		return transMonitoringDAO.selectSrcConnectorList();
	}

	@Override
	public Map<String, Object> selectSourceConnectorTableList(int trans_id) {
		return transMonitoringDAO.selectSourceConnectorTableList(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id) {
		return transMonitoringDAO.selectSourceConnectInfo(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotInfo(trans_id);
	}
	
	
}
