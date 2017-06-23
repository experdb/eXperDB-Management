package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("transferDAO")
public class TransferDAO extends EgovAbstractMapper{
	
	/**
	 * Connector 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectConnectorRegister",param);
		return sl;
	}

	
	/**
	 * Connector 상세조회
	 * 
	 * @param cnr_id
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws SQLException {
		List<ConnectorVO> sl = null;
		sl = (List<ConnectorVO>) list("transferSql.selectDetailConnectorRegister",cnr_id);
		return sl;
	}

	
	/**
	 * Connector 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteConnectorRegister(int cnr_id) throws SQLException {
		delete("transferSql.deleteConnectorRegister", cnr_id);
		
	}

	
	/**
	 * Connector 등록
	 * 
	 * @param connectorVO
	 * @throws SQLException
	 */
	public void insertConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.insertConnectorRegister", connectorVO);
		
	}

	
	/**
	 * Connector 수정
	 * 
	 * @param connectorVO
	 * @throws SQLException
	 */
	public void updateConnectorRegister(ConnectorVO connectorVO) throws SQLException {
		delete("transferSql.updateConnectorRegister", connectorVO);	
	}

	
	/**
	 * 전송설정 등록
	 * 
	 * @param transferVO
	 * @throws SQLException
	 */
	public void insertTransferSetting(TransferVO transferVO) throws SQLException {
		insert("transferSql.insertTransferSetting", transferVO);
	}

}
