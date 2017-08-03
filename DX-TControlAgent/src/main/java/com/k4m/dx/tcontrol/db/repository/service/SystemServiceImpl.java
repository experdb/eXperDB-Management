package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.SystemDAO;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
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
	public void agentInfoStartMng(DbServerInfoVO dbServerInfo) throws Exception  {
		if(dbServerInfo == null) {
			throw new Exception("DX-Tcontrol Repository DB에 서버가 등록되어 있지 않습니다. Database 서버를 등록 후 Agent를 구동하세요.");
		} else {
			String strSocketPort = FileUtil.getPropertyValue("context.properties", "socket.server.port");
			int DB_SVR_ID = dbServerInfo.getDB_SVR_ID();
			AgentInfoVO searchAgentInfoVO = new AgentInfoVO();
			searchAgentInfoVO.setDB_SVR_ID(DB_SVR_ID);
			
			AgentInfoVO agentInfo = this.selectAgentInfo(searchAgentInfoVO);
			
			AgentInfoVO vo = new AgentInfoVO();
			
			vo.setDB_SVR_ID(dbServerInfo.getDB_SVR_ID());
			vo.setSOCKET_PORT(Integer.parseInt(strSocketPort));
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
	}
	
	public void agentInfoStopMng(DbServerInfoVO dbServerInfo) throws Exception  {
		int DB_SVR_ID = dbServerInfo.getDB_SVR_ID();
		AgentInfoVO searchAgentInfoVO = new AgentInfoVO();
		searchAgentInfoVO.setDB_SVR_ID(DB_SVR_ID);
		
		AgentInfoVO vo = new AgentInfoVO();
		
		vo.setDB_SVR_ID(dbServerInfo.getDB_SVR_ID());
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
}
