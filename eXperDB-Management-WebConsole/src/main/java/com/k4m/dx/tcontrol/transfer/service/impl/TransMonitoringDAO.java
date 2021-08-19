package com.k4m.dx.tcontrol.transfer.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TransMonitoringDAO")
public class TransMonitoringDAO extends EgovAbstractMapper{

	public List<Map<String, Object>> selectSrcConnectorList() {
		List<Map<String, Object>> result = null;
		result = selectList("transMonitoringSql.selectSourceConnectorList");
		return result;
	}

	public Map<String, Object> selectSourceConnectorTableList(int trans_id) {
		return selectOne("transMonitoringSql.selectSourceConnectorTableList", trans_id);
	}

	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceConnectInfo", trans_id);
	}
	
	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id) {
		return selectList("transMonitoringSql.selectSourceSnapshotChart", trans_id);
	}

	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceSnapshotInfo", trans_id);
	}

	public List<Map<String, Object>> selectSourceChart_1(int trans_id) {
		return selectList("transMonitoringSql.selectSourceChart_1", trans_id);
	}

	public List<Map<String, Object>> selectSourceChart_2(int trans_id) {
		return selectList("transMonitoringSql.selectSourceChart_2", trans_id);
	}

	public List<Map<String, Object>> selectSourceErrorChart(int trans_id) {
		return selectList("transMonitoringSql.selectSourceErrorChart", trans_id);
	}

	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id) {
		return selectList("transMonitoringSql.selectSourceErrorInfo", trans_id);
	}

	public List<Map<String, Object>> selectTargetConnectList(int trans_id) {
		return selectList("transMonitoringSql.selectTargetConnectList", trans_id);
	}

}
