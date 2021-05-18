package com.experdb.management.proxy.service;

import java.net.ConnectException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;



public interface ProxyHistoryService {

	/**
	 * Proxy 기동 상태 변경 이력
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectProxyActStateHistoryList(Map<String, Object> param);

	/**
	 * Proxy 설정 변경 이력
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param);

	/**
	 * Proxy 설정 파일 읽어오기
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> getProxyConfFileContent(Map<String, Object> param) throws ConnectException, Exception;

}
