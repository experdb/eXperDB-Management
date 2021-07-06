package com.k4m.dx.tcontrol.admin.menuauthority.web;

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
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityVO;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
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
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		ModelAndView mv = new ModelAndView();
		try {
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0036");
				historyVO.setMnu_id(14);
				accessHistoryService.insertHistory(historyVO);
		
				String usr_id = request.getParameter("usr_id")==null?"":request.getParameter("usr_id");
				if(usr_id != null){
					mv.addObject("usr_id", usr_id);
				}
				 
				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
				String encrypt_useyn = props.get("encrypt.useyn").toString();		
				//백업 사용 여부 추가 2021-04-13 변승우
				String bnr_useyn = props.get("bnr.useyn").toString();		

			    /*proxy 메뉴사용 사용유무 추가 2021-04-23  */
				String proxy_menu_useyn = "";
				if (props.get("proxy.menu.useyn") != null) {
					proxy_menu_useyn = props.get("proxy.menu.useyn").toString(); 
				}

			    /*proxy 사용유무 추가 2021-04-23  */
				String proxy_useyn = "";
				if (props.get("proxy.useyn") != null) {
					proxy_useyn = props.get("proxy.useyn").toString(); 
				}
				
				mv.addObject("encrypt_useyn", encrypt_useyn);
				mv.addObject("bnr_useyn", bnr_useyn);
				mv.addObject("proxy_useyn", proxy_useyn);
				mv.addObject("proxy_menu_useyn", proxy_menu_useyn);
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));				
				mv.setViewName("admin/menuAuthority/menuAuthority");
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
	@RequestMapping(value = "/selectMenuAutUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
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
	 * 메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/menuAuthorityList.do")
	@ResponseBody
	public List<MenuAuthorityVO> menuAuthorityList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletRequest request, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		List<MenuAuthorityVO> resultSet = null;
		try {		
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			/*if(menuAut.get(0).get("read_aut_yn").equals("N")){
				System.out.println("@@@@@@@@@@@@@@@@@@@@");
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{*/
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				menuAuthorityVO.setUsr_id(usr_id);
				
				resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
			//}	
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
	public List<MenuAuthorityVO> selectUsrmnuautList(@ModelAttribute("userVo") UserVO userVo, @ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletResponse response) {
		
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");
				
		List<MenuAuthorityVO> resultSet = null;
		List<MenuAuthorityVO> addMenu = null;
		try {		
			//읽기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return resultSet;
			}else{
				
				addMenu=menuAuthorityService.selectAddMenu(menuAuthorityVO);
				
				//추가된 메뉴조회 하여, 있을경우 추가된 메뉴 권한 N, 등록
				if(addMenu.size() > 0){
					for(int i =0; i<addMenu.size(); i++){
						userVo.setMnu_id(addMenu.get(i).getMnu_id());
						menuAuthorityService.insertUsrmnuaut(userVo);
					}
				}
				
				resultSet = menuAuthorityService.selectUsrmnuautList(menuAuthorityVO);		
			}	
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
	public void updateUsrMnuAut(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		//해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000501");

		try {
			//쓰기 권한이 없는경우 에러페이지 호출 [추후 Exception 처리예정]
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}else{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0036_01");
				historyVO.setMnu_id(14);
				accessHistoryService.insertHistory(historyVO);
							
				String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
				
				for(int i=0; i<rows.size(); i++){
					JSONObject jsonObject = (JSONObject) rows.get(i);
					int mnu_id=menuAuthorityService.selectMenuId(jsonObject.get("mnu_cd").toString());			
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("mnu_id", mnu_id);
					param.put("usr_id", jsonObject.get("usr_id").toString());
					param.put("read_aut_yn", jsonObject.get("read_aut_yn").toString());
					param.put("wrt_aut_yn", jsonObject.get("wrt_aut_yn").toString());
					menuAuthorityService.updateUsrMnuAut(param);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 전송설정 메뉴권한정보 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/transferAuthorityList.do")
	@ResponseBody
	public List<MenuAuthorityVO> transferAuthorityList(@ModelAttribute("menuAuthorityVO") MenuAuthorityVO menuAuthorityVO, HttpServletRequest request, HttpServletResponse response) {
			
		List<MenuAuthorityVO> resultSet = null;
		try {		
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				
				menuAuthorityVO.setUsr_id(usr_id);
				
				resultSet = menuAuthorityService.transferAuthorityList(menuAuthorityVO);				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}	
}
