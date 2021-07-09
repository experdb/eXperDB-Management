package com.experdb.management.proxy.web;

import java.net.ConnectException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.experdb.management.proxy.service.ProxyHistoryService;
import com.experdb.management.proxy.service.ProxyServerVO;
import com.experdb.management.proxy.service.ProxySettingService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 *Proxy 설정이력 관리
 *
 * @author 김민정
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.03.03   김민정 최초 생성
 *      </pre>
 */
@Controller
public class ProxyHistoryController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private ProxySettingService proxySettingService;
	
	@Autowired
	private ProxyHistoryService proxyHistoryService;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private MessageSource msg;
	
	private List<Map<String, Object>> menuAut;
	
	private String show_menu_id = "46";
	
	/**
	 * Proxy 상태 이력 관리
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws 
	 */
	@RequestMapping(value = "/proxyStatusHistory.do")
	public ModelAndView proxyStatusHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");
				
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기 - Proxy 이력 관리 화면 
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167", show_menu_id);
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				
				mv.addObject("usr_id", loginVo.getUsr_id());

				List<CmmnCodeVO> cmmnCodeVO =  null;
				PageVO pageVO = new PageVO();
				
				pageVO.setGrp_cd("TC0040");
				pageVO.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("actExeTypeCd",cmmnCodeVO);
				
				//Listener Nm Code Search
				PageVO pageVO_2 = new PageVO();
				
				pageVO_2.setGrp_cd("TC0015");
				pageVO_2.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO_2);
				mv.addObject("exeRsltCd", cmmnCodeVO);
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("svr_use_yn", "Y");
				List<ProxyServerVO> prySvrList = proxySettingService.selectProxyServerList(param);
			
				List<Map<String, Object>> dbSvrList = proxyHistoryService.selectSvrStatusDBConAddrList();
				//select current_date as today, current_date-1 as yesterday, current_date-6 as before_6days
				mv.addObject("dbSvrList", dbSvrList);
				mv.addObject("prySvrList", prySvrList);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));	

				mv.setViewName("proxy/history/proxyHistory");
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * Proxy 기동 상태 변경 이력 리스트를 조회한다.
	 * 
	 * @param request, historyVO, response
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@RequestMapping(value = "/selectProxyActStateHistory.do")
	public @ResponseBody List<Map<String, Object>> selectProxyActStateHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");
				
		List<Map<String, Object>> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167_03", show_menu_id);		

				param.put("wlk_dtm_start", cu.getStringWithoutNull(request.getParameter("wlk_dtm_start")));
				param.put("wlk_dtm_end", cu.getStringWithoutNull(request.getParameter("wlk_dtm_end")));
				param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? "" : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			    param.put("sys_type", cu.getStringWithoutNull(request.getParameter("sys_type")));
				param.put("act_type", cu.getStringWithoutNull(request.getParameter("act_type")));
				param.put("act_exe_type", cu.getStringWithoutNull(request.getParameter("act_exe_type")));
				param.put("exe_rslt_cd", cu.getStringWithoutNull(request.getParameter("exe_rslt_cd")));
				
				resultSet = proxyHistoryService.selectProxyActStateHistoryList(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	/**
	 * Proxy 기동 상태 변경 이력 리스트를 조회한다.
	 * 
	 * @param request, historyVO, response
	 * @return List<Map<String, Object>>
	 * @throws 
	 */
	@RequestMapping(value = "/selectProxyStatusHistory.do")
	public @ResponseBody Map<String, Object> selectProxyStatusHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");
				
		Map<String, Object> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167_03", show_menu_id);		
				resultSet =  new HashMap<String, Object>();
				param.put("exe_dtm_start", cu.getStringWithoutNull(request.getParameter("exe_dtm_start")));
				param.put("exe_dtm_end", cu.getStringWithoutNull(request.getParameter("exe_dtm_end")));
				param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? "" : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			    param.put("log_type", cu.getStringWithoutNull(request.getParameter("log_type")));
				param.put("db_con_addr", cu.getStringWithoutNull(request.getParameter("db_con_addr")));
				
				List<Map<String, Object>> data = proxyHistoryService.selectProxyStatusHistory(param);
			
				resultSet.put("data", data);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	/**
	 * Proxy 설정 변경 이력 리스트를 조회한다.
	 * 
	 * @param historyVO, request, response
	 * @return List<Map<String, Object>>
	 * @throws
	 */
	@RequestMapping(value = "/selectProxySettingChgHistory.do")
	public @ResponseBody List<Map<String, Object>> selectProxySettingChgHistory(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");
				
		List<Map<String, Object>> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167_02", show_menu_id);		

				param.put("lst_dtm_start", request.getParameter("lst_dtm_start")==null ? "" : request.getParameter("lst_dtm_start").toString());
				param.put("lst_dtm_end", request.getParameter("lst_dtm_end")==null ? "" : request.getParameter("lst_dtm_end").toString());
				param.put("pry_svr_id", (request.getParameter("pry_svr_id") ==null || "".equals(request.getParameter("pry_svr_id").toString())) ? "" : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			    param.put("exe_rst_cd", request.getParameter("exe_rst_cd")==null ? "" : request.getParameter("exe_rst_cd").toString());
				//param.put("lst_mdfr_id", request.getParameter("lst_mdfr_id")==null ? "" : request.getParameter("lst_mdfr_id").toString());
				  
				resultSet = proxyHistoryService.selectProxySettingChgHistoryList(param);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultSet;
	}

	/**
	 * Proxy Conf 파일 확인 팝업 
	 * 
	 * @param request, historyVO
	 * @return ModelAndView mv
	 * @throws

	@RequestMapping(value = "/popup/proxyBackupConfForm.do")
	public ModelAndView proxyListenRegForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");

			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167_01", show_menu_id);				
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
		 */
	
	/**
	 * Proxy Conf 파일 읽어오기
	 * 
	 * @param historyVO, request, response
	 * @return JSONObject
	 * @throws 
	 */
	@RequestMapping(value = "/getBackupConfFile.do")
	public @ResponseBody JSONObject getBackupConfFile(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		CmmnUtils cu = new CmmnUtils();		
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
		Map<String, Object> confFileStrMap = new HashMap();
		try {	
			param.put("sys_type", cu.getStringWithoutNull(request.getParameter("sys_type")));
			param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 0 : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			param.put("pry_svr_nm", cu.getStringWithoutNull(request.getParameter("pry_svr_nm")));
			param.put("pry_cng_sn", "".equals(cu.getStringWithoutNull(request.getParameter("pry_cng_sn"))) ? 0 : Integer.parseInt(request.getParameter("pry_cng_sn").toString()));
				
			try{
				confFileStrMap = proxyHistoryService.getProxyConfFileContent(param);
			}catch(ConnectException e){
				e.printStackTrace();
				resultObj.put("errcd", 1);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
				return resultObj;
			}catch(Exception e){
				e.printStackTrace();
				resultObj.put("errcd", 2);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale()));
			}
			resultObj.put("pry_svr_id", param.get("pry_svr_id").toString());
			resultObj.put("pry_svr_nm", param.get("pry_svr_nm").toString());
			
			if( confFileStrMap.get("RESULT_CODE") != null &&   "0".equals(confFileStrMap.get("RESULT_CODE").toString())){
				if(confFileStrMap.get("BACKUP_CONF") != null) resultObj.put("backupConf", confFileStrMap.get("BACKUP_CONF").toString());
				else resultObj.put("backupConf", msg.getMessage("eXperDB_proxy.msg44", null, LocaleContextHolder.getLocale()));
				if(confFileStrMap.get("PRESENT_CONF") != null) resultObj.put("presentConf",confFileStrMap.get("PRESENT_CONF").toString());
				else resultObj.put("presentConf", msg.getMessage("eXperDB_proxy.msg44", null, LocaleContextHolder.getLocale()));
				
				resultObj.put("errcd", 0);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));
			}else{
				resultObj.put("errcd", -1);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg46", null, LocaleContextHolder.getLocale()));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg46", null, LocaleContextHolder.getLocale()));
		}
		return resultObj;
	}
	
	/**
	 * Proxy Conf 파일 읽어오기
	 * 
	 * @param historyVO, request, response
	 * @return JSONObject
	 * @throws 
	 */
	@RequestMapping(value = "/deleteBackupConfFile.do")
	public @ResponseBody JSONObject deleteBackupConfFile(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		Map<String, Object> param = new HashMap<String, Object>();
		JSONObject resultObj = new JSONObject();
		Map<String, Object> confFileStrMap = new HashMap();
		
		try {	
			param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? 0 : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			param.put("pry_cng_sn", "".equals(cu.getStringWithoutNull(request.getParameter("pry_cng_sn"))) ? 0 : Integer.parseInt(request.getParameter("pry_cng_sn").toString()));
			param.put("lst_mdfr_id", loginVo.getUsr_id()==null ? "" : loginVo.getUsr_id().toString());	
			try{
				confFileStrMap = proxyHistoryService.deleteProxyConfFolder(param);
			}catch(ConnectException e){
				e.printStackTrace();
				resultObj.put("errcd", 1);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg47", null, LocaleContextHolder.getLocale()));
				return resultObj;
			}catch(Exception e){
				e.printStackTrace();
				resultObj.put("errcd", 2);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg48", null, LocaleContextHolder.getLocale()));
				return resultObj;
			}
			
			if( confFileStrMap.get("RESULT_CODE") != null &&   "0".equals(confFileStrMap.get("RESULT_CODE").toString())){
				resultObj.put("errcd", 0);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg45", null, LocaleContextHolder.getLocale()));		
			}else{
				resultObj.put("errcd", -1);
				resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg46", null, LocaleContextHolder.getLocale()));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			resultObj.put("errcd", -1);
			resultObj.put("errmsg",msg.getMessage("eXperDB_proxy.msg46", null, LocaleContextHolder.getLocale()));
		}
		return resultObj;
	}

	/**
	 * 실시간 상태 로그 엑셀을 저장한다.
	 * 
	 * @param request
	 * @throws Exception
	 */
	@RequestMapping("/proxyStatusHistory_Excel.do")
	public ModelAndView proxyStatusHistory_Excel(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletResponse response, HttpServletRequest request) throws Exception {
		List<Map<String, Object>> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
            Cookie cookie = new Cookie("fileDownload", "true");
            cookie.setPath("/");
            response.addCookie(cookie);
			
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");

			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return null;
			}
			
			param.put("exe_dtm_start", cu.getStringWithoutNull(request.getParameter("excel_wlk_dtm_start")));
			param.put("exe_dtm_end", cu.getStringWithoutNull(request.getParameter("excel_wlk_dtm_end")));
			param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("excel_pry_svr_id"))) ? "" : Integer.parseInt(request.getParameter("excel_pry_svr_id").toString()));
		    param.put("log_type", cu.getStringWithoutNull(request.getParameter("excel_log_type")));
			param.put("db_con_addr", cu.getStringWithoutNull(request.getParameter("excel_db_con_addr")));
			
			resultSet = proxyHistoryService.selectProxyStatusHistory(param);
			
			String title = "Proxy 상태 로그";
			String[] headerNm={"DB서버IP","Proxy명","Listener명","실행일자","실행일시","실행결과","상태","마지막상태체크","중단시간","처리 요청 선택 건수","백업 서버수","상태 전환 건수","실패 검사 수","현재 세션 수","최대 세션 수","세션 제한 수","누적 세션 연결 수","수신수","송신수"};
			String[] dataSet={"db_con_addr","pry_svr_nm","lsn_nm","exe_dtm_date","exe_dtm_time","exe_rslt_cd","svr_status","lst_status_chk_desc","svr_stop_tm","svr_pro_req_sel_cnt","bakup_ser_cnt","svr_status_chg_cnt","fail_chk_cnt","cur_session","max_session","session_limit","cumt_sso_con_cnt","byte_receive","byte_transmit"};
			String fileName = "Proxy Status History";
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("category", resultSet);
			map.put("excel_title",title);
			map.put("excel_header_nm", headerNm);
			map.put("excel_data", dataSet);
			map.put("excel_file", fileName);
			
			return new ModelAndView("overallExcelView", "categoryMap", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	// "/popup/proxyStatusChartTitle.do",
	/**
	 * Proxy 설정 변경 이력 리스트를 조회한다.
	 * 
	 * @param historyVO, request, response
	 * @return List<Map<String, Object>>
	 * @throws
	 */
	@RequestMapping(value = "/popup/proxyStatusChartTitle.do")
	public @ResponseBody Map<String, Object> selectProxyStatusChartTitle(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN0001803");
				
		Map<String, Object> resultSet = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();

		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				// 화면접근이력 이력 남기기 - Proxy 설정관리 - Proxy Listen 관리 팝업
				proxySettingService.accessSaveHistory(request, historyVO, "DX-T0167_02", show_menu_id);		
				param.put("exe_dtm_start", cu.getStringWithoutNull(request.getParameter("exe_dtm_start")));
				param.put("exe_dtm_end", cu.getStringWithoutNull(request.getParameter("exe_dtm_end")));
				param.put("pry_svr_id", "".equals(cu.getStringWithoutNull(request.getParameter("pry_svr_id"))) ? "" : Integer.parseInt(request.getParameter("pry_svr_id").toString()));
			    param.put("db_con_addr", cu.getStringWithoutNull(request.getParameter("db_con_addr")));
				param.put("lsn_id", cu.getStringWithoutNull(request.getParameter("lsn_id")));
				param.put("log_type", cu.getStringWithoutNull(request.getParameter("log_type")));
				
				List<Map<String, Object>>  serverChartData = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>>  sessionChartData = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>>  byteChartData = new ArrayList<Map<String, Object>>();
				
				String prySvrNm = "";
				String lsnNm = "";
				String dbConAddr = "";
				
				List<Map<String, Object>> statusData = proxyHistoryService.selectProxyStatusHistory(param);
				
				for(int i=0; i < statusData.size(); i++){
					Map<String, Object> serverChart = new HashMap<String, Object>();
					serverChart.put("exe_dtm_date", statusData.get(i).get("exe_dtm_date"));
					serverChart.put("svr_pro_req_sel_cnt", statusData.get(i).get("svr_pro_req_sel_cnt"));
					serverChart.put("bakup_ser_cnt", statusData.get(i).get("bakup_ser_cnt"));
					serverChart.put("svr_status_chg_cnt", statusData.get(i).get("svr_status_chg_cnt"));
					serverChart.put("fail_chk_cnt", statusData.get(i).get("fail_chk_cnt"));
					
					serverChartData.add(serverChart);
					
					Map<String, Object> sessionChart = new HashMap<String, Object>();
					sessionChart.put("exe_dtm_date", statusData.get(i).get("exe_dtm_date"));
					sessionChart.put("cur_session", statusData.get(i).get("cur_session"));
					sessionChart.put("max_session", statusData.get(i).get("max_session"));
					sessionChart.put("session_limit", statusData.get(i).get("session_limit"));
					sessionChart.put("cumt_sso_con_cnt", statusData.get(i).get("cumt_sso_con_cnt"));

					sessionChartData.add(sessionChart);
					
					Map<String, Object> byteChart = new HashMap<String, Object>();
					byteChart.put("exe_dtm_date", statusData.get(i).get("exe_dtm_date"));
					byteChart.put("byte_receive", statusData.get(i).get("byte_receive"));
					byteChart.put("byte_transmit", statusData.get(i).get("byte_transmit"));
					
					byteChartData.add(byteChart);
					
					prySvrNm = cu.getStringWithoutNull(statusData.get(i).get("pry_svr_nm"));
					lsnNm = cu.getStringWithoutNull(statusData.get(i).get("lsn_nm"));
					dbConAddr = cu.getStringWithoutNull(statusData.get(i).get("db_con_addr"));
				}
				
				resultSet.put("prySvrNm", prySvrNm);
				resultSet.put("lsnNm", lsnNm);
				resultSet.put("serverChartData", serverChartData);
				resultSet.put("sessionChartData", sessionChartData);
				resultSet.put("byteChartData", byteChartData);
				resultSet.put("dbConAddr", dbConAddr);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultSet;
	}

}