package com.k4m.dx.tcontrol.scale.web;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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

import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
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

	@Autowired
	private PlatformTransactionManager txManager;
	
	/**
	 * aws 설치여부 체크
	 * @param HttpServletRequest, HttpServletResponse 
	 * @return Map<String, Object>
	 */
	@RequestMapping("/selectScaleInstallChk.do")
	public @ResponseBody Map<String, Object> selectScaleInstallChk(HttpServletRequest request, HttpServletResponse response) {	
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
		if(dbSvrAut.get(0).get("scale_aut_yn").equals("N")){
			mv.setViewName("error/autError");	
		}else{
			try {
				//scale log 확인
				result = (Map<String, Object>)instanceScaleService.scaleInstallChk(instanceScaleVO);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

		return result;
	}

	/**
	 * Scale Setting View page
	 * @param HistoryVO, InstanceScaleVO, HttpServletRequest
	 * @return ModelAndView
	 */
	@RequestMapping("/scaleManagement.do")
	public ModelAndView scaleManagement(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id = instanceScaleVO.getDb_svr_id();

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("scale_cng_aut_yn").equals("N")){
			mv.setViewName("error/autError");
		} else {
			try {
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				
				String dtlCd = "DX-T0058";
				
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
				
				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				mv.addObject("login_id", (String)loginVo.getUsr_id());
				
				//작업유형 공통코드 조회
				PageVO pageVO = new PageVO();
				List<CmmnCodeVO> cmmnCodeVO =  null;

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

				mv.setViewName("scale/experdbScaleCngList");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}

		return mv;	
	}

	/**
	 * Scale Auto Setting List 조회
	 * @param WorkVO
	 * @return List<WorkVO>
	 */
	@RequestMapping("/selectScaleCngList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScriptList(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO,HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<Map<String, Object>> result = null;
		
		String dtlCd = "DX-T0058_01";
		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			
			result = instanceScaleService.selectScaleCngList(instanceScaleVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * scale 설정 정보 상세조회
	 * @param  request
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectAutoScaleCngInfo.do")
	@ResponseBody
	public Map<String, Object> selectAutoScaleCngInfo(HttpServletRequest request, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO) {
		Map<String, Object> result = null;

		try {
			result = instanceScaleService.selectAutoScaleCngInfo(instanceScaleVO);	
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
		if(dbSvrAut.get(0).get("scale_aut_yn").equals("N")){
			mv.setViewName("error/autError");	
		}else{
			try {
				//scale log 확인
				result = (Map<String, Object>)instanceScaleService.scaleSetResult(instanceScaleVO);
			} catch (Exception e1) {
				System.out.println("================123123===========");
				
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

		return result;
	}
	
	/**
	 * Auto scale setting Registration View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@RequestMapping("/selectAutoScaleComCngInfo.do")
	@ResponseBody
	public Map<String, Object> selectAutoScaleComCngInfo(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = null;

		String dtlCd = "DX-T0061";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			
			result = instanceScaleService.selectAutoScaleComCngInfo(instanceScaleVO);	
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;	
	}

	/**
	 * Auto scale common setting update
	 * @param 
	 * @return
	 */
	@RequestMapping("/popup/scaleComCngWrite.do")
	@ResponseBody
	public String scaleComCngWrite(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

		//중복체크 flag 값
		String result = "S";
		String dtlCd = "DX-T0061_01";

		try {
			//저장 process
			result = instanceScaleService.updateAutoScaleCommonSetting(instanceScaleVO);

			//저장 완료시
			if ("S".equals(result)) {
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * Auto scale setting Registration View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@RequestMapping("/popup/scaleAutoRegForm.do")
	@ResponseBody
	public Map<String, Object> scaleAutoRegForm(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		String dtlCd = "DX-T0059";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			
			result = instanceScaleService.scaleInstallList(instanceScaleVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;	
	}
	
	/**
	 * Auto scale setting insert
	 * @param 
	 * @return
	 */
	@RequestMapping("/popup/scaleCngWrite.do")
	@ResponseBody
	public String scaleCngWrite(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

		//중복체크 flag 값
		String result = "S";
		String dtlCd = "DX-T0059_01";
		try {
			//저장 process
			result = instanceScaleService.insertAutoScaleSetting(instanceScaleVO);

			//저장 완료시
			if ("S".equals(result)) {
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * scale 설정 정보 delete
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/scaleWrkIdDelete.do")
	@ResponseBody
	public String scaleWrkIdDelete(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());	

		String result = "S";
		String dtlCd = "DX-T0058_02";
	
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		try{
			String wrk_id_Rows = request.getParameter("wrk_id_List").toString().replaceAll("&quot;", "\"");
			
			if (!"".equals(wrk_id_Rows)) {
				instanceScaleVO.setWrk_id_Rows(wrk_id_Rows);

				result = instanceScaleService.deleteAutoScaleSetting(instanceScaleVO);
			} else {
				result = "P";
			}
			
			//저장 완료시
			if ("S".equals(result)) {
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			}
			
			return result;
			
		} catch(Exception e){
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
		
		return result;
	}	

	/**
	 * Auto scale setting Modify View page
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@RequestMapping("/popup/scaleAutoReregForm.do")
	@ResponseBody
	public Map<String, Object> scaleAutoReregForm(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		String dtlCd = "DX-T0060";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);

			result = instanceScaleService.scaleInstallList(instanceScaleVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;	
	}

	/**
	 * Auto scale setting update
	 * @param 
	 * @return
	 */
	@RequestMapping("/popup/scaleCngUpdate.do")
	@ResponseBody
	public String scaleCngUpdate(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

		//중복체크 flag 값
		String result = "S";
		String dtlCd = "DX-T0060_01";
		try {
			//저장 process
			result = instanceScaleService.updateAutoScaleSetting(instanceScaleVO);

			//저장 완료시
			if ("S".equals(result)) {
				// 화면접근이력 이력 남기기
				instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
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
	public ModelAndView scaleLogList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id = instanceScaleVO.getDb_svr_id();

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);

		//읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if(dbSvrAut.get(0).get("scale_hist_aut_yn").equals("N")){
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
	
	/**
	 * scale 실행이력 상세정보 조회
	 * @param  request
	 * @return result
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectScaleWrkInfo.do")
	@ResponseBody
	public Map<String, Object> selectScaleWrkInfo(HttpServletRequest request, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO) {
		Map<String, Object> result = null;
		
		try {
			result = instanceScaleService.selectScaleWrkInfo(instanceScaleVO);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * scale 실패 이력정보
	 * @param  request, instanceScaleVO
	 * @return result
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectScaleWrkErrorMsg.do")
	@ResponseBody
	public Map<String, Object> selectScaleWrkErrorMsg(HttpServletRequest request, @ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO) {
		Map<String, Object> result = null;
		
		try {	
			result = instanceScaleService.selectScaleWrkErrorMsg(instanceScaleVO);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

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

		if(dbSvrAut.get(0).get("scale_aut_yn").equals("N")){
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
	 * scale 실행 팝업
	 * @param WorkVO
	 * @return ModelAndView
	 */
	@RequestMapping("/popup/scaleInOutCountForm.do")
	@ResponseBody
	public Map<String, Object> scaleInOutCountForm(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		String dtlCd = "DX-T0056_06";

		try {
			// 화면접근이력 이력 남기기
			instanceScaleService.scaleSaveHistory(request, historyVO, dtlCd);
			
			result.put("db_svr_id", instanceScaleVO.getDb_svr_id());
			result.put("title_gbn", instanceScaleVO.getTitle_gbn());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
		int scale_count = Integer.parseInt(request.getParameter("scale_count"));
				
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
			param.put("scale_count", scale_count);

			result = (Map<String, Object>)instanceScaleService.scaleInOutSet(historyVO, param);
		} catch (Exception e) {
			result.put("RESULT", "FAIL");
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 사용여부 수정
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/scaleCngUseUpdate.do")
	@ResponseBody
	public String scaleCngUseUpdate(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletResponse response, HttpServletRequest request) {
		String result = "fail";

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		instanceScaleVO.setLogin_id((String)loginVo.getUsr_id());

		try {					
			//저장 process
			result = instanceScaleService.updateAutoScaleUseSetting(instanceScaleVO);
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 선택 사용여부 수정
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/scaleTotCngUseUpdate.do")
	@ResponseBody
	public String scaleTotCngUseUpdate(@ModelAttribute("instanceScaleVO") InstanceScaleVO instanceScaleVO, HttpServletResponse response, HttpServletRequest request) {
		String result = "fail";

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		String use_gbn = request.getParameter("use_gbn").toString();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		
		String wrk_id_Rows = "";
		JSONArray wrk_ids = null;
		
		String result_code = "";
		int sucCnt = 0;
	
		Map<String, Object> connStartResult = new  HashMap<String, Object>();
		
		try {			
			if (request.getParameter("wrk_id_List") != null) {
				wrk_id_Rows = request.getParameter("wrk_id_List").toString().replaceAll("&quot;", "\"");
				wrk_ids = (JSONArray) new JSONParser().parse(wrk_id_Rows);
			}
			
			if (wrk_ids != null && wrk_ids.size() > 0) {
				for(int i=0; i<wrk_ids.size(); i++){
					String resultSs = "fail";
					InstanceScaleVO instanceScaleVOPrm = new InstanceScaleVO();

					String wrk_id = wrk_ids.get(i).toString();
					
					instanceScaleVOPrm.setDb_svr_id(db_svr_id);
					instanceScaleVOPrm.setWrk_id(wrk_id);
					instanceScaleVOPrm.setLogin_id((String)loginVo.getUsr_id());
					
					if ("active".equals(use_gbn)) {
						instanceScaleVOPrm.setUseyn("Y");
					} else {
						instanceScaleVOPrm.setUseyn("N");
					}

					resultSs = instanceScaleService.updateAutoScaleUseSetting(instanceScaleVOPrm);
					
					if (resultSs != null && "success".equals(resultSs)) {
						sucCnt = sucCnt + 1;
					}
				}

				if (sucCnt == wrk_ids.size() ) {
					result = "success";
				} else {
					result = "fail";
				}
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}

		return result;
	}
}