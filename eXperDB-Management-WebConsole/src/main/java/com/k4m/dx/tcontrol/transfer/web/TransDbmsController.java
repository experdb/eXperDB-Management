package com.k4m.dx.tcontrol.transfer.web;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.dbms.service.DbmsService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;

/**
 * Transfer 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.08   변승우 최초 생성
 *      </pre>
 */
@Controller
public class TransDbmsController {

	@Autowired
	private TransService transService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private DbmsService dbmsService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;

	private List<Map<String, Object>> menuAut;
	
	/**
	 * 타켓 DBMS 설정 화면 출력
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transDbmsSetting.do")
	public ModelAndView transDbmsSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
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
				historyVO.setExe_dtl_cd("DX-T0148");
				accessHistoryService.insertHistory(historyVO);
				
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				mv.setViewName("transfer/transDbmsSetting");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 타켓 DBMS 설정 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws 
	 */
	@RequestMapping(value = "/popup/transTargetDbmsSetting.do")
	public ModelAndView transTargetDbmsSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0147");
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 타켓 DBMS 시스템을 조회한다.
	 * 
	 * @param historyVO, transDbmsVO, response, request
	 * @return List<TransDbmsVO>
	 */
	@RequestMapping(value = "/selectTransDBMS.do")
	@ResponseBody
	public List<TransDbmsVO> selectTransDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<TransDbmsVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0147_01");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = transService.selectTransDBMS(transDbmsVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
		
	}
	
	/**
	 * 타켓 DBMS 설정 등록 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/transTargetDbmsIns.do")
	public ModelAndView transTargetDbmsIns(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);
	
			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0149");
			accessHistoryService.insertHistory(historyVO);

			List<Map<String, Object>> dbmsGrb = dbmsService.dbmsGrb();
			mv.addObject("dbmsGrb_reg", dbmsGrb);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 시스템명을 중복 체크한다.
	 * 
	 * @param trans_sys_nm
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value = "/trans_sys_nmCheck.do")
	public @ResponseBody String trans_sys_nmCheck(@RequestParam("trans_sys_nm") String trans_sys_nm) {
		String resultMsg = "";
		
		try {	
			resultMsg = transService.trans_sys_nmCheck(trans_sys_nm);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMsg;
	}
	
	/**
	 * TRANS DBMS 시스템을 등록한다.
	 * 
	 * @param historyVO, transDbmsVO, workVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/insertTransDBMS.do")
	public @ResponseBody String insertTransDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0149_01");
			accessHistoryService.insertHistory(historyVO);
			
			transDbmsVO.setFrst_regr_id(id);
			transDbmsVO.setLst_mdfr_id(id);

			result = transService.insertTransDBMS(transDbmsVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		
		return result;
	}
	
	/**
	 * dbms 사용중 또는 등록 되있는 경우 확인
	 * @param response, request , transDbmsVO
	 * @return String
	 */
	@RequestMapping("/selectTransDmbsIngChk.do")
	public @ResponseBody String selectTransDmbsIngChk(@ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletRequest request, HttpServletResponse response) {	
		String result = "S";

		String trans_dbms_id_Rows = request.getParameter("trans_dbms_id_List").toString().replaceAll("&quot;", "\"");

		try {
			if (!"".equals(trans_dbms_id_Rows)) {
				transDbmsVO.setTrans_dbms_id_Rows(trans_dbms_id_Rows);
				
				//scale log 확인
				result = transService.selectTransDbmsIngChk(transDbmsVO);
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
	 * Rman Backup Reregistration View page
	 * @param historyVO, transDbmsVO, request
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/transTargetDbmsUpd.do")
	public ModelAndView transTargetDbmsUpd(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		List<TransDbmsVO> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0150");
			accessHistoryService.insertHistory(historyVO);
			
			//패스워드  복호화
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			//리스트 조회
			resultSet = transService.selectTransDBMS(transDbmsVO);
			//password
			String pwd = dec.aesDecode(resultSet.get(0).getPwd()).toString();
			
			//공통코드 조회
			List<Map<String, Object>> dbmsGrb = dbmsService.dbmsGrb();

			mv.addObject("pwd", pwd);
			mv.addObject("resultInfo", resultSet);
			mv.addObject("dbmsGrb_reg", dbmsGrb);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * TRANS DBMS 시스템을 수정한다.
	 * 
	 * @param transDbmsVO, workVO, historyVO, request, response
	 * @return String
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/updateTransDBMS.do")
	public @ResponseBody String updateTransDBMS(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, @ModelAttribute("workVO") WorkVO workVO, 
			HttpServletRequest request, HttpServletResponse response) throws ParseException {
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0150_01");
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();

			transDbmsVO.setFrst_regr_id(id);
			transDbmsVO.setLst_mdfr_id(id);

			result = transService.updateTransDBMS(transDbmsVO);	

		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		return result;
	}
	
	/**
	 * Work deleteTransDBMS
	 * @param transDbmsVO, response, request, historyVO
	 * @return boolean
	 * @throws IOException 
	 * @throws ParseException 
	 */
	@RequestMapping(value = "/deleteTransDBMS.do")
	@ResponseBody
	public boolean deleteTransDBMS(@ModelAttribute("transDbmsVO") TransDbmsVO transDbmsVO, HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws IOException, ParseException{
		boolean result = false;

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String trans_dbms_id_Rows = request.getParameter("trans_dbms_id_List").toString().replaceAll("&quot;", "\"");

		try{
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0147_02");
			accessHistoryService.insertHistory(historyVO);
			
			if (!"".equals(trans_dbms_id_Rows)) {
				transDbmsVO.setTrans_dbms_id_Rows(trans_dbms_id_Rows);
				
				//scale log 확인
				transService.deleteTransDBMS(transDbmsVO);	
				
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
	 * 타켓 DBMS 설정 화면 출력
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
	 * kafka connect 설정 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws 
	 */
	@RequestMapping(value = "/popup/transConSettingForm.do")
	public ModelAndView transConSettingForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0153");
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("db_svr_id", db_svr_id);
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
			
			resultSet = transService.selectTransKafkaConList(transDbmsVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
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

			result = transService.insertTransKafkaConnect(transDbmsVO);	
	
		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
		}
		
		return result;
	}
	
	/**
	 * Work deleteTransKafkaConnect
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
			historyVO.setExe_dtl_cd("DX-T0151_02");
			accessHistoryService.insertHistory(historyVO);

			if (!"".equals(trans_connect_id_Rows)) {
				transDbmsVO.setTrans_connect_id_Rows(trans_connect_id_Rows);
				
				transService.deleteTransKafkaConnect(transDbmsVO);	
				
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
	 * Rman Backup Reregistration View page
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
			resultSet = transService.selectTransKafkaConList(transDbmsVO);

			mv.addObject("resultInfo", resultSet);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * TRANS DBMS 시스템을 수정한다.
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

			result = transService.updateTransKafkaConnect(transDbmsVO);	

		} catch (Exception e) {
			e.printStackTrace();
			result = "F";
			return result;
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

				result = transService.selectTransKafkaConIngChk(transDbmsVO);
			} else {
				result = "F";
			}
		} catch (Exception e1) {
			result = "F";
			e1.printStackTrace();
		}

		return result;
	}	
}
