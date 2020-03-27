package com.k4m.dx.tcontrol.scale.web;

import java.io.FileNotFoundException;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleService;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;

/**
* @author 
* @see aws scale 관련 화면 controller
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
@Controller
public class InstanceScaleController {
	
	@Autowired
	private DbAuthorityService dbAuthorityService; //유저 DB서버권한

	@Autowired
	private InstanceScaleService instanceScaleService;

	private List<Map<String, Object>> dbSvrAut;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	/**
	 * SCale List View page
	 * @param WorkVO
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/scale/scaleList.do")
	public ModelAndView scaleList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String dtlCd = "DX-T0056";

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);

		ModelAndView mv = new ModelAndView();

		if(dbSvrAut.get(0).get("scale_yn").equals("N")){
			mv.setViewName("error/autError");
		}else{
			try {
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				mv.setViewName("scale/experdbScale");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		return mv;
	}

	/**
	 * scale 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/scale/selectScaleList.do")
	public @ResponseBody JSONObject selectScaleList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) throws Exception {
		JSONObject result = new JSONObject();
		String dtlCd = "DX-T0056_01";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			result = instanceScaleService.instanceListSetting(instanceScaleVO);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return result;
	}	
	
	
	/**
	 * scale chkeck
	 * 
	 * @return resultSet
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 * @throws Exception
	 */
	@RequestMapping(value = "/scale/selectScaleLChk.do")
	public @ResponseBody Map<String, Object> selectScaleLChk(HttpServletRequest request, HttpServletResponse response) {	
		Map<String, Object> result = new JSONObject();

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService,db_svr_id);

		ModelAndView mv = new ModelAndView();
		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("scale_yn").equals("N")){
			mv.setViewName("error/autError");	
		}else{
			try {
				//scale log 확인
				result = (Map<String, Object>)instanceScaleService.scaleSetResult(request);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * scaleInOutSet
	 * @param 
	 * @return ModelAndView
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/scale/scaleInOutSet.do")
	public Map<String, Object> scaleInOutSet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		Map<String, Object> result = null;
		Map<String, Object> param = new HashMap<String, Object>();
	
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		String scaleGbn = request.getParameter("scaleGbn");	
		String dtlCd = "";
		if ("scaleIn".equals(scaleGbn)) {
			dtlCd = "DX-T0056_02";
		} else {
			dtlCd = "DX-T0056_03";
		}

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			//scale 실행
			param.put("scale_gbn", scaleGbn);
			param.put("login_id", (String)loginVo.getUsr_id());
			result = (Map<String, Object>)instanceScaleService.scaleInOutSet(historyVO, param);
		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * scale 상세 정보
	 * @param 
	 * @return resultSet
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectScaleInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectScaleInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO) throws FileNotFoundException, IOException {
		List<Map<String, Object>> result = null;
		String dtlCd = "DX-T0056_04";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			result = instanceScaleService.instanceInfoListSetting(instanceScaleVO);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * securityGroupShowView page
	 * @param 
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/scale/securityGroupShowView.do")
	public ModelAndView securityGroupShowView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
	
		ModelAndView mv = new ModelAndView();

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String scale_id = request.getParameter("scale_id");
		 			
		mv.addObject("db_svr_id",db_svr_id);
		mv.addObject("scale_id",scale_id);
		mv.setViewName("popup/scaleSecurityGroupShow");
		
		return mv;
	}
	
	/**
	 * scale 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/scale/securityGroupList.do")
	public @ResponseBody JSONObject securityGroupList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) throws Exception {
		JSONObject result = new JSONObject();
		String dtlCd = "DX-T0056_05";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			result = instanceScaleService.instanceSecurityListSetting(instanceScaleVO);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
}
