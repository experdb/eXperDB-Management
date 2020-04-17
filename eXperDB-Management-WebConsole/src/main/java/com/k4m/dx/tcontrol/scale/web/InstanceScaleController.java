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
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
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
@RequestMapping("/scale")
public class InstanceScaleController {
	
	@Autowired
	private DbAuthorityService dbAuthorityService; //유저 DB서버권한

	@Autowired
	private InstanceScaleService instanceScaleService;

	private List<Map<String, Object>> dbSvrAut;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;

	/**
	 * SCale List View page
	 * @param HistoryVO, HttpServletRequest
	 * @return ModelAndView
	 * @throws
	 */
	@RequestMapping("/scaleList.do")
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
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				mv.addObject("login_id", (String)loginVo.getUsr_id());
				
				mv.setViewName("scale/experdbScale");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		return mv;
	}

	/**
	 * scale 리스트를 조회한다.
	 * @param HistoryVO, InstanceScaleVO, HttpServletRequest
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping("/selectScaleList.do")
	public @ResponseBody JSONObject selectScaleList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		JSONObject result = new JSONObject();
		String dtlCd = "DX-T0056_01";

		try {
			instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());
			
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
	 * scale 상세 정보
	 * @param HttpServletRequest, HistoryVO, InstanceScaleVO
	 * @return List<Map<String, Object>>
	 * @throws IOException 
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/selectScaleInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectScaleInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO) throws FileNotFoundException, IOException {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		List<Map<String, Object>> result = null;
		String dtlCd = "DX-T0056_04";

		try {
			instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());
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
	 * scale chkeck
	 * @param HttpServletRequest, HttpServletResponse 
	 * @return Map<String, Object>
	 */
	@RequestMapping("/selectScaleLChk.do")
	public @ResponseBody Map<String, Object> selectScaleLChk(HttpServletRequest request, HttpServletResponse response) {	
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		InstanceScaleVO instanceScaleVO = new InstanceScaleVO();
		Map<String, Object> result = new JSONObject();

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		instanceScaleVO.setDb_svr_id(db_svr_id);
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

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
				result = (Map<String, Object>)instanceScaleService.scaleSetResult(instanceScaleVO);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * scaleInOutSet
	 * @param HistoryVO, HttpServletRequest
	 * @return Map<String, Object>
	 * @throws 
	 */
	@ResponseBody
	@RequestMapping("/scaleInOutSet.do")
	public Map<String, Object> scaleInOutSet(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		Map<String, Object> result = null;
		Map<String, Object> param = new HashMap<String, Object>();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		String scaleSet = request.getParameter("scaleSet");	
		String dtlCd = "";
		if ("scaleIn".equals(scaleSet)) {
			dtlCd = "DX-T0056_02";
		} else {
			dtlCd = "DX-T0056_03";
		}

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			//scale 실행
			param.put("scale_set", scaleSet);
			param.put("login_id", (String)loginVo.getUsr_id());
			param.put("db_svr_id", db_svr_id);

			result = (Map<String, Object>)instanceScaleService.scaleInOutSet(historyVO, param);
		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * securityGroupShowView page
	 * @param HistoryVO, HttpServletRequest
	 * @return ModelAndView
	 * @throws 
	 */
	@RequestMapping("/securityGroupShowView.do")
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
	 * @param HistoryVO, InstanceScaleVO, HttpServletRequest
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping("/securityGroupList.do")
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
	
	/**
	 * Scale Log View page
	 * @param HistoryVO, InstanceScaleVO, HttpServletRequest
	 * @return ModelAndView
	 */
	@RequestMapping("/scaleLogList.do")
	public ModelAndView rmanLogList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id = instanceScaleVO.getDb_svr_id();

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("scale_hist_yn").equals("N")){
			mv.setViewName("error/autError");
		} else {
			try {
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				
				String dtlCd = "DX-T0057";
				
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
				
				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				mv.addObject("login_id", (String)loginVo.getUsr_id());
				
				//작업유형 공통코드 조회
				PageVO pageVO = new PageVO();
				
				pageVO.setGrp_cd("TC0033");
				pageVO.setSearchCondition("0");
				List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("wrkTypeList",cmmnCodeVO);
				
				//실행유형
				pageVO.setGrp_cd("TC0034");
				pageVO.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("executeTypeList",cmmnCodeVO);
				
				//정책유형
				pageVO.setGrp_cd("TC0035");
				pageVO.setSearchCondition("0");
				cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("policyTypeList",cmmnCodeVO);

				mv.setViewName("scale/experdbScaleHistory");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}

		return mv;	
	}
	
	/**
	 * scale Log List 조회
	 * @param InstanceScaleVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	@RequestMapping("/selectScaleHistoryList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScaleHistoryList(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		String histGbn= (String)instanceScaleVO.getHist_gbn();

		List<Map<String, Object>> result = null;	
		String dtlCd = "";
		
		if (histGbn.equals("execute_hist")) {
			dtlCd = "DX-T0057_01";
		} else {
			dtlCd = "DX-T0057_02";
		}

		try {
			instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			result = instanceScaleService.selectScaleHistoryList(instanceScaleVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
}
