package com.k4m.dx.tcontrol.mypage.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.SHA256;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.UserManagerServiceCall;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.mypage.service.MyPageService;

/**
 * Mypage 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.20   김주영 최초 생성
 *      </pre>
 */

@Controller
public class MypageController {

	@Autowired
	private MyPageService myPageService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private UserManagerService userManagerService;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;

	/**
	 * 개인정보수정 화면을 보여준다.
	 * 
	 * @param historyVO, userVo
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/myPage.do")
	public ModelAndView myPage(@ModelAttribute("historyVO") HistoryVO historyVO,@ModelAttribute("userVo") UserVO userVo,HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		List<UserVO> result = null;

		try {
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0048");
			historyVO.setMnu_id(22);
			accessHistoryService.insertHistory(historyVO);

			result = myPageService.selectDetailMyPage(usr_id);

			if (result != null) {
				mv.addObject("usr_id", usr_id);
				mv.addObject("usr_nm", result.get(0).getUsr_nm());
				mv.addObject("aut_id", result.get(0).getAut_id());
				mv.addObject("bln_nm", result.get(0).getBln_nm());
				mv.addObject("dept_nm", result.get(0).getDept_nm());
				mv.addObject("pst_nm", result.get(0).getPst_nm());
				mv.addObject("cpn", result.get(0).getCpn());
				mv.addObject("rsp_bsn_nm", result.get(0).getRsp_bsn_nm());
				mv.addObject("usr_expr_dt", result.get(0).getUsr_expr_dt());
				
				mv.addObject("encp_use_yn", result.get(0).getEncp_use_yn());
				mv.addObject("use_yn", result.get(0).getUse_yn());
			}

			mv.setViewName("mypage/myPage");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 개인정보수정
	 * 
	 * @param userVo
	 * @param historyVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateMypage.do")
	public @ResponseBody void updateMypage(@ModelAttribute("userVo") UserVO userVo,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			userVo.setLst_mdfr_id(usr_id);
			
			myPageService.updateMypage(userVo);
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0048_01");
			historyVO.setMnu_id(22);
			accessHistoryService.insertHistory(historyVO);
			
		} catch (Exception e) {
			txManager.rollback(status);
			e.printStackTrace();
			return;
		}finally{
			txManager.commit(status);
		}
	}

	/**
	 * 패스워드변경 팝업을 보여준다.
	 * 
	 * @param request
	 * @param historyVO
	 * @throws 
	 */
	@RequestMapping(value = "/popup/pwdRegForm.do")
	public ModelAndView connectorReg(HttpServletRequest request,@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0049");
			historyVO.setMnu_id(22);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 패스워드를 체크한다.
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/checkPwd.do")
	public @ResponseBody boolean checkPwd(HttpServletRequest request) {
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			String salt_value = "";
			/*AES256 aes = new AES256(AES256_KEY.ENC_KEY);*/
			/*sha-256 암호화 변경 2020-11-26 */

			UserVO userInfoHd = (UserVO) userManagerService.selectDetailUserManagerHd(usr_id);
			if (userInfoHd != null){
				if (!"".equals(userInfoHd.getSalt_value())) {
					salt_value = userInfoHd.getSalt_value();
				} 
			}

			if (salt_value == null || "".equals(salt_value)) {
				salt_value = SHA256.getSalt();
			}

			String nowpwd = SHA256.setSHA256(request.getParameter("nowpwd"), salt_value);
			
			param.put("usr_id", usr_id);
			param.put("nowpwd", nowpwd);
			
			List<Map<String, Object>> list = myPageService.selectPwd(param);
			if(list.size()==1){
				return true;
			}else{
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 패스워드를 변경한다.
	 * 
	 * @param userVo
	 * @param historyVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePwd.do")
	public @ResponseBody JSONObject updatePwd(@ModelAttribute("userVo") UserVO userVo,@ModelAttribute("historyVO") HistoryVO historyVO,HttpServletRequest request) {
		JSONObject result = new JSONObject();
		UserManagerServiceCall uic= new UserManagerServiceCall();
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		try {
			String strTocken = loginVo.getTockenValue();
			String loginId = loginVo.getUsr_id();
			String entityId = loginVo.getEctityUid();	
			String encp_use_yn = loginVo.getEncp_use_yn();
			String password = userVo.getPwd();
			String salt_value = "";

			if(encp_use_yn.equals("Y") && (strTocken != null && !"".equals(strTocken)) && (entityId !=null && !"".equals(entityId))){
				String restIp = loginVo.getRestIp();
				int restPort = loginVo.getRestPort();

				try{
					result = uic.updatePassword(restIp, restPort, strTocken, loginId, entityId, password);
				}catch(Exception e){
					result.put("resultCode", "8000000002");
				}
			} else {
				result.put("resultCode", "0000000000");
			}
			
			if(result.get("resultCode").equals("0000000000")){
				String usr_id = loginVo.getUsr_id();
				userVo.setUsr_id(usr_id);
				userVo.setLst_mdfr_id(usr_id);
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				/*sha-256 암호화 변경 2020-11-26 */

				UserVO userInfoHd = (UserVO) userManagerService.selectDetailUserManagerHd(request.getParameter("nowpwd"));
				if (userInfoHd != null){
					if (!"".equals(userInfoHd.getSalt_value())) {
						salt_value = userInfoHd.getSalt_value();
					} 
				}

				if (salt_value == null || "".equals(salt_value)) {
					salt_value = SHA256.getSalt();
				}

				userVo.setPwd(SHA256.setSHA256(userVo.getPwd(), salt_value));
				myPageService.updatePwd(userVo);

				userVo.setPwd(aes.aesEncode(password));
				userVo.setSalt_value(salt_value); // 패스워드 salt_value setting

				myPageService.updateTranPwd(userVo);
			}
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0049_01");
			historyVO.setMnu_id(22);
			accessHistoryService.insertHistory(historyVO);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}