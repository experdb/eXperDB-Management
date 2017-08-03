package com.k4m.dx.tcontrol.db.repository.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;


@Repository("SystemDAO")
public class SystemDAO {
	
	//private SqlSessionFactory sqlSessionFactory = SqlSessionManager.getInstance();

	@Autowired
    private SqlSession session;

	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception {
		return (List) session.selectList("system.selectDbServerInfo");
	}
	
	public DbServerInfoVO selectDbServerInfo(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) session.selectOne("system.selectDbServerInfo", vo);
	}

	public void insertAgentInfo(AgentInfoVO vo) throws Exception  {
		 session.insert("system.insertAgentInfo", vo);
	}
	
	public void updateAgentInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updateAgentInfo", vo);
	}
	
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) session.selectOne("system.selectAgentInfo", vo);
	}
	
	public int selectQ_WRKEXE_G_01_SEQ() throws Exception  {
		return (int) session.selectOne("system.selectQ_WRKEXE_G_01_SEQ");
	}

	public void insertT_WRKEXE_G(WrkExeVO vo) throws Exception  {
		 session.insert("system.insertT_WRKEXE_G", vo);
	}

	public void updateT_WRKEXE_G(WrkExeVO vo) throws Exception  {
		 session.update("system.updateT_WRKEXE_G", vo);
	}
	
	
}
