package com.experdb.management.proxy.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

public interface ProxySettingService {

	/**
	 * proxy 화면 접속 히스토리 등록
	 * 
	 * @param request, historyVO, dtlCd, MnuId
	 * @return 
	 * @throws Exception
	 */
	void accessSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, String MnuId) throws Exception;

	/**
	 * Proxy Server 목록 조회
	 * 
	 * @param param
	 * @return List<ProxyServerVO>
	 * @throws Exception
	 */
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception;

	/**
	 * Proxy conf 상세조회
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject getPoxyServerConf(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 연결 DBMS 및 Master Proxy 정보 조회
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject createSelPrySvrReg(Map<String, Object> param) throws Exception;

	/**
	 * Proxy Master Proxy 정보 조회
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject selectMasterSvrProxyList(Map<String, Object> param);

	/**
	 * Proxy 서버 등록 서버명 조회
	 * 
	 * @param param
	 * @return String
	 * @throws
	 */
	public String proxySetServerNmList(Map<String, Object> param);

	/**
	 * Proxy 적용 실행
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject runProxyServer(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 연결 테스트
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject prySvrConnTest(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 등록
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> proxyServerReg(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 삭제
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject deletePrySvr(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param param
	 * @return List<ProxyListenerServerVO>
	 * @throws Exception
	 */
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param);

	/**
	 * Proxy ip 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectIpList(Map<String, Object> param);

	/**
	 * Proxy 적용
	 * 
	 * @param param, confData
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject applyProxyConf(Map<String, Object> param, JSONObject confData) throws Exception;
	
	/**
	 * Proxy agent 목록 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param);

	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param);

	JSONObject restartAgent(Map<String, Object> param) throws Exception;
}
