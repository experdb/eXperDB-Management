package com.experdb.proxy.db.repository.service;

import org.json.simple.JSONObject;

/**
* @author 윤정 매니저
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.04.22   윤정 매니저         최초 생성
*      </pre>
*/
public interface ProxyGetFileService {
	
	/**
	 * proxy, vip config file 가져오기
	 * @param strDxExCode, jObj
	 * @return JSONObject
	 * @throws NumberFormatException, Exception
	 */
	public JSONObject getConfigFile(String strDxExCode, JSONObject jObj) throws NumberFormatException, Exception;

	public JSONObject getLogFile(String strDxExCode, JSONObject jObj) throws NumberFormatException, Exception;
	
}
