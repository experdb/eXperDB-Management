package com.experdb.proxy.db.repository.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.experdb.proxy.db.repository.dao.SystemDAO;
import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.TrfTrgCngVO;
import com.experdb.proxy.db.repository.vo.WrkExeVO;

/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

@Service("SystemService")
public class SystemServiceImpl implements SystemService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	/**
	 * Agent 설치정보 조회
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public AgentInfoVO selectPryAgtInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) systemDAO.selectPryAgtInfo(vo);
	}

	/**
	 * 설치정보 관리
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStartMng(String strSocketIp, String strSocketPort, String strVersion) throws Exception  {
		AgentInfoVO searchAgentInfoVO = new AgentInfoVO();
		searchAgentInfoVO.setIpadr(strSocketIp);
		socketLogger.info("SystemServiceImpl.strSocketIp : " + strSocketIp);
		String domainNm = "";
		String SvrUseNm = "";
		
		//에이전트 조회
		AgentInfoVO agentInfo = this.selectPryAgtInfo(searchAgentInfoVO);
		AgentInfoVO vo = new AgentInfoVO();
			
		vo.setIpadr(strSocketIp);
		vo.setSocket_port(Integer.parseInt(strSocketPort));
		vo.setAgt_version(strVersion);
		
		vo.setAgt_cndt_cd(vo.TC001101); //실행
		vo.setIstcnf_yn("Y");
		vo.setFrst_regr_id("system");
		vo.setLst_mdfr_id("system");

		if(agentInfo == null) {
			socketLogger.info("SystemServiceImpl.strSocketIp444 : " + strSocketIp);
			vo.setDomain_nm("PROXY_" + strSocketIp);
			vo.setSvr_use_yn("N");
			
			this.insertPryAgtInfo(vo);
		} else {
			socketLogger.info("SystemServiceImpl.strSocketIp333 : " + strSocketIp);
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
		
		socketLogger.info("SystemServiceImpl.strSocketIp555 : " + strSocketIp);
	}

	/**
	 * Agent 설치 정보 등록
	 * @param vo
	 * @throws Exception
	 */
	public void insertPryAgtInfo(AgentInfoVO vo) throws Exception {
		socketLogger.info("SystemServiceImpl.insertPryAgtInfo : " + vo);
		
		systemDAO.insertPryAgtInfo(vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public void updatePryAgtInfo(AgentInfoVO vo) throws Exception {
		socketLogger.info("SystemServiceImpl.updatePryAgtInfo : " + vo);
		
		systemDAO.updatePryAgtInfo(vo);
	}

	/**
	 * Agent 종료
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStopMng(String strSocketIp, String strSocketPort) throws Exception  {
		AgentInfoVO vo = new AgentInfoVO();

		vo.setIpadr(strSocketIp);
		vo.setSocket_port(Integer.parseInt(strSocketPort));
		vo.setAgt_cndt_cd(vo.TC001102); //종료
		vo.setIstcnf_yn("Y");
		vo.setLst_mdfr_id("system");

		this.updatePryAgtStopInfo(vo);
	}
	
	/**
	 * Agent 종료 정보 변경
	 * @param vo
	 * @throws Exception
	 */
	public void updatePryAgtStopInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updatePryAgtStopInfo(vo);
	}

	/**
	 * proxy 마지막 이름 조회
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMaxNmInfo(ProxyServerVO vo) throws Exception {
		return (ProxyServerVO) systemDAO.selectPrySvrMaxNmInfo(vo);
	}
}