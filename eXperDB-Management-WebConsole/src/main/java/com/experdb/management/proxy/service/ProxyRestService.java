package com.experdb.management.proxy.service;

import java.net.ConnectException;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

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
public interface ProxyRestService {

	/**
	 * Scale In된 Proxy 서버 및 Agent 목록
	 * 
	 * @param List<String>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectScaleInProxyList(Map<String, Object> param) throws Exception;
	
	/**
	 * Scale Out된 Proxy 서버 및 Agent 목록
	 * 
	 * @param List<String>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectScaleOutProxyList(Map<String, Object> param) throws Exception;
	
	/**
	 * Scale In시 Proxy Listener Svr List 삭제 
	 * 
	 * @param List<String>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public void scaleInProxyLsnSvrList(Map<String, Object> param) throws Exception;	
	
	/**
	 * Scale In시 Proxy Listener Svr List 추가 
	 * 
	 * @param List<String>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public void scaleOutProxyLsnSvrList(ProxyListenerServerVO[] listnSvr, List<Map<String, Object>> pryScaleList) throws ConnectException, Exception;
	
	/**
	 * Proxy Agent HAProxy.cfg 수정
	 * 
	 * @param List<Map<String, Object>>
	 * @return JSONObject
	 * @throws ConnectException
	 * @throws Exception
	 */
	public JSONObject setProxyConfScaleIn(List<Map<String, Object>> pryScaleList) throws ConnectException, Exception;



	
}