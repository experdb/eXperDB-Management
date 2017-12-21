package com.k4m.dx.tcontrol.admin.usermanager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.SHA256;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;

/**
 * 사용자 관리 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.25   김주영 최초 생성
 *      </pre>
 */

@Controller
public class UserManagerController {
	
	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
	
	@Autowired
	private UserManagerService userManagerService;

	@Autowired
	private AccessHistoryService accessHistoryService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * 사용자관리 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/userManager.do")
	public ModelAndView userManager(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0033");
				historyVO.setMnu_id(12);
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("admin/userManager/userManager");
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
	@RequestMapping(value = "/selectUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request,HttpServletResponse response) {
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				response.sendRedirect("/autError.do.do");
				return resultSet;
			}
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0033_01");
			historyVO.setMnu_id(12);
			accessHistoryService.insertHistory(historyVO);
			
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
	 * 사용자 등록/수정 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/userManagerRegForm.do")
	public ModelAndView userManagerForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				String act = request.getParameter("act");
				CmmnUtils.saveHistory(request, historyVO);
				
				if(act.equals("i")){
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0034");
					historyVO.setMnu_id(12);
					accessHistoryService.insertHistory(historyVO);			
				}

				if(act.equals("u")){
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0035");
					historyVO.setMnu_id(12);
					accessHistoryService.insertHistory(historyVO);
								
					String usr_id = request.getParameter("usr_id");
					UserVO result= (UserVO)userManagerService.selectDetailUserManager(usr_id);
					
					mv.addObject("get_usr_id",result.getUsr_id());
					mv.addObject("get_usr_nm",result.getUsr_nm());
					mv.addObject("pwd",result.getPwd());
					mv.addObject("bln_nm",result.getBln_nm());
					mv.addObject("dept_nm",result.getDept_nm());
					mv.addObject("pst_nm",result.getPst_nm());
					mv.addObject("rsp_bsn_nm",result.getRsp_bsn_nm());
					mv.addObject("cpn",result.getCpn());
					mv.addObject("use_yn",result.getUse_yn());	
					mv.addObject("aut_id",result.getAut_id());
					mv.addObject("usr_expr_dt",result.getUsr_expr_dt());
					
				}
				mv.addObject("act",act);
				mv.setViewName("popup/userManagerRegForm");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
   
	}

	
	/**
	 * 사용자를 등록한다.
	 * 
	 * @param userVo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertUserManager.do")
	public @ResponseBody void insertUserManager(@ModelAttribute("userVo") UserVO userVo,HttpServletRequest request,HttpServletResponse response,@ModelAttribute("historyVO") HistoryVO historyVO) {
			List<UserVO> result = null;
		try {		
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			
			//쓰기권한이 없는경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0034_01");
			historyVO.setMnu_id(12);
			accessHistoryService.insertHistory(historyVO);
			
			//패스워드 암호화
			userVo.setPwd(SHA256.SHA256(userVo.getPwd()));
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			userVo.setFrst_regr_id(usr_id);
			userVo.setLst_mdfr_id(usr_id);
			
			if(userVo.getUsr_expr_dt() ==null | userVo.getUsr_expr_dt().equals("")){
				userVo.setUsr_expr_dt("20990101");
			}else{
				userVo.setUsr_expr_dt(userVo.getUsr_expr_dt().replace("-", ""));
			}
			
			userManagerService.insertUserManager(userVo);
			
			
			// 메뉴 권한 초기등록
			result = menuAuthorityService.selectMnuIdList();
			
			for(int i=0; i<result.size(); i++){
				userVo.setMnu_id(result.get(i).getMnu_id());
				menuAuthorityService.insertUsrmnuaut(userVo);
			}
			
			
			// 유저디비서버 권한 초기등록
			List<Map<String, Object>>  severList = null;
			severList = dbAuthorityService.selectSvrList();
			for(int j=0; j<severList.size(); j++){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", userVo.getUsr_id());
				param.put("usr_id", usr_id);
				param.put("db_svr_id", severList.get(j).get("db_svr_id"));
				dbAuthorityService.insertUsrDbSvrAut(param);
			}
					
			// 유저디비 권한 초기등록
			List<Map<String, Object>>  dbList = null;
			dbList = dbAuthorityService.selectDBList();
			for(int k=0; k<dbList.size(); k++){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", userVo.getUsr_id());
				param.put("usr_id", usr_id);
				param.put("db_svr_id", dbList.get(k).get("db_svr_id"));
				param.put("db_id", dbList.get(k).get("db_id"));
				dbAuthorityService.insertUsrDbAut(param);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 사용자를 수정한다.
	 * 
	 * @param userVo
	 * @param historyVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateUserManager.do")
	public @ResponseBody void updateUserManager(@ModelAttribute("userVo") UserVO userVo,HttpServletResponse response,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			//쓰기권한이 없는경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0035_01");
			historyVO.setMnu_id(12);
			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			userVo.setLst_mdfr_id(usr_id);
			UserVO userInfo= (UserVO)userManagerService.selectDetailUserManager(userVo.getUsr_id());
			if(userInfo.getPwd().equals(userVo.getPwd())){
				userVo.setPwd(userVo.getPwd());
			}else{
				//패스워드 암호화
				userVo.setPwd(SHA256.SHA256(userVo.getPwd()));
			}
			userVo.setUsr_expr_dt(userVo.getUsr_expr_dt().replace("-", ""));
	
			userManagerService.updateUserManager(userVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 중복 아이디를 체크한다.
	 * 
	 * @param usr_id
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/UserManagerIdCheck.do")
	public @ResponseBody String UserManagerIdCheck(@RequestParam("usr_id") String usr_id) {
		try {
			int resultSet = userManagerService.userManagerIdCheck(usr_id);
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
	 * 사용자를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteUserManager.do")
	public @ResponseBody boolean deleteUserManager(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		try {	
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			
			//쓰기권한이 없는경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return false;
			}
			
			String[] param = request.getParameter("usr_id").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				menuAuthorityService.deleteMenuAuthority(param[i]);
				dbAuthorityService.deleteDbSvrAuthority(param[i]);
				dbAuthorityService.deleteDbAuthority(param[i]);
				userManagerService.deleteUserManager(param[i]);
			}

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0033_02");
			historyVO.setMnu_id(12);
			accessHistoryService.insertHistory(historyVO);
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
