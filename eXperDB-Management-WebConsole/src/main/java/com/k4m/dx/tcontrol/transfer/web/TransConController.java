package com.k4m.dx.tcontrol.transfer.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
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
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.transfer.TransferSchemaInfo;
import com.k4m.dx.tcontrol.transfer.service.TransConService;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransRegiVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailMappingVO;

/**
 * Trans connect 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  
 *      </pre>
 */
@Controller
public class TransConController {

	@Autowired
	private TransConService transConService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	private List<Map<String, Object>> menuAut;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;

	/**
	 * kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/kafkaConnectionTest.do")
	@ResponseBody
	public Map<String, Object> kafkaConnectionTest(HttpServletResponse response, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			String connect_gbn = String.valueOf(request.getParameter("connect_gbn"));
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("db_svr_id", db_svr_id);
			paramMap.put("connect_gbn", connect_gbn);
			
			if ("kafka".equals(connect_gbn)) {
				String kafkaIp = request.getParameter("kafkaIp");
				String kafkaPort = request.getParameter("kafkaPort");
				
				paramMap.put("kafkaIp", kafkaIp);
				paramMap.put("kafkaPort", kafkaPort);
			} else {
				String regiIP = request.getParameter("regiIP");
				String regiPort = request.getParameter("regiPort");
				
				paramMap.put("regiIP", regiIP);
				paramMap.put("regiPort", regiPort);
			}

			result = transConService.kafkaConnectionTest(paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * kafka connect 사용중 또는 등록 되있는 경우 확인
	 * @param response, request , transDbmsVO
	 * @return String
	 */
	@RequestMapping("/selectTransKafkaConIngChk.do")
	public @ResponseBody String selectTransKafkaConIngChk(@ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletRequest request, HttpServletResponse response) {	
		String result = "S";

		String trans_connect_id_Rows = request.getParameter("trans_connect_id_List").toString().replaceAll("&quot;", "\"");

		try {
			if (!"".equals(trans_connect_id_Rows)) {
				transDbmsVO.setTrans_connect_id_Rows(trans_connect_id_Rows);

				result = transConService.selectTransKafkaConIngChk(transDbmsVO);
			} else {
				result = "F";
			}
		} catch (Exception e1) {
			result = "F";
			e1.printStackTrace();
		}

		return result;
	}

	/**
	 * Schema Registry 사용중 또는 등록 되있는 경우 확인
	 * @param response, request , transDbmsVO
	 * @return String
	 */
	@RequestMapping("/selectTransScheRegiIngChk.do")
	public @ResponseBody String selectTransScheRegiIngChk(@ModelAttribute("transRegiVO") TransRegiVO transRegiVO, HttpServletRequest request, HttpServletResponse response) {	
		String result = "S";

		String trans_regi_id_Rows = request.getParameter("trans_regi_id_List").toString().replaceAll("&quot;", "\"");

		try {
			if (!"".equals(trans_regi_id_Rows)) {
				transRegiVO.setTrans_regi_id_Rows(trans_regi_id_Rows);

				result = transConService.selectTransSchemRegiIngChk(transRegiVO);
			} else {
				result = "F";
			}
		} catch (Exception e1) {
			result = "F";
			e1.printStackTrace();
		}

		return result;
	}
	
	/**
	 * TRANS Schema Registry 시스템을 수정한다.
	 * 
	 * @param transRegiVO, workVO, historyVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/updateTransSchemaRegistry.do")
	public @ResponseBody String updateTransSchemaRegistry(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transRegiVO") TransRegiVO transRegiVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0169_01");
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			transRegiVO.setFrst_regr_id(id);
			transRegiVO.setLst_mdfr_id(id);

			result = transConService.updateTransShcemaRegistry(transRegiVO);	

		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		return result;
	}

	/**
	 * Schema 수정 페이지 조회
	 * @param historyVO, transRegiVO, request
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/transTargetScheRegiUdt.do")
	public ModelAndView transTargetScheRegiUdt(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transRegiVO") TransRegiVO transRegiVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		List<TransRegiVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0169");
			accessHistoryService.insertHistory(historyVO);

			//리스트 조회
			resultSet = transConService.selectTransRegiList(transRegiVO);

			mv.addObject("resultInfo", resultSet);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * kafka connect 수정 View page 조회
	 * @param historyVO, transDbmsVO, request
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/transTargetKfkConUdt.do")
	public ModelAndView transTargetKfkConUdt(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		List<TransDbmsVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0155");
			accessHistoryService.insertHistory(historyVO);

			//리스트 조회
			resultSet = transConService.selectTransKafkaConList(transDbmsVO);

			mv.addObject("resultInfo", resultSet);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 스키마 레지스트리 deleteTransSchemaRegistry 삭제
	 * @param transRegiVO, response, request, historyVO
	 * @return boolean
	 * @throws IOException 
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/deleteTransSchemaRegistry.do")
	@ResponseBody
	public boolean deleteTransSchemaRegistry(@ModelAttribute("transRegiVO") TransRegiVO transRegiVO, HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws IOException, ParseException{
		boolean result = false;

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String trans_regi_id_List = request.getParameter("trans_regi_id_List").toString().replaceAll("&quot;", "\"");
		
		try{
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0153_04");
			accessHistoryService.insertHistory(historyVO);

			if (!"".equals(trans_regi_id_List)) {
				transRegiVO.setTrans_regi_id_Rows(trans_regi_id_List);
				
				transConService.deleteTransSchemaRegistry(transRegiVO);	
				
				result = true;
			} else {
				result = false;
			}
		}catch(Exception e){
			result = false;
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
		return result;
	}
	
	/**
	 * kafka 커넥터 deleteTransKafkaConnect 삭제
	 * @param transDbmsVO, response, request, historyVO
	 * @return boolean
	 * @throws IOException 
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/deleteTransKafkaConnect.do")
	@ResponseBody
	public boolean deleteTransKafkaConnect(@ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws IOException, ParseException{
		boolean result = false;

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String trans_connect_id_Rows = request.getParameter("trans_connect_id_List").toString().replaceAll("&quot;", "\"");
		
		try{
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0153_03");
			accessHistoryService.insertHistory(historyVO);

			if (!"".equals(trans_connect_id_Rows)) {
				transDbmsVO.setTrans_connect_id_Rows(trans_connect_id_Rows);
				
				transConService.deleteTransKafkaConnect(transDbmsVO);	
				
				result = true;
			} else {
				result = false;
			}
		}catch(Exception e){
			result = false;
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
		return result;
	}
	
	/**
	 * TRANS Schema Registry 설정을 등록한다.
	 * 
	 * @param historyVO, transRegiVO, workVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/insertTransSchemaRegistry.do")
	public @ResponseBody String insertTransSchemaRegistry(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transRegiVO") TransRegiVO transRegiVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0168_01");
			accessHistoryService.insertHistory(historyVO);
			
			transRegiVO.setFrst_regr_id(id);
			transRegiVO.setLst_mdfr_id(id);
			
			//Map<String, Object> transMap = BeanUtils.describe(transRegiVO);
			//System.out.println("transMap :: "+transMap.toString());
			//System.out.println("regi_ip :: "+transRegiVO.getRegi_ip());

			result = transConService.insertTransSchemaRegistry(transRegiVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		
		return result;
	}
	
	/**
	 * TRANS kafka connect 설정을 등록한다.
	 * 
	 * @param historyVO, transDbmsVO, workVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/insertTransKafkaConnect.do")
	public @ResponseBody String insertTransKafkaConnect(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0154_01");
			accessHistoryService.insertHistory(historyVO);
			
			transDbmsVO.setFrst_regr_id(id);
			transDbmsVO.setLst_mdfr_id(id);
			
			result = transConService.insertTransKafkaConnect(transDbmsVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		
		return result;
	}

	/**
	 * Schema Registry 설정 등록 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transSchemaRegistryIns.do")
	public ModelAndView transSchemaRegistryIns(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);
	
			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0168");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * kafka connenct 설정 등록 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transTargetKfkConIns.do")
	public ModelAndView transTargetKfkConIns(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);
	
			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0154");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * kafka connenct를 조회한다.
	 * 
	 * @param historyVO, transDbmsVO, response, request
	 * @return List<TransDbmsVO>
	 */
	@RequestMapping(value = "/selectTransKafkaConList.do")
	@ResponseBody
	public List<TransDbmsVO> selectTransKafkaConList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<TransDbmsVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0153_01");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = transConService.selectTransKafkaConList(transDbmsVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * Schema Registry 정보를 조회한다.
	 * 
	 * @param historyVO, TransRegiVO, response, request
	 * @return List<TransRegiVO>
	 */
	@RequestMapping(value = "/selectTransRegiList.do")
	@ResponseBody
	public List<TransRegiVO> selectTransRegiList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transRegiVO") TransRegiVO transRegiVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<TransRegiVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0153_02");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = transConService.selectTransRegiList(transRegiVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * 커넥터 서버 설정화면 출력
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transConnectSetting.do")
	public ModelAndView transConnectSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id=Integer.parseInt(request.getParameter("db_svr_id"));

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

		try {
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0153");
				accessHistoryService.insertHistory(historyVO);
				
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				mv.setViewName("transfer/transKafkaConSetting");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * TRANS kafka 시스템을 수정한다.
	 * 
	 * @param transDbmsVO, workVO, historyVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/updateTransKafkaConnect.do")
	public @ResponseBody String updateTransKafkaConnect(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0155_01");
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			transDbmsVO.setFrst_regr_id(id);
			transDbmsVO.setLst_mdfr_id(id);

			result = transConService.updateTransKafkaConnect(transDbmsVO);	

		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		return result;
	}


	/**
	 * select box kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	// 
	@RequestMapping(value = "/kafkaConnectionTestUpdate.do")
	@ResponseBody
	public Map<String, Object> kafkaConnectionTestUpdate(@ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletResponse response, HttpServletRequest request) {

		Map<String, Object> result = new HashMap<String, Object>();
		List<TransDbmsVO> resultSet = null;
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			//리스트 조회
			resultSet = transConService.selectTransKafkaConList(transDbmsVO);
			
			result = transConService.kafkaConnectionTestUpdate(transDbmsVO, resultSet, db_svr_id, id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * select box kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	// 
	@RequestMapping(value = "/schemaRegistryTestUpdate.do")
	@ResponseBody
	public Map<String, Object> schemaRegistryTestUpdate(@ModelAttribute("transRegiVO") TransRegiVO transRegiVO, HttpServletResponse response, HttpServletRequest request) {

		Map<String, Object> result = new HashMap<String, Object>();
		List<TransRegiVO> resultSet = null;
		
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String id = loginVo.getUsr_id();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			//리스트 조회
			resultSet = transConService.selectTransRegiList(transRegiVO);
			
			result = transConService.schemaRegistryTestUpdate(transRegiVO, resultSet, db_svr_id, id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//////////////////////////////////사용안함/////////////////////////////////////////////////////////////////
	/**
	 * 스키마레지스티리 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/schemaMapp.do")
	public ModelAndView schemaInfo(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		JSONArray jsonArray = new JSONArray();

		//테이블구분 (추출테이블 = include , 제외테이블 = exclude)
		String schemaGbn = request.getParameter("schemaGbn");
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_nm = request.getParameter("db_nm");
		
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0146");
			historyVO.setMnu_id(41);
			accessHistoryService.insertHistory(historyVO);*/

			String[] schemas = null;
			//테이블 구분에 따른 테이블 리스트저장
			if(schemaGbn.equals("include")){
				schemas = request.getParameter("include_schema_nm").toString().split(",");
			}else{
				schemas = request.getParameter("exclude_schema_nm").toString().split(",");
			}
			for (int i = 0; i < schemas.length; i++) {
				jsonArray.add(schemas[i]);
			}
		} catch (Exception e2) {
			e2.printStackTrace();
		}

		mv.addObject("db_svr_id", db_svr_id);
		mv.addObject("db_nm", db_nm);
		mv.addObject("schemaGbn", schemaGbn);
		mv.addObject("schemaList", jsonArray);
		
		mv.setViewName("/popup/schemaMapp");
		return mv;
	}

	/**
	 * 스키마 리스트 조회
	 * 
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value="/selectSchemaList.do")
	public @ResponseBody JSONObject selectSchemaList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_nm = request.getParameter("db_nm");
		String schema_nm = request.getParameter("schema_nm");

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			JSONObject serverObj = new JSONObject();

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn cic = new ClientInfoCmmn();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, db_nm);
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));	
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");  //postgres 한정
			serverObj.put(ClientProtocolID.SCHEMA, schema_nm);
			serverObj.put(ClientProtocolID.TABLE_NM, "%");

			//result = cic.schemaList(serverObj, IP, PORT);
			result =  TransferSchemaInfo.getSchemaList(serverObj);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * Database 매핑작업 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transMappForm.do")
	public ModelAndView transferMappingRegForm(@ModelAttribute("dbServerVO") DbServerVO dbServerVO,@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		List<DbServerVO> resultSet = null;
		List<TransferDetailMappingVO> result = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0020");
			historyVO.setMnu_id(34);
			accessHistoryService.insertHistory(historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		
			mv.setViewName("popup/transMapp");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}