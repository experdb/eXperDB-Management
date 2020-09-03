package com.k4m.dx.tcontrol.accesscontrol.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 * 접근제어관리 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.23   김주영 최초 생성
 *      </pre>
 */

@Controller
public class AccessControlController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private AccessControlService accessControlService;

	@Autowired
	private DbAuthorityService dbAuthorityService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	private List<Map<String, Object>> dbSvrAut;


	/**
	 * 서버접근제어 화면을 보여준다.
	 * 
	 * @param historyVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessControl.do")
	public ModelAndView serverAccessControl(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		Map<String, Object> resultJson = new HashMap<String, Object>();

		try {
			if (dbSvrAut.get(0).get("acs_cntr_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0027");
				accessHistoryService.insertHistory(historyVO);

				AES256 dec = new AES256(AES256_KEY.ENC_KEY);

				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

				String strIpAdr = dbServerVO.getIpadr();
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

				if (agentInfo == null) {
					mv.addObject("extName", "agent");
				} else if (agentInfo.getAGT_CNDT_CD().equals("TC001102")) {
					mv.addObject("extName", "agentfail");
				} else {
					String IP = dbServerVO.getIpadr();
					int PORT = agentInfo.getSOCKET_PORT();
					String strExtname = "adminpack";

					serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
					serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
					serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
					serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
					serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
					serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

					List<Object> result = cic.extension_select(serverObj, IP, PORT, strExtname);

					if (result == null || result.size() == 0) {
						mv.addObject("extName", strExtname);
					} else {
						resultJson = cic.role_List(serverObj,IP,PORT);
						mv.addObject("resultUser", resultJson);
						
						HttpSession session = request.getSession();
						LoginVO loginVo = (LoginVO) session.getAttribute("session");
						String usr_id = loginVo.getUsr_id();

						DbAutVO dbAutVO = new DbAutVO();
						dbAutVO.setDb_svr_id(db_svr_id);
						dbAutVO.setUsr_id(usr_id);

						List<DbIDbServerVO> resultSet = accessControlService.selectDatabaseList(dbAutVO);
						mv.addObject("resultSet", resultSet);
						
						List<AccessControlVO> resultType = accessControlService.selectCodeType("TC0011");
						mv.addObject("resultType", resultType);

						List<AccessControlVO> resultMethod = accessControlService.selectCodeMethod("TC0012");
						mv.addObject("resultMethod", resultMethod);
						
						mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
						mv.addObject("db_svr_id", db_svr_id);
					}
				}
				mv.setViewName("dbserver/accesscontrol");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근제어 리스트를 조회한다.
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAccessControl.do")
	public @ResponseBody JSONObject selectAccessControl(HttpServletRequest request) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();
		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			JSONObject serverObj = new JSONObject();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			result = cic.dbAccess_select(serverObj, IP, PORT);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 접근제어 등록/수정 팝업을 보여준다.
	 * 
	 * @param request
	 * @param historyVO
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/accessControlRegForm.do")
	public ModelAndView connectorReg(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			String act = request.getParameter("act");
			CmmnUtils.saveHistory(request, historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);

			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			if (act.equals("i")) {
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0028");
				accessHistoryService.insertHistory(historyVO);
			}

			if (act.equals("u")) {
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0029");
				accessHistoryService.insertHistory(historyVO);
			}

			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", dbServerVO.getDb_svr_id());

			mv.addObject("act", act);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근제어를 적용한다.
	 * 
	 * @param accessControlVO, accessControlHistoryVO, historyVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/applyAccessControl.do")
	public @ResponseBody boolean applyAccessControl(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			HttpServletRequest request, @ModelAttribute("accessControlVO") AccessControlVO accessControlVO,@ModelAttribute("historyVO") HistoryVO historyVO) {

		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		AgentInfoVO vo = new AgentInfoVO();
		JSONParser jParser = new JSONParser();

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			JSONArray jArr = (JSONArray) jParser.parse(request.getParameter("rowList").toString().replace("&quot;", "\""));
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0027_02");
			accessHistoryService.insertHistory(historyVO);
			
			List<DbServerVO> dbServerVO = cmmnServerInfoService.selectAllIpadrList(db_svr_id);
			for(int m=0; m<dbServerVO.size(); m++){
				String IP = dbServerVO.get(m).getIpadr();
				vo.setIPADR(IP);
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				int PORT = agentInfo.getSOCKET_PORT();

				serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.get(m).getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.get(m).getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.get(m).getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.get(m).getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, dbServerVO.get(m).getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.get(m).getSvr_spr_scm_pwd()));

				/*pg_hba.conf 전체 삭제*/
				ArrayList arrSeq = new ArrayList();
				cic.dbAccess_delete(serverObj, arrSeq, IP, PORT);
							
				for (int i = 0; i < jArr.size(); i++) {
					JSONObject jObj = (JSONObject) jArr.get(i);
					String User = (String) jObj.get("User");
					String Seq = String.valueOf(jObj.get("Seq"));
					String Method = (String) jObj.get("Method");
					String Type = (String) jObj.get("Type");
					String Set = (String) jObj.get("Set");
					String Ipadr = (String) jObj.get("Ipadr");
					String Ipmask = (String) jObj.get("Ipmask");
					String Option = (String) jObj.get("Option");
					String Database = (String) jObj.get("Database");
						
					JSONObject acObj = new JSONObject();
					acObj.put(ClientProtocolID.AC_SET, "1");
					acObj.put(ClientProtocolID.AC_TYPE, Type);
					acObj.put(ClientProtocolID.AC_DATABASE, Database);
					acObj.put(ClientProtocolID.AC_USER, User);
					acObj.put(ClientProtocolID.AC_IP, Ipadr);
					acObj.put(ClientProtocolID.AC_IPMASK, Ipmask == null ? "" : Ipmask);
					acObj.put(ClientProtocolID.AC_METHOD, Method);
					acObj.put(ClientProtocolID.AC_OPTION, Option);

					cic.dbAccess_create(serverObj, acObj, IP, PORT);
				}
				
				if(dbServerVO.get(m).getMaster_gbn().equals("M")){
					accessControlService.deleteDbAccessControl(db_svr_id);
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					String usr_id = loginVo.getUsr_id();
					accessControlVO.setFrst_regr_id(usr_id);
					accessControlVO.setLst_mdfr_id(usr_id);		
					accessControlHistoryVO.setLst_mdfr_id(usr_id);
					int current_his_grp = accessControlService.selectCurrenthisrp();	
					accessControlHistoryVO.setHis_grp_id(current_his_grp);					
					JSONObject result = cic.dbAccess_selectAll(serverObj, IP, PORT);
					for (int i = 0; i < result.size(); i++) {
						JSONArray data = (JSONArray) result.get("data");
						for (int j = 0; j < data.size(); j++) {
							JSONObject jsonObj = (JSONObject) data.get(j);
							int svr_acs_cntr_id= accessControlService.selectCurrentCntrid();
							
							accessControlVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
							accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
							accessControlVO.setPrms_set((String) jsonObj.get("Set"));
							accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
							accessControlVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
							accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
							accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
							accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
							accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
							accessControlVO.setDtb((String) jsonObj.get("Database"));
							accessControlService.insertAccessControl(accessControlVO);

							accessControlHistoryVO.setDb_svr_id(db_svr_id);
							accessControlHistoryVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
							accessControlHistoryVO.setDtb((String) jsonObj.get("Database"));
							accessControlHistoryVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
							accessControlHistoryVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
							accessControlHistoryVO.setPrms_usr_id((String) jsonObj.get("User"));
							accessControlHistoryVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
							accessControlHistoryVO.setPrms_set((String) jsonObj.get("Set"));
							accessControlHistoryVO.setCtf_mth_nm((String) jsonObj.get("Method"));
							accessControlHistoryVO.setCtf_tp_nm((String) jsonObj.get("Type"));
							accessControlHistoryVO.setOpt_nm((String) jsonObj.get("Option"));
							accessControlService.insertAccessControlHistory(accessControlHistoryVO);
						}
					}
				}
			}		
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 접근제어이력 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessControlHistory.do")
	public ModelAndView accessControlHistory(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);
		ModelAndView mv = new ModelAndView();
		try {
			 if(dbSvrAut.get(0).get("policy_change_his_aut_yn").equals("N")){
			 mv.setViewName("error/autError");
			 }else{
				// 화면접근이력 이력 남기기
				 CmmnUtils.saveHistory(request, historyVO);
				 historyVO.setExe_dtl_cd("DX-T0030");
				 accessHistoryService.insertHistory(historyVO);
	
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				List<AccessControlHistoryVO> result = accessControlService.selectLstmdfdtm(db_svr_id);
				
				mv.addObject("lst_mdf_dtm", result);
				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
				mv.addObject("db_svr_id", db_svr_id);
				mv.setViewName("dbserver/accesscontrolHistory");
			 }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근제어이력을 조회한다.
	 * 
	 * @param accessControlHistoryVO
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/selectAccessControlHistory.do")
	public @ResponseBody List<AccessControlHistoryVO> selectAccessControlHistory(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		List<AccessControlHistoryVO> resultSet = null;
		try {
			// 화면접근이력 이력 남기기
			 CmmnUtils.saveHistory(request, historyVO);
			 historyVO.setExe_dtl_cd("DX-T0030_01");
			 accessHistoryService.insertHistory(historyVO);

			resultSet = accessControlService.selectAccessControlHistory(accessControlHistoryVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}

	@RequestMapping(value = "/recoveryAccessControlHistory.do")
	public @ResponseBody String recoveryAccessControlHistory(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		JSONObject acObj = new JSONObject();
		AgentInfoVO vo = new AgentInfoVO();
		try {
			// 화면접근이력 이력 남기기
			 CmmnUtils.saveHistory(request, historyVO);
			 historyVO.setExe_dtl_cd("DX-T0030_02");
			 accessHistoryService.insertHistory(historyVO);

			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			List<DbServerVO> dbServerVO = cmmnServerInfoService.selectAllIpadrList(db_svr_id);
			for(int m=0; m<dbServerVO.size(); m++){
				String IP = dbServerVO.get(m).getIpadr();
				vo.setIPADR(IP);
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				
				if (agentInfo == null) {
					return "agent";
				} 
				
				if (agentInfo.getAGT_CNDT_CD().equals("TC001102")) {
					return "agentfail";
				}
				
				int PORT = agentInfo.getSOCKET_PORT();

				serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.get(m).getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.get(m).getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.get(m).getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.get(m).getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, dbServerVO.get(m).getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.get(m).getSvr_spr_scm_pwd()));

				String strExtname = "adminpack";
				List<Object> resultExt = cic.extension_select(serverObj, IP, PORT, strExtname);
				if (resultExt == null || resultExt.size() == 0) {
					return "adminpack";
				}
				
				/*pg_hba.conf 전체 삭제*/
				ArrayList arrSeq = new ArrayList();
				cic.dbAccess_delete(serverObj, arrSeq, IP, PORT);
				
				List<AccessControlHistoryVO> resultSet = accessControlService.selectAccessControlHistory(accessControlHistoryVO);
				for(int i=0; i<resultSet.size(); i++){
					acObj.put(ClientProtocolID.AC_SET, "1");
					acObj.put(ClientProtocolID.AC_TYPE, resultSet.get(i).getCtf_tp_nm());
					acObj.put(ClientProtocolID.AC_DATABASE, resultSet.get(i).getDtb());
					acObj.put(ClientProtocolID.AC_USER, resultSet.get(i).getPrms_usr_id());
					acObj.put(ClientProtocolID.AC_IP, resultSet.get(i).getPrms_ipadr());
					acObj.put(ClientProtocolID.AC_IPMASK, resultSet.get(i).getPrms_ipmaskadr() == null ? "" : resultSet.get(i).getPrms_ipmaskadr());
					acObj.put(ClientProtocolID.AC_METHOD, resultSet.get(i).getCtf_mth_nm());
					acObj.put(ClientProtocolID.AC_OPTION, resultSet.get(i).getOpt_nm());
					cic.dbAccess_create(serverObj, acObj, IP, PORT);	
				}

				if(dbServerVO.get(m).getMaster_gbn().equals("M")){
					accessControlService.deleteDbAccessControl(db_svr_id);
					
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					String id = loginVo.getUsr_id();
				
					accessControlVO.setFrst_regr_id(id);
					accessControlVO.setLst_mdfr_id(id);
					accessControlHistoryVO.setLst_mdfr_id(id);
					int current_his_grp = accessControlService.selectCurrenthisrp();				
					accessControlHistoryVO.setHis_grp_id(current_his_grp);				
					JSONObject result = cic.dbAccess_selectAll(serverObj, IP, PORT);
					for (int i = 0; i < result.size(); i++) {
						JSONArray data = (JSONArray) result.get("data");
						for (int j = 0; j < data.size(); j++) {
							JSONObject jsonObj = (JSONObject) data.get(j);	
							int svr_acs_cntr_id= accessControlService.selectCurrentCntrid();
							
							accessControlVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
							accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
							accessControlVO.setPrms_set((String) jsonObj.get("Set"));
							accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
							accessControlVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
							accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
							accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
							accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
							accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
							accessControlVO.setDtb((String) jsonObj.get("Database"));
							accessControlService.insertAccessControl(accessControlVO);
		
							accessControlHistoryVO.setDb_svr_id(db_svr_id);
							accessControlHistoryVO.setSvr_acs_cntr_id(svr_acs_cntr_id);
							accessControlHistoryVO.setDtb((String) jsonObj.get("Database"));
							accessControlHistoryVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
							accessControlHistoryVO.setPrms_ipmaskadr((String) jsonObj.get("Ipmask"));
							accessControlHistoryVO.setPrms_usr_id((String) jsonObj.get("User"));
							accessControlHistoryVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
							accessControlHistoryVO.setPrms_set((String) jsonObj.get("Set"));
							accessControlHistoryVO.setCtf_mth_nm((String) jsonObj.get("Method"));
							accessControlHistoryVO.setCtf_tp_nm((String) jsonObj.get("Type"));
							accessControlHistoryVO.setOpt_nm((String) jsonObj.get("Option"));
							accessControlService.insertAccessControlHistory(accessControlHistoryVO);
						}
					}
				}

			}
							
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "false";

	}

}
