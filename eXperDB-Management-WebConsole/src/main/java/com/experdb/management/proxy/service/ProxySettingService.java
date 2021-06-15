package com.experdb.management.proxy.service;

import java.net.ConnectException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
* @author 
* @see proxy 설정 관련 화면 service
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
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
	 * @param Map<String, Object>
	 * @return List<ProxyServerVO>
	 * @throws Exception
	 */
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception;

	/**
	 * Proxy conf 상세조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject getPoxyServerConf(Map<String, Object> param) throws Exception;

	/**
	 * Proxy Peer Vip 정보 select 박스 생성
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	JSONObject getVipInstancePeerList(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 연결 DBMS 및 Master Proxy 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject createSelPrySvrReg(Map<String, Object> param) throws Exception;

	/**
	 * Proxy Master Proxy 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject selectMasterSvrProxyList(Map<String, Object> param);

	/**
	 * Proxy 서버 등록 서버명 조회
	 * 
	 * @param Map<String, Object>
	 * @return String
	 * @throws
	 */
	public String proxySetServerNmList(Map<String, Object> param);

	/**
	 * Proxy 서비스 재/구동/중지
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject runProxyService(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 연결 테스트
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject prySvrConnTest(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 등록
	 * 
	 * @param Map<String, Object>
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> proxyServerReg(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 서버 삭제
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject deletePrySvr(Map<String, Object> param) throws Exception;

	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<ProxyListenerServerVO>
	 * @throws 
	 */
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param);

	/**
	 * Proxy 연결 dbms ip/port 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
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
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param);

	/**
	 * Proxy Master Proxy 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param);

	/**
	 * Proxy Agent Network Interface 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<String>
	 * @throws ConnectException
	 * @throws Exception
	 */
	List<String> getAgentInterface(Map<String, Object> param)throws ConnectException, Exception;

	/**
	 * VIP 사용 여부 업데이트
	 * 
	 * @param Map<String, Object>
	 * @return 
	 * @throws ConnectException
	 * @throws Exception
	 */
	public void updateDeleteVipUseYn(Map<String, Object> param) throws ConnectException, Exception;
	
	/**
	 * Proxy 연결 DBMS 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectDbmsTotList(Map<String, Object> param) throws Exception;

	/**
	 * Proxy Master 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectProxyMstTotList(Map<String, Object> param) throws Exception;

	/**
	 * Proxy Conf 데이터 재등록 요청
	 * 
	 * @param Map<String, Object>
	 * @return boolean
	 * @throws 
	 */
	boolean proxyServerReReg(Map<String, Object> param) throws ConnectException, Exception;

	/**
	 * Proxy Agent kal_install_yn 체크
	 * 
	 * @param Map<String, Object>
	 * @return boolean
	 * @throws ConnectException
	 * @throws Exception
	 */
	boolean checkAgentKalInstYn(Map<String, Object> param) throws ConnectException, Exception;
}