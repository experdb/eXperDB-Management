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

}
