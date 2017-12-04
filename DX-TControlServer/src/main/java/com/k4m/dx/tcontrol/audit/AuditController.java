package com.k4m.dx.tcontrol.audit;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.audit.service.AuditVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientAdapter;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.cmmn.client.ClientTranCodeType;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * 감사로그 컨트롤러 클래스를 정의한다.
 *
 * @author 박태혁
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.07.06   박태혁
 *      </pre>
 */

@Controller
public class AuditController {
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	private List<Map<String, Object>> dbSvrAut;
	
	@RequestMapping(value = "/audit/auditManagement.do")
	public ModelAndView auditManagement(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		
		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService);
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(dbSvrAut.get(0).get("adt_cng_aut_yn").equals("N")){
				mv.setViewName("error/autError");				
			}else{		
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0031");
				historyVO.setMnu_id(30);
				accessHistoryService.insertHistory(historyVO);
				
				String strDbSvrId = request.getParameter("db_svr_id");
				int db_svr_id = Integer.parseInt(strDbSvrId);
				
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				
				DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
				String strIpAdr = dbServerVO.getIpadr();
			
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);
				
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				
				JSONObject serverObj = new JSONObject();
				
				AES256 dec = new AES256(AES256_KEY.ENC_KEY);
				//System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
				String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
				
				
				serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, strPwd);	
				
				String IP = dbServerVO.getIpadr();
				
				if(agentInfo == null) {
					mv.addObject("extName", "agent");
					mv.setViewName("dbserver/auditManagement");
					return mv;
				}
				
				if(agentInfo.getAGT_CNDT_CD().equals("TC001102")){
					mv.addObject("extName", "agentfail");
					mv.setViewName("dbserver/auditManagement");
					return mv;
				}
				
				int PORT = agentInfo.getSOCKET_PORT();
				
				//IP = "127.0.0.1";
				ClientAdapter CA = new ClientAdapter(IP, PORT);
				 
				JSONObject objList;
				
				String strExtName = "pgaudit";
				
				CA.open();
				JSONObject objExtList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtName);
				CA.close();
				
				List<Object> selectExtList  = (ArrayList<Object>) objExtList.get(ClientProtocolID.RESULT_DATA);
				
				if(selectExtList == null || selectExtList.size() == 0) {
					strExtName = "";
					mv.addObject("extName", strExtName);
					mv.setViewName("dbserver/auditManagement");
					return mv;
				}
				
				CA.open();
				objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_R, serverObj );
				CA.close();
	
				String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
				String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
				String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
				String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
				System.out.println("RESULT_CODE : " +  strResultCode);
				System.out.println("ERR_CODE : " +  strErrCode);
				System.out.println("ERR_MSG : " +  strErrMsg);
				
				HashMap selectData =(HashMap) objList.get(ClientProtocolID.RESULT_DATA);
				
				JSONObject objRoleList;
				
				CA.open();
				objRoleList = CA.dxT011(ClientTranCodeType.DxT011, serverObj);
				CA.close();
				
				List<Object> selectRoleList =(ArrayList<Object>) objRoleList.get(ClientProtocolID.RESULT_DATA);
	
				String strIsActive = "on";
				
				String auditActive = (String) selectData.get("log");
				
				if(auditActive == null || auditActive.equals("")) {
					strIsActive = "off";
				}
				
				selectData.put("isActive", strIsActive);
				
				mv.addObject("audit", selectData);
				mv.addObject("roleList", selectRoleList);
				mv.addObject("extName", strExtName);
				mv.addObject("serverName", dbServerVO.getDb_svr_nm());
				mv.addObject("db_svr_id", strDbSvrId);
			
				mv.setViewName("dbserver/auditManagement");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	@RequestMapping(value = "/saveAudit.do")
	public @ResponseBody boolean auditSave(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) throws Exception {
		boolean blnReturn = true;
		AgentInfoVO vo = new AgentInfoVO();
		JSONObject serverObj = new JSONObject();
		try{
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0031_01");
			historyVO.setMnu_id(30);
			accessHistoryService.insertHistory(historyVO);
					
			String strLogActive = request.getParameter("chkLogActive") == null?"":request.getParameter("chkLogActive");
			String strLogLevel = request.getParameter("log_level") == null?"":request.getParameter("log_level");
			String strRead = request.getParameter("chkRead") == null?"":request.getParameter("chkRead");
			if(strRead.equals("on")) strRead = "read";
			
			String strWrite = request.getParameter("chkWrite") == null?"":request.getParameter("chkWrite");
			if(strWrite.equals("on")) strWrite = "write";
			
			String strFunc = request.getParameter("chkFunction") == null?"":request.getParameter("chkFunction");
			if(strFunc.equals("on")) strFunc = "function";
			
			String strRole =  request.getParameter("chkRole") == null?"":request.getParameter("chkRole");
			if(strRole.equals("on")) strRole = "role";
			
			String strDdl =  request.getParameter("chkDdl") == null?"":request.getParameter("chkDdl");
			if(strDdl.equals("on")) strDdl = "ddl";
			
			String strMisc =  request.getParameter("chkMisc") == null?"":request.getParameter("chkMisc");
			if(strMisc.equals("on")) strMisc = "misc";
			
			String strAllLog = (strRead == ""?"":strRead + ",") 
								+ (strWrite == ""?"":strWrite + ",")
								+ (strFunc == ""?"":strFunc + ",")
								+ (strRole == ""?"":strRole + ",")
								+ (strDdl == ""?"":strDdl + ",")
								+ (strMisc == ""?"":strMisc + ",");
			
			strAllLog = replaceLast(strAllLog, ",", "");
			
			String strCatalog =  request.getParameter("chkCatalog") == null?"off":request.getParameter("chkCatalog");
			String strParameter =  request.getParameter("chkParameter") == null?"off":request.getParameter("chkParameter");
			String strRelation =  request.getParameter("chkRelation") == null?"off":request.getParameter("chkRelation");
			String strStatement = request.getParameter("chkStatement") == null?"off":request.getParameter("chkStatement");
			
			String strRoles = "";
			
			String[] arrRoles = request.getParameterValues("chkRoles");
			
			if(arrRoles!= null && arrRoles.length > 0) {
				for(int i=0; i<arrRoles.length; i++) {
					strRoles += arrRoles[i] + ",";
				}
				
				strRoles = replaceLast(strRoles, ",", "");
			}
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		
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
				
				JSONObject objSettingInfo = new JSONObject();
				
				//로그종류 
				objSettingInfo.put(ClientProtocolID.AUDIT_USE_YN, (strLogActive.equals("on")?"Y" : "N"));
				objSettingInfo.put(ClientProtocolID.AUDIT_LOG, strAllLog);
				objSettingInfo.put(ClientProtocolID.AUDIT_LEVEL, strLogLevel);
				objSettingInfo.put(ClientProtocolID.AUDIT_CATALOG, strCatalog);
				objSettingInfo.put(ClientProtocolID.AUDIT_PARAMETER, strParameter);
				objSettingInfo.put(ClientProtocolID.AUDIT_RELATION, strRelation);
				objSettingInfo.put(ClientProtocolID.AUDIT_STATEMENT_ONCE, strStatement);
				objSettingInfo.put(ClientProtocolID.AUDIT_ROLE, strRoles);
	
				JSONObject objList;
	
				ClientAdapter CA = new ClientAdapter(IP, PORT);
				CA.open(); 
				objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_C, serverObj, objSettingInfo);
				CA.close();
				
				String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
				if(strResultCode.equals("1")) {
					blnReturn = false;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return blnReturn;
	}
	
	@RequestMapping(value = "/audit/auditLogList.do")
	public ModelAndView auditLogList(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		
		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService);
		
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if(dbSvrAut.get(0).get("adt_hist_aut_yn").equals("N")){
				mv.setViewName("error/autError");				
			}else{	
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0032");
				historyVO.setMnu_id(31);
				accessHistoryService.insertHistory(historyVO); 
				
				String strDbSvrId = request.getParameter("db_svr_id");
				int db_svr_id = Integer.parseInt(strDbSvrId);
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
		        Calendar c1 = Calendar.getInstance();
	
		        String strToday = sdf.format(c1.getTime());
	
				String strStartDate =  strToday;
				String strEndDate =  strToday;
				
				JSONObject searchInfoObj = new JSONObject();
				searchInfoObj.put(ClientProtocolID.START_DATE, strStartDate);
				searchInfoObj.put(ClientProtocolID.END_DATE, strEndDate);
				
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				
				DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
				
				String strIpAdr = dbServerVO.getIpadr();
				
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);
				
				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				
				String strDirectory = dbServerVO.getPgdata_pth() + "/pg_log/";
				
				JSONObject serverObj = new JSONObject();
				
				AES256 dec = new AES256(AES256_KEY.ENC_KEY);
				//System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
				String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
				
				
				serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, strPwd);
	
				
				JSONObject jObj = new JSONObject();
				jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
				jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
				jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
				jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
				jObj.put(ClientProtocolID.SEARCH_INFO, searchInfoObj);
				
				String IP = dbServerVO.getIpadr();
				
				if(agentInfo == null) {
					
					mv.addObject("extName", "agent");
					mv.setViewName("dbserver/auditLogList");
					return mv;
				}
				
				int PORT = agentInfo.getSOCKET_PORT();
				
				//IP = "127.0.0.1";
				ClientAdapter CA = new ClientAdapter(IP, PORT);
				
				String strExtName = "pgaudit";
				
				CA.open();
				JSONObject objExtList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtName);
				CA.close();
				
				List<Object> selectExtList  = (ArrayList<Object>) objExtList.get(ClientProtocolID.RESULT_DATA);
	
				if(selectExtList == null || selectExtList.size() == 0) {
					strExtName = "";
					mv.addObject("extName", strExtName);
					mv.setViewName("dbserver/auditManagement");
					return mv;
				}
				
				CA.open(); 
				JSONObject objList = CA.dxT015(jObj);
				CA.close();
				
				String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
				String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
				String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
				String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
				System.out.println("RESULT_CODE : " +  strResultCode);
				System.out.println("ERR_CODE : " +  strErrCode);
				System.out.println("ERR_MSG : " +  strErrMsg);
				
				List<HashMap<String, String>> fileList = (List<HashMap<String, String>>) objList.get(ClientProtocolID.RESULT_DATA);
				
				mv.addObject("serverName", dbServerVO.getDb_svr_nm());
				mv.addObject("db_svr_id", strDbSvrId);
				mv.addObject("logFileList", fileList);
				mv.addObject("extName", strExtName);
				mv.addObject("start_date", strStartDate);
				mv.addObject("end_date", strEndDate);
				mv.setViewName("dbserver/auditLogList");
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	@RequestMapping(value = "/audit/auditLogSearchList.do")
	public ModelAndView auditLogSearchList(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0032_01");
			historyVO.setMnu_id(31);
			accessHistoryService.insertHistory(historyVO); 
			
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			String strStartDate =  request.getParameter("start_date");
			String strEndDate =  request.getParameter("end_date");
			
			JSONObject searchInfoObj = new JSONObject();
			searchInfoObj.put(ClientProtocolID.START_DATE, strStartDate);
			searchInfoObj.put(ClientProtocolID.END_DATE, strEndDate);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String strDirectory = dbServerVO.getPgdata_pth()+ "/pg_log/";
			
			JSONObject serverObj = new JSONObject();
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			//System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
			String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, strPwd);

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.SEARCH_INFO, searchInfoObj);
			
			String IP = dbServerVO.getIpadr();
			
			if(agentInfo == null) {
				
				mv.addObject("extName", "agent");
				mv.setViewName("dbserver/auditLogList");
				return mv;
			}
			
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			
			String strExtName = "pgaudit";
			
			CA.open();
			JSONObject objExtList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtName);
			CA.close();
			
			List<Object> selectExtList  = (ArrayList<Object>) objExtList.get(ClientProtocolID.RESULT_DATA);
			
			if(selectExtList == null || selectExtList.size() == 0) {
				strExtName = "";
				mv.addObject("extName", strExtName);
				mv.setViewName("dbserver/auditManagement");
				return mv;
			}
			
			CA.open(); 
			JSONObject objList = CA.dxT015(jObj);
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			List<HashMap<String, String>> fileList = (List<HashMap<String, String>>) objList.get(ClientProtocolID.RESULT_DATA);
			
			mv.addObject("serverName", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", strDbSvrId);
			mv.addObject("logFileList", fileList);
			mv.addObject("extName", strExtName);
			mv.addObject("start_date", strStartDate);
			mv.addObject("end_date", strEndDate);

		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dbserver/auditLogList");
		return mv;
	}
	
	@RequestMapping(value = "/audit/auditLogView.do")
	public ModelAndView auditLogView(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0032_02");
			historyVO.setMnu_id(31);
			accessHistoryService.insertHistory(historyVO);
			
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			

			String strFileName = request.getParameter("file_name");
			
			
			String strBuffer = "";

			
			mv.addObject("serverName", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", strDbSvrId);
			mv.addObject("file_name", strFileName);
			
			mv.addObject("logView", strBuffer);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		mv.setViewName("popup/auditLogView");
		return mv;
	}
	
	@RequestMapping(value = "/audit/auditLogViewAjax.do")
	@ResponseBody
	public HashMap auditLogViewAjax(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws Exception{

		HashMap hp = new HashMap();
		String strBuffer = "";
		
		try {

			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
	
			String strSeek = request.getParameter("seek");
			String strReadLine = request.getParameter("readLine");
			String dwLen = request.getParameter("dwLen");
			//intDwlen = Integer.parseInt(dwLen);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String strDirectory = dbServerVO.getPgdata_pth()+ "/pg_log/";
			String strFileName = request.getParameter("file_name");
			
			//strDirectory = "C:\\k4m\\01-1. DX 제폼개발\\06. DX-Tcontrol\\07. 시험\\";
			//strFileName = "postgresql-2017-11-19.log";
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_V);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.FILE_NAME, strFileName);
			jObj.put(ClientProtocolID.SEEK, strSeek);
			jObj.put(ClientProtocolID.DW_LEN, dwLen);
			jObj.put(ClientProtocolID.READLINE, strReadLine);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList = CA.dxT015_V(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			String strEndFlag = (String)objList.get(ClientProtocolID.END_FLAG);
			strBuffer = (String)objList.get(ClientProtocolID.RESULT_DATA);
			
			int intDwlen = (int)objList.get(ClientProtocolID.DW_LEN);
			
			Long lngSeek= (Long)objList.get(ClientProtocolID.SEEK);
			
			hp.put("data", strBuffer);
			hp.put("fSize", strBuffer.length());
			//hp.put("fChrSize", intLastLength - intFirstLength);
			hp.put("seek", lngSeek.toString());
			hp.put("dwLen", Integer.toString(intDwlen));
			hp.put("endFlag", strEndFlag);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}

		return hp;
	}
	
	public HashMap auditLogViewAjax_old(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) throws Exception{

		HashMap hp = new HashMap();
		String strBuffer = "";
		
		try {

			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			int intDwlen = 1;
			String dwLen = request.getParameter("dwLen");
			intDwlen = Integer.parseInt(dwLen);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String strDirectory = dbServerVO.getPgdata_pth()+ "/pg_log/";
			String strFileName = request.getParameter("file_name");
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_V);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.FILE_NAME, strFileName);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList = CA.dxT015_V(jObj);
			
			CA.close();
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			//String strLogView = (String)objList.get(ClientProtocolID.RESULT_DATA);

			byte[] buffer = (byte[]) objList.get(ClientProtocolID.RESULT_DATA);
			
			int intBufLength = buffer.length;
			
			int intLastLength = 5000000;
			int intFirstLength = 0;
			if(intBufLength < 5000000) {
				intLastLength = buffer.length;
			} else {
				int intFirstDwlen = 0;
				if(intDwlen > 1 ) intFirstDwlen = intDwlen -1;
				
				intFirstLength = intLastLength * intFirstDwlen;
				intLastLength = intLastLength * intDwlen;
			}
			
			int intEndFlag = 0;
			
		
			
			if(intBufLength <= intLastLength) {
				//intFirstLength = buffer.length;
				intLastLength = intBufLength - 1;
				intEndFlag = 1;
			} else {
				intDwlen = intDwlen + 1;
			}
			System.out.println(" intBufLength : " + intBufLength + " intFirstLength : " + intFirstLength + " intLastLength : " + intLastLength + " intLastLength - intFirstLength :" + (intLastLength - intFirstLength));
			
			strBuffer = new String(buffer, intFirstLength, intLastLength - intFirstLength);
			hp.put("data", strBuffer);
			hp.put("fSize", strBuffer.length());
			hp.put("fChrSize", intLastLength - intFirstLength);
			hp.put("dwLen", intDwlen);
			hp.put("endFlag", intEndFlag);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}

		return hp;
	}
	
	@RequestMapping(value = "/audit/auditLogDownload.do")
	public void auditLogDownload(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0032_02");
			historyVO.setMnu_id(31);
			accessHistoryService.insertHistory(historyVO);
			
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			String strDirectory = dbServerVO.getPgdata_pth()+ "/pg_log/";
			//strDirectory = "C:\\k4m\\01-1. DX 제폼개발\\04. 시험\\pg_log\\";
			
			String strFileName = request.getParameter("file_name");
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());

			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015_DL);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_DL);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.FILE_NAME, strFileName);
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			CA.dxT015_DL(jObj, request, response);

			CA.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		//return "redirect:/popup/auditLogDownload";
		//mv.setViewName("popup/auditLogDownload");
		//return mv;
		//return true;
	}
	
	public static void main(String[] args) throws Exception {
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		
		String strData = dec.aesEncode("test");
		
		System.out.println(strData);
		
		System.out.println(dec.aesDecode("ELZ2H6WyVytsGBOhEcDMLw=="));
		
		
	}
	
    public static String replaceLast(String text, String regex, String replacement) {
        return text.replaceFirst("(?s)"+regex+"(?!.*?"+regex+")", replacement);
    }
}
