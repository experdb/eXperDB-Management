package com.k4m.dx.tcontrol.functions.transfer.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;

public interface TransferService {

	/**
	 * 전송설정 조회
	 * 
	 * @param usr_id
	 * @return
	 * @throws Exception
	 */
	List<TransferVO> selectTransferSetting(String usr_id) throws Exception;

	/**
	 * 전송설정 등록
	 * 
	 * @param transferVO
	 * @return
	 * @throws Exception
	 */
	void insertTransferSetting(TransferVO transferVO) throws Exception;

	/**
	 * 전송설정 수정
	 * 
	 * @param transferVO
	 * @return
	 * @throws Exception
	 */
	void updateTransferSetting(TransferVO transferVO) throws Exception;

	/**
	 * Connector 리스트 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws Exception;

	/**
	 * Connector 상세조회
	 * 
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws Exception;

	/**
	 * Connector 등록
	 * 
	 * @param connectorVO
	 * @return
	 * @throws Exception
	 */
	void insertConnectorRegister(ConnectorVO connectorVO) throws Exception;

	/**
	 * Connector 수정
	 * 
	 * @param connectorVO
	 * @return
	 * @throws Exception
	 */
	void updateConnectorRegister(ConnectorVO connectorVO) throws Exception;

	/**
	 * Connector 삭제
	 * 
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	void deleteConnectorRegister(int cnr_id) throws Exception;

	/**
	 * 전송대상설정정보 삭제
	 * 
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	void deleteTransferInfo(int cnr_id) throws Exception;

	/**
	 * trf_trg_mpp_id 조회
	 * 
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	List<TransferMappingVO> selectTrftrgmppid(int cnr_id) throws Exception;

	/**
	 * 전송대상매핑관계 삭제
	 * 
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	void deleteTransferRelation(int cnr_id) throws Exception;

	/**
	 * 전송매핑테이블 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @return
	 * @throws Exception
	 */
	void deleteTransferMapping(int trf_trg_mpp_id) throws Exception;

}
