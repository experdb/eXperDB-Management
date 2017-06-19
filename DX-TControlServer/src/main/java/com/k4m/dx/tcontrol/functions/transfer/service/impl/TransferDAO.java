package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("transferDAO")
public class TransferDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectConnectorRegister",param);
		return sl;
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectDetailConnectorRegister",cnr_id);
		return sl;
	}

	public void deleteConnectorRegister(int cnr_id) throws SQLException {
		delete("transferSql.deleteConnectorRegister", cnr_id);
		
	}

	public void insertConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.insertConnectorRegister", connectorVO);
		
	}

	public void updateConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.updateConnectorRegister", connectorVO);	
	}

}
