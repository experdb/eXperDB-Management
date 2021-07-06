package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.SystemDAO;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
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
*      </pre>
*/

@Service("SystemService")
public class SystemServiceImpl implements SystemService{

	@Resource(name = "SystemDAO")
	private SystemDAO systemDAO;
	
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
	public void agentInfoStartMng(String strSocketIp, String strSocketPort, String strVersion, String strProxyInterIP) throws Exception  {
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
		vo.setLST_MDFR_ID("system");
			
		if(agentInfo == null) {
			this.insertAgentInfo(vo);
		} else {
			this.updateAgentInfo(vo);
		}
	}
	
	public void agentInfoStopMng(String strSocketIp, String strSocketPort) throws Exception  {
		AgentInfoVO vo = new AgentInfoVO();
		
		vo.setIPADR(strSocketIp);
		vo.setSOCKET_PORT(Integer.parseInt(strSocketPort));
		vo.setAGT_CNDT_CD(vo.TC001102); //종료
		vo.setISTCNF_YN("Y");
		vo.setLST_MDFR_ID("system");
		
		this.updateAgentStopInfo(vo);
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
	
	public void updateTransExe(TransVO transVO) throws Exception{
		systemDAO.updateTransExe(transVO);
	}
	
	public void updateTransTargetExe(TransVO transVO) throws Exception{
		systemDAO.updateTransTargetExe(transVO);
	}
	
	//trans 기본사항 조회
	public TransVO selectTransComSettingInfo(TransVO vo)  throws Exception {
		return (TransVO) systemDAO.selectTransComSettingInfo(vo);
	}
	
	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception {
		return systemDAO.selectTablePkInfo(vo);
	}
}