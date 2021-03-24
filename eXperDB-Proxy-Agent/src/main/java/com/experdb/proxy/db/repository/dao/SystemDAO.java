package com.experdb.proxy.db.repository.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyGlobalVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerServerListVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.ProxyVipConfigVO;
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

@Repository("SystemDAO")
public class SystemDAO {
	
	//private SqlSessionFactory sqlSessionFactory = SqlSessionManager.getInstance();

	@Autowired
    private SqlSession session;

	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) session.selectOne("system.selectAgentInfo", vo);
	}
	
	public void insertAgentInfo(AgentInfoVO vo) throws Exception  {
		 session.insert("system.insertAgentInfo", vo);
	}
	
	public void updateAgentInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updateAgentInfo", vo);
	}
	
	public void updateAgentEndInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updateAgentEndInfo", vo);
	}

	public ProxyServerVO selectProxyServerInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectProxyServerInfo", vo);
	}
	
	public List<DbServerInfoVO> selectDatabaseMasterConnInfo(DbServerInfoVO vo) throws Exception {
		return (List) session.selectList("system.selectDatabaseMasterConnInfo");
	}
	
	public int insertT_PRY_SVR_I(ProxyServerVO vo) throws Exception  {
		return session.insert("system.insertT_PRY_SVR_I", vo);
	}

	public int updateT_PRY_SVR_I(ProxyServerVO vo) throws Exception  {
		return session.update("system.updateT_PRY_SVR_I", vo);
	}
	
	public int updateMasterSvrIdBack(ProxyServerVO vo) throws Exception  {
		return session.update("system.updateMasterSvrIdBack", vo);
	}

	public ProxyServerVO selectMaxAgentInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectMaxAgentInfo", vo);
	}

	public int updateT_PRY_AGT_I_Yn(AgentInfoVO vo) throws Exception  {
		return session.update("system.updateT_PRY_AGT_I_Yn", vo);
	}

	/**
	 * T_PRY_SVR_I table seq 조회
	 * 
	 * @param 
	 * @throws Exception
	 */
	public long selectQ_T_PRY_SVR_I_01() throws Exception  {
		return (long) session.selectOne("system.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * T_PRY_GLB_I table insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertPryGlbI(ProxyGlobalVO proxyGlobalVO) throws Exception  {
		 session.insert("system.insertPryGlbI", proxyGlobalVO);
	}

	public ProxyListenerVO selectProxyLisnerInfo(ProxyListenerVO vo) throws Exception  {
		return (ProxyListenerVO) session.selectOne("system.selectProxyLisnerInfo", vo);
	}

	public long selectQ_T_PRY_LSN_I_01_SEQ() throws Exception  {
		return (long) session.selectOne("system.selectQ_T_PRY_LSN_I_01_SEQ");
	}
	
	public int insertT_PRY_LSN_I(ProxyListenerVO vo) throws Exception  {
		return session.insert("system.insertT_PRY_LSN_I", vo);
	}

	public int updateT_PRY_LSN_I(ProxyListenerVO vo) throws Exception  {
		return session.update("system.updateT_PRY_LSN_I", vo);
	}

	/**
	 * T_PRY_LSN_SVR_I table delete
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void deleteProxyLisnerSebuInfo(ProxyListenerServerListVO vo) throws Exception  {
		 session.delete("system.deleteProxyLisnerSebuInfo", vo);
	}
	
	
	public int insertProxyListnerSebu(ProxyListenerServerListVO vo) throws Exception  {
		return session.insert("system.insertProxyListnerSebu", vo);
	}

	/**
	 * T_PRY_VIP table insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertPryvVipCngI(ProxyVipConfigVO vo) throws Exception  {
		 session.insert("system.insertPryvVipCngI", vo);
	}

	
	
	
	
	
	
	
	
	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception {
		return (List) session.selectList("system.selectDbServerInfo");
	}
	
	public DbServerInfoVO selectDbServerInfo(DbServerInfoVO vo) throws Exception  {
		return (DbServerInfoVO) session.selectOne("system.selectDbServerInfo", vo);
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
	
	public int selectScd_id() throws Exception {
		return (int) session.selectOne("system.selectScd_id");
	}
	
	public void insertWRKEXE_G(WrkExeVO vo) throws Exception  {
		 session.insert("system.insertWRKEXE_G", vo);
	}
}
