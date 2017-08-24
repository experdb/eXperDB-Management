package com.k4m.dx.tcontrol.admin.dbauthority.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.k4m.dx.tcontrol.admin.usermanager.service.UserManagerService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
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
	private AccessHistoryService accessHistoryService;

	@Autowired
	private UserManagerService userManagerService;
	
	@Autowired
	private DbAuthorityService dbAuthorityService;
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
		ModelAndView mv = new ModelAndView();
		try {
			// DB권한관리 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0035");
			accessHistoryService.insertHistory(historyVO);
				
			mv.setViewName("admin/dbAuthority/dbAuthority");
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
	 * 서버 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDBSrvAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectDBSrvAutInfo(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;
		
		try {	
				resultSet = dbAuthorityService.selectSvrList();
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
	public @ResponseBody List<Map<String, Object>> selectUsrDBSrvAutInfo(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;
		
		String usr_id ="";
		
		if(request.getParameter("usr_id") == null){
			usr_id = (String) request.getSession().getAttribute("usr_id");
		}else{
			usr_id = request.getParameter("usr_id");
		}
		try {	
				resultSet = dbAuthorityService.selectUsrDBSrvAutInfo(usr_id);	
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
	public void updateUsrDBSrvAutInfo(HttpServletRequest request) {
		int cnt = 0; 
		
		try {
			String strRows = request.getParameter("datasArr").toString().replaceAll("&quot;", "\"");
			JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
					
			for(int i=0; i<rows.size(); i++){
				cnt = dbAuthorityService.selectUsrDBSrvAutInfoCnt(rows.get(i));
				
				if(cnt==0){
					dbAuthorityService.insertUsrDBSrvAutInfo(rows.get(i));
				}else{
					dbAuthorityService.updateUsrDBSrvAutInfo(rows.get(i));
				}			
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 디비 권한정보를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDBAutInfo.do")
	public @ResponseBody List<Map<String, Object>> selectDBAutInfo(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;		
		try {	
			resultSet = dbAuthorityService.selectDBAutInfo();	
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
	public @ResponseBody List<Map<String, Object>> selectUsrDBAutInfo(HttpServletRequest request) {
		List<Map<String, Object>> resultSet = null;		
		try {	
			String usr_id ="";
			
			if(request.getParameter("usr_id") == null){
				usr_id = (String) request.getSession().getAttribute("usr_id");
			}else{
				usr_id = request.getParameter("usr_id");
			}
				resultSet = dbAuthorityService.selectUsrDBAutInfo(usr_id);	
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
	public void updateUsrDBAutInfo(HttpServletRequest request) {
		int cnt = 0;
		try {
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

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
