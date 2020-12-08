package com.k4m.dx.tcontrol.admin.dbauthority.web;

import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

@Controller
public class DbSvrAuthorityController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private UserManagerService userManagerService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	private List<Map<String, Object>> menuAut;
	
	
	/**
	 * DB서버 메뉴 권한관리 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbServerAuthority.do")
	public ModelAndView dbServerAuthority(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {

		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000502");
				
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				
				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0037");
				historyVO.setMnu_id(15);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				String scale_yn_chk = "";
				
				if (props.get("scale") != null) {
					scale_yn_chk = props.get("scale").toString();
				}
				
				mv.addObject("scale_yn_chk", scale_yn_chk);

				mv.setViewName("admin/dbAuthority/dbServerAuthority");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;

	}
	
	
	/**
	 * 사용자 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDBSvrAutUserManager.do")
	public @ResponseBody List<UserVO> selectDBSvrAutUserManager(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000502");
				
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {	
				//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
				if(menuAut.get(0).get("read_aut_yn").equals("N")){
					response.sendRedirect("/autError.do");
					return resultSet;
				}else{
					String type=request.getParameter("type");
					String search = request.getParameter("search");
					String use_yn = request.getParameter("use_yn");
								
					param.put("type", type);
					param.put("search", search);
					param.put("use_yn", use_yn);
				
					resultSet = userManagerService.selectUserManager(param);	
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	
	
	/**
	 * 서버 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDBSrvAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectDBSrvAutInfo(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000502");
		List<Map<String, Object>> resultSet = null;
		
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				resultSet = dbAuthorityService.selectSvrList();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	
	/**
	 * 서버 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectUsrDBSrvAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectUsrDBSrvAutInfo(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000502");
				
		List<Map<String, Object>> resultSet = null;
		
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
//			if(menuAut.get(0).get("read_aut_yn").equals("N")){
//				response.sendRedirect("/autError.do");
//				return resultSet;
//			}else{
				String usr_id ="";
				
				if(request.getParameter("usr_id") == null){
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					usr_id = loginVo.getUsr_id();
				}else{
					usr_id = request.getParameter("usr_id");
				}
				
				resultSet = dbAuthorityService.selectUsrDBSrvAutInfo(usr_id);	

			//}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB서버권한 업데이트
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateUsrDBSrvAutInfo.do")
	@ResponseBody
	public String updateUsrDBSrvAutInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		String result = "F";

		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000502");
				
		int cnt = 0; 
		
		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0037_01");
				historyVO.setMnu_id(15);
				accessHistoryService.insertHistory(historyVO);
	
				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));

				String scale_yn_chk = "";
				String trans_yn_chk ="";
				
				if (props.get("transfer") != null) {
					trans_yn_chk = props.get("transfer").toString();
				}
				if (props.get("scale") != null) {
					scale_yn_chk = props.get("scale").toString();
				}
						
				String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
				
				System.out.println(strRows);

				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
						
				for(int i=0; i<rows.size(); i++){
					JSONObject jval = null;
					cnt = dbAuthorityService.selectUsrDBSrvAutInfoCnt(rows.get(i));
					
					System.out.println(rows.get(i));
					
					jval = (JSONObject) rows.get(i);
					
					jval.put("scale_yn_chk", scale_yn_chk);
					jval.put("trans_yn_chk", trans_yn_chk);
					

					System.out.println("trans_yn_chk = " + jval.get("trans_yn_chk"));
					
					if(cnt==0){
						System.out.println("인서트");
						System.out.println(jval.get("transSetting_aut_yn"));
						dbAuthorityService.insertUsrDBSrvAutInfo(jval);
					}else{
						System.out.println("업데이트");
						
						if(jval.get("script_his_aut_yn") == null){
							jval.put("script_his_aut_yn", jval.get("_his_aut_yn"));
						}						
						
						if(jval.get("script_cng_aut_yn") == null){
							jval.put("script_cng_aut_yn", jval.get("_cng_aut_yn"));
						}
						
						System.out.println(jval.get("transSetting_aut_yn"));
						dbAuthorityService.updateUsrDBSrvAutInfo(jval);
					}			
				}
				
				result = "S";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectTreeDBSvrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectTreeDBSvrList(HttpServletRequest request) {
	
		List<Map<String, Object>> resultSet = null;
		try {		
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			resultSet = dbAuthorityService.selectTreeDBSvrList(usr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * scale yn check
	 * @param HttpServletRequest, HttpServletResponse 
	 * @return Map<String, Object>
	 */
	@RequestMapping("/selectServerScaleAuthInfo.do")
	public @ResponseBody Map<String, Object> selectScaleLChk(HttpServletRequest request, HttpServletResponse response) {	
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
			String scale_yn_chk = "";
			String transfer_ora_chk = "";
			
			if (props.get("scale") != null) {
				scale_yn_chk = props.get("scale").toString();
			}
			
			if (props.get("transfer_ora") != null) {
				transfer_ora_chk = props.get("transfer_ora").toString();
			}

			result.put("scale_yn_chk", scale_yn_chk);
			result.put("transfer_ora_chk", transfer_ora_chk);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
