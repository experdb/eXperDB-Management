package com.k4m.dx.tcontrol.admin.usermanager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
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
			menuAut = cu.selectMenuAut(menuAuthorityService, "4");
			if(menuAut.get(0).get("read_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				
				// 사용자관리 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0031");
				accessHistoryService.insertHistory(historyVO);
				
				mv.setViewName("admin/userManager/userManager");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
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
		List<UserVO> result = null;
		try {
			String act = request.getParameter("act");
			CmmnUtils.saveHistory(request, historyVO);
			
			if(act.equals("i")){
				// 사용자등록 화면 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0032");
				accessHistoryService.insertHistory(historyVO);			
			}

			if(act.equals("u")){
				// 사용자수정 화면 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0033");
				accessHistoryService.insertHistory(historyVO);
							
				String usr_id = request.getParameter("usr_id");
				result = userManagerService.selectDetailUserManager(usr_id);
				
				mv.addObject("get_usr_id",result.get(0).getUsr_id());
				mv.addObject("usr_nm",result.get(0).getUsr_nm());
				mv.addObject("pwd",result.get(0).getPwd());
				mv.addObject("bln_nm",result.get(0).getBln_nm());
				mv.addObject("dept_nm",result.get(0).getDept_nm());
				mv.addObject("pst_nm",result.get(0).getPst_nm());
				mv.addObject("rsp_bsn_nm",result.get(0).getRsp_bsn_nm());
				mv.addObject("cpn",result.get(0).getCpn());
				mv.addObject("use_yn",result.get(0).getUse_yn());	
				mv.addObject("aut_id",result.get(0).getAut_id());
				mv.addObject("usr_expr_dt",result.get(0).getUsr_expr_dt());
				
			}
			mv.addObject("act",act);
			mv.setViewName("popup/userManagerRegForm");
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
	public @ResponseBody void insertUserManager(@ModelAttribute("userVo") UserVO userVo,HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		try {		
			List<UserVO> result = null;
			
			// 사용자 등록 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0032_01");
			accessHistoryService.insertHistory(historyVO);
			
			//패스워드 암호화
			userVo.setPwd(SHA256.SHA256(userVo.getPwd()));
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			userVo.setFrst_regr_id(usr_id);
			userVo.setLst_mdfr_id(usr_id);
			
			userManagerService.insertUserManager(userVo);
			
			
			result = menuAuthorityService.selectMnuIdList();
			
			for(int i=0; i<result.size(); i++){
				userVo.setMnu_id(result.get(i).getMnu_id());
				menuAuthorityService.insertUsrmnuaut(userVo);
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
	public @ResponseBody void updateUserManager(@ModelAttribute("userVo") UserVO userVo,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {
		try {
			// 사용자 수정 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0033_01");
			accessHistoryService.insertHistory(historyVO);
			
			//패스워드 암호화
			userVo.setPwd(SHA256.SHA256(userVo.getPwd()));
			
			HttpSession session = request.getSession();
			String usr_id = (String)session.getAttribute("usr_id");
			userVo.setLst_mdfr_id(usr_id);
			
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
	 * 사용자 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectUserManager.do")
	public @ResponseBody List<UserVO> selectUserManager(HttpServletRequest request) {
		List<UserVO> resultSet = null;
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "4");
		
			//읽기권한이 있을경우
			if(menuAut.get(0).get("read_aut_yn").equals("Y")){
				
				String type=request.getParameter("type");
				String search = request.getParameter("search");
				String use_yn = request.getParameter("use_yn");
							
				param.put("type", type);
				param.put("search", search);
				param.put("use_yn", use_yn);
			
				resultSet = userManagerService.selectUserManager(param);	
			}else{
				return resultSet;
			}
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

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
	public @ResponseBody boolean deleteUserManager(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		try {
			String[] param = request.getParameter("usr_id").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				userManagerService.deleteUserManager(param[i]);
			}
			
			// 사용자관리 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0031_01");
			accessHistoryService.insertHistory(historyVO);
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
