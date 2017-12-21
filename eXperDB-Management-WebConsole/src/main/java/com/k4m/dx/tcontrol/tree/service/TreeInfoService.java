package com.k4m.dx.tcontrol.tree.service;

import java.util.List;

import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;

public interface TreeInfoService {

	/**
	 * Connector 리스트 조회
	 * 
	 * @param usr_id
	 * @return ConnectorVO
	 * @throws Exception
	 */
	List<ConnectorVO> selectConnectorRegister(String usr_id) throws Exception;


}
