package com.k4m.dx.tcontrol.transfer.web;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.common.service.PageVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.transfer.TransferTableInfo;
import com.k4m.dx.tcontrol.transfer.service.TransConService;
import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransRegiVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

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
public class TransController {
	
	@Autowired
	private BackupService backupService;

	@Autowired
	private TransService transService;

	@Autowired
	private TransConService transConService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;
	
	private List<Map<String, Object>> menuAut;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
	/**
	 * 전송설정 화면을 보여준다.(use)
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transSetting.do")
	public ModelAndView transSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id=Integer.parseInt(request.getParameter("db_svr_id"));
		
		String transfer_ora = request.getParameter("transfer_ora");

		//유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
		
		TransDbmsVO transDbmsVO = new TransDbmsVO();
		TransVO transVO = new TransVO();
		TransRegiVO transRegiVO = new TransRegiVO();

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

				List<CmmnCodeVO> cmmnCodeVO =  null;
				PageVO pageVO = new PageVO();
				
				// Get DB List(use)
				try {
					HttpSession session = request.getSession();
					LoginVO loginVo = (LoginVO) session.getAttribute("session");
					String usr_id = loginVo.getUsr_id();
					workVO.setUsr_id(usr_id);
					
					mv.addObject("dbList", backupService.selectDbList(workVO));
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				// 공통코드 Get 스냅샷모드 (use)
				try {
					pageVO.setGrp_cd("TC0036");
					pageVO.setSearchCondition("3");
					cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
					
					mv.addObject("snapshotModeList", cmmnCodeVO);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				// 공통코드 압축형식  (use)
				try {
					pageVO.setGrp_cd("TC0037");
					pageVO.setSearchCondition("3");
					cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
					
					mv.addObject("compressionTypeList", cmmnCodeVO);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				// 공통코드 Connect타입  (use)
				try {
					pageVO.setGrp_cd("TC0043");
					pageVO.setSearchCondition("3");
					cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
					
					mv.addObject("connectTypeList", cmmnCodeVO);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				// 공통코드 토픽타입  (use)
				try {
					pageVO.setGrp_cd("TC0044");
					pageVO.setSearchCondition("3");
					cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
					
					mv.addObject("topicTypeList", cmmnCodeVO);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				//kafka 조회
				try {
					mv.addObject("kafkaConnectList", transConService.selectTransKafkaConList(transDbmsVO));
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				//schemaRegistry 조회
				try {
					mv.addObject("schemaRegistryList", transConService.selectTransRegiList(transRegiVO));
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			
				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);
				
				Properties props = new Properties();
				props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
				
				if (transfer_ora == null || transfer_ora.equals("")|| !transfer_ora.equals("Y")) {
					transfer_ora = "";

					if (props.get("transfer_ora") != null) {
						transfer_ora = props.get("transfer_ora").toString();
					}
				}
				
				//trans heatbeat 체크
				try {
					mv.addObject("heartbeatchk", transService.selectTransComCoIngChk(transVO));
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				if (transfer_ora != null && "Y".equals(transfer_ora)) {
					mv.setViewName("transfer/transFullSetting");
				} else {
					mv.setViewName("transfer/transSetting");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 소스시스템 전송설정 조회
	 * 
	 * @param transVO, request, response
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSourceTransSetting.do")
	public @ResponseBody List<Map<String, Object>> selectSourceTransSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transVO") TransVO transVO, HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> result = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0148_01");
			accessHistoryService.insertHistory(historyVO);

			result = transService.selectTransSetting(transVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 타켓시스템 전송설정 조회
	 * 
	 * @param transVO, request, response
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTargetTransSetting.do")
	public @ResponseBody List<Map<String, Object>> selectTargetTransSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transVO") TransVO transVO, HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> result = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0148_01");
			accessHistoryService.insertHistory(historyVO);

			result = transService.selectTargetTransSetting(transVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * kafka-Connection 시작
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/transStart.do")
	@ResponseBody
	public String transStart(HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		String result = "fail";

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id = Integer.parseInt(request.getParameter("trans_id"));
			
			TransVO transVOPrm = new TransVO();
			transVOPrm.setDb_svr_id(db_svr_id);
			transVOPrm.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
			transVOPrm.setTrans_id(trans_id);
			transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
			transVOPrm.setLst_mdfr_id((String)loginVo.getUsr_id());
	
			result = transService.transStart(transVOPrm);
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * kafka-Connection Target시작
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/transTargetStart.do")
	@ResponseBody
	public String transTargetStart(HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		String result = "fail";

		try {					
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id = Integer.parseInt(request.getParameter("trans_id"));
			
			TransVO transVOPrm = new TransVO();
			transVOPrm.setDb_svr_id(db_svr_id);
			transVOPrm.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
			transVOPrm.setTrans_id(trans_id);
			transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
			transVOPrm.setLst_mdfr_id((String)loginVo.getUsr_id());
			
			result = transService.transTargetStart(transVOPrm);	
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * kafka-Connection 중지
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/transStop.do")
	@ResponseBody
	public String transStop(HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		String result = "fail";

		try {
			String kc_ip = request.getParameter("kc_ip");
			int kc_port = Integer.parseInt(request.getParameter("kc_port"));
			String connect_nm = request.getParameter("connect_nm");
			int trans_id = Integer.parseInt(request.getParameter("trans_id"));
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			//구분
			String trans_active_gbn = (String)request.getParameter("trans_active_gbn");

			TransVO transVOPrm = new TransVO();
			transVOPrm.setKc_ip(kc_ip);
			transVOPrm.setKc_port(kc_port);
			transVOPrm.setConnect_nm(connect_nm);
			transVOPrm.setTrans_id(trans_id);
			transVOPrm.setDb_svr_id(db_svr_id);
			transVOPrm.setTrans_active_gbn(trans_active_gbn);
			transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
	
			result = transService.transStop(transVOPrm);
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 전송설정 삭제한다.
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteTransSetting.do")
	@ResponseBody
	public boolean deleteTransSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String trans_active_gbn = request.getParameter("trans_active_gbn");
		String trans_id_Rows = request.getParameter("trans_id_List").toString().replaceAll("&quot;", "\"");	
		
		String trans_exrt_trg_tb_id_Rows = request.getParameter("trans_exrt_trg_tb_id_List").toString().replaceAll("&quot;", "\"");
		String resultSebu = "";

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0148_02");
			accessHistoryService.insertHistory(historyVO);

			TransVO transVOPrm = new TransVO();

			if (!"".equals(trans_id_Rows)) {
				transVOPrm.setTrans_id_Rows(trans_id_Rows);
				transVOPrm.setTrans_exrt_trg_tb_id_Rows(trans_exrt_trg_tb_id_Rows);
				transVOPrm.setTrans_active_gbn(trans_active_gbn);

				transVOPrm.setLst_mdfr_id(usr_id);

				resultSebu = transService.deleteTransTotSetting(transVOPrm);

				if (!"S".equals(resultSebu)) {
					txManager.rollback(status);
					return false;
				}
			} else {
				txManager.rollback(status);
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			txManager.rollback(status);
			return false;
		}finally{
			txManager.commit(status);
		}

		return true;
	}
	
	/**
	 * 다중 kafka-Connection 시작
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/transTotExecute.do")
	@ResponseBody
	public String transTotExecute(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String result = "fail";

		try {
			result = transService.transTotExecute(request, loginVo);
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
	
		return result;
	}

	/**
	 * 소스 전송대상상세 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransSettingInfo.do")
	public ModelAndView selectTransSettingInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		JSONObject tableResult = new JSONObject();

		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		Map<String, Object> transInfoMap = new HashMap<String, Object>();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0148_03");
			accessHistoryService.insertHistory(historyVO);
			
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
			String trans_active_gbn = request.getParameter("trans_active_gbn");
			String multi_gbn = "";
			
			if ("source".equals(trans_active_gbn)) {
				transInfo = transService.selectTransInfo(trans_id);
				
				multi_gbn = "sur_multi";
			} else {
				transInfo = transService.selectTargetTransInfo(trans_id);
				
				multi_gbn = "tar_multi";
			}
			System.out.println("전송정보 : "+transInfo.get(0));

			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));

			tableResult = transService.selectTransMatchMappInfo(mappInfo, trans_active_gbn, multi_gbn);
			System.out.println("전송대상테이블정보 : "+ tableResult);

			if (transInfo != null) {
				transInfoMap = transService.selectTransMatchInfo(transInfo, trans_active_gbn);
			}

			mv.addObject("transInfoMap", transInfoMap); //use
			mv.addObject("tables", tableResult); //use
			mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
			mv.addObject("trans_id",trans_id);

			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송설정등록 팝업 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/connectRegForm2.do")
	public ModelAndView connectRegForm2(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);

			String act = request.getParameter("act");
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0151");
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("act", act);
			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 타겟 전송대상상세 화면 조회
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/connectTargetRegReForm.do")
	public ModelAndView connectTargetRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		JSONObject tableResult = new JSONObject();

		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		Map<String, Object> transInfoMap = new HashMap<String, Object>();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0152");
			accessHistoryService.insertHistory(historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id =  Integer.parseInt(request.getParameter("trans_id"));

			transInfo = transService.selectTargetTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));
			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));

			tableResult = transService.selectTransMatchMappInfo(mappInfo, "target", "tar_single");
			System.out.println("전송대상테이블정보 : "+ tableResult);

			if (transInfo != null) {
				transInfoMap = transService.selectTransMatchInfo(transInfo, "target");
			}

			mv.addObject("transInfoMap", transInfoMap); //use
			mv.addObject("tables", tableResult); //use
			mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
			mv.addObject("trans_id",trans_id);

			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 소스 전송대상상세 화면 조회
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/connectRegReForm.do")
	public ModelAndView connectRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		JSONObject tableResult = new JSONObject();

		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		Map<String, Object> transInfoMap = new HashMap<String, Object>();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0152");
			accessHistoryService.insertHistory(historyVO);
			
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id =  Integer.parseInt(request.getParameter("trans_id"));

			transInfo = transService.selectTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));
			
			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));
			

			tableResult = transService.selectTransMatchMappInfo(mappInfo, "source", "sur_single");
			System.out.println("전송대상테이블정보 : "+ tableResult);

			if (transInfo != null) {
				transInfoMap = transService.selectTransMatchInfo(transInfo, "source");
			}

			mv.addObject("transInfoMap", transInfoMap); //use
			mv.addObject("tables", tableResult); //use
			mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
			mv.addObject("trans_id",trans_id);

			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 커넥터명을 중복 체크한다.
	 * 
	 * @param connect_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/connect_nm_Check.do")
	public @ResponseBody String connect_nm_Check(@RequestParam("connect_nm") String connect_nm, @RequestParam("connect_gbn") String connect_gbn) {
		try {
			int resultSet = transService.connect_nm_Check(connect_nm, connect_gbn);
					
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
	 * 기본설절 목록을 조회한다.
	 * 
	 * @param historyVO, transDbmsVO, response, request
	 * @return List<TransDbmsVO>
	 */
	@RequestMapping(value = "/selectTransComConPopList.do")
	@ResponseBody
	public List<Map<String, Object>> selectTransComConPopList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transVO") TransVO transVO, HttpServletResponse response, HttpServletRequest request) {
		
		List<Map<String, Object>> resultSet = null;
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0157_01");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = transService.selectTransComConPopList(transVO);
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * 기본설정 등록 화면 조회
	 * @param transVO, request, historyVO
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/transComSettingCngIns.do")
	public ModelAndView transComSettingCngIns(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);
	
			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0156");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	/**
	 * 기본설정 수정 화면 조회
	 * @param transVO, request, historyVO
	 * @return Map<String, Object>
	 */
	@RequestMapping("/selectTransComSettingCngInfo.do")
	@ResponseBody
	public Map<String, Object> selectTransComSettingCngInfo(@ModelAttribute("transVO") TransVO transVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0158");
			accessHistoryService.insertHistory(historyVO);
			
			result = transService.selectTransComSettingCngInfo(transVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;	
	}

	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	/**
	 * 기본설정 등록
	 * @param 
	 * @return
	 */
	@RequestMapping("/transComConCngInsert.do")
	@ResponseBody
	public String transComConCngInsert(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transVO") TransVO transVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		//중복체크 flag 값
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0156_1");
			accessHistoryService.insertHistory(historyVO);
			
			transVO.setFrst_regr_id((String)loginVo.getUsr_id());
			transVO.setLst_mdfr_id((String)loginVo.getUsr_id());
			
			transVO.setTrans_com_cng_gbn("ins");

			//저장 process
			result = transService.updateTransCommonSetting(transVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 기본설정 수정
	 * @param 
	 * @return
	 */
	@RequestMapping("/transComConCngWrite.do")
	@ResponseBody
	public String transComConCngWrite(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("transVO") TransVO transVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");

		//중복체크 flag 값
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0158_1");
			accessHistoryService.insertHistory(historyVO);
			
			transVO.setFrst_regr_id((String)loginVo.getUsr_id());
			transVO.setLst_mdfr_id((String)loginVo.getUsr_id());
			
			transVO.setTrans_com_cng_gbn("mod");

			//저장 process
			result = transService.updateTransCommonSetting(transVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 기본설정 삭제
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/deleteTransComConSet.do")
	@ResponseBody
	public boolean deleteTransComConSet(@ModelAttribute("transDbmsVO") TransVO transVO, HttpServletResponse response, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws IOException, ParseException{
		boolean result = false;

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String trans_com_id_Rows = request.getParameter("trans_com_id_List").toString().replaceAll("&quot;", "\"");

		try{
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0157_02");
			accessHistoryService.insertHistory(historyVO);
			
			if (!"".equals(trans_com_id_Rows)) {
				transVO.setTrans_com_id_Rows(trans_com_id_Rows);
				
				//scale log 확인
				transService.deleteTransComConSet(transVO);	
				
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
	 * 전송설정 등록한다.       ---- 수정필요
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertConnectInfoNew.do")
	public @ResponseBody String insertConnectInfo(@ModelAttribute("transVO") TransVO transVO, @ModelAttribute("transMappVO") TransMappVO transMappVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String result = "fail";
		int trans_exrt_trg_tb_id =0;

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0151_01");
			accessHistoryService.insertHistory(historyVO);

			transVO.setFrst_regr_id(usr_id);
			transVO.setLst_mdfr_id(usr_id);
			transMappVO.setFrst_regr_id(usr_id);

			//포함대항(스키마,테이블)등록
			try{
				trans_exrt_trg_tb_id = transService.selectTransExrttrgMappSeq();
				transMappVO.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);				

				if(transMappVO.getSchema_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setSchema_total_cnt("0");
				}
				
				if(transMappVO.getTable_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setTable_total_cnt("0");
				}
				
				if (transVO.getRegi_id() != null && !"".equals(transVO.getRegi_id())) {
					transMappVO.setRegi_id(transVO.getRegi_id());
				} else {
					transMappVO.setRegi_id(null);
				}

				//전송대상 테이블 등록
				transService.insertTransExrttrgMapp(transMappVO);	
				
				result = "success";
			} catch (Exception e) {
				result = "fail";
				e.printStackTrace();
				txManager.rollback(status);
				return result;
			}

			transVO.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
			if (transVO.getRegi_id() == null || "".equals(transVO.getRegi_id())) {
				transVO.setRegi_id(null);
			}
			
			transService.insertConnectInfo(transVO);		
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
			return result;
		}finally{
			txManager.commit(status);
		}
		return result;
	}

	/**
	 * target 전송설정 등록한다.   --- 수정필요
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTargetConnectInfo.do")
	public @ResponseBody String insertTargetConnectInfo(@ModelAttribute("transVO") TransVO transVO, @ModelAttribute("transMappVO") TransMappVO transMappVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		String result = "fail";
		int trans_exrt_trg_tb_id =0;

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0151_01");
			accessHistoryService.insertHistory(historyVO);

			transVO.setFrst_regr_id(usr_id);
			transVO.setLst_mdfr_id(usr_id);
			transMappVO.setFrst_regr_id(usr_id);

			//포함대항(스키마,테이블)등록
			try{
				trans_exrt_trg_tb_id=transService.selectTransExrttrgMappSeq();
				transMappVO.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);				

				if(transMappVO.getSchema_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setSchema_total_cnt("0");
				}
				
				if(transMappVO.getTable_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setTable_total_cnt("0");
				}
				
				transVO.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);

				if (transVO.getRegi_id() != null && !"".equals(transVO.getRegi_id())) {
					transMappVO.setRegi_id(transVO.getRegi_id());
				} else {
					transMappVO.setRegi_id(null);
				}
				
				if (transVO.getRegi_id() == null || "".equals(transVO.getRegi_id())) {
					transVO.setRegi_id(null);
				}

				//전송대상 테이블 등록
				result = transService.insertTargetConnectInfoTot(transMappVO, transVO);
			} catch (Exception e) {
				result = "fail";
				e.printStackTrace();
				txManager.rollback(status);
				return result;
			}	
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
			return result;
		}finally{
			txManager.commit(status);
		}
		return result;
	}

	/**
	 * 토픽 리스트 조회    -- 수정필요
	 * 
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value="/selectTargetTopicMappList.do")
	public @ResponseBody JSONObject selectTargetTopicMappList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String kc_ip = request.getParameter("kc_ip");

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			ClientInfoCmmn cic = new ClientInfoCmmn();
			JSONObject serverObj = new JSONObject();

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();
				
			String strCmd ="bin/kafka-topics.sh --list --zookeeper " + kc_ip + ":2181";

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			serverObj.put(ClientProtocolID.REQ_CMD, strCmd);

			result = cic.trans_topic_List(serverObj,IP,PORT);

			System.out.println("result====" + result);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 전송설정 수정한다.
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateConnectInfo.do")
	public @ResponseBody boolean updateConnectInfo(@ModelAttribute("transVO") TransVO transVO, @ModelAttribute("transMappVO") TransMappVO transMappVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0152_01");
			accessHistoryService.insertHistory(historyVO);

			transMappVO.setTrans_exrt_trg_tb_id(Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id")));
			transMappVO.setFrst_regr_id(usr_id);

			transVO.setFrst_regr_id(usr_id);
			transVO.setLst_mdfr_id(usr_id);

			try{			
				if(transMappVO.getSchema_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setSchema_total_cnt("0");
				}

				if(transMappVO.getTable_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setTable_total_cnt("0");
				}

				if (transVO.getRegi_id() != null && !"".equals(transVO.getRegi_id())) {
					transMappVO.setRegi_id(transVO.getRegi_id());
				} else {
					transMappVO.setRegi_id(null);
				}
				
				if (transVO.getRegi_id() == null || "".equals(transVO.getRegi_id())) {
					transVO.setRegi_id(null);
				}

				transService.updateTransExrttrgMapp(transMappVO);	

				transService.updateConnectInfo(transVO);

			}catch (Exception e) {

				e.printStackTrace();
				txManager.rollback(status);
				return false;
			}
		} catch (Exception e) {

			e.printStackTrace();
			txManager.rollback(status);
			return false;
		}finally{
			txManager.commit(status);
		}

		return true;
	}
	
	/**
	 * target 전송설정 수정한다.
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTargetConnectInfo.do")
	public @ResponseBody String updateTargetConnectInfo(@ModelAttribute("transVO") TransVO transVO, @ModelAttribute("transMappVO") TransMappVO transMappVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		String result = "fail";
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0152_01");
			accessHistoryService.insertHistory(historyVO);

			transMappVO.setTrans_exrt_trg_tb_id(Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id")));
			transMappVO.setFrst_regr_id(usr_id);
	
			transVO.setFrst_regr_id(usr_id);
			transVO.setLst_mdfr_id(usr_id);

			try{			
				if(transMappVO.getSchema_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setSchema_total_cnt("0");
				}
				
				if(transMappVO.getTable_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
					transMappVO.setTable_total_cnt("0");
				}

				if (transVO.getRegi_id() != null && !"".equals(transVO.getRegi_id())) {
					transMappVO.setRegi_id(transVO.getRegi_id());
				} else {
					transMappVO.setRegi_id(null);
				}
				
				if (transVO.getRegi_id() == null || "".equals(transVO.getRegi_id())) {
					transVO.setRegi_id(null);
				}
				
				transVO.setTrans_exrt_trg_tb_id(Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id")));
				//전송대상 테이블 수정
				result = transService.updateTargetConnectInfoTot(transMappVO, transVO);
			}catch (Exception e) {
				result = "fail";
				e.printStackTrace();
				txManager.rollback(status);
				return result;
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
			return result;
		}finally{
			txManager.commit(status);
		}
		return result;
	}
	

	/**
	 * 테이블 리스트 조회
	 * 
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value="/selectTableMappList.do")
	public @ResponseBody JSONObject selectTableMappList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_nm = request.getParameter("db_nm");
		String table_nm = request.getParameter("table_nm");

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			JSONObject serverObj = new JSONObject();

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, db_nm);
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));	
			serverObj.put(ClientProtocolID.DB_TYPE, "TC002204");  //postgres 한정
			serverObj.put(ClientProtocolID.SCHEMA, "%");
			serverObj.put(ClientProtocolID.TABLE_NM, table_nm);

			result =  TransferTableInfo.getTblList(serverObj);

		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 테이블리스트 등록 팝업 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/tableMapp.do")
	public ModelAndView tableMapp(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();

		JSONArray jsonArray = new JSONArray();
		//JSONArray tableArray = new JSONArray();
		String strRows = null;

		//테이블구분 (추출테이블 = include , 제외테이블 = exclude)
		String tableGbn = request.getParameter("tableGbn");
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_nm = request.getParameter("db_nm");

		String act = request.getParameter("act");

		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0146");
			historyVO.setMnu_id(41);
			*/

			if(act.equals("u")){
				String[] tables = null;
				//테이블 구분에 따른 테이블 리스트저장
				if(tableGbn.equals("include")){
					tables = request.getParameter("include_table_nm").toString().split(",");
					
				}else{
					tables = request.getParameter("exclude_table_nm").toString().split(",");
				}

				for (int i = 0; i < tables.length; i++) {
					System.out.println("테이블 = "+ tables[i]);
					jsonArray.add(tables[i]);
				}
			}else{
				if(tableGbn.equals("include")){ 
					strRows = request.getParameter("include_table_nm").toString().replaceAll("&quot;", "\"");

					if(!strRows.equals("")){
						jsonArray= (JSONArray) new JSONParser().parse(strRows);
					}
				}else{
					strRows = request.getParameter("exclude_table_nm").toString().replaceAll("&quot;", "\"");		

					if(!strRows.equals("")){
						jsonArray= (JSONArray) new JSONParser().parse(strRows);
					}
				}
			}
		} catch (Exception e2) {
			e2.printStackTrace();
		}

		mv.addObject("db_svr_id", db_svr_id);
		mv.addObject("db_nm", db_nm);
		mv.addObject("tableGbn", tableGbn);
		mv.addObject("tableList", jsonArray);
		mv.addObject("act", act);

		mv.setViewName("/popup/tableMapp");
		return mv;
	}

	/**
	 * kafka-Connection 시작
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/transAutoStart.do")
	@ResponseBody
	public String transAutoStart(HttpServletResponse response, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		String result = "fail";
		List<Map<String, Object>> transInfo = null;
		
		try {					
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = -1;
			int trans_id = -1;

			String trans_id_prm = request.getParameter("trans_id");
			String trans_active_gbn = request.getParameter("trans_active_gbn").toString();

			if (trans_id_prm != null && !"".equals(trans_id_prm)) {
				trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
				trans_id = Integer.parseInt(request.getParameter("trans_id"));
			} else {
				if ("ins_target".equals(trans_active_gbn)) {
					transInfo = transService.selectTargetTransInfoAuto(db_svr_id);
				} else if ("ins_source".equals(trans_active_gbn)) {
					transInfo = transService.selectTransInfoAuto(db_svr_id);
				}

				if (transInfo != null) {
					trans_exrt_trg_tb_id = Integer.parseInt(transInfo.get(0).get("trans_exrt_trg_tb_id").toString());
					trans_id = Integer.parseInt(transInfo.get(0).get("trans_id").toString());
				}
			}

			if (trans_exrt_trg_tb_id != -1 && trans_id != -1) {
				TransVO transVOPrm = new TransVO();
				transVOPrm.setDb_svr_id(db_svr_id);
				transVOPrm.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
				transVOPrm.setTrans_id(trans_id);
				transVOPrm.setFrst_regr_id((String)loginVo.getUsr_id());
				transVOPrm.setLst_mdfr_id((String)loginVo.getUsr_id());

				if ("ins_target".equals(trans_active_gbn) || "mod_target".equals(trans_active_gbn)) {
					result = transService.transTargetStart(transVOPrm);
				} else if ("ins_source".equals(trans_active_gbn) || "mod_source".equals(trans_active_gbn)) {
					result = transService.transStart(transVOPrm);
				}
			} else {
				result = "fail";	
			}

		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 기본설정 화면 출력
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transComSettingCngSetting.do")
	public ModelAndView transDbmsSetting(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			CmmnUtils.saveHistory(request, historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0157");
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
}