package com.experdb.proxy.db.repository.service;

import java.util.Map;

import org.codehaus.jettison.json.JSONObject;

import com.experdb.proxy.db.repository.vo.ProxyServerVO;

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

public interface ProxyService {
	
	/**
	 * proxy 서버 정보 조회
	 * @param ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrInfo(ProxyServerVO vo)  throws Exception;
	
	/**
	 * Proxy Properting 설정
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String selectProxyServerChk(String cmdGbn) throws Exception ;

	/**
	 * Proxy Properting 설정
	 * @param String strSocketIp, String strSocketPort
	 * @throws Exception
	 */
	/*public String proxyServerCfgSetting(String strSocketIp, String strSocketPort) throws Exception ;*/

	/**
	 * proxy 서버 param setting
	 * @param String search_gbn, String req_cmd, String server_ip
	 * @throws Exception
	 */
	public Map<String, Object> paramLoadSetting(String search_gbn, String req_cmd, String server_ip, String db_chk) throws Exception;
	
	/**
	 * 설치정보 conf 조회
	 * @param String cmdGbn, String req_cmd, String server_ip
	 * @throws Exception
	 */
	public JSONObject selectProxyServerList(String cmdGbn, String req_cmd, String server_ip, String db_chk) throws Exception;

	/**
	 * proxy 서버 저장 
	 * @param ProxyServerVO, insUpNmGbn
	 * @throws Exception
	 */
	public String proxyConfFisrtIns(ProxyServerVO insPryVo, String insUpNmGbn, Map<String, Object> insertParam, JSONObject jObjListResult) throws Exception;

	/**
	 * Proxy 실행상태 및 설치 상태 조회
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String selectProxyTotServerChk(String cmdGbn, String reqCmd) throws Exception ;
	

	/**
	 * Proxy 실행상태 및 설치 상태 조회
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String proxyDbmsStatusChk(Map<String, Object> chkParam) throws Exception ;
	
	/**
	 * Proxy 실시간 통계 데이터 삭제
	 * @param String cmdGbn
	 * @throws Exception
	 */
	public String proxyLsnScrStatusDel(Map<String, Object> chkParam) throws Exception ;
}
