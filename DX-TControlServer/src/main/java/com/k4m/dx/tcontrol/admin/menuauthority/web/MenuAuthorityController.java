package com.k4m.dx.tcontrol.admin.menuauthority.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityVO;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

/**
 *메뉴권한관리 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.08.07   변승우 최초 생성
 *      </pre>
 */

@Controller
public class MenuAuthorityController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private UserManagerService userManagerService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 메뉴권한관리 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/menuAuthority.do")
	public ModelAndView menuAuthority(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 메뉴권한관리 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0034");
			accessHistoryService.insertHistory(historyVO);
	
			mv.setViewName("admin/menuAuthority/menuAuthority");
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
	@RequestMapping(value = "/selectMenuAutUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(HttpServletRequest request) {
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {	
				String type=request.getParameter("type");
				String search = request.getParameter("search");
				String use_yn = request.getParameter("use_yn");
							
				param.put("type", type);
				param.put("search", search);
				param.put("use_yn", use_yn);
			
				resultSet = userManagerService.selectUserManager(param);	

		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	
	/**
	 * 탑 메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/menuAuthorityList.do")
	@ResponseBody
	public List<MenuAuthorityVO> menuAuthorityList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletRequest request) {
		List<MenuAuthorityVO> resultSet = null;
		try {		
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			
			menuAuthorityVO.setUsr_id(usr_id);
			
			resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	
	
	
	/**
	 * 사용자메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectUsrmnuautList.do")
	@ResponseBody
	public List<MenuAuthorityVO> selectUsrmnuautList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO) {
		List<MenuAuthorityVO> resultSet = null;
		try {		
			resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	

	
	/**
	 * 메뉴권한 업데이트
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateUsrMnuAut.do")
	@ResponseBody
	public void updateUsrMnuAut(HttpServletRequest request) {

		try {
			String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
			
			for(int i=0; i<rows.size(); i++){
				menuAuthorityService.updateUsrMnuAut(rows.get(i));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
