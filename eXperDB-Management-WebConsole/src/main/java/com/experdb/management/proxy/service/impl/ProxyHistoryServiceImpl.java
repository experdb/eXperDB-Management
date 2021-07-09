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
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @author
 * @see proxy 설정이력 관련 serviceImpl
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Service("ProxyHistoryServiceImpl")
public class ProxyHistoryServiceImpl extends EgovAbstractServiceImpl implements ProxyHistoryService{
	
	@Resource(name = "proxyHistoryDAO")
	private ProxyHistoryDAO proxyHistoryDAO;

	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;

	/**
	 * Proxy 기동 상태 변경 이력 조회
	 * 
	 * @param Map<String, Object> param
	 * @return List<Map<String, Object>>
	 * @throws 
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
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectProxySettingChgHistoryList(Map<String, Object> param) {
		return proxyHistoryDAO.selectProxySettingChgHistoryList(param);
	}
	
	/**
	 * Proxy 설정 파일 읽어오기
	 * 
	 * @param param
	 * @return Map<String, Object>
	 * @throws ConnectException 
	 * @throws Exception
	 */
	@Override
	public  Map<String, Object> getProxyConfFileContent(Map<String, Object> param) throws ConnectException, Exception{
		CmmnUtils cu = new CmmnUtils();
		//System.out.println("getProxyConfFileContent");
		Map<String, Object> result = new HashMap<String, Object>();
		
		Map<String, Object> pathInfo =  proxyHistoryDAO.selectProxyConfFilePath(param);
		JSONObject agentJobj = new JSONObject();
		String backupFilePath = "";
		String presentFilePath = "";
		if("P".equals(param.get("sys_type").toString())){
			backupFilePath=cu.getStringWithoutNull(pathInfo.get("backup_pry_pth"));
			presentFilePath=cu.getStringWithoutNull(pathInfo.get("present_pry_pth"));
		}else{
			backupFilePath=cu.getStringWithoutNull(pathInfo.get("backup_kal_pth"));
			presentFilePath=cu.getStringWithoutNull(pathInfo.get("present_kal_pth"));
		}
		
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
	    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
	      try{
	         agentJobj.put("backup_file_path", backupFilePath);
	         agentJobj.put("present_file_path", presentFilePath);
	         result = cic.getConfigBackupFile(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
	         //System.out.println(result.toString());
	      }catch(ConnectException e){
	         throw e;
	      }
	      
	      return result;
	      
	}

	@Override
	public List<Map<String, Object>> selectSvrStatusDBConAddrList() {
		return proxyHistoryDAO.selectSvrStatusDBConAddrList();
	}

	@Override
	public List<Map<String, Object>> selectProxyStatusHistory(Map<String, Object> param) throws SQLException {
		return proxyHistoryDAO.selectProxyStatusHistory(param);
	}

	@Override
	public Map<String, Object> deleteProxyConfFolder(Map<String, Object> param)	throws ConnectException, Exception {
		CmmnUtils cu = new CmmnUtils();
		//System.out.println("getProxyConfFileContent");
		Map<String, Object> result = new HashMap<String, Object>();
		
		Map<String, Object> pathInfo =  proxyHistoryDAO.selectProxyConfFilePath(param);
		JSONObject agentJobj = new JSONObject();
		String backupPryFilePath = "";
		
		backupPryFilePath=cu.getStringWithoutNull(pathInfo.get("backup_pry_pth"));
		
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
	    ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
	    
	    try{
		    backupPryFilePath = backupPryFilePath.substring(0, backupPryFilePath.lastIndexOf("/")+1);
		    agentJobj.put("del_backup_folder", backupPryFilePath);
		    result = cic.deleteConfigBackupFolder(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
		    
		    if( result.get("RESULT_CODE") != null &&   "0".equals(result.get("RESULT_CODE").toString())){
		    	proxyHistoryDAO.updateProxySettingChgHistoryList(param);
		    }
		    
	    }catch(ConnectException e){
	         throw e;
	     }
	      
	      return result;
	}

}
