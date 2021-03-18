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
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) systemDAO.selectAgentInfo(vo);
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
		
		AgentInfoVO agentInfo = this.selectAgentInfo(searchAgentInfoVO);
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
			
			this.insertAgentInfo(vo);
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
				
			this.updateAgentInfo(vo);
		} 
	}

	/**
	 * Agent 설치 정보 등록
	 * @param vo
	 * @throws Exception
	 */
	public void insertAgentInfo(AgentInfoVO vo) throws Exception {
		socketLogger.info("SystemServiceImpl.insertAgentInfo : " + vo);
		
		systemDAO.insertAgentInfo(vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public void updateAgentInfo(AgentInfoVO vo) throws Exception {
		socketLogger.info("SystemServiceImpl.updateAgentInfo : " + vo);
		
		systemDAO.updateAgentInfo(vo);
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

		this.updateAgentEndInfo(vo);
	}
	
	/**
	 * Agent 설치 정보 종료 변경
	 * @param vo
	 * @throws Exception
	 */
	public void updateAgentEndInfo(AgentInfoVO vo) throws Exception {
		systemDAO.updateAgentEndInfo(vo);
	}
	
	/**
	 * 설치정보 관리
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentPropertiesChg() throws Exception  {
		Properties prop = new Properties();

		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		File file = new File(loader.getResource("context.properties").getFile());
	
		String path = file.getParent() + File.separator;

		try {
			prop.load(new FileInputStream(path + "context.properties"));
		} catch(FileNotFoundException e) {
			System.out.println("Exit(0) File Not Found ");
			System.exit(0);
		} catch(Exception e) {
			System.out.println("Exit(0) Error : " + e.toString());
			System.exit(0);
		}
		
		prop.setProperty("proxy.root.pwd", "");

		try {
			prop.store(new FileOutputStream(path + "context.properties"), "");
		} catch(FileNotFoundException e) {
			System.out.println("Exit(0) Error : File Not Found ");
			System.exit(0);
		} catch(Exception e) {
			System.out.println("Exit(0) Error : " + e.toString());
			System.exit(0);
		}
	}	

	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception {
		return systemDAO.selectDbServerInfoList();
	}
	
	public DbServerInfoVO selectDbServerInfo(DbServerInfoVO vo)  throws Exception {
		return (DbServerInfoVO) systemDAO.selectDbServerInfo(vo);
	}

	

	public DbServerInfoVO selectDatabaseConnInfo(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) systemDAO.selectDatabaseConnInfo(vo);
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

	public int selectScd_id() throws Exception {
		return (int) systemDAO.selectScd_id();
	}

	public void insertWRKEXE_G(WrkExeVO vo)  throws Exception{
		systemDAO.insertWRKEXE_G(vo);
	}
	
}