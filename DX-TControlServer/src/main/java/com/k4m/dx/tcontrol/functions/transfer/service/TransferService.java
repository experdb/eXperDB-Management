package com.k4m.dx.tcontrol.functions.transfer.service;

import java.util.List;
import java.util.Map;

public interface TransferService {
	
	/**
	 * Connector 리스트 조회
	 * @param param 
	 * @return
	 * @throws Exception
	 */
	List<ConnectorVO> selectConnectorRegister(Map<String, Object> param) throws Exception;
	
	
	/**
	 * Connector 상세조회
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	List<ConnectorVO> selectDetailConnectorRegister(int cnr_id) throws Exception;
	
	
	/**
	 * Connector 삭제
	 * @param cnr_id
	 * @return
	 * @throws Exception
	 */
	void deleteConnectorRegister(int cnr_id) throws Exception;
	
	
	/**
	 * Connector 등록
	 * @param connectorVO
	 * @return
	 * @throws Exception
	 */
	void insertConnectorRegister(ConnectorVO connectorVO)throws Exception;


	/**
	 * Connector 수정
	 * @param connectorVO
	 * @return
	 * @throws Exception
	 */
	void updateConnectorRegister(ConnectorVO connectorVO)throws Exception;

	
	/**
	 * 전송설정 등록
	 * @param transferVO
	 * @return
	 * @throws Exception
	 */
	void insertTransferSetting(TransferVO transferVO)throws Exception;
	
}
