package com.k4m.dx.tcontrol.tree.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
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
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.tree.service.TreeInfoService;

/**
 * TreeInfoController 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.11.25   김주영 최초 생성
 *      </pre>
 */
@Controller
public class TreeInfoController {

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	@Autowired
	private TreeInfoService treeInfoService;
	
	/**
	 * 트리 Connector 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTreeConnectorRegister.do")
	public @ResponseBody List<ConnectorVO> selectTreeConnectorRegister(HttpServletRequest request) {
		List<ConnectorVO> resultSet = null;
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			resultSet = treeInfoService.selectConnectorRegister(usr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * 트리 암호화 권한을 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTreeEncrypt.do")
	public @ResponseBody List<Map<String, Object>> selectTreeEncrypt(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			resultSet = treeInfoService.selectTreeEncrypt(usr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	/**
	 * 속성 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/property.do")
	public ModelAndView workList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0073");
			accessHistoryService.insertHistory(historyVO);

			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO); //서버정보조회
			
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo); //agent 정보조회

			List<Map<String, Object>> serverInfoVOSelectTot = (List<Map<String, Object>>) cmmnServerInfoService.selectDashboardServerInfoImg(schDbServerVO);

			if (agentInfo == null) {
				mv.addObject("extName", "agent");
			} else if (agentInfo.getAGT_CNDT_CD().equals("TC001102")) {
				mv.addObject("extName", "agentfail");
			} else {
				try{
					String IP = dbServerVO.getIpadr();
					int PORT = agentInfo.getSOCKET_PORT();

					serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
					serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
					serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
					serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
					serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
					serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

					JSONObject result = cic.dbms_inforamtion(IP, PORT, serverObj);   //DBMS 정보(시스템정보, DBMS정보-데이터베이스정보)
					List<DbServerVO> resultIpadr = cmmnServerInfoService.selectAllIpadrList(db_svr_id);
					
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					String usr_id = loginVo.getUsr_id();
					dbServerVO.setUsr_id(usr_id);
					List<DbServerVO> resultRepoDB = cmmnServerInfoService.selectRepoDBList(dbServerVO);			
					
					ArrayList<String> arrayList = new ArrayList<>();
					ArrayList<String> deleteDB = new ArrayList<>();
					JSONArray data = (JSONArray) result.get("CMD_DATABASE_INFO");
					for (int i = 0; i < data.size(); i++) {
						JSONObject jsonObj = (JSONObject) data.get(i);	
						 arrayList.add((String) jsonObj.get("name"));
					}		 			
					for(int m=0; m<resultRepoDB.size(); m++){
						int check =0;
						for(int n=0; n<arrayList.size(); n++){
							if(resultRepoDB.get(m).getDb_nm().equals(arrayList.get(n))){
								check=1;
							}
						}
						if(check==0){
							deleteDB.add(resultRepoDB.get(m).getDb_nm());
						}
					}
					mv.addObject("result", result);
					mv.addObject("resultIpadr", resultIpadr);
					mv.addObject("resultRepoDB", resultRepoDB);
					mv.addObject("deleteDB", deleteDB);
					mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
					mv.addObject("db_svr_id", db_svr_id);	
					
					mv.addObject("serverInfoVOSelectTot", serverInfoVOSelectTot);
				}catch(Exception e){
					mv.addObject("extName", "agentfail");
				}
			}
			mv.setViewName("dbserver/property");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	
	/**
	 * 속성 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/test.do")
	public ModelAndView test(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {

		ModelAndView mv = new ModelAndView();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		
		try {
		AES256 dec = new AES256(AES256_KEY.ENC_KEY);
		
		
		//int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		int db_svr_id = 2;

		DbServerVO schDbServerVO = new DbServerVO();
		schDbServerVO.setDb_svr_id(db_svr_id);
		DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO); //서버정보조회
		
		String strIpAdr = dbServerVO.getIpadr();
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(strIpAdr);
		AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo); //agent 정보조회
	
		
		String IP = dbServerVO.getIpadr();
		int PORT = agentInfo.getSOCKET_PORT();

		serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
		serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
		serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
		serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
		serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
		serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

		JSONObject result = cic.serverSpace(IP, PORT, serverObj);   //대시보드 서버용량
		

		mv.addObject("result", result);
		
		}catch(Exception e){
			e.printStackTrace();
			
		}			
			mv.setViewName("test");

		return mv;
	}
}
