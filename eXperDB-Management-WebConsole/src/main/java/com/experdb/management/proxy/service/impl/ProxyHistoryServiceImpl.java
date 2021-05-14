package com.experdb.management.proxy.service.impl;

import java.net.ConnectException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyHistoryService;
import com.experdb.management.proxy.service.ProxyServerVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;



@Service("ProxyHistoryServiceImpl")
public class ProxyHistoryServiceImpl extends EgovAbstractServiceImpl implements ProxyHistoryService{
	
	@Resource(name = "proxyHistoryDAO")
	private ProxyHistoryDAO proxyHistoryDAO;

	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;
	
	/**
	 * Proxy 기동 상태 변경 이력 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectProxyActStateHistoryList(Map<String, Object> param) {
		return proxyHistoryDAO.selectProxyActStateHistoryList(param);
	}
	
	/**
	 * Proxy 설정 변경 이력 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param) {
		return proxyHistoryDAO.selectProxySettingChgHistoryList(param);
	}
	
	/**
	 * Proxy 설정 파일 읽어오기
	 * 
	 * @param param
	 * @return String
	 * @throws SQLException 
	 * @throws Exception
	 */
	@Override
	public String getProxyConfFileContent(Map<String, Object> param) throws ConnectException, Exception{
		String confStr = "";
		
		Map<String, Object> pathInfo =  proxyHistoryDAO.selectProxyConfFilePath(param);
		
		JSONObject agentJobj = new JSONObject();
		String filePath = "";
		if("P".equals(param.get("sys_type").toString())){
			filePath=pathInfo.get("pry_pth").toString();
		}else{
			filePath=pathInfo.get("kal_pth").toString();
		}
		
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
	    Map<String, Object> fileReadResult = new  HashMap<String, Object>();
	    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
	      try{
	         agentJobj.put("file_path", filePath);
	         fileReadResult = cic.getConfigBackupFile(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
	      }catch(ConnectException e){
	         throw e;
	      }
	      
	      if (fileReadResult != null) {
	        confStr = fileReadResult.get("RESULT_CODE").toString();
	      } 
		return confStr;
	}
}
