package com.experdb.proxy.db.repository.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.proxy.db.repository.vo.ProxyActStateChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyConfChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyGlobalVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerServerListVO;
import com.experdb.proxy.db.repository.vo.ProxyListenerVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.db.repository.vo.ProxyStatisticVO;
import com.experdb.proxy.db.repository.vo.ProxyVipConfigVO;


/**
* @author 
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   		최초 생성
*      </pre>
*/

@Repository("ProxyDAO")
public class ProxyDAO {

	@Autowired
    private SqlSession session;

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	/**
	 * proxy 서버 정보 조회
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("proxy.selectPrySvrInfo", vo);
	}

	/**
	 * proxy 서버 정보 조회
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInslInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("proxy.selectPrySvrInslInfo", vo);
	}
	
	/**
	 * T_PRY_SVR_I table seq 조회
	 * 
	 * @param 
	 * @return long
	 * @throws Exception
	 */
	public long selectQ_T_PRY_SVR_I_01() throws Exception  {
		return (long) session.selectOne("proxy.selectQ_T_PRY_SVR_I_01");
	}

	/**
	 * Proxy Server 정보 등록
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int insertPrySvrInfo(ProxyServerVO vo) throws Exception  {
		return session.insert("proxy.insertPrySvrInfo", vo);
	}

	/**
	 * Proxy Server 정보 수정
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePrySvrInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrInfo", vo);
	}

	/**
	 * Proxy Server Master_svr_id 변경
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePrySvrMstSvrIdList(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrMstSvrIdList", vo);
	}

	/**
	 * T_PRY_GLB_I table insert
	 * 
	 * @param ProxyGlobalVO
	 * @throws Exception
	 */
	public void insertPryGlbInfo(ProxyGlobalVO proxyGlobalVO) throws Exception  {
		 session.insert("proxy.insertPryGlbInfo", proxyGlobalVO);
	}

	/**
	 * T_PRY_GLB_I table 단건 조회
	 * 
	 * @param ProxyListenerVO
	 * @return ProxyListenerVO
	 * @throws Exception
	 */
	public ProxyListenerVO selectPryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return (ProxyListenerVO) session.selectOne("proxy.selectPryLsnInfo", vo);
	}

	/**
	 * T_PRY_LSN_I table seq 조회
	 * 
	 * @param 
	 * @return long
	 * @throws Exception
	 */
	public long selectQ_T_PRY_LSN_I_01() throws Exception  {
		return (long) session.selectOne("proxy.selectQ_T_PRY_LSN_I_01");
	}

	/**
	 * T_PRY_LSN_I table 등록
	 * 
	 * @param ProxyListenerVO
	 * @return integer
	 * @throws Exception
	 */
	public int insertPryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return session.insert("proxy.insertPryLsnInfo", vo);
	}

	/**
	 * T_PRY_LSN_I table 수정
	 * 
	 * @param ProxyListenerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryLsnInfo(ProxyListenerVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnInfo", vo);
	}
	
	/**
	 * T_PRY_LSN_SVR_I table delete
	 * 
	 * @param ProxyListenerServerListVO
	 * @throws Exception
	 */
	public void deletePryLsnSvrList(ProxyListenerServerListVO vo) throws Exception  {
		 session.delete("proxy.deletePryLsnSvrList", vo);
	}
	
	/**
	 * T_PRY_LSN_SVR_I table insert
	 * 
	 * @param ProxyListenerServerListVO
	 * @return integer
	 * @throws Exception
	 */
	public int insertPryLsnSvrInfo(ProxyListenerServerListVO vo) throws Exception  {
		return session.insert("proxy.insertPryLsnSvrInfo", vo);
	}

	/**
	 * T_PRY_VIP table insert
	 * 
	 * @param ProxyVipConfigVO
	 * @throws Exception
	 */
	public void insertPryVipCngInfo(ProxyVipConfigVO vo) throws Exception  {
		 session.insert("proxy.insertPryVipCngInfo", vo);
	}
	
	/**
	 * T_PRYCNG_G table insert
	 * 
	 * @param ProxyConfChangeHistoryVO
	 * @throws Exception
	 */
	public void insertPrycngInfo(ProxyConfChangeHistoryVO vo) throws Exception  {
		 session.insert("proxy.insertPrycngInfo", vo);
	}
	/**
	 * Proxy 기동 이력 insert
	 * @param ProxyActStateChangeHistoryVO
	 * @throws Exception
	 */
	public void insertPryActCngInfo(ProxyActStateChangeHistoryVO vo) throws Exception  {
		session.insert("proxy.insertPryActCngInfo", vo);
	}
	
	/**
	 * Proxy 기동 상태 update
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePrySvrExeStatusInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrExeStatusInfo", vo);
	}

	/**
	 * Proxy 리스너 포트 내역 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryLsnPortList(Map<String, Object> param) {
		List<Map<String, Object>> selectList = session.selectList("proxy.selectPryLsnPortList", param);
		return selectList;
	}

	/**
	 * T_PRY_LSN_I table 수정(실행상태 등록)
	 * 
	 * @param ProxyListenerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryLsnStatusInfo(ProxyListenerVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnStatusInfo", vo);
	}

	/**
	 * vip 내역 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryVipcngVipList(Map<String, Object> param) {
		List<Map<String, Object>> selectList = session.selectList("proxy.selectPryVipcngVipList", param);
		return selectList ;
	}

	/**
	 * T_PRY_VIPCNG_I table 수정(실행상태 등록)
	 * 
	 * @param ProxyVipConfigVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryVipcngStatusInfo(ProxyVipConfigVO vo) throws Exception  {
		return session.update("proxy.updatePryVipcngStatusInfo", vo);
	}

	/**
	 * Proxy 기동상태 이력 max 값 조회 
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryActstateCngMaxTypeInfo(Map<String, Object> param) {
		List<Map<String, Object>> selectList = session.selectList("proxy.selectPryActstateCngMaxTypeInfo", param);
		return selectList;
	}

	/**
	 * proxy / keepalived 기동-정지 상태 변경 
	 * @param Map<String, Object>
	 * @return integer
	 * @throws Exception
	 */
	public int insertPryActExeCngInfo(Map<String, Object> param) throws Exception  {
		return session.insert("proxy.insertPryActExeCngInfo", param);
	}

	/**
	 * proxy 현재 마스터 목록 조회
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMasterSetInfo(Map<String, Object> param) throws Exception  {
		return (ProxyServerVO) session.selectOne("proxy.selectPrySvrMasterSetInfo", param);
	}

	/**
	 * Proxy Server 마스터 구분 정보 수정
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePrySvrMstGbnInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrMstGbnInfo", vo);
	}

	/**
	 * Proxy 리스너 포트 조회
	 * 
	 * @param ProxyStatisticVO
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectPryLsnSvrIdInfo(ProxyStatisticVO vo) throws SQLException {
		@SuppressWarnings("unchecked")
		Map<String, Object> selectOne = (Map<String, Object>) session.selectOne("proxy.selectPryLsnSvrIdInfo", vo);
		return selectOne;
	}

	/**
	 * T_PRY_LSN_SVR_I table DB연결체크 수정
	 * 
	 * @param ProxyStatisticVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryLsnSvrDbRealChkInfo(ProxyStatisticVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnSvrDbRealChkInfo", vo);
	}

	/**
	 * proxy 리스너 통계 데이터 등록
	 * @param ProxyStatisticVO
	 * @return integer
	 * @throws Exception
	 */
	public int insertPrySvrStatusInfo(ProxyStatisticVO vo) throws Exception  {
		return session.insert("proxy.insertPrySvrStatusInfo", vo);
	}
	
	/**
	 * proxy 리스너 통계정보 삭제
	 * 
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public void lsnSvrDelExecuteList(ProxyServerVO vo) throws Exception  {
		 session.delete("proxy.lsnSvrDelExecuteList", vo);
	}

	/**
	 * 리스너 서버 등록 여부 조회
	 * 
	 * @param ProxyListenerServerListVO
	 * @return ProxyListenerServerListVO
	 * @throws Exception
	 */
	public ProxyListenerServerListVO selectPryLsnSvrChkInfo(ProxyListenerServerListVO vo) throws Exception  {
		return (ProxyListenerServerListVO) session.selectOne("proxy.selectPryLsnSvrChkInfo", vo);
	}

	/**
	 * T_PRY_LSN_SVR_I table DB연결체크 수정
	 * 
	 * @param ProxyListenerServerListVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryLsnSvrInfo(ProxyListenerServerListVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnSvrInfo", vo);
	}
	
	/**
	 * T_PRY_SVR_I의 KAL_PATH 수정
	 * 
	 * @param ProxyServerVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePrySvrKalPathInfo(ProxyServerVO vo) {
		return session.update("proxy.updatePrySvrKalPathInfo", vo);
	}}
