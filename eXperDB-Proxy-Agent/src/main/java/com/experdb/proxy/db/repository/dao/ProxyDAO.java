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

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
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
	/**
	 * Proxy 기동 이력 insert
	 * @param vo
	 * @throws Exception
	 */
	public void insertPryActCngInfo(ProxyActStateChangeHistoryVO vo) throws Exception  {
		session.insert("proxy.insertPryActCngInfo", vo);
	}
	
	/**
	 * Proxy 기동 상태 update
	 * @param vo
	 * @throws Exception
	 */
	public int updatePrySvrExeStatusInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrExeStatusInfo", vo);
	}

	/**
	 * Proxy 리스너 포트 내역 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryLsnPortList(Map<String, Object> param) {
		return (List) session.selectList("proxy.selectPryLsnPortList", param);
	}

	/**
	 * T_PRY_LSN_I table 수정(실행상태 등록)
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePryLsnStatusInfo(ProxyListenerVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnStatusInfo", vo);
	}

	/**
	 * vip 내역 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryVipcngVipList(Map<String, Object> param) {
		return (List) session.selectList("proxy.selectPryVipcngVipList", param);
	}

	/**
	 * T_PRY_VIPCNG_I table 수정(실행상태 등록)
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePryVipcngStatusInfo(ProxyVipConfigVO vo) throws Exception  {
		return session.update("proxy.updatePryVipcngStatusInfo", vo);
	}


	/**
	 * Proxy 기동상태 이력 max 값 조회 
	 * 
	 * @param param
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectPryActstateCngMaxTypeInfo(Map<String, Object> param) {
		return (List) session.selectList("proxy.selectPryActstateCngMaxTypeInfo", param);
	}

	/**
	 * proxy / keepalived 기동-정지 상태 변경 
	 * @param vo
	 * @throws Exception
	 */
	public int insertPryActExeCngInfo(Map<String, Object> param) throws Exception  {
		return session.insert("proxy.insertPryActExeCngInfo", param);
	}

	/**
	 * proxy selectPrySvrMasterSetInfo
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMasterSetInfo(Map<String, Object> param) throws Exception  {
		return (ProxyServerVO) session.selectOne("proxy.selectPrySvrMasterSetInfo", param);
	}

	/**
	 * Proxy Server 마스터 구분 정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public int updatePrySvrMstGbnInfo(ProxyServerVO vo) throws Exception  {
		return session.update("proxy.updatePrySvrMstGbnInfo", vo);
	}

	/**
	 * Proxy 관련 id 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectPryLsnSvrIdInfo(ProxyStatisticVO vo) throws SQLException {
		return (Map<String, Object>) session.selectOne("proxy.selectPryLsnSvrIdInfo", vo);
	}


	/**
	 * T_PRY_LSN_SVR_I table DB연결체크 수정
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePryLsnSvrDbRealChkInfo(ProxyStatisticVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnSvrDbRealChkInfo", vo);
	}

	/**
	 * t_pry_svr_status_g 리스너 정보등록
	 * @param vo
	 * @throws Exception
	 */
	public int insertPrySvrStatusInfo(ProxyStatisticVO vo) throws Exception  {
		return session.insert("proxy.insertPrySvrStatusInfo", vo);
	}
	
	/**
	 * t_pry_svr_status_g table delete
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void lsnSvrDelExecuteList(ProxyServerVO vo) throws Exception  {
		 session.delete("proxy.lsnSvrDelExecuteList", vo);
	}
	

	/**
	 * T_PRY_GLB_I table 단건 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public ProxyListenerServerListVO selectPryLsnSvrChkInfo(ProxyListenerServerListVO vo) throws Exception  {
		return (ProxyListenerServerListVO) session.selectOne("proxy.selectPryLsnSvrChkInfo", vo);
	}

	/**
	 * T_PRY_LSN_SVR_I table DB연결체크 수정
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePryLsnSvrInfo(ProxyListenerServerListVO vo) throws Exception  {
		return session.update("proxy.updatePryLsnSvrInfo", vo);
	}
	/**
	 * T_PRY_SVR_I의 KAL_PATH 수정
	 * 
	 * @param 
	 * @throws Exception
	 */
	public int updatePrySvrKalPathInfo(ProxyServerVO vo) {
		return session.update("proxy.updatePrySvrKalPathInfo", vo);
	}}
