package com.experdb.proxy.db.repository.service;

import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
* 
*      </pre>
*/

public interface SystemService {
	/**
	 * proxy Agent 설치정보 조회
	 * 
	 * @param AgentInfoVO
	 * @return AgentInfoVO
	 * @throws Exception
	 */
	public AgentInfoVO selectPryAgtInfo(AgentInfoVO vo) throws Exception;

	/**
	 * Agent 설치 정보 등록
	 * 
	 * @param AgentInfoVO
	 * @return AgentInfoVO
	 * @throws Exception
	 */
	public void insertPryAgtInfo(AgentInfoVO vo) throws Exception ;

	/**
	 * Agent 설치 정보 수정
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtInfo(AgentInfoVO vo) throws Exception ;
	
	/**
	 * proxy max 이름 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMaxNmInfo(ProxyServerVO vo) throws Exception;
	
	/**
	 * Proxy DBMS 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrMaxNmInfo(ProxyServerVO vo) throws Exception;
	
	/**
	 * Proxy DBMS 별 마스터 중 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrEtcMaxNmInfo(ProxyServerVO vo) throws Exception;

	/**
	 * Agent 실행
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStartMng(String strSocketIp, String strSocketPort, String strVersion) throws Exception ;

	/**
	 * Agent 종료
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStopMng(String strSocketIp, String strSocketPort) throws Exception ;
}
