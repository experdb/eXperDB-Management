package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.SystemDAO;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.TrfTrgCngVO;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;
import com.k4m.dx.tcontrol.util.FileUtil;



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
			searchAgentInfoVO.setIPADR(strSocketIp);
			
			AgentInfoVO agentInfo = this.selectAgentInfo(searchAgentInfoVO);
			
			AgentInfoVO vo = new AgentInfoVO();
			
			vo.setIPADR(strSocketIp);
			vo.setSOCKET_PORT(Integer.parseInt(strSocketPort));
			vo.setAGT_VERSION(strVersion);
			vo.setAGT_CNDT_CD(AgentInfoVO.TC001101); //실행
			vo.setISTCNF_YN("Y");
			vo.setFRST_REGR_ID("system");
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
		vo.setAGT_CNDT_CD(AgentInfoVO.TC001102); //종료
		vo.setISTCNF_YN("Y");
		vo.setLST_MDFR_ID("system");
		
		this.updateAgentInfo(vo);
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
}
