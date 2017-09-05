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
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;

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
	private TransferService transferService;

	@Autowired
	private AccessControlService accessControlService;

	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	private List<Map<String, Object>> dbSvrAut;
	
	/**
	 * 트리 Connector 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTreeConnectorRegister.do")
	public @ResponseBody List<ConnectorVO> selectTreeConnectorRegister(HttpServletRequest request) {
		List<ConnectorVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			param.put("usr_id", usr_id);
			
			resultSet = transferService.selectConnectorRegister(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * 서버접근제어 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/accessControl.do")
	public ModelAndView serverAccessControl(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
	
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService);

		ModelAndView mv = new ModelAndView();
		try {
			if(dbSvrAut.get(0).get("acs_cntr_aut_yn").equals("N")){
				mv.setViewName("error/autError");				
			}else{
				// 접근제어관리 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0027");
				accessHistoryService.insertHistory(historyVO);
	
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);		
				String strIpAdr = dbServerVO.getIpadr();		
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);		
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
		
				if(agentInfo == null) {
					mv.addObject("extName", "agent");
					mv.setViewName("dbserver/accesscontrol");
				}else{
					mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
					mv.addObject("db_svr_id", db_svr_id);
					mv.setViewName("dbserver/accesscontrol");	
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근제어 리스트를 조회한다.
	 * 
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
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			result = cic.dbAccess_select(serverObj,IP,PORT);
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
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		JSONObject serverObj = new JSONObject();
		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			String act = request.getParameter("act");
			CmmnUtils.saveHistory(request, historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
	
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			/* TODO ip,port ROLE LIST조회 */
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.role_List(serverObj);
			mv.addObject("result", result);
			
			DbAutVO dbAutVO = new DbAutVO();
			dbAutVO.setDb_svr_id(db_svr_id);
			HttpSession session = request.getSession();
			dbAutVO.setUsr_id((String) session.getAttribute("usr_id"));
			List<DbIDbServerVO> resultSet = accessControlService.selectDatabaseList(dbAutVO);
			mv.addObject("resultSet", resultSet);
			
			if (act.equals("i")) {
				// 접근제어 등록 팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0028");
				accessHistoryService.insertHistory(historyVO);
			}
			
			if (act.equals("u")) {
				// 접근제어 수정 팝업 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0028_01");
				accessHistoryService.insertHistory(historyVO);

				mv.addObject("prms_seq",request.getParameter("Seq").equals("undefined") ? "" : request.getParameter("Seq"));
				mv.addObject("prms_ipadr",request.getParameter("Ipadr").equals("undefined") ? "" : request.getParameter("Ipadr"));
				mv.addObject("prms_usr_id",request.getParameter("User").equals("undefined") ? "" : request.getParameter("User"));
				mv.addObject("ctf_mth_nm",request.getParameter("Method").equals("undefined") ? "" : request.getParameter("Method"));
				mv.addObject("ctf_tp_nm",request.getParameter("Type").equals("undefined") ? "" : request.getParameter("Type"));
				mv.addObject("dtb",request.getParameter("Database").equals("undefined") ? "" : request.getParameter("Database"));
			}
			
			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", dbServerVO.getDb_svr_id());
			mv.addObject("act", act);
			mv.setViewName("popup/accessControlRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 접근제어를 등록한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertAccessControl.do")
	public @ResponseBody void insertAccessControl(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		JSONObject acObj = new JSONObject();

		try {
			// 접근제어 등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0028_02");
			accessHistoryService.insertHistory(historyVO);
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			/*서버접근제어 전체 삭제*/
			accessControlService.deleteDbAccessControl(db_svr_id);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);	
			String strIpAdr = dbServerVO.getIpadr();	
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);	
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, accessControlVO.getCtf_tp_nm());
			acObj.put(ClientProtocolID.AC_DATABASE, accessControlVO.getDtb());
			acObj.put(ClientProtocolID.AC_USER, accessControlVO.getPrms_usr_id());
			acObj.put(ClientProtocolID.AC_IP, accessControlVO.getPrms_ipadr());
			acObj.put(ClientProtocolID.AC_METHOD, accessControlVO.getCtf_mth_nm());
			acObj.put(ClientProtocolID.AC_OPTION, accessControlVO.getOpt_nm());
			
			cic.dbAccess_create(serverObj, acObj, IP, PORT);
			
			String id = (String) request.getSession().getAttribute("usr_id");
			accessControlVO.setFrst_regr_id(id);
			accessControlVO.setLst_mdfr_id(id);

			JSONObject result = cic.dbAccess_selectAll(serverObj, IP, PORT);

			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int j = 0; j < data.size(); j++) {
					JSONObject jsonObj = (JSONObject) data.get(j);
					accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
					accessControlVO.setPrms_set((String) jsonObj.get("Set"));
					accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
					accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
					accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
					accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
					accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
					accessControlVO.setDtb((String) jsonObj.get("Database"));
					accessControlService.insertAccessControl(accessControlVO);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 접근제어를 수정한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateAccessControl.do")
	public @ResponseBody void updateAccessControl(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		JSONObject serverObj = new JSONObject();
		JSONObject acObj = new JSONObject();

		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			// 접근제어 수정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0028_03");
			accessHistoryService.insertHistory(historyVO);
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
	
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			acObj.put(ClientProtocolID.AC_SEQ, request.getParameter("prms_seq"));	
			acObj.put(ClientProtocolID.AC_SET, "1");
			acObj.put(ClientProtocolID.AC_TYPE, accessControlVO.getCtf_tp_nm());
			acObj.put(ClientProtocolID.AC_DATABASE, accessControlVO.getDtb());
			acObj.put(ClientProtocolID.AC_USER, accessControlVO.getPrms_usr_id());
			acObj.put(ClientProtocolID.AC_IP, accessControlVO.getPrms_ipadr());
			acObj.put(ClientProtocolID.AC_METHOD, accessControlVO.getCtf_mth_nm());
			acObj.put(ClientProtocolID.AC_OPTION, accessControlVO.getOpt_nm());
			
			cic.dbAccess_update(serverObj, acObj, IP, PORT);
			
			/*서버접근제어 전체 삭제*/
			accessControlService.deleteDbAccessControl(db_svr_id);
			
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			accessControlVO.setFrst_regr_id(usr_id);
			accessControlVO.setLst_mdfr_id(usr_id);

			JSONObject result = cic.dbAccess_selectAll(serverObj,IP,PORT);
			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int j = 0; j < data.size(); j++) {
					JSONObject jsonObj = (JSONObject) data.get(j);
					accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
					accessControlVO.setPrms_set((String) jsonObj.get("Set"));
					accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
					accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
					accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
					accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
					accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
					accessControlVO.setDtb((String) jsonObj.get("Database"));
					accessControlService.insertAccessControl(accessControlVO);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 접근제어를 삭제한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @param historyVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteAccessControl.do")
	public @ResponseBody boolean deleteAccessControl(@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
	
		DbServerVO schDbServerVO = new DbServerVO();
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		ArrayList arrSeq = new ArrayList();
		try {	
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			String[] param = request.getParameter("rowList").toString().split(",");
			
			for (int i = 0; i < param.length; i++) {
				HashMap<String, String> hpSeq = new HashMap<String, String>();
				hpSeq.put(ClientProtocolID.AC_SEQ, param[i]);
				arrSeq.add(hpSeq);
			}
			
			cic.dbAccess_delete(serverObj, arrSeq, IP, PORT);

			/*DBid 서버접근제어 전체 삭제*/
			accessControlService.deleteDbAccessControl(db_svr_id);
			
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			accessControlVO.setFrst_regr_id(usr_id);
			accessControlVO.setLst_mdfr_id(usr_id);

			JSONObject result = cic.dbAccess_selectAll(serverObj,IP,PORT);
			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int j = 0; j < data.size(); j++) {
					JSONObject jsonObj = (JSONObject) data.get(j);
					accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
					accessControlVO.setPrms_set((String) jsonObj.get("Set"));
					accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
					accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
					accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
					accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
					accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
					accessControlVO.setDtb((String) jsonObj.get("Database"));
					accessControlService.insertAccessControl(accessControlVO);
				}
			}		
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * 접근제어를 수정한다.
	 * 
	 * @param accessControlVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/changeAccessControl.do")
	public @ResponseBody boolean changeAccessControl(HttpServletRequest request,@ModelAttribute("accessControlVO") AccessControlVO accessControlVO) {

		DbServerVO schDbServerVO = new DbServerVO();
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String IP = dbServerVO.getIpadr();
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			int PORT = agentInfo.getSOCKET_PORT();
					
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			ArrayList arrSeq = new ArrayList();
			
			JSONParser jParser = new JSONParser();
			JSONArray jArr = (JSONArray)jParser.parse(request.getParameter("rowList").toString().replace("&quot;", "\""));
			
			for(int i=0; i<jArr.size(); i++){
				JSONObject jObj = (JSONObject)jArr.get(i);
				String Seq=String.valueOf(jObj.get("Seq"));
				HashMap<String, String> hpSeq = new HashMap<String, String>();
				hpSeq.put(ClientProtocolID.AC_SEQ, Seq);
				arrSeq.add(hpSeq);	
			}
			
			cic.dbAccess_delete(serverObj, arrSeq, IP, PORT);
			
			for(int i=0; i<jArr.size(); i++){
				JSONObject jObj = (JSONObject)jArr.get(i);
				String User=(String) jObj.get("User");
				String Seq=String.valueOf(jObj.get("Seq"));
				String Method=(String) jObj.get("Method");
				String Type=(String) jObj.get("Type");
				String Set=(String) jObj.get("Set");
				String Ipadr=(String) jObj.get("Ipadr");
				String Option=(String) jObj.get("Option");
				String Database=(String) jObj.get("Database");
				
				JSONObject acObj = new JSONObject();
				acObj.put(ClientProtocolID.AC_SET, Set);
				acObj.put(ClientProtocolID.AC_TYPE, Type);
				acObj.put(ClientProtocolID.AC_DATABASE, Database);
				acObj.put(ClientProtocolID.AC_USER, User);
				acObj.put(ClientProtocolID.AC_IP, Ipadr);
				acObj.put(ClientProtocolID.AC_METHOD, Method);
				acObj.put(ClientProtocolID.AC_OPTION, Option);

				cic.dbAccess_create(serverObj, acObj, IP, PORT);
			}
			
			/*DBid 서버접근제어 전체 삭제*/
			accessControlService.deleteDbAccessControl(db_svr_id);
			
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			accessControlVO.setFrst_regr_id(usr_id);
			accessControlVO.setLst_mdfr_id(usr_id);

			JSONObject result = cic.dbAccess_selectAll(serverObj,IP,PORT);
			for (int i = 0; i < result.size(); i++) {
				JSONArray data = (JSONArray) result.get("data");
				for (int j = 0; j < data.size(); j++) {
					JSONObject jsonObj = (JSONObject) data.get(j);
					accessControlVO.setPrms_seq(Integer.parseInt((String) jsonObj.get("Seq")));
					accessControlVO.setPrms_set((String) jsonObj.get("Set"));
					accessControlVO.setPrms_ipadr((String) jsonObj.get("Ipadr"));
					accessControlVO.setPrms_usr_id((String) jsonObj.get("User"));
					accessControlVO.setCtf_mth_nm((String) jsonObj.get("Method"));
					accessControlVO.setCtf_tp_nm((String) jsonObj.get("Type"));
					accessControlVO.setOpt_nm((String) jsonObj.get("Option"));
					accessControlVO.setDtb((String) jsonObj.get("Database"));
					accessControlService.insertAccessControl(accessControlVO);
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
