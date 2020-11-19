package com.k4m.dx.tcontrol.db2pg.dbms.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.cmmn.DBCPPoolManager;
import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class Db2pgDbmsSystemController {
	
	@Autowired
	private DbmsService dbmsService;
	
	@Autowired
	private DbServerManagerService dbServerManagerService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	private List<Map<String, Object>> dbmsGrb;
	private List<Map<String, Object>> dbmsChar;
	
	/**
	 * DBMS시스템 설정 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pgDBMS.do")
	public ModelAndView db2pgDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0134");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			dbmsGrb = dbmsService.dbmsListDbmsGrb();
			mv.addObject("result", dbmsGrb);
			dbmsGrb = dbmsService.dbmsGrb();
			mv.addObject("dbmsGrb_reg", dbmsGrb);
			dbmsGrb = dbmsService.dbmsGrb();
			mv.addObject("dbmsGrb_reg_re", dbmsGrb);

			mv.setViewName("db2pg/dbms/dbmsList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DBMS 수정 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsRegReForm.do")
	public ModelAndView dbmsRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<Db2pgSysInfVO> resultSet = null;
		HashMap<String , Object> paramvalue = new HashMap<String, Object>();
		try {				
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0136");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			resultSet = dbmsService.selectDb2pgDBMS(db2pgSysInfVO);
			
			String pwd = dec.aesDecode(resultSet.get(0).getPwd()).toString();
			
			if(resultSet.get(0).getDbms_dscd().equals("TC002201")){
				paramvalue.put("dbms_dscd", "TC0023");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002208")){
				paramvalue.put("dbms_dscd", "TC0024");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002205")){
				paramvalue.put("dbms_dscd", "TC0025");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002203")){
				paramvalue.put("dbms_dscd", "TC0027");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002206")){
				paramvalue.put("dbms_dscd", "TC0026");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002204")){
				paramvalue.put("dbms_dscd", "TC0005");
			}else if(resultSet.get(0).getDbms_dscd().equals("TC002202")){
				paramvalue.put("dbms_dscd", "TC0038");
			} else if(resultSet.get(0).getDbms_dscd().equals("TC002207")){
				paramvalue.put("dbms_dscd", "TC0031");
			} else if(resultSet.get(0).getDbms_dscd().equals("TC002209")){
				paramvalue.put("dbms_dscd", "TC0027");
			}

			dbmsChar = dbmsService.selectCharSetList(paramvalue);
			
			mv.addObject("pwd", pwd);
			mv.addObject("resultInfo", resultSet);
			mv.addObject("dbmsChar", dbmsChar);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * DBMS 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/dbmsRegForm.do")
	public ModelAndView dbmsRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0135");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			dbmsGrb = dbmsService.dbmsGrb();
		
			mv.addObject("result", dbmsGrb);
			mv.setViewName("db2pg/popup/dbmsRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * DB2PG DBMS 시스템을 조회한다.
	 * 
	 * @param db2pgSysInfVO
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDb2pgDBMS.do")
	@ResponseBody
	public List<Db2pgSysInfVO> selectDb2pgDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<Db2pgSysInfVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0134_01");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = dbmsService.selectDb2pgDBMS(db2pgSysInfVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
		
	}
		
	
	
	
	
	/**
	 * 기 등록된 PostgreSQL DBMS List 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param requestr
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/popup/pgDbmsRegForm.do")
	public ModelAndView pgDbmsRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {				
			mv.setViewName("db2pg/popup/pgDbmsRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 기 등록된 PostgreSQL DBMS List  조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectPgDbmsList.do")
	@ResponseBody
	public List<DbServerVO> selectPgDbmsList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletResponse response, HttpServletRequest request) {
	
		List<DbServerVO> resultSet = null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {		
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			resultSet = dbServerManagerService.selectPgDbmsList();

			for (int i = 0; i < resultSet.size(); i++) {			
				resultSet.get(i).setSvr_spr_scm_pwd(dec.aesDecode(resultSet.get(i).getSvr_spr_scm_pwd()));
			}
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * PostgreSQL 스키마 리스트조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused") 
	@RequestMapping(value = "/selectPgSchemaList.do")
	@ResponseBody
	public Map<String, Object> selectPgSchemaList(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> result =new HashMap<String, Object>();
		JSONObject serverObj = new JSONObject();
		AgentInfoVO vo = new AgentInfoVO();

		
		try {
			String ip = request.getParameter("ipadr");
			String port = request.getParameter("portno");
			String db_nm = request.getParameter("dtb_nm");
			String user = request.getParameter("spr_usr_id");
			String  pw = request.getParameter("pwd");

			vo.setIPADR(ip);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			String IP = ip;
			int PORT = agentInfo.getSOCKET_PORT();

			serverObj.put(ClientProtocolID.SERVER_NAME, ip);
			serverObj.put(ClientProtocolID.SERVER_IP, ip);
			serverObj.put(ClientProtocolID.SERVER_PORT,port);
			serverObj.put(ClientProtocolID.DATABASE_NAME, db_nm);
			serverObj.put(ClientProtocolID.USER_ID, user);
			serverObj.put(ClientProtocolID.USER_PWD, pw);
			
			ClientInfoCmmn conn  = new ClientInfoCmmn();
			result = conn.schemaList(serverObj, IP, PORT);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 선택한 DBMS에 따른 케릭터셋 호출
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectCharSetList.do")
	@ResponseBody
	public List<Map<String, Object>> selectCharSetList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletResponse response, HttpServletRequest request) {
	
		List<Map<String, Object>> result = null;
		HashMap<String , Object> paramvalue = new HashMap<String, Object>();
		try {		

			String dbms_dscd = request.getParameter("dbms_dscd");
			
			if(dbms_dscd.equals("TC002201")){
				paramvalue.put("dbms_dscd", "TC0023");
			}else if(dbms_dscd.equals("TC002208")){
				paramvalue.put("dbms_dscd", "TC0024");
			}else if(dbms_dscd.equals("TC002205")){
				paramvalue.put("dbms_dscd", "TC0025");
			}else if(dbms_dscd.equals("TC002203")){
				paramvalue.put("dbms_dscd", "TC0027");
			}else if(dbms_dscd.equals("TC002206")){
				paramvalue.put("dbms_dscd", "TC0026");
			}else if(dbms_dscd.equals("TC002204")){
				paramvalue.put("dbms_dscd", "TC0005");
			}else if(dbms_dscd.equals("TC002207")){
				paramvalue.put("dbms_dscd", "TC0031");
			}else if(dbms_dscd.equals("TC002202")){
				paramvalue.put("dbms_dscd", "TC0038");
			}else if(dbms_dscd.equals("TC002209")){
				paramvalue.put("dbms_dscd", "TC0027");
			}
				
			 result = dbmsService.selectCharSetList(paramvalue);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * DBMS서버 연결 테스트를 한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value="/dbmsConnTest.do")
	public @ResponseBody Map<String, Object> dbmsConnTest(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		Map<String, Object> result = null;
		
		try {
			
		JSONObject serverObj = new JSONObject();

		String ipadr = request.getParameter("ipadr");
		String portno = request.getParameter("portno");
		String db_nm = request.getParameter("dtb_nm");
		String svr_spr_usr_id = request.getParameter("spr_usr_id");
		String svr_spr_scm_pwd = request.getParameter("pwd");
		String dbms_cd = request.getParameter("dbms_dscd");
		
		serverObj.put(ClientProtocolID.SERVER_NAME, ipadr);
		serverObj.put(ClientProtocolID.SERVER_IP, ipadr);
		serverObj.put(ClientProtocolID.SERVER_PORT, portno);
		serverObj.put(ClientProtocolID.DATABASE_NAME, db_nm);
		serverObj.put(ClientProtocolID.USER_ID, svr_spr_usr_id);
		serverObj.put(ClientProtocolID.USER_PWD, svr_spr_scm_pwd);
		serverObj.put(ClientProtocolID.DB_TYPE, dbms_cd);
		
		result =  DBCPPoolManager.setupDriver(serverObj);

	}catch (Exception e) {
		e.printStackTrace();
	}
		return result;
	}
	

	/**
	 * 시스템명을 중복 체크한다.
	 * 
	 * @param scd_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg_sys_nmCheck.do")
	public @ResponseBody String db2pg_sys_nmCheck(@RequestParam("db2pg_sys_nm") String db2pg_sys_nm) {
		try {	
			int resultSet = dbmsService.db2pg_sys_nmCheck(db2pg_sys_nm);		
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
	
	
	/**
	 * DB2PG DBMS 시스템을 등록한다.
	 * 
	 * @param db2pgSysInfVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertDb2pgDBMS.do")
	public @ResponseBody boolean insertDb2pgDBMS(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			@ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		// 해당메뉴 권한 조회 (공통메소드호출)
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0135_01");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			String pwd = aes.aesEncode(db2pgSysInfVO.getPwd());
			
			db2pgSysInfVO.setPwd(pwd);
			
			db2pgSysInfVO.setFrst_regr_id(id);
			db2pgSysInfVO.setLst_mdfr_id(id);
			
			if(db2pgSysInfVO.getDbms_dscd().equals("TC002201")){
				db2pgSysInfVO.setScm_nm(db2pgSysInfVO.getScm_nm().toUpperCase());
				db2pgSysInfVO.setDtb_nm(db2pgSysInfVO.getDtb_nm().toUpperCase());
			}else if (db2pgSysInfVO.getDbms_dscd().equals("TC002208")){
				db2pgSysInfVO.setScm_nm(db2pgSysInfVO.getScm_nm().toUpperCase());
			}
			
			dbmsService.insertDb2pgDBMS(db2pgSysInfVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	
	/**
	 * DB2PG DBMS 시스템을 수정한다.
	 * 
	 * @param db2pgSysInfVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateDb2pgDBMS.do")
	public @ResponseBody boolean updateDb2pgDBMS(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			@ModelAttribute("db2pgSysInfVO") Db2pgSysInfVO db2pgSysInfVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		// 해당메뉴 권한 조회 (공통메소드호출)
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0136_01");
			historyVO.setMnu_id(40);
			accessHistoryService.insertHistory(historyVO);
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			String pwd = aes.aesEncode(db2pgSysInfVO.getPwd());
			
			db2pgSysInfVO.setPwd(pwd);
			db2pgSysInfVO.setFrst_regr_id(id);
			db2pgSysInfVO.setLst_mdfr_id(id);
			
			if(db2pgSysInfVO.getDbms_dscd().equals("TC002201")){
				db2pgSysInfVO.setScm_nm(db2pgSysInfVO.getScm_nm().toUpperCase());
				db2pgSysInfVO.setDtb_nm(db2pgSysInfVO.getDtb_nm().toUpperCase());
			}

			dbmsService.updateDb2pgDBMS(db2pgSysInfVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	
	
	
	/**
	 * 해당 시스템이 등록된 WORK 있는지 확인
	 * 
	 * @param db2pg_sys_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/exeMigCheck.do")
	public @ResponseBody int exeMigCheck(HttpServletRequest request, HttpServletResponse response) {
		
		int result = 0;
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		try {				
			
			String db2pg_sys_id =  request.getParameter("db2pg_sys_id");
			String db2pg_trg_sys_id = request.getParameter("db2pg_trg_sys_id");

			param.put("db2pg_sys_id", db2pg_sys_id);
			param.put("db2pg_trg_sys_id", db2pg_trg_sys_id);
			
			int ddl_result = dbmsService.db2pg_ddl_check(param);				
			int mig_result = dbmsService.db2pg_mig_check(param);		
			
			result = ddl_result+mig_result;		

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	/**
	 * DB2PG DBMS 시스템을 삭제한다.
	 * 
	 * @param db2pgSysInfVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/deleteDBMS.do")
	public @ResponseBody boolean deleteDBMS(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		// 해당메뉴 권한 조회 (공통메소드호출)
		
		try {
			
			int db2pg_sys_id =  Integer.parseInt(request.getParameter("db2pg_sys_id"));
			
			dbmsService.deleteDBMS(db2pg_sys_id);	
	
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
		
	
}
