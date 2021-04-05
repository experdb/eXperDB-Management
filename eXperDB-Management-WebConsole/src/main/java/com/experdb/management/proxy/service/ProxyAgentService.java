package com.experdb.management.proxy.service;

import java.util.List;

import com.k4m.dx.tcontrol.transfer.service.TransVO;

public interface ProxyAgentService {

	/**
	 * Proxy agent count 조회
	 * 
	 * @param param
	 * @return List<ProxyServerVO>
	 * @throws Exception
	 */
	public int selectAgentCount() throws Exception;

	/**
	 * proxy agent 리스트 조회
	 * 
	 * @param proxyAgentVO
	 * @return List<ProxyAgentVO>
	 * @throws Exception
	 */
	public List<ProxyAgentVO> selectProxyAgentList(ProxyAgentVO proxyAgentVO) throws Exception;
	
	/**
	 * proxy agent 기동 / 정지 실행
	 * 
	 * @param response, request
	 * @return result
	 * @throws
	 */
	public String proxyAgentExcute(ProxyAgentVO proxyAgentVO) throws Exception;
}
