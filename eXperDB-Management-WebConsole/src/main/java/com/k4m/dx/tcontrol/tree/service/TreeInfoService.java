package com.k4m.dx.tcontrol.tree.service;

import java.util.List;
import java.util.Map;

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

	/**
	 * 암호화메뉴 권한 조회
	 * 
	 * @param usr_id
	 * @return ConnectorVO
	 * @throws Exception
	 */
	List<Map<String, Object>> selectTreeEncrypt(String usr_id) throws Exception;

}
