package com.k4m.dx.tcontrol.db.repository.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.util.FileUtil;
import com.k4m.dx.tcontrol.db.repository.dao.SystemDAO;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.PryAgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.TrfTrgCngVO;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;

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
*  2022.12.22 	강병석		에이전트 통합, 프록시 에이전트 기능 추가
*      </pre>
*/

@Service("SystemService")
public class SystemServiceImpl implements SystemService{
	
	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;
	
	Properties prop = new Properties();
	ClassLoader loader = Thread.currentThread().getContextClassLoader();
	File file = new File(loader.getResource("context.properties").getFile());
    String path = file.getParent() + File.separator;
    
	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception {
		return systemDAO.selectDbServerInfoList();
	}
	
	public DbServerInfoVO selectDbServerInfo(DbServerInfoVO vo)  throws Exception {
		return (DbServerInfoVO) systemDAO.selectDbServerInfo(vo);
	}
	
	public void insertAgentInfo(AgentInfoVO vo) throws Exception {
		systemDAO.insertAgentInfo(vo);
	}
	
	public void updateAgentInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updateAgentInfo(vo);
	}
	
	public void updateAgentStopInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updateAgentStopInfo(vo);
	}
	
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) systemDAO.selectAgentInfo(vo);
	}
	
	public DbServerInfoVO selectDatabaseConnInfo(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) systemDAO.selectDatabaseConnInfo(vo);
	}

	/**
	 * 설치정보 관리
	 * @param dbServerInfo
	 * @throws Exception
	 */
	//에이전트 실행
	public void agentInfoStartMng(String strSocketIp, String strSocketPort, String strVersion, String strProxyInterIP) throws Exception  {
		//properties 호출
		filesetting();
		
		if("N".equals(prop.getProperty("proxy.global.serveryn"))){
			AgentInfoVO searchAgentInfoVO = new AgentInfoVO();
			
			searchAgentInfoVO.setIPADR(strSocketIp);
				
			AgentInfoVO agentInfo = this.selectAgentInfo(searchAgentInfoVO);
				
			AgentInfoVO vo = new AgentInfoVO();
				
			vo.setIPADR(strSocketIp);
			vo.setSOCKET_PORT(Integer.parseInt(strSocketPort));
			vo.setINTL_IPADR(strProxyInterIP);
				
			vo.setAGT_VERSION(strVersion);
			vo.setAGT_CNDT_CD(vo.TC001101); //실행
			vo.setISTCNF_YN("Y");
			vo.setFRST_REGR_ID("system");
			vo.setLST_MDFR_ID("system");
				
			if(agentInfo == null) {
				this.insertAgentInfo(vo);
			} else {
				this.updateAgentInfo(vo);
			}
		}
		
		if("Y".equals(prop.getProperty("agent.proxy_yn"))) {
			PryAgentInfoVO pry_searchAgentInfoVO = new PryAgentInfoVO();
			pry_searchAgentInfoVO.setIpadr(strSocketIp);
			String domainNm = "";
			String SvrUseNm = "";

			//에이전트 조회
			PryAgentInfoVO pry_agentInfo = this.selectPryAgtInfo(pry_searchAgentInfoVO);
			PryAgentInfoVO pry_vo = new PryAgentInfoVO();
				
			pry_vo.setIpadr(strSocketIp);
			pry_vo.setSocket_port(Integer.parseInt(strSocketPort));
			pry_vo.setAgt_version(strVersion);
			
			pry_vo.setAgt_cndt_cd(pry_vo.TC001501); //실행
			pry_vo.setIstcnf_yn("Y");
			pry_vo.setFrst_regr_id("system");
			pry_vo.setLst_mdfr_id("system");
			pry_vo.setAws_yn(FileUtil.getPropertyValue("context.properties", "aws.yn"));
			if("Y".equals(FileUtil.getPropertyValue("context.properties", "agent.inner.ip.useyn"))){
				pry_vo.setIntl_ipadr(FileUtil.getPropertyValue("context.properties", "agent.inner.ip"));
			}

			if(pry_agentInfo == null) {
				pry_vo.setDomain_nm("PROXY_" + strSocketIp);
				pry_vo.setSvr_use_yn("N");
				
				this.insertPryAgtInfo(pry_vo);
			} else {
				if (pry_agentInfo.getDomain_nm() != null) {
					domainNm = pry_agentInfo.getDomain_nm();
				} else {
					domainNm = "PROXY_" + strSocketIp;
				}

				if (pry_agentInfo.getSvr_use_yn() != null) {
					SvrUseNm = pry_agentInfo.getSvr_use_yn();
				} else {
					SvrUseNm = "N";
				}

				pry_vo.setDomain_nm(domainNm);
				pry_vo.setSvr_use_yn(SvrUseNm);
					
				
				if(pry_agentInfo == null) {
					this.insertPryAgtInfo(pry_vo);
				} else {
					this.updatePryAgtInfo(pry_vo);
				}
			}
		}
	}
	
	//에이전트 중지
	public void agentInfoStopMng(String strSocketIp, String strSocketPort) throws Exception  {
		//properties 호출
		filesetting();
		
		//매니지먼트 기능
		if("N".equals(prop.getProperty("agent.proxy_yn")) || "N".equals(prop.getProperty("proxy.global.serveryn"))) {
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strSocketIp);
			vo.setSOCKET_PORT(Integer.parseInt(strSocketPort));
			vo.setAGT_CNDT_CD(vo.TC001102); //종료
			vo.setISTCNF_YN("Y");
			vo.setLST_MDFR_ID("system");
			this.updateAgentStopInfo(vo);			
		}
		
		
		if("Y".equals(prop.getProperty("agent.proxy_yn"))) {
			//프록시 기능
			PryAgentInfoVO pryvo = new PryAgentInfoVO();
	
			pryvo.setIpadr(strSocketIp);
			pryvo.setSocket_port(Integer.parseInt(strSocketPort));
			pryvo.setAgt_cndt_cd(pryvo.TC001502); //종료
			pryvo.setIstcnf_yn("Y");
			pryvo.setLst_mdfr_id("system");
	
			this.updatePryAgtStopInfo(pryvo);
		}
	}

	public int selectQ_WRKEXE_G_01_SEQ() throws Exception  {
		return (int) systemDAO.selectQ_WRKEXE_G_01_SEQ();
	}
	
	public void insertT_WRKEXE_G(WrkExeVO vo) throws Exception  {
		systemDAO.insertT_WRKEXE_G(vo);
	}

	public void updateT_WRKEXE_G(WrkExeVO vo) throws Exception {
		systemDAO.updateT_WRKEXE_G(vo);
	}
	
	public void updateT_TRFTRGCNG_I(TrfTrgCngVO vo) throws Exception {
		systemDAO.updateT_TRFTRGCNG_I(vo);
	}
	
	public int selectQ_WRKEXE_G_02_SEQ() throws Exception  {
		return (int) systemDAO.selectQ_WRKEXE_G_02_SEQ();
	}
	
	public void updateSCD_CNDT(WrkExeVO vo) throws Exception  {
		systemDAO.updateSCD_CNDT(vo);
	}
	
	public void updateDB_CNDT(DbServerInfoVO vo) throws Exception {
		systemDAO.updateDB_CNDT(vo);
	}
	
	public void updateDBSlaveAll(DbServerInfoVO vo) throws Exception {
		systemDAO.updateDBSlaveAll(vo);
	}
	
	public DbServerInfoVO selectISMasterGbm(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) systemDAO.selectISMasterGbm(vo);
	}
	
	public void updateRMAN_RESTORE_CNDT(RmanRestoreVO vo) throws Exception {
		systemDAO.updateRMAN_RESTORE_CNDT(vo);
	}
	
	public void updateRMAN_RESTORE_EXELOG(RmanRestoreVO vo) throws Exception {
		systemDAO.updateRMAN_RESTORE_EXELOG(vo);
	}
	
	public void updateDUMP_RESTORE_CNDT(DumpRestoreVO vo) throws Exception {
		systemDAO.updateDUMP_RESTORE_CNDT(vo);
	}
	
	public void updateDUMP_RESTORE_EXELOG(DumpRestoreVO vo) throws Exception {
		systemDAO.updateDUMP_RESTORE_EXELOG(vo);
	}

	public int selectScd_id() throws Exception {
		return (int) systemDAO.selectScd_id();
	}

	public void insertWRKEXE_G(WrkExeVO vo)  throws Exception{
		systemDAO.insertWRKEXE_G(vo);
	}
	
	//=======================================================================
	//프록시 추가 2022.12.22
	public PryAgentInfoVO selectPryAgtInfo(PryAgentInfoVO vo) throws Exception  {
		return (PryAgentInfoVO) systemDAO.selectPryAgtInfo(vo);
	}

	/**
	 * Agent 설치 정보 등록
	 * 
	 * @param PryAgentInfoVO
	 * @throws Exception
	 */
	public void insertPryAgtInfo(PryAgentInfoVO vo) throws Exception {
		systemDAO.insertPryAgtInfo(vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * 
	 * @param PryAgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtInfo(PryAgentInfoVO vo) throws Exception {
		systemDAO.updatePryAgtInfo(vo);
	}
	
	/**
	 * Agent 종료 정보 변경
	 * 
	 * @param PryAgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtStopInfo(PryAgentInfoVO vo) throws Exception {
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
	
	public void filesetting() {
		try {
	    	prop.load(new FileInputStream(path + "context.properties"));
	    } catch(FileNotFoundException e) {
	    	System.out.println("Exit(0) File Not Found ");
	    	System.exit(0);
	    } catch(Exception e) {
	    	System.out.println("Exit(0) Error : " + e.toString());
	    	System.exit(0);
	    }
	}
	
	@Override
	public int selectDbSvrIpAdrId(String ipadr) throws Exception {
		return systemDAO.selectDbSvrIpAdrId(ipadr);
	}

	@Override
	public void insertPgbackrestBackup(WrkExeVO vo) throws Exception {
		systemDAO.insertPgbackrestBackup(vo);
	}

	@Override
	public void updateBackrestWrk(WrkExeVO vo) throws Exception {
		systemDAO.updateBackrestWrk(vo);
	}
	
	@Override
	public void updateBackrestRestore(RmanRestoreVO vo) throws Exception {
		systemDAO.updateBackrestRestore(vo);
	}
	
	@Override
	public void updateBackrestErr(WrkExeVO vo) throws Exception {
		systemDAO.updateBackrestErr(vo);
	}
	

}