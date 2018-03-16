package com.k4m.dx.tcontrol.tree.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TreeInfoDAO")
public class TreeInfoDAO extends EgovAbstractMapper {

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<ConnectorVO> selectConnectorRegister(String usr_id) {
		List<ConnectorVO> result = null;
		result = (List<ConnectorVO>) list("treeSql.selectConnectorRegister", usr_id);
		return result;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectTreeEncrypt(String usr_id) {
		List<Map<String, Object>>  result = null;
		result = (List<Map<String, Object>>) list("treeSql.selectTreeEncrypt", usr_id);
		return result;
	}
	
}
