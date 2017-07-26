package com.k4m.dx.tcontrol.audit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.audit.service.AuditVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
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
	private CmmnServerInfoService cmmnServerInfoService;
	
	@RequestMapping(value = "/audit/auditManagement.do")
	public ModelAndView auditManagement(@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setDB_SVR_ID(db_svr_id);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			JSONObject serverObj = new JSONObject();
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
			String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, strPwd);
			
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;
			
			String strExtName = "pgaudit";
			
			JSONObject objExtList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtName);
			
			List<Object> selectExtList  = (ArrayList<Object>) objExtList.get(ClientProtocolID.RESULT_DATA);
			
			
			if(selectExtList.size() == 0) {
				strExtName = "";
				mv.addObject("extName", strExtName);
				mv.setViewName("dbserver/auditManagement");
				return mv;
			}
			
			
			JSONObject objSettingInfo = new JSONObject();
			
			objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_R, serverObj, objSettingInfo);

			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			HashMap selectData =(HashMap) objList.get(ClientProtocolID.RESULT_DATA);
			
			JSONObject objRoleList;
			objRoleList = CA.dxT011(ClientTranCodeType.DxT011, serverObj);
			
			List<Object> selectRoleList =(ArrayList<Object>) objRoleList.get(ClientProtocolID.RESULT_DATA);

			CA.close();
			
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
			

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dbserver/auditManagement");
		return mv;
	}
	
	@RequestMapping(value = "/saveAudit.do")
	public @ResponseBody boolean auditSave( HttpServletRequest request) throws Exception {
		
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		
		AgentInfoVO vo = new AgentInfoVO();
		vo.setDB_SVR_ID(db_svr_id);
		
		AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
		
		DbServerVO schDbServerVO = new DbServerVO();
		schDbServerVO.setDb_svr_id(db_svr_id);
		
		DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
		
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
		
		String IP = dbServerVO.getIpadr();
		int PORT = agentInfo.getSOCKET_PORT();
		
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

		IP = "127.0.0.1";
		
		ClientAdapter CA = new ClientAdapter(IP, PORT);
		CA.open(); 
		
		objList = CA.dxT007(ClientTranCodeType.DxT007, ClientProtocolID.COMMAND_CODE_C, serverObj, objSettingInfo);
		
		boolean blnReturn = true;
		
		String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
		if(strResultCode.equals("1")) {
			blnReturn = false;
		}
		
		CA.close();
		
		return blnReturn;
	}
	
	
	@RequestMapping(value = "/audit/auditLogList.do")
	public ModelAndView auditLogList(@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setDB_SVR_ID(db_svr_id);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			
			mv.addObject("serverName", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", strDbSvrId);
			
			List<HashMap<String, String>> fileList = new ArrayList<HashMap<String, String>>();
			
			mv.addObject("logFileList", fileList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dbserver/auditLogList");
		return mv;
	}
	
	
	@RequestMapping(value = "/audit/auditLogSearchList.do")
	public ModelAndView auditLogSearchList(@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			String strStartDate =  request.getParameter("start_date");
			String strEndDate =  request.getParameter("end_date");
			
			JSONObject searchInfoObj = new JSONObject();
			searchInfoObj.put(ClientProtocolID.START_DATE, strStartDate);
			searchInfoObj.put(ClientProtocolID.END_DATE, strEndDate);
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setDB_SVR_ID(db_svr_id);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strDirectory = dbServerVO.getIstpath();
			
			JSONObject serverObj = new JSONObject();
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
			String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());

			
			JSONObject jObj = new JSONObject();
			jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.DxT015);
			jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
			jObj.put(ClientProtocolID.COMMAND_CODE, ClientProtocolID.COMMAND_CODE_R);
			jObj.put(ClientProtocolID.FILE_DIRECTORY, strDirectory);
			jObj.put(ClientProtocolID.SEARCH_INFO, searchInfoObj);
			
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			//IP = "127.0.0.1";
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList = CA.dxT015(jObj);
			
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
			
			mv.addObject("start_date", strStartDate);
			mv.addObject("end_date", strEndDate);
			

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dbserver/auditLogList");
		return mv;
	}
	
	@RequestMapping(value = "/audit/auditLogView.do")
	public ModelAndView auditLogView(@ModelAttribute("auditVO") AuditVO auditVO, ModelMap model, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView();

		//mv.addObject("db_svr_id",workVO.getDb_svr_id());
		try {
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setDB_SVR_ID(db_svr_id);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strDirectory = dbServerVO.getIstpath();
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
			
			JSONObject objList = CA.dxT015(jObj);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			System.out.println("RESULT_CODE : " +  strResultCode);
			System.out.println("ERR_CODE : " +  strErrCode);
			System.out.println("ERR_MSG : " +  strErrMsg);
			
			String strLogView = (String)objList.get(ClientProtocolID.RESULT_DATA);
			
			System.out.println("#################################");
			System.out.println(strLogView.trim());
			System.out.println("#################################");
			

			
			mv.addObject("serverName", dbServerVO.getDb_svr_nm());
			mv.addObject("db_svr_id", strDbSvrId);
			mv.addObject("logView", strLogView.trim());
			

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("popup/auditLogView");
		return mv;
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
