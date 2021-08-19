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
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotChart(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return transMonitoringDAO.selectSourceSnapshotInfo(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceChart_1(int trans_id) {
		return transMonitoringDAO.selectSourceChart_1(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceChart_2(int trans_id) {
		return transMonitoringDAO.selectSourceChart_2(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceErrorChart(int trans_id) {
		return transMonitoringDAO.selectSourceErrorChart(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id) {
		return transMonitoringDAO.selectSourceErrorInfo(trans_id);
	}

	@Override
	public List<Map<String, Object>> selectTargetConnectList(int trans_id) {
		return transMonitoringDAO.selectTargetConnectList(trans_id);
	}

	
	
}
