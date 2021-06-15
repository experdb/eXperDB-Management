package com.experdb.proxy.db.repository.service;

import org.codehaus.jettison.json.JSONObject;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public interface ProxyLinkService {
	/**
	 * proxy Global 설정 조회
	 * @param ProxyGlovalVO
	 * @return String
	 * @throws Exception
	 */
	public JSONObject createNewConfFile(JSONObject jObj) throws Exception;
	
	/**
	 * Backup Conf 파일 읽어오기
	 * 
	 * @param String
	 * @return String
	 */
	String readBackupConfFile(String filePath);
	
	/**
	 * keepalvied, haproxy 서비스 중단/시작/재시작 하기
	 * @param JSONObject
	 * @return JSONObject
	 */
	JSONObject executeService(JSONObject jObj) throws Exception;
	
	/**
	 * Agent network Interface 정보
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	JSONObject getAgentInterface(JSONObject jObj) throws Exception;
	
	/**
	 * keepalived 설치 여부 및 path update
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception 
	 */
	JSONObject checkKeepalivedInstallYn(JSONObject jObj) throws Exception;
}
