package com.k4m.dx.tcontrol.admin.extension.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientAdapter;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.cmmn.client.ClientTranCodeType;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
 * Agent 모니터링 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.30   김주영 최초 생성
 *      </pre>
 */

@Controller
public class ExtensionController {

	@Autowired
	private AccessHistoryService accessHistoryService;
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@RequestMapping(value = "/extensionList.do")
	public ModelAndView extensionList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0041");
			historyVO.setMnu_id(21);
			accessHistoryService.insertHistory(historyVO);
			
			mv.setViewName("admin/extension/extensionList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	@RequestMapping(value = "/extensionDetail.do")
	@ResponseBody
	public ArrayList<Object> extensionDetail(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ArrayList<Object> selectDBList = null;
		try {	
			String strDbSvrId = request.getParameter("db_svr_id");
			int db_svr_id = Integer.parseInt(strDbSvrId);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();

			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			

			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			//System.out.println("KEY : " + dbServerVO.getSvr_spr_scm_pwd());
			String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
			
			
			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, strPwd);
			
			String strExtname = "";
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;
			
			//strExtname = "pgaudit";
			objList = CA.dxT010(ClientTranCodeType.DxT010, serverObj, strExtname);
			
			String strErrMsg = (String)objList.get(ClientProtocolID.ERR_MSG);
			String strErrCode = (String)objList.get(ClientProtocolID.ERR_CODE);
			String strDxExCode = (String)objList.get(ClientProtocolID.DX_EX_CODE);
			String strResultCode = (String)objList.get(ClientProtocolID.RESULT_CODE);
			
			selectDBList =(ArrayList<Object>) objList.get(ClientProtocolID.RESULT_DATA);
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return selectDBList;
	}
	
	
	
	@RequestMapping(value = "/extensionCreate.do")
	@ResponseBody
	public void extensionCreate(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
	
		try {	

			int agentPORT = Integer.parseInt(request.getParameter("agentPort"));
			String serverIp = request.getParameter("ipadr");
			String serverName = request.getParameter("db_svr_nm");
			String serverPort = request.getParameter("port");
			String DatabaseName =request.getParameter("dft_db_nm");
			String userId = request.getParameter("svr_spr_usr_id");
			String userPw = request.getParameter("svr_spr_scm_pwd");

			JSONObject serverObj = new JSONObject();
			
			serverObj.put(ClientProtocolID.SERVER_NAME, serverName);
			serverObj.put(ClientProtocolID.SERVER_IP, serverIp);
			serverObj.put(ClientProtocolID.SERVER_PORT, serverPort);
			serverObj.put(ClientProtocolID.DATABASE_NAME, DatabaseName);
			serverObj.put(ClientProtocolID.USER_ID, userId);
			serverObj.put(ClientProtocolID.USER_PWD, userPw);
					
		
			ClientInfoCmmn cic = new ClientInfoCmmn();
			
			String strExtName = "";
			List<Object> results = cic.extension_select(serverObj,serverIp,agentPORT,strExtName);
			
			if(results.size() > 0) {
				boolean isAdminPackYn = false;
				boolean isAuditYn = false;
				
				for(int i=0; i<results.size(); i++) {
					Object obj = results.get(i);		
					HashMap hp = (HashMap) obj;
					String extname = (String) hp.get("extname");
								
					if(extname.equals("adminpack")){
						isAdminPackYn = true;
					}
					if(extname.equals("pgaudit")){
						isAuditYn = true;
					}	
					System.out.println(i + " " + extname);
				}	
				
				
				if(isAdminPackYn == false){
					System.out.println("ADMINPACK 미설치");
					cic.extensionCreate(serverObj,serverIp,agentPORT,"ADMINPACK");
				}
				if(isAuditYn == false){
					System.out.println("PGAUDIT 미설치");
					cic.extensionCreate(serverObj,serverIp,agentPORT,"PGAUDIT");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
	
	
}
