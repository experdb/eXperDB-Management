package com.experdb.proxy.db.repository.service;

import java.util.Map;

import org.codehaus.jettison.json.JSONException;
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

public interface ProxyLinkService {
	/**
	 * proxy Global 설정 조회
	 * @param ProxyGlovalVO
	 * @throws Exception
	 */
	public JSONObject createNewConfFile(JSONObject jObj) throws Exception;

	String readBackupConfFile(String filePath);

	JSONObject executeService(JSONObject jObj) throws Exception;

	JSONObject getAgentInterface(JSONObject jObj) throws Exception;

	JSONObject checkKeepalivedInstallYn(JSONObject jObj) throws Exception;
}
