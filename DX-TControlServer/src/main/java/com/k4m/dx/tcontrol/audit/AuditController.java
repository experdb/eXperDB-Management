package com.k4m.dx.tcontrol.audit;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

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
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setDB_SVR_ID(db_svr_id);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			
			DbServerVO dbServerVO = (DbServerVO)  cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			JSONObject serverObj = new JSONObject();
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			String strPwd = dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd());
			
			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, strPwd);
			
			
			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
			
			ClientAdapter CA = new ClientAdapter(IP, PORT);
			CA.open(); 
			
			JSONObject objList;
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
			
				
				System.out.println("log : " +  selectData.get("log")
				                + " log_level : " +  selectData.get("log_level")
				                + " log_relation : " +  selectData.get("log_relation")
								+ " role : " +  selectData.get("role")
								+ " log_catalog : " +  selectData.get("log_catalog")
								+ " log_parameter : " +  selectData.get("log_parameter")
								+ " log_statement_once : " +  selectData.get("log_statement_once")
								);

			CA.close();
			
			
			mv.addObject("audit", selectData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dbserver/auditManagement");
		return mv;
	}
	
}
