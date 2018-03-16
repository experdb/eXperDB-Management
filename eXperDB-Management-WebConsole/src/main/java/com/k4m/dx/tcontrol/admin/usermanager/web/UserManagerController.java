package com.k4m.dx.tcontrol.admin.usermanager.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
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
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.UserManagerServiceCall;
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
				response.sendRedirect("/autError.do");
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
			String encp_use_yn = request.getParameter("encp_use_yn");
						
			param.put("type", type);
			param.put("search", search);
			param.put("use_yn", use_yn);
			param.put("encp_use_yn", encp_use_yn);
		
			resultSet = userManagerService.selectUserManager(param);	

		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	/**
	 * 사용자 등록 화면을 보여준다.
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
				CmmnUtils.saveHistory(request, historyVO);

				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0034");
				historyVO.setMnu_id(12);
				accessHistoryService.insertHistory(historyVO);			
				
				HttpSession session = request.getSession();
				String strTocken = (String)session.getAttribute("tockenValue");
				String entityId = (String)session.getAttribute("ectityUid");
				String encp_use_yn = (String)session.getAttribute("encp_use_yn");
			
				if(encp_use_yn.equals("Y") && strTocken != null && entityId !=null){
					mv.addObject("encp_yn", encp_use_yn);
				}
				mv.setViewName("popup/userManagerRegForm");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 사용자 수정 화면을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/userManagerRegReForm.do")
	public ModelAndView userManagerRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				mv.setViewName("error/autError");
			}else{
				CmmnUtils.saveHistory(request, historyVO);

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
				mv.addObject("encp_use_yn",result.getEncp_use_yn());
				mv.addObject("aut_id",result.getAut_id());
				mv.addObject("usr_expr_dt",result.getUsr_expr_dt());
				
				HttpSession session = request.getSession();
				String strTocken = (String)session.getAttribute("tockenValue");
				String entityId = (String)session.getAttribute("ectityUid");
				String encp_use_yn = (String)session.getAttribute("encp_use_yn");	
			
				if(encp_use_yn.equals("Y") && strTocken != null && entityId !=null){
					mv.addObject("encp_yn", encp_use_yn);
				}
				mv.setViewName("popup/userManagerRegReForm");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
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
				return "false"; // 중복값이 존재함.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}
	
	/**
	 * 사용자를 등록한다.
	 * 
	 * @param userVo
	 * @param request
	 * @return 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertUserManager.do")
	public @ResponseBody JSONObject insertUserManager(@ModelAttribute("userVo") UserVO userVo,HttpServletRequest request,HttpServletResponse response,@ModelAttribute("historyVO") HistoryVO historyVO) {
			List<UserVO> result = null;
			UserManagerServiceCall uic= new UserManagerServiceCall();
			JSONObject results = new JSONObject();
			
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
			
			String password = userVo.getPwd();
			HttpSession session = request.getSession();
			
			//암호화 사용자 등록
			String strTocken = (String)session.getAttribute("tockenValue");
			String loginId = (String)session.getAttribute("usr_id");
			String entityId = (String)session.getAttribute("ectityUid");
			String encp_use_yn = (String)session.getAttribute("encp_use_yn");
			
			if(userVo.getEncp_use_yn() == null){
				userVo.setEncp_use_yn("N");
			}
			
			if(userVo.getEncp_use_yn().equals("Y")){
				if(encp_use_yn.equals("Y") && strTocken != null && entityId !=null){
					String encp_yn = userVo.getEncp_use_yn();
					if(encp_yn.equals("Y")){
						String strUserId = userVo.getUsr_id();
						String entityname =userVo.getUsr_nm();
						String restIp = (String)session.getAttribute("restIp");
						int restPort = (int)session.getAttribute("restPort");
						results = uic.insertEntityWithPermission(restIp, restPort, strTocken, loginId, entityId, strUserId, password, entityname);
						if(!results.get("resultCode").equals("0000000000")){
							results.put("resultCode", results.get("resultCode"));
							results.put("resultMessage", results.get("resultMessage"));
							return results;
						}
					}
				}
			}
			
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			userVo.setPwd(aes.aesEncode(password)); //패스워드 암호화
			
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
			
			if(results.size()==0){
				results.put("resultCode", "0000000000");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return results;
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
	public @ResponseBody JSONObject updateUserManager(@ModelAttribute("userVo") UserVO userVo,HttpServletResponse response,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {
		CmmnUtils cu = new CmmnUtils();
		UserManagerServiceCall uic= new UserManagerServiceCall();
		JSONObject result = new JSONObject();
		try {
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
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				userVo.setPwd(aes.aesEncode(userVo.getPwd()));
			}

			String strTocken = (String)session.getAttribute("tockenValue");
			String loginId = (String)session.getAttribute("usr_id");
			String entityId = (String)session.getAttribute("ectityUid");	
			String encp_use_yn = (String)session.getAttribute("encp_use_yn");
			
			if(encp_use_yn.equals("Y") && strTocken != null && entityId !=null){
				String beforeEncrypyn = userInfo.getEncp_use_yn();
				String nowEncrypt = userVo.getEncp_use_yn();			
				String restIp = (String)session.getAttribute("restIp");
				int restPort = (int)session.getAttribute("restPort");
				
				if(!beforeEncrypyn.equals(nowEncrypt)){
					if(nowEncrypt.equals("Y")){
						String strUserId = userVo.getUsr_id();
						String entityname =userVo.getUsr_nm();
						AES256 aes = new AES256(AES256_KEY.ENC_KEY);
						String password = aes.aesDecode(userVo.getPwd());
						result = uic.insertEntityWithPermission(restIp, restPort, strTocken, loginId, entityId, strUserId, password, entityname);
						if(!result.get("resultCode").equals("0000000000")){
							result.put("resultCode", result.get("resultCode"));
							result.put("resultMessage", result.get("resultMessage"));
							return result;
						}
					}else if(nowEncrypt.equals("N")){
						JSONObject resultEntity = uic.selectEntityUid(restIp, restPort, strTocken, loginId, entityId, userVo.getUsr_id());
						if(!resultEntity.get("resultCode").equals("0000000000")){
							result.put("resultCode", resultEntity.get("resultCode"));
							result.put("resultMessage", resultEntity.get("resultMessage"));
							return result;
						}
						Map map = (Map) resultEntity.get("map");
						String entityUid=(String) map.get("entityUid");
						result = uic.deleteEntity(restIp, restPort, strTocken, loginId, entityId, entityUid);
						if(!result.get("resultCode").equals("0000000000")){
							result.put("resultCode", result.get("resultCode"));
							result.put("resultMessage", result.get("resultMessage"));
							return result;
						}
					}
				}
			}
			userVo.setUsr_expr_dt(userVo.getUsr_expr_dt().replace("-", ""));
			userManagerService.updateUserManager(userVo);
			
			if(result.size()==0){
				result.put("resultCode", "0000000000");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
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
	public @ResponseBody JSONObject deleteUserManager(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		UserManagerServiceCall uic= new UserManagerServiceCall();
		JSONObject result = new JSONObject();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			
			//쓰기권한이 없는경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
			}
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0033_02");
			historyVO.setMnu_id(12);
			accessHistoryService.insertHistory(historyVO);
			
			HttpSession session = request.getSession();
			String strTocken = (String)session.getAttribute("tockenValue");
			String loginId = (String)session.getAttribute("usr_id");
			String entityId = (String)session.getAttribute("ectityUid");
			String encp_use_yn = (String)session.getAttribute("encp_use_yn");
			
			String[] param = request.getParameter("usr_id").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				UserVO userDetail= (UserVO)userManagerService.selectDetailUserManager(param[i]);
				String getEncpUseyn = userDetail.getEncp_use_yn();
				if(getEncpUseyn.equals("Y")){
					if(encp_use_yn.equals("Y") && strTocken != null && entityId !=null){
						String restIp = (String)session.getAttribute("restIp");
						int restPort = (int)session.getAttribute("restPort");
						JSONObject resultEntity = uic.selectEntityUid(restIp, restPort, strTocken, loginId, entityId, param[i]);
						if(!resultEntity.get("resultCode").equals("0000000000")){
							result.put("resultCode", resultEntity.get("resultCode"));
							result.put("resultMessage", resultEntity.get("resultMessage"));
							return result;
						}
						Map map = (Map) resultEntity.get("map");
						String entityUid=(String) map.get("entityUid");
						result = uic.deleteEntity(restIp, restPort, strTocken, loginId, entityId, entityUid);
						if(!result.get("resultCode").equals("0000000000")){
							result.put("resultCode", result.get("resultCode"));
							result.put("resultMessage", result.get("resultMessage"));
							return result;
						}
					}else{
						//로그인 한 유저가 strTocken, entityId 가 없을 경우 삭제 막아야 함!
						result.put("resultCode", "에러");
						result.put("resultMessage", "에러");
						return result;
					}
				}
				menuAuthorityService.deleteMenuAuthority(param[i]);
				dbAuthorityService.deleteDbSvrAuthority(param[i]);
				dbAuthorityService.deleteDbAuthority(param[i]);
				userManagerService.deleteUserManager(param[i]);
			}
			if(result.size()==0){
				result.put("resultCode", "0000000000");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
