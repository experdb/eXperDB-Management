package com.k4m.dx.tcontrol.db.repository.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
	
	public void updateAgentStopInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updateAgentStopInfo", vo);
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
	
	public void updateT_TRFTRGCNG_I(TrfTrgCngVO vo) throws Exception  {
		 session.update("system.updateT_TRFTRGCNG_I", vo);
	}
	
	public int selectQ_WRKEXE_G_02_SEQ() throws Exception  {
		return (int) session.selectOne("system.selectQ_WRKEXE_G_02_SEQ");
	}
	
	public void updateSCD_CNDT(WrkExeVO vo) throws Exception  {
		 session.update("system.updateSCD_CNDT", vo);
	}
	
	public DbServerInfoVO selectDatabaseConnInfo(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) session.selectOne("system.selectDatabaseConnInfo", vo);
	}
	
	public void updateDB_CNDT(DbServerInfoVO vo) throws Exception {
		session.update("system.updateDB_CNDT", vo);
	}
	
	public void updateDBSlaveAll(DbServerInfoVO vo) throws Exception {
		session.update("system.updateDBSlaveAll", vo);
	}
	
	public DbServerInfoVO selectISMasterGbm(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) session.selectOne("system.selectISMasterGbm", vo);
	}
	
	public void updateRMAN_RESTORE_CNDT(RmanRestoreVO vo) throws Exception {
		session.update("system.updateRMAN_RESTORE_CNDT", vo);
	}
	
	public void updateRMAN_RESTORE_EXELOG(RmanRestoreVO vo) throws Exception {
		session.update("system.updateRMAN_RESTORE_EXELOG", vo);
	}
	
	public void updateDUMP_RESTORE_CNDT(DumpRestoreVO vo) throws Exception {
		session.update("system.updateDUMP_RESTORE_CNDT", vo);
	}
	
	public void updateDUMP_RESTORE_EXELOG(DumpRestoreVO vo) throws Exception {
		session.update("system.updateDUMP_RESTORE_EXELOG", vo);
	}

	public int selectScd_id() throws Exception {
		return (int) session.selectOne("system.selectScd_id");
	}
	
	public void insertWRKEXE_G(WrkExeVO vo) throws Exception  {
		 session.insert("system.insertWRKEXE_G", vo);
	}
	
	public void updateTransExe(TransVO transVO) throws Exception{
		session.update("system.updateTransExe", transVO);
	}
	
	public void updateTransTargetExe(TransVO transVO) throws Exception{
		session.update("system.updateTransTargetExe", transVO);
	}

	//trans 기본사항 조회
	public TransVO selectTransComSettingInfo(TransVO vo) throws Exception  {
		return (TransVO) session.selectOne("system.selectTransComSettingInfo", vo);
	}

	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception {
		return (List) session.selectList("system.selectTablePkInfo", vo);
	}
}