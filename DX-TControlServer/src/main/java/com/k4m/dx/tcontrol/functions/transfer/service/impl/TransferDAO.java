package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;

@Repository("TransferDAO")
public class TransferDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) {
		List<ConnectorVO> sl = null;
		try {
			sl = (List<ConnectorVO>) sqlMapClient.queryForList("transferSql.selectConnectorRegister",param);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

	@SuppressWarnings("unchecked")
	public List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) {
		List<ConnectorVO> sl = null;
		try {
			sl = (List<ConnectorVO>) sqlMapClient.queryForList("transferSql.selectDetailConnectorRegister",cnr_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

	public void deleteConnectorRegister(int cnr_id) {
		try {
			sqlMapClient.delete("transferSql.deleteConnectorRegister", cnr_id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	public void insertConnectorRegister(ConnectorVO connectorVO) {
		try {
			sqlMapClient.delete("transferSql.insertConnectorRegister", connectorVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	public void updateConnectorRegister(ConnectorVO connectorVO) {
		try {
			sqlMapClient.delete("transferSql.updateConnectorRegister", connectorVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}

}
