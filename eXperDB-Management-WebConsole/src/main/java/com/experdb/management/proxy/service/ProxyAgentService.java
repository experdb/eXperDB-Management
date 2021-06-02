package com.experdb.management.proxy.service;

import java.util.List;

/**
* @author 
* @see proxy 관리 agent 관련 화면 service
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
public interface ProxyAgentService {

	/**
	 * Proxy agent count 조회
	 * 
	 * @param 
	 * @return integer
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
	 * @param proxyAgentVO
	 * @return string
	 * @throws Exception
	 */
	public String proxyAgentExcute(ProxyAgentVO proxyAgentVO) throws Exception;
}
