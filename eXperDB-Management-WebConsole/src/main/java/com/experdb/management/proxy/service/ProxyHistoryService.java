package com.experdb.management.proxy.service;

import java.net.ConnectException;
import java.util.List;
import java.util.Map;

/**
* @author 
* @see proxy 설정이력 관련 화면 service
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
*      </pre>
*/
public interface ProxyHistoryService {

	/**
	 * Proxy 기동 상태 변경 이력 조회
	 * 
	 * @param Map<String, Object> param
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectProxyActStateHistoryList(Map<String, Object> param);

	/**
	 * Proxy 설정 변경 이력 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param);

	/**
	 * Proxy 설정 파일 읽어오기
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws ConnectException 
	 * @throws Exception
	 */
	public Map<String, Object> getProxyConfFileContent(Map<String, Object> param) throws ConnectException, Exception;
	
	/**
	 * Proxy DB_CON_ADDR 목록 조회
	 *
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectSvrStatusDBConAddrList();

	/**
	 * Proxy T_PRY_SVR_STATUS_G 조회
	 *
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	public List<Map<String, Object>> selectProxyStatusHistory(Map<String, Object> param) throws Exception;

	public Map<String, Object> deleteProxyConfFolder(Map<String, Object> param) throws ConnectException, Exception;
}