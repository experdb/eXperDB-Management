package com.experdb.proxy.db.repository.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.experdb.proxy.db.repository.dao.SystemDAO;
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
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
@Service("SystemService")
public class SystemServiceImpl implements SystemService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;

	/**
	 * proxy Agent 설치정보 조회
	 * 
	 * @param AgentInfoVO
	 * @return AgentInfoVO
	 * @throws Exception
	 */
	public AgentInfoVO selectPryAgtInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) systemDAO.selectPryAgtInfo(vo);
	}

	/**
	 * AGENT 정보 변경
	 * 
	 * @param String strSocketIp, String strSocketPort, String strVersion
	 * @throws Exception
	 */
	public void agentInfoStartMng(String strSocketIp, String strSocketPort, String strVersion) throws Exception  {
		AgentInfoVO searchAgentInfoVO = new AgentInfoVO();
		searchAgentInfoVO.setIpadr(strSocketIp);

		String domainNm = "";
		String SvrUseNm = "";
		
		//에이전트 조회
		AgentInfoVO agentInfo = this.selectPryAgtInfo(searchAgentInfoVO);
		AgentInfoVO vo = new AgentInfoVO();
			
		vo.setIpadr(strSocketIp);
		vo.setSocket_port(Integer.parseInt(strSocketPort));
		vo.setAgt_version(strVersion);
		
		vo.setAgt_cndt_cd(vo.TC001501); //실행
		vo.setIstcnf_yn("Y");
		vo.setFrst_regr_id("system");
		vo.setLst_mdfr_id("system");

		if(agentInfo == null) {
			vo.setDomain_nm("PROXY_" + strSocketIp);
			vo.setSvr_use_yn("N");
			
			this.insertPryAgtInfo(vo);
		} else {
			if (agentInfo.getDomain_nm() != null) {
				domainNm = agentInfo.getDomain_nm();
			} else {
				domainNm = "PROXY_" + strSocketIp;
			}

			if (agentInfo.getSvr_use_yn() != null) {
				SvrUseNm = agentInfo.getSvr_use_yn();
			} else {
				SvrUseNm = "N";
			}

			vo.setDomain_nm(domainNm);
			vo.setSvr_use_yn(SvrUseNm);
				
			this.updatePryAgtInfo(vo);
		} 
	}

	/**
	 * Agent 설치 정보 등록
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void insertPryAgtInfo(AgentInfoVO vo) throws Exception {
		systemDAO.insertPryAgtInfo(vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updatePryAgtInfo(vo);
	}

	/**
	 * Agent 종료
	 * 
	 * @param String strSocketIp, String strSocketPort
	 * @throws Exception
	 */
	public void agentInfoStopMng(String strSocketIp, String strSocketPort) throws Exception  {
		AgentInfoVO vo = new AgentInfoVO();

		vo.setIpadr(strSocketIp);
		vo.setSocket_port(Integer.parseInt(strSocketPort));
		vo.setAgt_cndt_cd(vo.TC001502); //종료
		vo.setIstcnf_yn("Y");
		vo.setLst_mdfr_id("system");

		this.updatePryAgtStopInfo(vo);
	}
	
	/**
	 * Agent 종료 정보 변경
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtStopInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updatePryAgtStopInfo(vo);
	}

	/**
	 * proxy max 이름 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMaxNmInfo(ProxyServerVO vo) throws Exception {
		return (ProxyServerVO) systemDAO.selectPrySvrMaxNmInfo(vo);
	}

	/**
	 * Proxy DBMS 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrMaxNmInfo(ProxyServerVO vo) throws Exception {
		return (ProxyServerVO) systemDAO.selectDBMSSvrMaxNmInfo(vo);
	}

	/**
	 * Proxy DBMS 별 마스터 중 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrEtcMaxNmInfo(ProxyServerVO vo) throws Exception {
		return (ProxyServerVO) systemDAO.selectDBMSSvrEtcMaxNmInfo(vo);
	}
}