package com.k4m.dx.tcontrol.functions.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("transferDAO")
public class TransferDAO extends EgovAbstractMapper {

	/**
	 * 전송설정 조회
	 * 
	 * @param usr_id
	 * @throws SQLException
	 */
	public TransferVO selectTransferSetting(String usr_id) {	
		return (TransferVO) selectOne("transferSql.selectTransferSetting", usr_id);
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

	/**
	 * 전송설정 등록
	 * 
	 * @param transferVO
	 * @throws SQLException
	 */
	public void updateTransferSetting(TransferVO transferVO) throws SQLException {
		update("transferSql.updateTransferSetting", transferVO);
	}

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
		sl = (List<ConnectorVO>) list("transferSql.selectConnectorRegister", param);
		return sl;
	}

	/**
	 * kafka-Connector ip,port 조회
	 * 
	 * @param cnr_id
	 * @return
	 * @throws SQLException
	 */
	public ConnectorVO selectDetailConnectorRegister(int cnr_id) throws SQLException {
		return (ConnectorVO) selectOne("transferSql.selectDetailConnectorRegister", cnr_id);
	}

	/**
	 * Connector 중복체크
	 * 
	 * @param connectorVO
	 * @return 
	 * @throws SQLException
	 */
	public int connectorNameCheck(String cnr_nm) {
		return (int) selectOne("transferSql.connectorNameCheck", cnr_nm);
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
	 * Connector 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteConnectorRegister(int cnr_id) throws SQLException {
		delete("transferSql.deleteConnectorRegister", cnr_id);

	}

	/**
	 * 전송대상설정정보 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteTransferInfo(int cnr_id) throws SQLException {
		delete("transferSql.deleteTransferInfo", cnr_id);

	}

	/**
	 * trf_trg_mpp_id 조회
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<TransferMappingVO> selectTrftrgmppid(int cnr_id) throws SQLException {
		List<TransferMappingVO>  result = null;
		result = (List<TransferMappingVO>) list("transferSql.selectTrftrgmppid", cnr_id);
		return result;
	}

	/**
	 * 전송대상매핑관계 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteTransferRelation(int cnr_id) throws SQLException {
		delete("transferSql.deleteTransferRelation", cnr_id);
	}

	/**
	 * 전송매핑테이블 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @throws SQLException
	 */
	public void deleteTransferMapping(int trf_trg_mpp_id) throws SQLException {
		delete("transferSql.deleteTransferMapping", trf_trg_mpp_id);
	}
	
	/**
	 * t엔진 ip, t엔진 port 정보 조회
	 * 
	 * @param usr_id
	 * @return
	 * @throws Exception
	 */
	public TransferVO selectTengInfo(String usr_id) {
		return (TransferVO) selectOne("transferSql.selectTengInfo", usr_id);
	}

	/**
	 * 삭제 할 Connect 정보 조회
	 * 
	 * @param db_svr_id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectConnectorInfo(int db_svr_id) {
		 List<Map<String, Object>> result = null;
		result = (List<Map<String, Object>>) list("transferSql.selectConnectorInfo", db_svr_id);
		return result;
	}

}
