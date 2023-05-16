package com.k4m.dx.tcontrol.db.repository.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.PryAgentInfoVO;
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
*  2022.12.22	강병석		에이전트 통합, 프록시 에이전트 기능 추가
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
	
	//=============================================
	//프록시 기능 추가 22.12.22
	
	/**
	 * Agent 설치정보 조회
	 * 
	 * @param AgentInfoVO
	 * @return AgentInfoVO
	 * @throws Exception
	 */
	public PryAgentInfoVO selectPryAgtInfo(PryAgentInfoVO vo) throws Exception  {
		return (PryAgentInfoVO) session.selectOne("system.selectPryAgtInfo", vo);
	}

	/**
	 * Agent 설치 정보 등록
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void insertPryAgtInfo(PryAgentInfoVO vo) throws Exception  {
		 session.insert("system.insertPryAgtInfo", vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtInfo(PryAgentInfoVO vo) throws Exception {
		session.update("system.updatePryAgtInfo", vo);
	}
	
	/**
	 * Agent 종료 정보 변경
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtStopInfo(PryAgentInfoVO vo) throws Exception {
		session.update("system.updatePryAgtStopInfo", vo);
	}
	
	/**
	 * db리스트 조회
	 * @param DbServerInfoVO
	 * @return List<DbServerInfoVO>
	 * @throws Exception
	 */
	public List<DbServerInfoVO> selectDbsvripadrMstGbnInfo(DbServerInfoVO vo) throws Exception {
		List<DbServerInfoVO> selectList = session.selectList("system.selectDbsvripadrMstGbnInfo");
		return selectList;
	}
	
	/**
	 * db리스트 내부ip 조회
	 * @param DbServerInfoVO
	 * @return List<DbServerInfoVO>
	 * @throws Exception
	 */
	public DbServerInfoVO selectDbsvripadrMstGbnIntlInfo(DbServerInfoVO vo) throws Exception {
		DbServerInfoVO selectList = session.selectOne("system.selectDbsvripadrMstGbnIntlInfo", vo);
		return selectList;
	}

	/**
	 * Proxy 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectPrySvrMaxNmInfo", vo);
	}

	/**
	 * Proxy DBMS 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectDBMSSvrMaxNmInfo", vo);
	}

	/**
	 * Proxy DBMS 별 마스터 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrEtcMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectDBMSSvrEtcMaxNmInfo", vo);
	}
	
	/**
	 * Agent 사용여부 변경
	 * 
	 * @param AgentInfoVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryAgtUseYnLInfo(PryAgentInfoVO vo) throws Exception  {
		return session.update("system.updatePryAgtUseYnLInfo", vo);
	}
	
	
	public int selectDbSvrIpAdrId(String ipadr) {
		int result;
		result = session.selectOne("system.selectDbSvrIpAdrId", ipadr);
		return result;
	}
	
	public void insertPgbackrestBackup(WrkExeVO vo) {
		session.insert("system.insertPgbackrestBackup", vo);
	}
}


