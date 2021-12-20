package com.experdb.management.proxy.service.impl;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyRestService;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * @author 김민정
 * @see proxy 설정 관련 화면 serviceImpl
 * 
 *      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2021.03.05              최초 생성
 *      </pre>
 */
@Service("ProxyRestServiceImpl")
public class ProxyRestServiceImpl extends EgovAbstractServiceImpl implements ProxyRestService{
	
	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;
	
	@Resource(name = "proxyRestDAO")
	private ProxyRestDAO proxyRestDAO;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	@Autowired
	private MessageSource msg;

	/**
	 * Scale In된 Proxy 서버 및 Agent 목록
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectScaleInProxyList(Map<String, Object> param) throws Exception {
		return  proxyRestDAO.selectScaleInProxyList(param);
	}
	
	/**
	 * Scale Out된 Proxy 서버 및 Agent 목록
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectScaleOutProxyList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return  proxyRestDAO.selectScaleOutProxyList(param);
	}
	
	/**
	 * Scale In시 Proxy Listener Svr List 및 이력 삭제 
	 * 
	 * @param Map<String, Object>
	 * @return 
	 * @throws 
	 */
	@Override
	public void scaleInProxyLsnSvrList(Map<String, Object> param) throws Exception {
		//상태 이력 삭제
		System.out.println("상태 이력 삭제 ");
		proxyRestDAO.deletProxySvrStatusHistoryList(param);
		//서버리스트 삭제 
		System.out.println("서버 리스트 삭제 ");
		proxyRestDAO.deletProxyLsnSvrList(param);
		
	}

	/**
	 * Scale In시 Proxy Listener Svr List 추가 
	 * 
	 * @param Map<String, Object>
	 * @return 
	 * @throws 
	 */
	@Override
	public void scaleOutProxyLsnSvrList(ProxyListenerServerVO[] listnSvr, List<Map<String, Object>> pryScaleList) throws Exception {
		// TODO Auto-generated method stub
		
		if(listnSvr.length >0){
		
			for(int i=0; i<pryScaleList.size(); i++){
				Map<String, Object> pryList = pryScaleList.get(i);
				int prySvrId = Integer.parseInt(pryList.get("pry_svr_id").toString());
				int agtSn = Integer.parseInt(pryList.get("agt_sn").toString());
				for(int j=0; j < listnSvr.length; j++){
					listnSvr[j].setPry_svr_id(prySvrId);
					
					proxyRestDAO.insertProxyLsnSvrList(listnSvr[j]);
					
				}
			}
			
		}
	}
	
	/**
	 * Proxy Agent HAProxy.cfg 수정
	 * 
	 * @param List<Map<String, Object>>, JSONArray
	 * @return JSONArray
	 * @throws ConnectException
	 * @throws Exception
	 */
	@Override
	public JSONObject setProxyConfScaleIn(List<Map<String, Object>> pryScaleList) throws ConnectException, Exception {
		JSONObject result = new JSONObject();
		//Agent 마다 설정 수정 및 reload 처리 해야 함.
		for(Map<String, Object> agentInfo : pryScaleList){
			int prySvrId =  Integer.parseInt(agentInfo.get("pry_svr_id").toString());
			
			//Agent에 넘겨줄 Data JSONObject로 생성
			Map<String, Object> agentParam = new HashMap<String,Object>();
			agentParam.put("pry_svr_id", prySvrId);
			//GLOBAL 정보
			JSONObject globalJObj = proxySettingDAO.selectProxyGlobal(agentParam).toJSONObject();
			
			JSONObject agentJobj = new JSONObject();
			agentJobj.put("global_info", globalJObj); //global 정보 생성
			
			//LISTENER 정보
			List<ProxyListenerVO> listenerList = proxySettingDAO.selectProxyListenerList(agentParam);
			JSONArray listenerJArr = new JSONArray();
			for(ProxyListenerVO listenVO : listenerList){
				JSONObject tempObj = listenVO.toJSONObject();
				agentParam.put("lsn_id", listenVO.getLsn_id());
				List<ProxyListenerServerVO> listenerSvrList= proxySettingDAO.selectListenServerList(agentParam);
				JSONArray listenerSvrJArr = new JSONArray();
				for(ProxyListenerServerVO listenSvrVO : listenerSvrList){
					listenerSvrJArr.add(listenSvrVO.toJSONObject());
				}
				tempObj.put("server_list", listenerSvrJArr);
				listenerJArr.add(tempObj);
				agentParam.remove("lsn_id");
			}
			agentJobj.put("listener_list", listenerJArr);
		
			List<CmmnCodeVO> cmmnCodeVO =  null;
			PageVO pageVO = new PageVO();
			
			pageVO.setGrp_cd("TC0042");
			pageVO.setSearchCondition("0");
			cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			
			for(int j=0; j<cmmnCodeVO.size(); j++){
				CmmnCodeVO tempCode = cmmnCodeVO.get(j);
				agentJobj.put(tempCode.getSys_cd(), tempCode.getSys_cd_nm());
			}
			
			ProxyServerVO proxyServerVO =(ProxyServerVO) proxySettingDAO.selectProxyServerInfo(prySvrId);
			String kalUseYn = (proxyServerVO.getKal_install_yn() == null) ? "" : proxyServerVO.getKal_install_yn(); 
		    String awsYn = (proxyServerVO.getAws_yn() == null) ? "N" : proxyServerVO.getAws_yn(); 
			agentJobj.put("KAL_INSTALL_YN", kalUseYn);
			agentJobj.put("AWS_YN", awsYn);
			agentJobj.put("lst_mdfr_id", "system");
			
			boolean createNewConfig = false;
			String resultLog = "";
			String errMsg = "";
			
			//Agent 접속 정보 추출 
			ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(agentParam);
			Map<String, Object> agentConnectResult = new  HashMap<String, Object>();
			ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
			agentConnectResult = cic.setProxyConfScaleIn(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
			
			//String result_code = "";
			if (agentConnectResult != null) {
				if ("0".equals(agentConnectResult.get("RESULT_CODE"))) {
					createNewConfig = true;
					resultLog = "success";
					errMsg= msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale());
					result.put("resultCd", 0);
				}else{
					createNewConfig = false;
					resultLog = "faild";
					errMsg= msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
					result.put("resultCd", -2);
				}
			}else{
				createNewConfig = false;
				resultLog = "faild";
				errMsg= msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
				result.put("resultCd", -1);
			}
			
			result.put("resultMsg", errMsg);
		}
		return result;
	}
	
}
