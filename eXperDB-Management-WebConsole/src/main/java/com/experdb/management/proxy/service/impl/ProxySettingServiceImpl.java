package com.experdb.management.proxy.service.impl;

import java.net.ConnectException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.CommonUtil;
import com.experdb.management.proxy.cmmn.ProxyClientInfoCmmn;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;

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
@Service("ProxySettingServiceImpl")
public class ProxySettingServiceImpl extends EgovAbstractServiceImpl implements ProxySettingService{
	
	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;
	
	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	@Autowired
	private MessageSource msg;

	/**
	 * proxy 화면 접속 히스토리 등록
	 * 
	 * @param request, historyVO, dtlCd, MnuId
	 * @return 
	 * @throws Exception
	 */
	@Override
	public void accessSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd, String MnuId) throws Exception {
		CmmnUtils.saveHistory(request, historyVO);
		historyVO.setExe_dtl_cd(dtlCd);
		
		if (MnuId != null && !"".equals(MnuId)) {
			historyVO.setMnu_id(Integer.parseInt(MnuId));
		}
	
		accessHistoryDAO.insertHistory(historyVO);
	}

	/**
	 * Proxy Server 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<ProxyServerVO>
	 * @throws Exception
	 */
	@Override
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyServerList(param);
	}

	/**
	 * Proxy Agent Network Interface 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<String>
	 * @throws ConnectException
	 * @throws Exception
	 */
	public List<String> getAgentInterface(Map<String, Object> param) throws ConnectException, Exception {
		List<String> interfList = new ArrayList<String>();
		//Agent Interface select box 생성 정보
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
		Map<String, Object> intfItemsResult = new HashMap<String, Object>();
		ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		try{
			intfItemsResult = cic.getProxyAgtInterface(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
		}catch(ConnectException e){
			throw e;
		}catch(Exception e){
			throw e;
		}
		
		if (intfItemsResult != null) {
			String agentInterfList = intfItemsResult.get("INTF_LIST").toString();
			String agentInterf = intfItemsResult.get("INTF").toString();
			
			interfList.add(agentInterf);
			
			String[] interfItems = agentInterfList.split("\t");
			for(int  i =0; i< interfItems.length; i++){
				interfList.add(interfItems[i]);
			}
		}
		return interfList;
	}

	/**
	 * Proxy conf 상세조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject getPoxyServerConf(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();
		
		//Global 정보 조회
		ProxyGlobalVO globalInfo = proxySettingDAO.selectProxyGlobal(param);

		//Proxy Listener List 정보 조회
		List<ProxyListenerVO> listenerList = proxySettingDAO.selectProxyListenerList(param);

		//VIP List 정보조회
		List<ProxyVipConfigVO> vipConfigList = proxySettingDAO.selectProxyVipConfList(param);

		//Proxy Listener database select box 생성 정보
		List<Map<String, Object>> dbSelList = proxySettingDAO.selectDBSelList(param);
		
		param.put("peer", "Y");
		//Peer Server VIP List 정보 조회 
		List<ProxyVipConfigVO> peerVipConfigList = proxySettingDAO.selectProxyVipConfList(param);

		//Peer Server Proxy Listener 정보 조회 
		List<ProxyListenerVO> peerListenerList = proxySettingDAO.selectProxyListenerList(param);
		
		//json set
		resultObj.put("errcd", 0);
		resultObj.put("errMsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
		resultObj.put("global_info", globalInfo == null? null:globalInfo);
		resultObj.put("listener_list", listenerList == null? null:listenerList);
		resultObj.put("vipconfig_list", vipConfigList == null? null:vipConfigList);
		resultObj.put("db_sel_list", dbSelList == null? null:dbSelList);
		resultObj.put("peer_listener_list", peerListenerList == null? null:peerListenerList);
		resultObj.put("peer_vipconfig_list", peerVipConfigList == null? null:peerVipConfigList);
		return resultObj;
	}

	/**
	 * Proxy Peer Vip 정보 select 박스 생성
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject getVipInstancePeerList(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();
		
		param.put("peer", "Y");
		//Peer Server VIP List 정보 조회 
		List<ProxyVipConfigVO> peerVipConfigList = proxySettingDAO.selectProxyVipConfList(param);
		resultObj.put("errcd", 0);
		resultObj.put("errMsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
		resultObj.put("peer_vipconfig_list", peerVipConfigList == null? null:peerVipConfigList);
		
		return resultObj;
	}

	/**
	 * Proxy 연결 DBMS 및 Master Proxy 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject createSelPrySvrReg(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();
		
		//연결 DBMS 정보 
		List<Map<String, Object>> dbmsSelList = proxySettingDAO.selectDbmsList(param);

/*		//Master Proxy 정보
		if (dbmsSelList.size() > 0) {
			param.put("db_svr_id", dbmsSelList.get(0).get("db_svr_id"));
		} else {
			param.put("db_svr_id", null);
		}*/
		List<Map<String, Object>> mstSvrSelList = proxySettingDAO.selectMasterSvrProxyList(param);
		
		//json set
		resultObj.put("dbmsSvrList", dbmsSelList == null? null:dbmsSelList);
		resultObj.put("mstSvrList", mstSvrSelList == null? null:mstSvrSelList);
		
		return resultObj;
	}

	/**
	 * Proxy Master Proxy 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	@Override
	public JSONObject selectMasterSvrProxyList(Map<String, Object> param) {
		JSONObject resultObj = new JSONObject();

		List<Map<String, Object>> mstSvrSelList = proxySettingDAO.selectMasterSvrProxyList(param);
		//json set
		resultObj.put("mstSvr_sel_list", mstSvrSelList == null? null:mstSvrSelList);

		return resultObj;
	}

	/**
	 * Proxy 서버 등록 서버명 조회
	 * 
	 * @param Map<String, Object>
	 * @return String
	 * @throws
	 */
	@Override
	public String proxySetServerNmList(Map<String, Object> param) {
		String result = "";
		
		try {
			int resultObjNum = 0;
			String ServerCnt = proxySettingDAO.proxySetServerNmList(param);

			if (ServerCnt != null && !"".equals(ServerCnt)) {
				resultObjNum = Integer.parseInt(ServerCnt) + 1;
				result = Integer.toString(resultObjNum);
			} else {
				result = "1";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * Proxy 서비스 재/구동/중지
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	   public JSONObject runProxyService(Map<String, Object> param) throws ConnectException, Exception {
		      JSONObject resultObj = new JSONObject();

		      int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
		      String lst_mdfr_id = param.get("lst_mdfr_id").toString();
		      String status = param.get("status").toString();
		      String actType = param.get("act_type").toString();
		      String[] statusNm = new String[1];
		     
		      boolean proxyExecute = false;
		      boolean keepaExecute = true;
		      
		      String resultLog = "";
		      String errMsg = "";
		      
		      ProxyServerVO proxyServerVO =(ProxyServerVO) proxySettingDAO.selectProxyServerInfo(prySvrId);
		      String kalUseYn = "";
		      if (proxyServerVO.getKal_install_yn() != null) {
		         kalUseYn = proxyServerVO.getKal_install_yn();
		      }

		      //Agent 접속 정보 추출 
		      ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
		      Map<String, Object> proxyExecuteResult = new  HashMap<String, Object>();
		      Map<String, Object> keepaExecuteResult = new  HashMap<String, Object>();
		      
		      ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		      JSONObject agentJobj = new JSONObject();
		      agentJobj.put("act_type", actType);
		      
		      if("S".equals(actType)){
		    	  statusNm[0] = msg.getMessage("eXperDB_proxy.act_stop",null, LocaleContextHolder.getLocale());//중지
		      }else if("A".equals(actType)){
		    	  statusNm[0] = msg.getMessage("eXperDB_proxy.act_start",null, LocaleContextHolder.getLocale());//기동
		      }else if("R".equals(actType)){
		    	  statusNm[0] = msg.getMessage("eXperDB_proxy.act_restart",null, LocaleContextHolder.getLocale());//재기동
		      }
		      
		      agentJobj.put("pry_svr_id", prySvrId);
		      agentJobj.put("lst_mdfr_id", lst_mdfr_id);
		      
		      try{
		         agentJobj.put("sys_type", "PROXY");
		         proxyExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
		      }catch(ConnectException e){
		         throw e;
		      }
		      
		      if (proxyExecuteResult != null) {
		         if (status.equals(proxyExecuteResult.get("EXECUTE_RESULT"))) {
		            proxyExecute = true;
		         }else{
		            proxyExecute = false;
		         }
		      }else{
		         proxyExecute = false;
		      }

		      //keepalived는 설치 여부에 따라 실행을 하지 않을 수 있음
		      if(kalUseYn.equals("Y")){
		         try{
		            agentJobj.remove("sys_type");
		            agentJobj.put("sys_type", "KEEPALIVED");
		            keepaExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
		         }catch(ConnectException e){
		            throw e;
		         }
		         
		         if (keepaExecuteResult != null) {
		        	 if (status.equals(keepaExecuteResult.get("EXECUTE_RESULT"))) {
		        		 keepaExecute = true;
		        	 }else{
		        		 keepaExecute = false;
		        	 }
		         }else{
		        	 keepaExecute = false;
		         }
		      }
		      
		      if(!proxyExecute || !keepaExecute){
		         if(!proxyExecute){
		            errMsg = "Proxy ";
		         }
		         if(!keepaExecute){
		            if(!errMsg.equals("")) errMsg += " / Keepalived ";
		            else errMsg += "Keepalived ";   
		         }
		         errMsg +=msg.getMessage("eXperDB_proxy.msg51",statusNm, LocaleContextHolder.getLocale());
		      }else{
		         //기동상태 재확인
		         ProxyServerVO prySvrVO =(ProxyServerVO) proxySettingDAO.selectProxyServerInfo(prySvrId);
		         
		         if("S".equals(actType)){
		        	if("TC001502".equals(prySvrVO.getExe_status()) && ((kalUseYn.equals("Y") && "TC001502".equals(prySvrVO.getKal_exe_status())) || kalUseYn.equals("N"))){
		        		errMsg = msg.getMessage("eXperDB_proxy.msg52",statusNm, LocaleContextHolder.getLocale());
		        	}else{
		        		errMsg = msg.getMessage("eXperDB_proxy.msg51",statusNm, LocaleContextHolder.getLocale());
		        	}
		         }else{
		        	 if("TC001501".equals(prySvrVO.getExe_status()) && ( kalUseYn.equals("N") || (kalUseYn.equals("Y") && "TC001501".equals(prySvrVO.getKal_exe_status())))){
		        		errMsg = msg.getMessage("eXperDB_proxy.msg52",statusNm, LocaleContextHolder.getLocale());
		        	}else{
		        		errMsg = msg.getMessage("eXperDB_proxy.msg51",statusNm, LocaleContextHolder.getLocale());
		        	}
		         }
		      }
		      
		      resultObj.put("resultLog", resultLog);
		      resultObj.put("result",(proxyExecute && keepaExecute));
		      resultObj.put("errMsg",errMsg);
		      
		      return resultObj;
		   }

	/**
	 * Proxy 서버 연결 테스트
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject prySvrConnTest(Map<String, Object> param) throws ConnectException, Exception {
		JSONObject resultObj = new JSONObject();

		try {
			//Proxy Agent 연결 - 처리로직 들어가야함
			ProxyAgentVO proxyAgentVO = (ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
			String result_code = "";
			
			Map<String, Object> agentConnectResult = new  HashMap<String, Object>();
			boolean agentConn = false;
			
			String IP = proxyAgentVO.getIpadr();
			int PORT = proxyAgentVO.getSocket_port();
			System.out.println("Agent IP : "+IP+"\n PORT : "+PORT);
			ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
			agentConnectResult = cic.proxyAgentConnectionTest(IP, PORT);

			if (agentConnectResult != null) {
				System.out.println(agentConnectResult.toString());
				result_code = agentConnectResult.get("RESULT_CODE").toString();
				if ("0".equals(result_code)) {
					agentConn = true;
				}
			}else{
				agentConn = false;
			}
			
			resultObj.put("agentConn", agentConn);
			resultObj.put("errcd", 0);
			resultObj.put("errmsg", msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
		} catch (ConnectException e) {
			resultObj.put("agentConn", false);
			resultObj.put("errcd", -2);
			resultObj.put("errmsg", msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
			e.printStackTrace();
			
		} catch(Exception e){
			resultObj.put("agentConn", false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale()));
			e.printStackTrace();
		}
		return resultObj;
	}

	/**
	 * Proxy 서버 등록
	 * 
	 * @param Map<String, Object>
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> proxyServerReg(Map<String, Object> param) throws Exception {
		Map<String, Object> resultObj = new HashMap<String, Object>();

		try {
			String reg_mode = param.get("reg_mode").toString();
			long pry_svr_id_sn = 1L;
			
			//서버명 중복확인
			List<ProxyServerVO> prySvrList = proxySettingDAO.selectProxyServerList(param);
			if (prySvrList != null && prySvrList.size() > 0) {
				resultObj.put("resultLog", "fail");
				resultObj.put("result",false);
				resultObj.put("errMsg",msg.getMessage("eXperDB_proxy.msg50", null, LocaleContextHolder.getLocale()));
				
				return resultObj;
			}
			
			/* param setting */
			ProxyAgentVO pryAgtVO = new ProxyAgentVO();
			ProxyServerVO prySvrVO = new ProxyServerVO();

			pryAgtVO.setSvr_use_yn("Y");

			int	prySvrId = Integer.parseInt(param.get("pry_svr_id") != null && !"".equals((String)param.get("pry_svr_id"))  ? param.get("pry_svr_id").toString() : "0");
			int	day_data_del_term = Integer.parseInt(param.get("day_data_del_term") != null && !"".equals((String)param.get("day_data_del_term"))  ? param.get("day_data_del_term").toString() : "0");
			int	min_data_del_term = Integer.parseInt(param.get("min_data_del_term") != null && !"".equals((String)param.get("min_data_del_term"))  ? param.get("min_data_del_term").toString() : "0");
			int	db_svr_id = Integer.parseInt(param.get("db_svr_id") != null && !"".equals((String)param.get("db_svr_id"))  ? param.get("db_svr_id").toString() : "0");

			String ipadr = param.get("ipadr").toString();
			String lst_mdfr_id = param.get("lst_mdfr_id").toString();
			String master_gbn = param.get("master_gbn").toString();
			String kal_install_yn = param.get("kal_install_yn").toString();

			prySvrVO.setPry_svr_id(prySvrId);
			prySvrVO.setPry_svr_nm(param.get("pry_svr_nm").toString());
			prySvrVO.setDay_data_del_term(day_data_del_term);
			prySvrVO.setMin_data_del_term(min_data_del_term);
			prySvrVO.setUse_yn(param.get("use_yn").toString());
			prySvrVO.setMaster_gbn(param.get("master_gbn").toString());
			
			if("S".equals(master_gbn)){
				int	master_svr_id = Integer.parseInt(param.get("master_svr_id") != null && !"".equals((String)param.get("master_svr_id"))  ? param.get("master_svr_id").toString() : "0");
				prySvrVO.setMaster_svr_id(master_svr_id);
			}
			
			prySvrVO.setDb_svr_id(db_svr_id);
			prySvrVO.setLst_mdfr_id(lst_mdfr_id);
			prySvrVO.setFrst_regr_id(lst_mdfr_id);
			prySvrVO.setIpadr(param.get("ipadr").toString());
			prySvrVO.setKal_install_yn(kal_install_yn);

			//insert 로직 추가
			if ("reg".equals(reg_mode)) {
				Map<String, Object> agentParam = new HashMap<String,Object>();
				System.out.println("ipadr===" + ipadr);
				agentParam.put("ipadr", ipadr);
				
				ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(agentParam);
				
				//global 저장 처리
				pry_svr_id_sn = proxySettingDAO.selectQ_T_PRY_SVR_I_01();
				prySvrId = (int)pry_svr_id_sn;
				prySvrVO.setPry_svr_id(prySvrId);

				//proxy server 등록
				proxySettingDAO.insertProxyServerInfo(prySvrVO);
				
				//global 등록
				ProxyGlobalVO proxyGlobalVO = new ProxyGlobalVO();

				proxyGlobalVO.setPry_svr_id(prySvrVO.getPry_svr_id());
				proxyGlobalVO.setMax_con_cnt(1000);
				proxyGlobalVO.setCl_con_max_tm("30m");
				proxyGlobalVO.setCon_del_tm("4s");
				proxyGlobalVO.setSvr_con_max_tm("30m");
				proxyGlobalVO.setChk_tm("5s");
				proxyGlobalVO.setIf_nm(null);
				
				if ("Y".equals(proxyAgentVO.getKal_install_yn())) {
					proxyGlobalVO.setObj_ip(ipadr);
				} else {
					proxyGlobalVO.setObj_ip(null);
				}

				proxyGlobalVO.setPeer_server_ip(null);
				proxyGlobalVO.setLst_mdfr_id(lst_mdfr_id);
				proxyGlobalVO.setFrst_regr_id(lst_mdfr_id);

				proxySettingDAO.insertProxyGlobalConf(proxyGlobalVO);
			} else {
				proxySettingDAO.updateProxyServerInfo(prySvrVO);
			}
			
			String svrUseYn = proxySettingDAO.selectProxyAgentSvrUseYnFromProxyId(prySvrId);
			String reRegYn = "";
			//삭제 재등록 시 기존 Config 읽어서 데이터 insert
			if("D".equals(svrUseYn)){
				reRegYn = "Y";
			}
			
			Map<String, Object> paramEnd = new HashMap<String, Object>();
			//agent update
			paramEnd.put("svr_use_yn", "Y");
			paramEnd.put("lst_mdfr_id", lst_mdfr_id);
			paramEnd.put("pry_svr_id", prySvrId);
			
			proxySettingDAO.updateProxyAgentInfoFromProxyId(paramEnd);
			
			resultObj.put("reRegYn", reRegYn);
			resultObj.put("resultLog", "success");
			resultObj.put("result",true);
			resultObj.put("errMsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
		} catch (Exception e) {
			resultObj.put("resultLog", "fail");
			resultObj.put("result", false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
			
			e.printStackTrace();
		}

		return resultObj;
	}
	
	/**
	 * Proxy Conf 데이터 재등록 요청
	 * 
	 * @param Map<String, Object>
	 * @return boolean
	 * @throws 
	 */
	public boolean proxyServerReReg(Map<String, Object> param) {
		try{
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
		
		Map<String, Object> insertDataResult = new  HashMap<String, Object>();
		
		ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		try{
			insertDataResult = cic.insertProxyConfigFileInfo(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
		}catch(ConnectException e){
			throw e;
		}
		
		if (insertDataResult != null) {
			if ("true".equals(insertDataResult.get("RESULT_DATA"))) {
				//System.out.println("정상적으로 Config 입력 되었습니다.");
				return true;
			}else{
				//System.out.println("Config Data Insert 중 오류가 발생하였습니다. :: \n" + insertDataResult.get("ERR_MSG"));
			}
		}else{
			//System.out.println("Config 입력이 안되었습니다.");
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * Proxy 서버 삭제
	 * 
	 * @param Map<String, Object>
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject deletePrySvr(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();

		try {

			String lst_mdfr_id = param.get("lst_mdfr_id").toString();
			int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
			int dbSvrId = Integer.parseInt(param.get("db_svr_id").toString());
			
			param.put("svr_use_yn", "D");
			param.put("lst_mdfr_id", lst_mdfr_id);
			param.put("pry_svr_id", prySvrId);

			//update t_pry_agt_i의 svr_use_yn = D으로 업데이트
			proxySettingDAO.updateProxyAgentInfoFromProxyId(param);

			//Agent 접속 정보 추출 하여 기존 backup config 파일 삭제 
			ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
			Map<String, Object> agentConnectResult = new  HashMap<String, Object>();
			ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
			try{
				agentConnectResult = cic.deleteProxyConfigFiles(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port());
			}catch(ConnectException e){
				e.printStackTrace();
			}catch(Exception e){
				e.printStackTrace();
			}			

			//delete t_pry_vipcng_i
			proxySettingDAO.deletePryVipConfList(prySvrId);

			//테이블 전체 삭제
			proxySettingDAO.deleteProxyTblList(prySvrId);

			//같은 db_svr_id를 갖는 남은 proxy 중 old_master_gbn이 M이 없을 경우  자동 승격
			proxySettingDAO.upgradePrySvrOldMaster(dbSvrId);
			
			resultObj.put("resultLog", "success");
			resultObj.put("result",true);
			resultObj.put("errMsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));

		} catch (Exception e) {
			resultObj.put("resultLog", "fail");
			resultObj.put("result",false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", msg.getMessage("eXperDB_proxy.msg49", null, LocaleContextHolder.getLocale()));
			
			e.printStackTrace();
		}
		
		return resultObj;
	}

	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<ProxyListenerServerVO>
	 * @throws 
	 */
	@Override
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		return proxySettingDAO.selectListenServerList(param);
	}

	/**
	 * Proxy 연결 dbms ip/port 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectIpList(Map<String, Object> param) {
		return proxySettingDAO.selectIpList(param);
	}

	/**
	 * Proxy 적용
	 * 
	 * @param param, confData
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject applyProxyConf(Map<String, Object> param, JSONObject confData) throws ConnectException, Exception {
		JSONObject resultObj = new JSONObject();
		//DB Data insert/update/delete
		int prySvrId = CommonUtil.getIntOfJsonObj(confData,"pry_svr_id");
		String lst_mdfr_id = param.get("lst_mdfr_id").toString();
		/*System.out.println("applyProxyConf :: "+confData.toJSONString());*/
		ProxyGlobalVO global = new ProxyGlobalVO();
		global.setCl_con_max_tm(CommonUtil.getStringOfJsonObj(confData,"cl_con_max_tm"));
		global.setCon_del_tm(CommonUtil.getStringOfJsonObj(confData,"con_del_tm"));
		global.setSvr_con_max_tm(CommonUtil.getStringOfJsonObj(confData,"svr_con_max_tm"));
		global.setChk_tm(CommonUtil.getStringOfJsonObj(confData,"chk_tm"));
		global.setIf_nm(CommonUtil.getStringOfJsonObj(confData,"if_nm"));
		global.setObj_ip(CommonUtil.getStringOfJsonObj(confData,"obj_ip"));
		global.setPeer_server_ip(CommonUtil.getStringOfJsonObj(confData,"peer_server_ip"));
		global.setPry_svr_id(prySvrId);
		global.setPry_glb_id(CommonUtil.getIntOfJsonObj(confData,"pry_glb_id"));
		global.setMax_con_cnt(CommonUtil.getIntOfJsonObj(confData,"max_con_cnt"));
		global.setLst_mdfr_id(lst_mdfr_id);
		//update global conf Info
		proxySettingDAO.updateProxyGlobalConf(global);
		
		JSONArray delVipcngJArray = (JSONArray)confData.get("delVipcng");
		int delVipcngSize = delVipcngJArray.size();
		
		if (delVipcngSize > 0) {
			ProxyVipConfigVO delVipConf[] = new ProxyVipConfigVO[delVipcngSize];
			
			for(int i=0; i<delVipcngSize; i++){
				JSONObject delVipcngJobj = (JSONObject)delVipcngJArray.get(i);
				System.out.println(delVipcngJobj.toJSONString());
				delVipConf[i] = new ProxyVipConfigVO();
				delVipConf[i].setPry_svr_id(prySvrId);
				delVipConf[i].setVip_cng_id(CommonUtil.getIntOfJsonObj(delVipcngJobj,"vip_cng_id"));
				
				//delete vip instance
				proxySettingDAO.deletePryVipConf(delVipConf[i]);
			}
		}
		
		JSONArray vipcngJArray = (JSONArray)confData.get("vipcng");
		
		int vipcngSize = vipcngJArray.size();
		
		if (vipcngSize > 0) {
			ProxyVipConfigVO vipConf[] = new ProxyVipConfigVO[vipcngSize];
			
			for(int i=0; i<vipcngSize; i++){
				JSONObject vipcngJobj = (JSONObject)vipcngJArray.get(i);
				System.out.println(vipcngJobj.toJSONString());
				vipConf[i] = new ProxyVipConfigVO();
				vipConf[i].setPry_svr_id(prySvrId);
				
				if(!CommonUtil.nullCheckOfJsonObj(vipcngJobj, "vip_cng_id")){
					vipConf[i].setVip_cng_id(CommonUtil.getIntOfJsonObj(vipcngJobj,"vip_cng_id"));
				}
				vipConf[i].setV_ip(CommonUtil.getStringOfJsonObj(vipcngJobj,"v_ip"));
				vipConf[i].setV_rot_id(CommonUtil.getStringOfJsonObj(vipcngJobj, "v_rot_id"));
				vipConf[i].setChk_tm(CommonUtil.getIntOfJsonObj(vipcngJobj,"chk_tm"));
				vipConf[i].setV_if_nm(CommonUtil.getStringOfJsonObj(vipcngJobj,"v_if_nm"));
				vipConf[i].setPriority(CommonUtil.getIntOfJsonObj(vipcngJobj,"priority"));
				vipConf[i].setState_nm(CommonUtil.getStringOfJsonObj(vipcngJobj,"state_nm"));
				vipConf[i].setLst_mdfr_id(lst_mdfr_id);
				/*System.out.println("vipConf :: "+CommonUtil.toMap(vipConf[i]).toString());*/
				//insert/update vip instance
				proxySettingDAO.insertUpdatePryVipConf(vipConf[i]);
			}
		}
		
		JSONArray delListnJArray = (JSONArray)confData.get("delListener");
		int delListnSize = delListnJArray.size();
		
		if (delListnSize > 0) {
			ProxyListenerVO delListn[] = new ProxyListenerVO[delListnSize];
			for(int i=0; i<delListnSize; i++){
				JSONObject delListnObj = (JSONObject)delListnJArray.get(i);
				delListn[i] = new ProxyListenerVO();
				delListn[i].setPry_svr_id(prySvrId);
				delListn[i].setLsn_id(CommonUtil.getIntOfJsonObj(delListnObj,"lsn_id"));
				
				ProxyListenerServerVO delListnSvr = new ProxyListenerServerVO();
				delListnSvr.setPry_svr_id(prySvrId);
				delListnSvr.setLsn_id(CommonUtil.getIntOfJsonObj(delListnObj,"lsn_id"));
				proxySettingDAO.deletePryListenerSvr(delListnSvr);
				//delete proxy listener
				proxySettingDAO.deletePryListener(delListn[i]);
				
				Map<String, Object> delStatusParam = new HashMap<String, Object>();
				delStatusParam.put("pry_svr_id", prySvrId);
				delStatusParam.put("lsn_id", CommonUtil.getIntOfJsonObj(delListnObj, "lsn_id"));
				
				//delete t_pry_svr_status_g
				proxySettingDAO.deletePrySvrStatusList(delStatusParam);
			}
		}
		
		JSONArray listenerJArray = (JSONArray)confData.get("listener");
		int listenerSize = listenerJArray.size();
		
		if (listenerSize > 0) {
			ProxyListenerVO listener[] = new ProxyListenerVO[listenerSize];

			for(int i=0; i<listenerSize; i++){
				JSONObject listenerObj = (JSONObject)listenerJArray.get(i);

				listener[i] = new ProxyListenerVO();
				listener[i].setPry_svr_id(prySvrId);
				
				if(!CommonUtil.nullCheckOfJsonObj(listenerObj, "lsn_id")){
					listener[i].setLsn_id(CommonUtil.getIntOfJsonObj(listenerObj, "lsn_id"));
				}

				listener[i].setLsn_nm(CommonUtil.getStringOfJsonObj(listenerObj, "lsn_nm"));
				listener[i].setCon_bind_port(CommonUtil.getStringOfJsonObj(listenerObj, "con_bind_port"));
				listener[i].setLsn_desc(CommonUtil.getStringOfJsonObj(listenerObj,"lsn_desc"));
				listener[i].setDb_usr_id(CommonUtil.getStringOfJsonObj(listenerObj, "db_usr_id"));
				listener[i].setDb_id(CommonUtil.getIntOfJsonObj(listenerObj,"db_id"));
				listener[i].setDb_nm(CommonUtil.getStringOfJsonObj(listenerObj, "db_nm"));
				listener[i].setCon_sim_query(CommonUtil.getStringOfJsonObj(listenerObj, "con_sim_query"));
				listener[i].setField_nm(CommonUtil.getStringOfJsonObj(listenerObj, "field_nm"));
				listener[i].setField_val(CommonUtil.getStringOfJsonObj(listenerObj, "field_val"));
				listener[i].setLst_mdfr_id(lst_mdfr_id);
				
				//UPDATE/INSERT PROXY LISTENER
				proxySettingDAO.insertUpdatePryListener(listener[i]);
				
				if(listenerObj.get("lsn_svr_del_list") != null){
					JSONArray delListnSvrArry = (JSONArray) listenerObj.get("lsn_svr_del_list"); 
					int delListnSvrSize = delListnSvrArry.size();
					
					if (delListnSvrSize > 0) {
						ProxyListenerServerVO delListnSvr[] = new ProxyListenerServerVO[delListnSvrSize];
						for(int j=0; j<delListnSvrSize; j++){
							JSONObject delListnSvrObj = (JSONObject)delListnSvrArry.get(j);
							delListnSvr[j] = new ProxyListenerServerVO();
							delListnSvr[j].setPry_svr_id(prySvrId);
							delListnSvr[j].setLsn_id(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_id"));
							delListnSvr[j].setLsn_svr_id(CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_svr_id"));
							delListnSvr[j].setDb_con_addr(CommonUtil.getStringOfJsonObj(delListnSvrObj, "db_con_addr"));
							
							//delete proxy listener server list
							proxySettingDAO.deletePryListenerSvr(delListnSvr[j]);
							
							Map<String, Object> delStatusParam = new HashMap<String, Object>();
							delStatusParam.put("pry_svr_id", prySvrId);
							delStatusParam.put("lsn_id", CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_id"));
							delStatusParam.put("lsn_svr_id", CommonUtil.getIntOfJsonObj(delListnSvrObj, "lsn_svr_id"));
							
							//delete t_pry_svr_status_g
							proxySettingDAO.deletePrySvrStatusList(delStatusParam);
						}
					}
				}
				
				if(listenerObj.get("lsn_svr_edit_list") != null){
					JSONArray listnSvrArry = (JSONArray) listenerObj.get("lsn_svr_edit_list");
					int listnSvrSize = listnSvrArry.size();
					
					if (listnSvrSize > 0) {
						ProxyListenerServerVO listnSvr[] = new ProxyListenerServerVO[listnSvrSize];

						for(int j=0; j<listnSvrSize; j++){
							JSONObject listnSvrObj = (JSONObject)listnSvrArry.get(j);
							listnSvr[j] = new ProxyListenerServerVO();
							listnSvr[j].setPry_svr_id(prySvrId);
							
							if(!CommonUtil.nullCheckOfJsonObj(listnSvrObj, "lsn_id")){//newLsnId
								listnSvr[j].setLsn_id(CommonUtil.getIntOfJsonObj(listnSvrObj, "lsn_id"));
							}else{
								int newLsnId = proxySettingDAO.selectPryListenerMaxId();

								listnSvr[j].setLsn_id(newLsnId);
							}
							
							if(!CommonUtil.nullCheckOfJsonObj(listnSvrObj, "lsn_svr_id")){
								listnSvr[j].setLsn_svr_id(CommonUtil.getIntOfJsonObj(listnSvrObj, "lsn_svr_id"));
							}

							listnSvr[j].setDb_con_addr(CommonUtil.getStringOfJsonObj(listnSvrObj,"db_con_addr"));
							listnSvr[j].setChk_portno(CommonUtil.getIntOfJsonObj(listnSvrObj, "chk_portno"));
							listnSvr[j].setBackup_yn(CommonUtil.getStringOfJsonObj(listnSvrObj,"backup_yn"));
							listnSvr[j].setLst_mdfr_id(lst_mdfr_id);
							
							//UPDATE/INSERT PROXY LISTENER Server List
							proxySettingDAO.insertUpdatePryListenerSvr(listnSvr[j]);
						}
					}
				}
			}
		}
		
		//Agent에 넘겨줄 Data JSONObject로 생성
		Map<String, Object> agentParam = new HashMap<String,Object>();
		agentParam.put("pry_svr_id", prySvrId);
		
		//GLOBAL 정보
		JSONObject globalJObj = proxySettingDAO.selectProxyGlobal(agentParam).toJSONObject();
		
		JSONObject agentJobj = new JSONObject();
		agentJobj.put("global_info", globalJObj);
		
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
		
		//VIP CONFIG 정보
		List<ProxyVipConfigVO> vipConfigList = proxySettingDAO.selectProxyVipConfList(agentParam);
		JSONArray vipConfgJArr  = new JSONArray();
		for(ProxyVipConfigVO vipVO : vipConfigList){
			vipConfgJArr.add(vipVO.toJSONObject());
		}
		agentJobj.put("vipconfig_list", vipConfgJArr);
		agentJobj.put("lst_mdfr_id", lst_mdfr_id);
		
		List<CmmnCodeVO> cmmnCodeVO =  null;
		PageVO pageVO = new PageVO();
		
		pageVO.setGrp_cd("TC0042");
		pageVO.setSearchCondition("0");
		cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
		
		for(int i=0; i<cmmnCodeVO.size(); i++){
			CmmnCodeVO tempCode = cmmnCodeVO.get(i);
			agentJobj.put(tempCode.getSys_cd(), tempCode.getSys_cd_nm());
		}
		
		ProxyServerVO proxyServerVO =(ProxyServerVO) proxySettingDAO.selectProxyServerInfo(prySvrId);
		String kalUseYn = proxyServerVO.getKal_install_yn();
		agentJobj.put("KAL_INSTALL_YN", kalUseYn);
		
		boolean createNewConfig = false;
		String resultLog = "";
		String errMsg = "";
		
		//Agent 접속 정보 추출 
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(agentParam);
		Map<String, Object> agentConnectResult = new  HashMap<String, Object>();
		ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		try{
			agentConnectResult = cic.createProxyConfigFile(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(), agentJobj);
		}catch(ConnectException e){
			throw e;
		}
	
		//String result_code = "";
		if (agentConnectResult != null) {
			if ("0".equals(agentConnectResult.get("RESULT_CODE"))) {
				createNewConfig = true;
				resultLog = "success";
				errMsg= msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale());
			}else{
				createNewConfig = false;
				resultLog = "faild";
				errMsg= msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
			}
		}else{
			createNewConfig = false;
			resultLog = "faild";
			errMsg= msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale());
		}
		resultObj.put("resultLog", resultLog);
		resultObj.put("result",createNewConfig);
		resultObj.put("errMsg",errMsg);
		resultObj.put("lst_mdfr_id", lst_mdfr_id);
		
		return resultObj;
	}

	/**
	 * Proxy agent 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
		return proxySettingDAO.selectPoxyAgentSvrList(param);
	}

	/**
	 * ProxyAgent 조회
	 * 
	 * @param int pry_svr_id
	 * @return ProxyAgentVO
	 * @throws Exception
	 */
	public ProxyAgentVO getProxyAgent(int pry_svr_id) throws Exception{
		Map<String, Object> agentParam = new HashMap<String,Object>();
		agentParam.put("pry_svr_id", pry_svr_id);
		return (ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(agentParam);
	}
	
	/**
	 * Proxy Master Proxy 목록 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		return proxySettingDAO.selectMasterProxyList(param);
	}

	/**
	 * VIP 사용 여부 업데이트
	 * 
	 * @param Map<String, Object>
	 * @return 
	 * @throws ConnectException
	 * @throws Exception
	 */
	@Override
	public void updateDeleteVipUseYn(Map<String, Object> param) throws ConnectException, Exception{
		
		int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
		String lstMdfrId = param.get("lst_mdfr_id").toString();
		String kalInstallYn = param.get("kal_install_yn").toString();
		ProxyServerVO prySvrVO = new ProxyServerVO();
		prySvrVO.setPry_svr_id(prySvrId);
		prySvrVO.setLst_mdfr_id(lstMdfrId);
		prySvrVO.setKal_install_yn(kalInstallYn);

		//Server KAL_INATLL_YN update
		//N일 경우, Master로 변경 및 Master_svr_id null로 업데이트
		proxySettingDAO.updateProxyAgentInfo(prySvrVO);
		proxySettingDAO.updatePrySvrKalInstYn(prySvrVO);
		
		//global peer 정보  공백 처리
		ProxyGlobalVO globalVO = proxySettingDAO.selectProxyGlobal(param);
		
		//Delete T_PRY_VIPCNG_I
		if(kalInstallYn.equals("N"))
		{
			globalVO.setPeer_server_ip("");
			globalVO.setObj_ip("");
			globalVO.setIf_nm("");
			
			proxySettingDAO.updateProxyGlobalConf(globalVO);
			//vip 설정 정보 삭제 
			proxySettingDAO.deletePryVipConfList(prySvrId);
			
			//기동 중지
			ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
			Map<String, Object> keepaExecuteResult = new  HashMap<String, Object>();
			
			ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
			JSONObject agentJobj = new JSONObject();
			agentJobj.put("act_type", "S");
			agentJobj.put("pry_svr_id", prySvrId);
			agentJobj.put("lst_mdfr_id", lstMdfrId);
			
			try{
				agentJobj.put("sys_type", "KEEPALIVED");
				keepaExecuteResult = cic.proxyServiceExcute(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
			}catch(ConnectException e){
				throw e;
			}
		} else {
			globalVO.setIf_nm("");
			globalVO.setPeer_server_ip("");
			globalVO.setObj_ip(globalVO.getIpadr());
			proxySettingDAO.updateProxyGlobalConf(globalVO);
		}
	}

	/**
	 * Proxy 연결 DBMS 정보 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectDbmsTotList(Map<String, Object> param) throws Exception {
		//연결 DBMS 정보 
		List<Map<String, Object>> dbmsSelList = proxySettingDAO.selectDbmsList(param);
		return dbmsSelList;
	}

	/**
	 * Proxy Master 조회
	 * 
	 * @param Map<String, Object>
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectProxyMstTotList(Map<String, Object> param) throws Exception {
		List<Map<String, Object>> mstSvrSelList = proxySettingDAO.selectMasterSvrProxyList(param);
	
		return mstSvrSelList;
	}

	/**
	 * Proxy Agent kal_install_yn 체크
	 * 
	 * @param Map<String, Object>
	 * @return boolean
	 * @throws ConnectException
	 * @throws Exception
	 */
	@Override
	public boolean checkAgentKalInstYn(Map<String, Object> param) throws ConnectException, Exception {
		
		boolean result = true;
		
		int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());
		String lstMdfrId = param.get("lst_mdfr_id").toString();
		String kalInstYn = param.get("kal_install_yn").toString();
		
		//기동 중지
		ProxyAgentVO proxyAgentVO =(ProxyAgentVO) proxySettingDAO.selectProxyAgentInfo(param);
		Map<String, Object> checkKeepaResult = new  HashMap<String, Object>();
		
		ProxyClientInfoCmmn cic = new ProxyClientInfoCmmn();
		JSONObject agentJobj = new JSONObject();
		agentJobj.put("pry_svr_id", prySvrId);
		agentJobj.put("lst_mdfr_id", lstMdfrId);
		agentJobj.put("kal_install_yn", kalInstYn);//stop
		
		try{
			checkKeepaResult = cic.checkKeepavliedInstallYn(proxyAgentVO.getIpadr(), proxyAgentVO.getSocket_port(),agentJobj);
		}catch(ConnectException e){
			throw e;
		}
		
		if (checkKeepaResult != null) {
			if ("Y".equals(checkKeepaResult.get("KAL_INSTALL_YN").toString())) {
				result = true;
			}else{
				result = false;
			}
		}else{
			result = false;
		}
		
		return result;
	}
}
