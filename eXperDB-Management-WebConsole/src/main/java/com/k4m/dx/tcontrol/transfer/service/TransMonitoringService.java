package com.k4m.dx.tcontrol.transfer.service;

import java.util.List;
import java.util.Map;

public interface TransMonitoringService {

	public List<Map<String, Object>> selectSrcConnectorList();

	public Map<String, Object> selectSourceConnectorTableList(int trans_id);

	public List<Map<String, Object>> selectSourceConnectInfo(int trans_id);

	public List<Map<String, Object>> selectSourceSnapshotChart(int trans_id);

	public List<Map<String, Object>> selectSourceSnapshotInfo(int trans_id);

	public List<Map<String, Object>> selectSourceChart_1(int trans_id);

	public List<Map<String, Object>> selectSourceChart_2(int trans_id);

	public List<Map<String, Object>> selectSourceErrorChart(int trans_id);

	public List<Map<String, Object>> selectSourceErrorInfo(int trans_id);

	public List<Map<String, Object>> selectTargetConnectList(int trans_id); 


}
