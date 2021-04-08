package com.experdb.management.proxy.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import com.experdb.management.proxy.cmmn.CommonUtil;
import com.experdb.management.proxy.service.ProxyAgentVO;
import com.experdb.management.proxy.service.ProxyGlobalVO;
import com.experdb.management.proxy.service.ProxyListenerServerVO;
import com.experdb.management.proxy.service.ProxyListenerVO;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.experdb.management.proxy.service.ProxyVipConfigVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.impl.AccessHistoryDAO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.impl.CmmnServerInfoDAO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("ProxySettingServiceImpl")
public class ProxySettingServiceImpl extends EgovAbstractServiceImpl implements ProxySettingService{
	
	@Resource(name = "proxySettingDAO")
	private ProxySettingDAO proxySettingDAO;

	@Resource(name = "accessHistoryDAO")
	private AccessHistoryDAO accessHistoryDAO;
	
	@Resource(name = "cmmnServerInfoDAO")
	private CmmnServerInfoDAO cmmnServerInfoDAO;
	
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
	 * @param param
	 * @return List<ProxyServerVO>
	 * @throws Exception
	 */
	@Override
	public List<ProxyServerVO> selectProxyServerList(Map<String, Object> param) throws Exception {
		return proxySettingDAO.selectProxyServerList(param);
	}

	/**
	 * Proxy conf 상세조회
	 * 
	 * @param param
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
		resultObj.put("global_info", globalInfo == null? null:globalInfo);
		resultObj.put("listener_list", listenerList == null? null:listenerList);
		resultObj.put("vipconfig_list", vipConfigList == null? null:vipConfigList);
		resultObj.put("db_sel_list", dbSelList == null? null:dbSelList);
		resultObj.put("peer_listener_list", peerListenerList == null? null:peerListenerList);
		resultObj.put("peer_vipconfig_list", peerVipConfigList == null? null:peerVipConfigList);
		
		return resultObj;
	}


	/**
	 * Proxy 연결 DBMS 및 Master Proxy 정보 조회
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject createSelPrySvrReg(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();
		
		//연결 DBMS 정보 
		List<Map<String, Object>> dbmsSelList = proxySettingDAO.selectDbmsList(param);

		//Master Proxy 정보
		if (dbmsSelList.size() > 0) {
			param.put("db_svr_id", dbmsSelList.get(0).get("db_svr_id"));
		} else {
			param.put("db_svr_id", null);
		}
		List<Map<String, Object>> mstSvrSelList = proxySettingDAO.selectMasterSvrProxyList(param);
		
		//json set
		resultObj.put("dbms_sel_list", dbmsSelList == null? null:dbmsSelList);
		resultObj.put("mstSvr_sel_list", mstSvrSelList == null? null:mstSvrSelList);
		
		return resultObj;
	}

	/**
	 * Proxy Master Proxy 정보 조회
	 * 
	 * @param param
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
	 * @param param
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
	 * Proxy 적용 실행
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject runProxyServer(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();

		try {
			//처리로직 들어가야함
			proxySettingDAO.updateProxyServerStatus(param);
			
			resultObj.put("errcd", 0);
			resultObj.put("errMsg", "정상적으로 처리되었습니다.");
			
		} catch (Exception e) {
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 요류가 발생하였습니");
			
			e.printStackTrace();
		}

		return resultObj;
	}

	/**
	 * Proxy 서버 연결 테스트
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject prySvrConnTest(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();

		try {
			//Proxy Agent 연결 - 처리로직 들어가야함
			
			//결과 
			boolean agentConn = true;
			if(agentConn){
				resultObj.put("agentConn", true);
			}else{
				resultObj.put("agentConn", false);
			}
		} catch (Exception e) {
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 오류가 발생하였습니");
			
			e.printStackTrace();
		}
		return resultObj;
	}

	/**
	 * Proxy 서버 등록
	 * 
	 * @param param
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
				resultObj.put("errMsg","서버명이 다른 서버와 중복되었습니다.");
				
				return resultObj;
			}
			
			/* param setting */
			ProxyAgentVO pryAgtVO = new ProxyAgentVO();
			ProxyServerVO prySvrVO = new ProxyServerVO();

			pryAgtVO.setSvr_use_yn("Y");

			int	agt_sn = Integer.parseInt(param.get("agt_sn") != null && !"".equals((String)param.get("agt_sn"))  ? param.get("agt_sn").toString() : "0");
			int	prySvrId = Integer.parseInt(param.get("pry_svr_id") != null && !"".equals((String)param.get("pry_svr_id"))  ? param.get("pry_svr_id").toString() : "0");
			int	day_data_del_term = Integer.parseInt(param.get("day_data_del_term") != null && !"".equals((String)param.get("day_data_del_term"))  ? param.get("day_data_del_term").toString() : "0");
			int	min_data_del_term = Integer.parseInt(param.get("min_data_del_term") != null && !"".equals((String)param.get("min_data_del_term"))  ? param.get("min_data_del_term").toString() : "0");
			int	db_svr_id = Integer.parseInt(param.get("db_svr_id") != null && !"".equals((String)param.get("db_svr_id"))  ? param.get("db_svr_id").toString() : "0");

			String ipadr = param.get("ipadr").toString();
			String lst_mdfr_id = param.get("lst_mdfr_id").toString();
			String master_gbn = param.get("master_gbn").toString();

			pryAgtVO.setAgt_sn(agt_sn);
			pryAgtVO.setIpadr(ipadr);
			pryAgtVO.setLst_mdfr_id(lst_mdfr_id);
			
			prySvrVO.setPry_svr_id(prySvrId);
			prySvrVO.setPry_svr_nm(param.get("pry_svr_nm").toString());
			prySvrVO.setDay_data_del_term(day_data_del_term);
			prySvrVO.setMin_data_del_term(min_data_del_term);
			prySvrVO.setUse_yn(param.get("use_yn").toString());
			prySvrVO.setMaster_gbn(param.get("master_gbn").toString());

			if("B".equals(master_gbn)){
				int	master_svr_id = Integer.parseInt(param.get("master_svr_id") != null && !"".equals((String)param.get("master_svr_id"))  ? param.get("master_svr_id").toString() : "0");
				prySvrVO.setMaster_svr_id(master_svr_id);
			}
			
			prySvrVO.setDb_svr_id(db_svr_id);
			prySvrVO.setLst_mdfr_id(lst_mdfr_id);
			prySvrVO.setFrst_regr_id(lst_mdfr_id);
			prySvrVO.setIpadr(param.get("ipadr").toString());

			//agent update
			proxySettingDAO.updateProxyAgentInfo(pryAgtVO);

			//insert 로직 추가
			if ("reg".equals(reg_mode)) {
				//global 저장 처리
				pry_svr_id_sn = proxySettingDAO.selectQ_T_PRY_SVR_I_01();
				prySvrVO.setPry_svr_id((int)pry_svr_id_sn);

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
				proxyGlobalVO.setObj_ip(prySvrVO.getIpadr());
				proxyGlobalVO.setPeer_server_ip(null);
				proxyGlobalVO.setLst_mdfr_id(lst_mdfr_id);
				proxyGlobalVO.setFrst_regr_id(lst_mdfr_id);

				proxySettingDAO.insertProxyGlobalConf(proxyGlobalVO);
			} else {
				proxySettingDAO.updateProxyServerInfo(prySvrVO);
			}

			resultObj.put("resultLog", "success");
			resultObj.put("result",true);
			resultObj.put("errMsg","작업이 완료되었습니다.");
		} catch (Exception e) {
			resultObj.put("resultLog", "fail");
			resultObj.put("result", false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 오류가 발생하였습니");
			
			e.printStackTrace();
		}

		return resultObj;
	}

	/**
	 * Proxy 서버 삭제
	 * 
	 * @param param
	 * @return JSONObject
	 * @throws Exception
	 */
	public JSONObject deletePrySvr(Map<String, Object> param) throws Exception {
		JSONObject resultObj = new JSONObject();

		try {

			String lst_mdfr_id = param.get("lst_mdfr_id").toString();
			int prySvrId = Integer.parseInt(param.get("pry_svr_id").toString());

			param.put("svr_use_yn", "N");
			param.put("lst_mdfr_id", lst_mdfr_id);
			param.put("pry_svr_id", prySvrId);

			
			//서버 내리기

			//update t_pry_agt_i의 svr_use_yn = N으로 업데이트
			proxySettingDAO.updateProxyAgentInfoFromProxyId(param);

			//delete t_prycng_g
			proxySettingDAO.deleteProxyConfHistList(prySvrId);

			//delete t_pry_actstate_cng_g
			proxySettingDAO.deleteProxyActStateConfHistList(prySvrId);

			//delete t_pry_svr_status_g
			proxySettingDAO.deleteProxySvrStatusHistList(prySvrId);
	
			//delete t_pry_lsn_svr_i 
			proxySettingDAO.deletePryListenerSvrList(prySvrId);
			
			//delete t_pry_lsn_i
			proxySettingDAO.deletePryListenerList(prySvrId);
			
			//delete t_pry_vipcng_i
			proxySettingDAO.deletePryVipConfList(prySvrId);
			
			//delete t_pry_glb_i
			proxySettingDAO.deleteGlobalConfList(prySvrId);

			//delete t_pry_svr_i
			proxySettingDAO.deleteProxyServer(prySvrId);

			resultObj.put("resultLog", "success");
			resultObj.put("result",true);
			resultObj.put("errMsg","작업이 완료되었습니다.");

		} catch (Exception e) {
			resultObj.put("resultLog", "fail");
			resultObj.put("result",false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 오류가 발생하였습니");
			
			e.printStackTrace();
		}
		
		return resultObj;
	}

	/**
	 * Proxy 리스너 server 목록 조회
	 * 
	 * @param param
	 * @return List<ProxyListenerServerVO>
	 * @throws Exception
	 */
	@Override
	public List<ProxyListenerServerVO> selectListenServerList(Map<String, Object> param) {
		return proxySettingDAO.selectListenServerList(param);
	}

	/**
	 * Proxy ip 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
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
	public JSONObject applyProxyConf(Map<String, Object> param, JSONObject confData) throws Exception {
		JSONObject resultObj = new JSONObject();

		try {
			int prySvrId = getIntOfJsonObj(confData,"pry_svr_id");
			String lst_mdfr_id = param.get("lst_mdfr_id").toString();
			
			ProxyGlobalVO global = new ProxyGlobalVO();
			global.setCl_con_max_tm(getStringOfJsonObj(confData,"cl_con_max_tm"));
			global.setCon_del_tm(getStringOfJsonObj(confData,"con_del_tm"));
			global.setSvr_con_max_tm(getStringOfJsonObj(confData,"svr_con_max_tm"));
			global.setChk_tm(getStringOfJsonObj(confData,"chk_tm"));
			global.setIf_nm(getStringOfJsonObj(confData,"if_nm"));
			global.setObj_ip(getStringOfJsonObj(confData,"obj_ip"));
			global.setPeer_server_ip(getStringOfJsonObj(confData,"peer_server_ip"));
			global.setPry_svr_id(prySvrId);
			global.setPry_glb_id(getIntOfJsonObj(confData,"pry_glb_id"));
			global.setMax_con_cnt(getIntOfJsonObj(confData,"max_con_cnt"));
			global.setLst_mdfr_id(lst_mdfr_id);
			
			System.out.println("update global conf info ----------------------------------------");

			//update global conf Info
			proxySettingDAO.updateProxyGlobalConf(global);

			JSONArray vipcngJArray = (JSONArray)confData.get("vipcng");
			int vipcngSize = vipcngJArray.size();

			if (vipcngSize > 0) {
				ProxyVipConfigVO vipConf[] = new ProxyVipConfigVO[vipcngSize];
				
				for(int i=0; i<vipcngSize; i++){
					JSONObject vipcngJobj = (JSONObject)vipcngJArray.get(i);
					System.out.println(vipcngJobj.toJSONString());
					vipConf[i] = new ProxyVipConfigVO();
					vipConf[i].setPry_svr_id(prySvrId);
					
					if(!nullCheckOfJsonObj(vipcngJobj, "vip_cng_id")){
						vipConf[i].setVip_cng_id(getIntOfJsonObj(vipcngJobj,"vip_cng_id"));
					}
					
					vipConf[i].setV_ip(getStringOfJsonObj(vipcngJobj,"v_ip"));
					vipConf[i].setV_rot_id(getStringOfJsonObj(vipcngJobj, "v_rot_id"));
					vipConf[i].setChk_tm(getIntOfJsonObj(vipcngJobj,"chk_tm"));
					vipConf[i].setV_if_nm(getStringOfJsonObj(vipcngJobj,"v_if_nm"));
					vipConf[i].setPriority(getIntOfJsonObj(vipcngJobj,"priority"));
					vipConf[i].setState_nm(getStringOfJsonObj(vipcngJobj,"state_nm"));
					vipConf[i].setLst_mdfr_id(lst_mdfr_id);
					
					System.out.println("insert/update vip instance info ----------------------------------------");
					System.out.println(CommonUtil.toMap(vipConf[i]).toString());
					
					//insert/update vip instance
					proxySettingDAO.insertUpdatePryVipConf(vipConf[i]);
				}
			}
			
			JSONArray delVipcngJArray = (JSONArray)confData.get("delVipcng");
			int delVipcngSize = delVipcngJArray.size();
			
			if (delVipcngSize > 0) {
				ProxyVipConfigVO delVipConf[] = new ProxyVipConfigVO[delVipcngSize];
				
				for(int i=0; i<delVipcngSize; i++){
					JSONObject delVipcngJobj = (JSONObject)delVipcngJArray.get(i);
					System.out.println(delVipcngJobj.toJSONString());
					delVipConf[i] = new ProxyVipConfigVO();
					delVipConf[i].setPry_svr_id(prySvrId);
					delVipConf[i].setVip_cng_id(getIntOfJsonObj(delVipcngJobj,"vip_cng_id"));
					
					System.out.println("delete vip instance info ----------------------------------------");
					System.out.println(CommonUtil.toMap(delVipConf[i]).toString());
					
					//delete vip instance
					proxySettingDAO.deletePryVipConf(delVipConf[i]);
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
					
					if(!nullCheckOfJsonObj(listenerObj, "lsn_id")){
						listener[i].setLsn_id(getIntOfJsonObj(listenerObj, "lsn_id"));
					}
	
					listener[i].setLsn_nm(getStringOfJsonObj(listenerObj, "lsn_nm"));
					listener[i].setCon_bind_port(getStringOfJsonObj(listenerObj, "con_bind_port"));
					listener[i].setLsn_desc(getStringOfJsonObj(listenerObj,"lsn_desc"));
					listener[i].setDb_usr_id(getStringOfJsonObj(listenerObj, "db_usr_id"));
					listener[i].setDb_id(getIntOfJsonObj(listenerObj,"db_id"));
					listener[i].setDb_nm(getStringOfJsonObj(listenerObj, "db_nm"));
					listener[i].setCon_sim_query(getStringOfJsonObj(listenerObj, "con_sim_query"));
					listener[i].setField_nm(getStringOfJsonObj(listenerObj, "field_nm"));
					listener[i].setField_val(getStringOfJsonObj(listenerObj, "field_val"));
					listener[i].setLst_mdfr_id(lst_mdfr_id);
					
					System.out.println("insert/update proxy listenener info ----------------------------------------");
					System.out.println(CommonUtil.toMap(listener[i]).toString());
					
					//UPDATE/INSERT PROXY LISTENER
					proxySettingDAO.insertUpdatePryListener(listener[i]);

					if(listenerObj.get("lsn_svr_edit_list") != null){
						JSONArray listnSvrArry = (JSONArray) listenerObj.get("lsn_svr_edit_list");
						int listnSvrSize = listnSvrArry.size();
						
						if (listnSvrSize > 0) {
							ProxyListenerServerVO listnSvr[] = new ProxyListenerServerVO[listnSvrSize];

							for(int j=0; j<listnSvrSize; j++){
								JSONObject listnSvrObj = (JSONObject)listnSvrArry.get(j);
								listnSvr[j] = new ProxyListenerServerVO();
								listnSvr[j].setPry_svr_id(prySvrId);
								
								if(!nullCheckOfJsonObj(listnSvrObj, "lsn_id")){//newLsnId
									listnSvr[j].setLsn_id(getIntOfJsonObj(listnSvrObj, "lsn_id"));
								}else{
									int newLsnId = proxySettingDAO.selectPryListenerMaxId();

									System.out.println("newLsnID ----------------------------------------------------------------- :: "+newLsnId);
									listnSvr[j].setLsn_id(newLsnId);
								}
								
								if(!nullCheckOfJsonObj(listnSvrObj, "lsn_svr_id")){
									listnSvr[j].setLsn_svr_id(getIntOfJsonObj(listnSvrObj, "lsn_svr_id"));
								}

								listnSvr[j].setDb_con_addr(getStringOfJsonObj(listnSvrObj,"db_con_addr"));
								listnSvr[j].setChk_portno(getIntOfJsonObj(listnSvrObj, "chk_portno"));
								listnSvr[j].setBackup_yn(getStringOfJsonObj(listnSvrObj,"backup_yn"));
								listnSvr[j].setLst_mdfr_id(lst_mdfr_id);
								
								System.out.println("insert/update proxy listenener Server info ----------------------------------------");
								System.out.println(CommonUtil.toMap(listnSvr[j]).toString());
								
								//UPDATE/INSERT PROXY LISTENER Server List
								proxySettingDAO.insertUpdatePryListenerSvr(listnSvr[j]);
							}
						}
					}
					
					if(listenerObj.get("lsn_svr_del_list") != null){
						JSONArray delListnSvrArry = (JSONArray) listenerObj.get("lsn_svr_del_list"); 
						int delListnSvrSize = delListnSvrArry.size();
						
						if (delListnSvrSize > 0) {
							ProxyListenerServerVO delListnSvr[] = new ProxyListenerServerVO[delListnSvrSize];
							for(int j=0; j<delListnSvrSize; j++){
								JSONObject delListnSvrObj = (JSONObject)delListnSvrArry.get(j);
								delListnSvr[j] = new ProxyListenerServerVO();
								delListnSvr[j].setPry_svr_id(prySvrId);
								delListnSvr[j].setLsn_id(getIntOfJsonObj(delListnSvrObj, "lsn_id"));
								delListnSvr[j].setLsn_svr_id(getIntOfJsonObj(delListnSvrObj, "lsn_svr_id"));
								delListnSvr[j].setDb_con_addr(getStringOfJsonObj(delListnSvrObj, "db_con_addr"));
								System.out.println("delete proxy listenener Server info ----------------------------------------");
								System.out.println(CommonUtil.toMap(delListnSvr[j]).toString());
								
								//delete proxy listener server list
								proxySettingDAO.deletePryListenerSvr(delListnSvr[j]);
							}
						}
					}
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
					delListn[i].setLsn_id(getIntOfJsonObj(delListnObj,"lsn_id"));
					
					ProxyListenerServerVO delListnSvr = new ProxyListenerServerVO();
					delListnSvr.setPry_svr_id(prySvrId);
					delListnSvr.setLsn_id(getIntOfJsonObj(delListnObj,"lsn_id"));
					//System.out.println("Before delete proxy listenener info ----------------------------------------");
					//System.out.println(CommonUtil.toMap(delListn[i]).toString());
					proxySettingDAO.deletePryListenerSvr(delListnSvr);
					
					//System.out.println("delete proxy listenener info ----------------------------------------");
					//System.out.println(CommonUtil.toMap(delListn[i]).toString());
					//delete proxy listener
					proxySettingDAO.deletePryListener(delListn[i]);
				}
			}
			
			//agent 호출  > conf를 만들어서 던져??? agent에서 만들어??
			
			
			//agent가 할 일
			//conf 파일 만들어?? conf 신규 반영
			//
			
			//재기동 이력 남기기 
			//이전 config 파일 이력 남기기
			
			//기동 상태 return 받으면 ... 
			
			resultObj.put("resultLog", "success");
			resultObj.put("result",true);
			resultObj.put("errMsg","작업이 완료되었습니다.");

		} catch (Exception e) {
			resultObj.put("resultLog", "fail");
			resultObj.put("result",false);
			resultObj.put("errcd", -1);
			resultObj.put("errmsg", "작업 중 오류가 발생하였습니");
			
			e.printStackTrace();
		}
		
		return resultObj;
	}

	/**
	 * Proxy agent 목록 조회
	 * 
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@Override
	public List<Map<String, Object>> selectPoxyAgentSvrList(Map<String, Object> param) {
		return proxySettingDAO.selectPoxyAgentSvrList(param);
	}
	
	//int 형변환 / null 처리
	public int getIntOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null){
			return 0;
		}else{
			return Integer.parseInt(jobj.get(key).toString());
		}
	}

	//string 형변환
	public String getStringOfJsonObj(JSONObject jobj, String key){
		return String.valueOf(jobj.get(key));
	}
	
	//null 체크
	public boolean nullCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || "".equals(jobj.get(key))){
			return true;
		}else{
			return false;
		}
	}
	
	//0 체크
	public boolean zeroCheckOfJsonObj(JSONObject jobj, String key){
		if(jobj.get(key) == null || Integer.parseInt(jobj.get(key).toString()) == 0 ){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public List<Map<String, Object>> selectMasterProxyList(Map<String, Object> param) {
		return proxySettingDAO.selectMasterProxyList(param);
	}
}
