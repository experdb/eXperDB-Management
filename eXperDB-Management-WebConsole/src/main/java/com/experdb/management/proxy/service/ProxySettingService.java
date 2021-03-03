package com.experdb.management.proxy.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface ProxySettingService {
	
	/**
	 * Proxy Server 조회
	 * @param 
	 * @throws Exception
	 */
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception;

}
