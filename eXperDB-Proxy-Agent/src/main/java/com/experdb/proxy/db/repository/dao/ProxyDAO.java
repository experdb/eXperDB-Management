package com.experdb.proxy.db.repository.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyConfChangeHistoryVO;
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

@Repository("ProxyDAO")
public class ProxyDAO {

	@Autowired
    private SqlSession session;

	/**
	 * proxy 서버 정보 조회
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("proxy.selectPrySvrInfo", vo);
	}

	/**
	 * T_PRY_SVR_I table seq 조회
	 * 
	 * @param 
	 * @throws Exception
	 */
	public long selectQ_T_PRY_SVR_I_01() throws Exception  {
		return (long) session.selectOne("proxy.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * Proxy Server 정보 등록
	 * @param vo
	 * @throws Exception
	 */
	public int insertPrySvrInfo(ProxyServerVO vo) throws Exception  {
		return session.insert("proxy.insertPrySvrInfo", vo);
	}

	/**
	 * Proxy Server 정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public int updatePrySvrInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrInfo", vo);
	}

	/**
	 * Proxy Server Master_svr_id 변경
	 * @param vo
	 * @throws Exception
	 */
	public int updatePrySvrMstSvrIdList(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrMstSvrIdList", vo);
	}

	/**
	 * T_PRY_GLB_I table insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertPryGlbInfo(ProxyGlobalVO proxyGlobalVO) throws Exception  {
		 session.insert("proxy.insertPryGlbInfo", proxyGlobalVO);
	}

	/**
	 * T_PRY_GLB_I table 단건 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public ProxyListenerVO selectPryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return (ProxyListenerVO) session.selectOne("proxy.selectPryLsnInfo", vo);
	}

	/**
	 * T_PRY_LSN_I table seq 조회
	 * 
	 * @param 
	 * @throws Exception
	 */
	public long selectQ_T_PRY_LSN_I_01() throws Exception  {
		return (long) session.selectOne("proxy.selectQ_T_PRY_LSN_I_01");
	}

	/**
	 * T_PRY_LSN_I table 등록
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int insertPryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return session.insert("proxy.insertPryLsnInfo", vo);
	}

	/**
	 * T_PRY_LSN_I table 수정
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnInfo", vo);
	}
	
	/**
	 * T_PRY_LSN_SVR_I table delete
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void deletePryLsnSvrList(ProxyListenerServerListVO vo) throws Exception  {
		 session.delete("proxy.deletePryLsnSvrList", vo);
	}
	
	/**
	 * T_PRY_LSN_SVR_I table insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public int insertPryLsnSvrInfo(ProxyListenerServerListVO vo) throws Exception  {
		return session.insert("proxy.insertPryLsnSvrInfo", vo);
	}

	/**
	 * T_PRY_VIP table insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertPryVipCngInfo(ProxyVipConfigVO vo) throws Exception  {
		 session.insert("proxy.insertPryVipCngInfo", vo);
	}
	
	/**
	 * T_PRYCNG_G table insert
	 * 
	 * @param 
	 * @throws Exception
	 */
	public void insertPrycngInfo(ProxyConfChangeHistoryVO vo) throws Exception  {
		 session.insert("proxy.insertPrycngInfo", vo);
	}
}
