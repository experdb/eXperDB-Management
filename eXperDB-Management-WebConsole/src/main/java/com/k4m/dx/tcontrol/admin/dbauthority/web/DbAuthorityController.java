package com.k4m.dx.tcontrol.admin.dbauthority.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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

/**
 * DB권한 관리 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.29   변승우  최초 생성
 *      </pre>
 */

@Controller
public class DbAuthorityController {
	
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
	 * DB권한관리 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbAuthority.do")
	public ModelAndView dbAuthority(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000503");
				
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0038");
				historyVO.setMnu_id(16);
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.setViewName("admin/dbAuthority/dbAuthority");
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
	@RequestMapping(value = "/selectDBAutUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000503");
				
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
	 * 디비 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDBAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectDBAutInfo(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000503");
				
		List<Map<String, Object>> resultSet = null;		
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				resultSet = dbAuthorityService.selectDBAutInfo();	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * 디비 유저 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectUsrDBAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectUsrDBAutInfo(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000503");
				
		List<Map<String, Object>> resultSet = null;		
		try {	
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				String usr_id ="";				
				if(request.getParameter("usr_id") == null){
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					usr_id = loginVo.getUsr_id();
				}else{
					usr_id = request.getParameter("usr_id");
				}
					resultSet = dbAuthorityService.selectUsrDBAutInfo(usr_id);	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	/**
	 * DB권한 업데이트
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateUsrDBAutInfo.do")
	@ResponseBody
	public void updateUsrDBAutInfo(@ModelAttribute("historyVO") HistoryVO historyVO,  HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000503");
				
		int cnt = 0;
		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}else{			
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0038_01");
				historyVO.setMnu_id(16);
				accessHistoryService.insertHistory(historyVO);
				
				String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
				
				for(int i=0; i<rows.size(); i++){
					cnt = dbAuthorityService.selectUsrDBAutInfoCnt(rows.get(i));
					
					if(cnt==0){
						dbAuthorityService.insertUsrDBAutInfo(rows.get(i));
					}else{
						dbAuthorityService.updateUsrDBAutInfo(rows.get(i));
					}						
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * DB권한 업데이트
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateServerDBAutInfo.do")
	@ResponseBody 
	public void updateServerDBAutInfo(HttpServletRequest request, HttpServletResponse response) {
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String usr_id = request.getParameter("usr_id");
			
			List<Map<String, Object>> resultSet = dbAuthorityService.selectDatabase(db_svr_id);
			
			if (resultSet != null) {
				for(int i=0; i<resultSet.size(); i++){	
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("db_id", resultSet.get(i));
					param.put("db_svr_id", db_svr_id);
					param.put("usr_id", usr_id);
					param.put("aut_yn", "Y");
					int cnt = dbAuthorityService.selectUsrDBAutInfoCnt(param);
					if(cnt==0){
						dbAuthorityService.insertUsrDBAutInfo(param);
					}else{
						dbAuthorityService.updateUsrDBAutInfo(param);
					}	
				}
			}
		} catch (Exception e) {
				e.printStackTrace();
		}
	}
}
