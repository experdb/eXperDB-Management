package com.k4m.dx.tcontrol.backup.web;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.JsonNode;
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

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbauthority.service.DbAuthorityService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkObjVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
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
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

@Controller
public class BackupController {
	@Autowired
	private BackupService backupService;

	@Autowired
	private CmmnCodeDtlService cmmnCodeDtlService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private DbAuthorityService dbAuthorityService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	@Autowired
	private ScheduleService scheduleService;

	private List<Map<String, Object>> dbSvrAut;

	/**
	 * Mybatis Transaction
	 */
	@Autowired
	private PlatformTransactionManager txManager;

	/**
	 * Work List View page
	 * 
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup/workList.do")
	public ModelAndView workList(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		int db_svr_id = workVO.getDb_svr_id();
		String pgbackrest_useyn = "";

		Properties props = new Properties();
		try {
			props.load(new FileInputStream(
					ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
			pgbackrest_useyn = props.getProperty("pgbackrest.useyn").toString().toUpperCase();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// 유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);
		ModelAndView mv = new ModelAndView();

		// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if (dbSvrAut.get(0).get("bck_cng_aut_yn").equals("N")) {
			mv.setViewName("error/autError");
		} else {
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0021");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setUsr_id(usr_id);

				mv.addObject("usr_id", usr_id);
				mv.addObject("pgbackrest_useyn", pgbackrest_useyn);
				mv.addObject("dbList", backupService.selectDbList(workVO));

			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			// Get Incoding Code List
			try {
				PageVO pageVO = new PageVO();
				pageVO.setGrp_cd("TC0005");
				pageVO.setSearchCondition("0");
				List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
				mv.addObject("incodeList", cmmnCodeVO);
			} catch (Exception e) {
				e.printStackTrace();
			}

			try {
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if (request.getParameter("tabGbn") != null) {
				mv.addObject("tabGbn", request.getParameter("tabGbn"));
			}

			mv.addObject("db_svr_id", workVO.getDb_svr_id());

			mv.setViewName("backup/workList");
		}
		return mv;
	}

	/**
	 * Work List
	 * 
	 * @param WorkVO, request, historyVO
	 * @return List<WorkVO>
	 */
	@RequestMapping(value = "/backup/getWorkList.do")
	@ResponseBody
	public List<WorkVO> rmanDataList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		List<WorkVO> resultSet = null;

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			if (workVO.getBck_bsn_dscd().equals("TC000201")) {
				historyVO.setExe_dtl_cd("DX-T0021_01");
			} else {
				historyVO.setExe_dtl_cd("DX-T0021_03");
			}
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		try {
			resultSet = backupService.selectWorkList(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return resultSet;
	}

	/**
	 * Backup Log View page
	 * 
	 * @param WorkVO, historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/backup/workLogList.do")
	public ModelAndView rmanLogList(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		int db_svr_id = workVO.getDb_svr_id();
		// 유저 디비서버 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);

		ModelAndView mv = new ModelAndView();

		// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
		if (dbSvrAut.get(0).get("bck_hist_aut_yn").equals("N")) {
			mv.setViewName("error/autError");
		} else {
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0026");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setUsr_id(usr_id);

				mv.addObject("dbList", backupService.selectDbList(workVO));
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			// Get DBServer Name
			try {
				mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if (request.getParameter("tabGbn") != null) {
				mv.addObject("tabGbn", request.getParameter("tabGbn"));
			}

			// pgbackrest 권한에 따른 object 추가
			Properties props = new Properties();
			try {
				props.load(new FileInputStream(
						ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));
				mv.addObject("pgbackrest", props.getProperty("pgbackrest.useyn"));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			mv.addObject("db_svr_id", workVO.getDb_svr_id());
			mv.setViewName("backup/workLogList");
		}
		return mv;
	}

	/**
	 * Backup Log List
	 * 
	 * @param WorkLogVO, request, historyVO
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup/selectWorkLogList.do")
	@ResponseBody
	public List<WorkLogVO> selectWorkLogList(@ModelAttribute("workLogVo") WorkLogVO workLogVO,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) throws Exception {

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			if (workLogVO.getBck_bsn_dscd().equals("TC000201")) {
				historyVO.setExe_dtl_cd("DX-T0026_01");
			}else if(workLogVO.getBck_bsn_dscd().equals("TC000205")) {
				historyVO.setExe_dtl_cd("DX-T0021_05");
			}else {
				historyVO.setExe_dtl_cd("DX-T0026_02");
			}
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		List<WorkLogVO> resultSet = null;
		resultSet = backupService.selectWorkLogList(workLogVO);

		return resultSet;
	}

	/**
	 * Rman Backup Registration View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/rmanRegForm.do")
	public ModelAndView rmanRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0022");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}

	/**
	 * Backrest Backup Registration View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/backrestRegForm.do")
	public ModelAndView backrestRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		
		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}

	/**
	 * Backrest Backup Agent Info Select
	 * 
	 * @param WorkVO, request, dbServerVO, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/backup/backrestAgentList.do")
	public ModelAndView backrestAgentList(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		try {
			mv.addObject("agent_list", backupService.selectAgentInfo(dbServerVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}

	/**
	 * Backrest Backup Registration Custom View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/backrestRegCustomForm.do")
	public ModelAndView backrestRegCustomForm(@ModelAttribute("workVo") WorkVO workVO,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0022");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		try {
			mv.addObject("backrest_cus_opt", backupService.selectBackrestCstOpt(dbServerVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}

	/**
	 * Dump Backup Registration View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/dumpRegForm.do")
	public ModelAndView dumpRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0024");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		// Get DB ROLE List
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);

			int db_svr_id = workVO.getDb_svr_id();
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			// serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			ClientInfoCmmn cic = new ClientInfoCmmn();

			mv.addObject("roleList", cic.role_List(serverObj, IP, PORT));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());

		return mv;
	}

	/**
	 * Rman Backup Work Insert
	 * 
	 * @param historyVO, dbServerVO, workVO, response, request
	 * @return String
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/workRmanWrite.do")
	@ResponseBody
	public String workRmanWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("workVO") WorkVO workVO,
			HttpServletResponse response, HttpServletRequest request) throws IOException {
		String result = "S";
		WorkVO resultSet = null;

		try {
			Map<String, Object> initResult = new HashMap<String, Object>();
			AgentInfoVO vo = new AgentInfoVO();
			List<DbServerVO> ipResult = null;

			String bck_pth = request.getParameter("bck_pth");
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			// 백업 WORK등록시 백업 경로 INIT
			ipResult = (List<DbServerVO>) cmmnServerInfoService.selectAllIpadrList(db_svr_id);

			for (int i = 0; i < ipResult.size(); i++) {
				vo.setIPADR(ipResult.get(i).getIpadr());
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				String IP = ipResult.get(i).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				ClientInfoCmmn cic = new ClientInfoCmmn();
				initResult = cic.setInit(IP, PORT, bck_pth);
			}
		} catch (Exception e) {
			result = "I";
			e.printStackTrace();
		}

		// WORK 명 중복체크
		try {
			String wrk_nm = request.getParameter("wrk_nm");
			int wrkNmCheck = backupService.wrk_nmCheck(wrk_nm);

			if (wrkNmCheck > 0) {
				result = "F";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 중복체크 - 사용가능 wrk_nm
		if ("S".equals(result)) {
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0022_01");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setFrst_regr_id(usr_id);

				// 작업 정보등록
				backupService.insertWork(workVO);
			} catch (Exception e) {
				e.printStackTrace();
				result = "D";
			}

			// Get Last wrk_id
			if (result.equals("S")) {
				try {
					resultSet = backupService.lastWorkId();
					workVO.setWrk_id(resultSet.getWrk_id());
				} catch (Exception e) {
					e.printStackTrace();
					result = "D";
				}
			}

			if (result.equals("S")) {
				if (resultSet != null) {
					try {
						backupService.insertRmanWork(workVO);
					} catch (Exception e) {
						e.printStackTrace();
						result = "D";
					}
				}
			}
		} else {
			return result;
		}

		return result;
	}

	/**
	 * Backrest Backup Work Insert
	 * 
	 * @param historyVO, dbServerVO, workVO, response, request, paramMap
	 * @return String
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/workBackrestWrite.do")
	@ResponseBody
	public String workBackrestWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("workVO") WorkVO workVO,
			HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
			throws IOException {
		String result = "S";
		String remoteGbn = request.getParameter("backrest_gbn");
		WorkVO resultSet = null;

		// WORK 명 중복체크
		try {
			String wrk_nm = request.getParameter("wrk_nm");
			int wrkNmCheck = backupService.wrk_nmCheck(wrk_nm);

			if (wrkNmCheck > 0) {
				result = "F";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 중복체크 - 사용가능 wrk_nm
		if ("S".equals(result)) {
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
//				historyVO.setExe_dtl_cd("DX-T0022_01");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setFrst_regr_id(usr_id);

				// 작업 정보등록
				backupService.insertWork(workVO);
			} catch (Exception e) {
				e.printStackTrace();
				result = "D";
			}

			// Get Last wrk_id
			if (result.equals("S")) {
				try {
					resultSet = backupService.lastWorkId();
					workVO.setWrk_id(resultSet.getWrk_id());
				} catch (Exception e) {
					e.printStackTrace();
					result = "D";
				}
			}

			if (result.equals("S") && !remoteGbn.equals("remote")) {
				try {
					if(request.getParameter("master_gbn").toString().equals("M")) {
						createBackrestConfig(workVO, dbServerVO, request, paramMap, null);
					}else {
						List<DbServerVO> masterServer = backupService.selectMasterServer(dbServerVO);
						
						DbServerVO masterDbServerVO = new DbServerVO();
						masterDbServerVO.setPgdata_pth(masterServer.get(0).getPgdata_pth());
						masterDbServerVO.setPortno(masterServer.get(0).getPortno());
						masterDbServerVO.setIpadr(masterServer.get(0).getIpadr());
						masterDbServerVO.setSvr_spr_usr_id(masterServer.get(0).getSvr_spr_usr_id());
						
						createBackrestConfig(workVO, dbServerVO, request, paramMap, masterDbServerVO);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else {
				if(request.getParameter("master_gbn").toString().equals("M")) {	
					workVO.setRemote_use("Y");
					String file = createBackrestRemoteFile(workVO, dbServerVO, request, paramMap, null);
					
					String remoteMapStr = paramMap.get("remote_map").toString();

					ObjectMapper mapper = new ObjectMapper();
					Map<String,Object> remoteMap = mapper.readValue(remoteMapStr, Map.class);
								
					Map<String, Object> serverInfo = new HashMap<>();
								
					String bck_pth = request.getParameter("bck_pth");
					String chk = bck_pth.substring(bck_pth.length()-1, bck_pth.length());
					if(chk.equals("/")) {
						bck_pth = bck_pth.substring(0, bck_pth.length()-1);
						workVO.setBck_pth(bck_pth);
					}
					
					String log_file_pth = request.getParameter("log_file_pth");
					String chk2 = log_file_pth.substring(log_file_pth.length()-1, log_file_pth.length());
					if(chk2.equals("/")) {
						log_file_pth = log_file_pth.substring(0, log_file_pth.length()-1);
						workVO.setLog_file_pth(log_file_pth);
					}
					
					serverInfo.put("ip", remoteMap.get("remote_ip"));
					serverInfo.put("port", remoteMap.get("remote_port"));
					serverInfo.put("usr", remoteMap.get("remote_usr"));
					serverInfo.put("pw", remoteMap.get("remote_pw"));
					serverInfo.put("pth", "/home/remote/pgbackrest/config/" + request.getParameter("wrk_nm") + ".conf");

					CmmnUtil cu = new CmmnUtil();
					
					cu.createBackrestConf(serverInfo, file);
					
					workVO.setRemote_ip(serverInfo.get("ip").toString());
					workVO.setRemote_port(serverInfo.get("port").toString());
					workVO.setRemote_usr(serverInfo.get("usr").toString());
					workVO.setRemote_pw(serverInfo.get("pw").toString());
					
				}else {
					try {
						workVO.setRemote_use("Y");
						List<DbServerVO> masterServer = backupService.selectMasterServer(dbServerVO);
						
						DbServerVO masterDbServerVO = new DbServerVO();
						masterDbServerVO.setPgdata_pth(masterServer.get(0).getPgdata_pth());
						masterDbServerVO.setPortno(masterServer.get(0).getPortno());
						masterDbServerVO.setIpadr(masterServer.get(0).getIpadr());
						masterDbServerVO.setSvr_spr_usr_id(masterServer.get(0).getSvr_spr_usr_id());
						
						String file = createBackrestRemoteFile(workVO, dbServerVO, request, paramMap, masterDbServerVO);
						
						String remoteMapStr = paramMap.get("remote_map").toString();

						ObjectMapper mapper = new ObjectMapper();
						Map<String,Object> remoteMap = mapper.readValue(remoteMapStr, Map.class);
									
						Map<String, Object> serverInfo = new HashMap<>();
									
						serverInfo.put("ip", remoteMap.get("remote_ip"));
						serverInfo.put("port", remoteMap.get("remote_port"));
						serverInfo.put("usr", remoteMap.get("remote_usr"));
						serverInfo.put("pw", remoteMap.get("remote_pw"));
						serverInfo.put("pth", "/home/remote/pgbackrest/config/" + request.getParameter("wrk_nm") + ".conf");
						
						CmmnUtil cu = new CmmnUtil();
						
						cu.createBackrestConf(serverInfo, file);
						
						workVO.setRemote_ip(serverInfo.get("ip").toString());
						workVO.setRemote_port(serverInfo.get("port").toString());
						workVO.setRemote_usr(serverInfo.get("usr").toString());
						workVO.setRemote_pw(serverInfo.get("pw").toString());
						
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			if (result.equals("S")) {
				if (resultSet != null) {
					try {
						backupService.insertBackrestWork(workVO);
					} catch (Exception e) {
						e.printStackTrace();
						result = "D";
					}
				}
			}

		} else {
			return result;
		}

		return result;
	}

	/**
	 * Dump Backup Work Insert
	 * 
	 * @param WorkVO, historyVO, response, request
	 * @return String
	 * @throws IOException
	 */
	@RequestMapping(value = "/popup/workDumpWrite.do")
	@ResponseBody
	public String workDumpWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request)
			throws IOException {
		String result = "S";
		WorkVO resultSet = null;

		// work 명 중복체크
		try {
			String wrk_nm = request.getParameter("wrk_nm");
			int wrkNmCheck = backupService.wrk_nmCheck(wrk_nm);

			if (wrkNmCheck > 0) {
				result = "F";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		if ("F".equals(result)) {
			return result;
		}

		// 중복체크 - 사용가능 wrk_nm
		if ("S".equals(result)) {
			// Data Insert
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0024_01");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setFrst_regr_id(usr_id);

				// 작업 정보등록
				backupService.insertWork(workVO);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				result = "D";
			}

			// Get Last wrk_id
			if (result.equals("S")) {
				try {
					resultSet = backupService.lastWorkId();
					workVO.setWrk_id(resultSet.getWrk_id());

				} catch (Exception e) {
					result = "D";
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			if (result.equals("S")) {
				try {
					backupService.insertDumpWork(workVO);
				} catch (Exception e) {
					result = "F";
					e.printStackTrace();
				}
			}

			// Get Last bck_wrk_id
			if (result.equals("S")) {
				try {
					resultSet = backupService.lastBckWorkId();
				} catch (Exception e) {
					result = "D";
					e.printStackTrace();
				}
			}
		}

		return Integer.toString(resultSet.getBck_wrk_id());

	}

	/**
	 * Backup Work Option insert
	 * 
	 * @param WorkOptVO, request
	 * @return
	 */
	@RequestMapping(value = "/popup/workOptWrite.do")
	@ResponseBody
	public void workOptWrite(@ModelAttribute("WorkOptVO") WorkOptVO workOptVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		workOptVO.setFrst_regr_id(usr_id);
		try {
			backupService.insertWorkOpt(workOptVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Rman Backup Reregistration View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/rmanRegReForm.do")
	public ModelAndView rmanRegReForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0023");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		// Get Rman Backup Information
		try {
			workVO.setBck_bsn_dscd("TC000201");
			mv.addObject("workInfo", backupService.selectWorkList(workVO));
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// Get Incoding Code List
		try {
			PageVO pageVO = new PageVO();
			pageVO.setGrp_cd("TC0005");
			pageVO.setSearchCondition("0");
			List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			mv.addObject("incodeList", cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());
		mv.addObject("wrk_id", workVO.getWrk_id());
		mv.addObject("bck_wrk_id", workVO.getBck_wrk_id());

		return mv;
	}
	
	/**
	 * Backrest Backup Reregistration View page
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/backrestRegReForm.do")
	public ModelAndView backrestRegReForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		String result = null;

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0023");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		String backrest_gbn = request.getParameter("backrest_gbn");
		
		workVO.setBck_bsn_dscd("TC000205");

		try {
			
		List<WorkVO> selectedWork = backupService.selectWorkList(workVO);
		List<DbServerVO> dbServerVO = backupService.selectBckServer(selectedWork.get(0));
		mv.addObject("workInfo", selectedWork);
		mv.addObject("bckSvrInfo", dbServerVO);
		
		// Get Backrest Backup Information (REMOTE / ELSE)
		if(backrest_gbn.equals("remote")) {
			CmmnUtil cu = new CmmnUtil();
			Map<String, Object> serverInfo = new HashMap<>();
			
			String ip = request.getParameter("remote_ip");
			String port= request.getParameter("remote_port");
			String usr = request.getParameter("remote_usr");
			String pw = request.getParameter("remote_pw");
			
			serverInfo.put("ip", ip);
			serverInfo.put("port", port);
			serverInfo.put("usr", usr);
			serverInfo.put("pw", pw);
			mv.addObject("remote_map", serverInfo);
			
			JSONObject cmdObj = new JSONObject();
			
			String wrkNm = selectedWork.get(0).getWrk_nm() + ".conf";
			
			cmdObj.put("type", "conf");
			cmdObj.put("bck_filenm", wrkNm);
			cmdObj.put("usr", usr);
			
			String cmd = cu.createBackrestCmd(cmdObj);
			
			result = cu.executeBackrest(serverInfo, cmd, "backrest", null).get("RESULT_DATA").toString();
			
		}else {
			try {

				ClientInfoCmmn cic = new ClientInfoCmmn();
				JSONObject resultObj = new JSONObject();

				try {
					AgentInfoVO vo = new AgentInfoVO();
					vo.setIPADR(dbServerVO.get(0).getIpadr());
					AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

					String ip = dbServerVO.get(0).getIpadr();
					int port = agentInfo.getSOCKET_PORT();

					JSONObject jObj = new JSONObject();
					jObj.put(ClientProtocolID.WRK_NM, selectedWork.get(0).getWrk_nm());

					resultObj = cic.selectBackrestConf(ip, port, jObj);

					result = (String) resultObj.get(ClientProtocolID.RESULT_DATA);

				} catch (Exception e) {
					e.printStackTrace();
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		BufferedReader br = new BufferedReader(new StringReader(result));

		boolean readFromCustomLine = false;
		Map<String, Object> customMap = new HashMap<String, Object>();
		
		String gbn = "";
		String fileContent;
		try {
			while ((fileContent = br.readLine()) != null) {
				if (fileContent.contains("process-max")) {
					String processMaxLine = fileContent;
					String processMaxValue = processMaxLine.replaceAll("process-max=", "");

					mv.addObject("prcs_max_mod", processMaxValue);
				}

				if (fileContent.contains("compress-type")) {
					String compressTypeLine = fileContent;
					String compressTypeValue = compressTypeLine.replaceAll("compress-type=", "");

					mv.addObject("cps_type_mod", compressTypeValue);
				}
				
				if (fileContent.contains("#repo1-gbn=")) {
					String repoGbnLine = fileContent;
					String repoGbnValue = repoGbnLine.replaceAll("#repo1-gbn=", "");

					gbn = repoGbnValue;
				}
				
				if(gbn.equals("cloud")) {
					if (fileContent.contains("repo1-type=")) {
						String repoTypeLine = fileContent;
						String repoTypeValue = repoTypeLine.replaceAll("repo1-type=", "");

						mv.addObject("repo_type_mod", repoTypeValue);
					}
					
					if (fileContent.contains("repo1-s3-bucket=")) {
						String s3BucketLine = fileContent;
						String s3BucketValue = s3BucketLine.replaceAll("repo1-s3-bucket=", "");

						mv.addObject("s3_bucket_mod", s3BucketValue);
					}
					
					if (fileContent.contains("repo1-s3-endpoint=")) {
						String s3EndPointLine = fileContent;
						String s3EndPointValue = s3EndPointLine.replaceAll("repo1-s3-endpoint=", "");

						mv.addObject("s3_endPoint_mod", s3EndPointValue);
					}
					
					if (fileContent.contains("repo1-s3-key=")) {
						String s3KeytLine = fileContent;
						String s3KeyValue = s3KeytLine.replaceAll("repo1-s3-key=", "");

						mv.addObject("s3_key_mod", s3KeyValue);
					}
					
					if (fileContent.contains("repo1-s3-key-secret=")) {
						String s3SecretKeyLine = fileContent;
						String s3SecretKeyValue = s3SecretKeyLine.replaceAll("repo1-s3-key-secret=", "");

						mv.addObject("s3_secretKey_mod", s3SecretKeyValue);
					}
					
					if (fileContent.contains("repo1-s3-region=")) {
						String s3RegionLine = fileContent;
						String s3RegionValue = s3RegionLine.replaceAll("repo1-s3-region=", "");

						mv.addObject("s3_region_mod", s3RegionValue);
					}
					
					if (fileContent.contains("repo1-path")) {
						String s3PathLine = fileContent;
						String s3PathValue = s3PathLine.replaceAll("repo1-path=", "");

						mv.addObject("s3_path_mod", s3PathValue);
					}
				}

				if (readFromCustomLine) {
					String customLine = fileContent;
					String customSplit[] = customLine.split("=");

					customMap.put(customSplit[0], customSplit[1]);
				}

				if (fileContent.startsWith("#[custom]")) {
					readFromCustomLine = true;
				}
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		mv.addObject("custom_map", customMap);
		
		}catch(Exception e) {
			
		}

		// Get Incoding Code List
		try {
			PageVO pageVO = new PageVO();
			pageVO.setGrp_cd("TC0005");
			pageVO.setSearchCondition("0");
			List<CmmnCodeVO> cmmnCodeVO = cmmnCodeDtlService.cmmnDtlCodeSearch(pageVO);
			mv.addObject("incodeList", cmmnCodeVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());
		mv.addObject("wrk_id", workVO.getWrk_id());
		mv.addObject("bck_wrk_id", workVO.getBck_wrk_id());

		return mv;
	}

	/**
	 * Dump백업 수정팝업 페이지를 반환한다.
	 * 
	 * @param WorkVO, request, historyVO
	 * @return ModelAndView
	 */
	@SuppressWarnings({ "null", "unchecked" })
	@RequestMapping(value = "/popup/dumpRegReForm.do")
	public ModelAndView dumpRegReForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView("jsonView");

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0025");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		// Work info
		workVO.setBck_bsn_dscd("TC000202");
		try {
			mv.addObject("workInfo", backupService.selectWorkList(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Work Option List
		try {
			mv.addObject("workOptInfo", backupService.selectWorkOptList(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Work Object List
		try {
			mv.addObject("workObjList", backupService.selectWorkObj(workVO));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Server Role List
		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);

			int db_svr_id = workVO.getDb_svr_id();
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = DbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			ClientInfoCmmn cic = new ClientInfoCmmn();
			mv.addObject("roleList", cic.role_List(serverObj, IP, PORT));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", workVO.getDb_svr_id());
		mv.addObject("bck_wrk_id", workVO.getBck_wrk_id());
		mv.addObject("wrk_id", workVO.getWrk_id());

//		mv.setViewName("popup/dumpRegReForm");
		return mv;
	}

	/**
	 * Rman Backup Work Update
	 * 
	 * @param historyVO, workVO, response, request
	 * @return String
	 * @throws IOException
	 */
	@RequestMapping(value = "/popup/workRmanReWrite.do")
	@ResponseBody
	public String workRmanReWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request)
			throws IOException {
		String result = "S";

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0023_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 백업 WORK 수정 시 백업 경로 INIT
		try {
			Map<String, Object> initResult = new HashMap<String, Object>();
			AgentInfoVO vo = new AgentInfoVO();
			List<DbServerVO> ipResult = null;

			String bck_pth = workVO.getBck_pth();
			int db_svr_id = workVO.getDb_svr_id();

			ipResult = (List<DbServerVO>) cmmnServerInfoService.selectAllIpadrList(db_svr_id);

			for (int i = 0; i < ipResult.size(); i++) {
				vo.setIPADR(ipResult.get(i).getIpadr());
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
				String IP = ipResult.get(i).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				ClientInfoCmmn cic = new ClientInfoCmmn();
				initResult = cic.setInit(IP, PORT, bck_pth);
			}
		} catch (Exception e) {
			result = "I";
			e.printStackTrace();
		}

		// Rman 업데이트
		if (result.equals("S")) {
			try {
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();

				workVO.setLst_mdfr_id(usr_id);
				backupService.updateRmanWork(workVO);

			} catch (Exception e) {
				e.printStackTrace();
				result = "D";
			}
		}

		return result;
	}

	/**
	 * Backrest Backup Work Update
	 * 
	 * @param historyVO, workVO, dbServerVO, response, request, paramMap
	 * @return String
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/popup/workBackrestReWrite.do")
	@ResponseBody
	public String workBackrestReWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVO") WorkVO workVO, @ModelAttribute("dbServerVO") DbServerVO dbServerVO,
			HttpServletResponse response, HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
			throws IOException {
		String result = "S";
		String gbn = request.getParameter("backrest_gbn");
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
//			historyVO.setExe_dtl_cd("DX-T0023_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}

		// Backrest 업데이트
		if (result.equals("S")) {
			try {
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();

				workVO.setLst_mdfr_id(usr_id);
				backupService.updateBackrestWork(workVO);

			} catch (Exception e) {
				e.printStackTrace();
				result = "D";
				return result;
			}
		}

		if (result.equals("S") && ! gbn.equals("remote")) {
			deleteBackrestConfig(workVO, dbServerVO);
			
			try {
				if(request.getParameter("master_gbn").toString().equals("M")) {
					createBackrestConfig(workVO, dbServerVO, request, paramMap, null);
				}else {
					List<DbServerVO> masterServer = backupService.selectMasterServer(dbServerVO);
					DbServerVO masterDbServerVO = new DbServerVO();
					masterDbServerVO.setPgdata_pth(masterServer.get(0).getPgdata_pth());
					masterDbServerVO.setPortno(masterServer.get(0).getPortno());
					masterDbServerVO.setIpadr(masterServer.get(0).getIpadr());
					masterDbServerVO.setSvr_spr_usr_id(masterServer.get(0).getSvr_spr_usr_id());
					
					createBackrestConfig(workVO, dbServerVO, request, paramMap, masterDbServerVO);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		}else {
			if(request.getParameter("master_gbn").toString().equals("M")) {	
				workVO.setRemote_use("Y");
				String file = createBackrestRemoteFile(workVO, dbServerVO, request, paramMap, null);
				
				String remoteMapStr = paramMap.get("remote_map").toString();

				ObjectMapper mapper = new ObjectMapper();
				Map<String,Object> remoteMap = mapper.readValue(remoteMapStr, Map.class);
							
				Map<String, Object> serverInfo = new HashMap<>();
							
				String bck_pth = request.getParameter("bck_pth");
				String chk = bck_pth.substring(bck_pth.length()-1, bck_pth.length());
				if(chk.equals("/")) {
					bck_pth = bck_pth.substring(0, bck_pth.length()-1);
					workVO.setBck_pth(bck_pth);
				}
				
				String log_file_pth = request.getParameter("log_file_pth");
				String chk2 = log_file_pth.substring(log_file_pth.length()-1, log_file_pth.length());
				if(chk2.equals("/")) {
					log_file_pth = log_file_pth.substring(0, log_file_pth.length()-1);
					workVO.setLog_file_pth(log_file_pth);
				}
				
				serverInfo.put("ip", remoteMap.get("remote_ip"));
				serverInfo.put("port", remoteMap.get("remote_port"));
				serverInfo.put("usr", remoteMap.get("remote_usr"));
				serverInfo.put("pw", remoteMap.get("remote_pw"));
				serverInfo.put("pth", "/home/remote/pgbackrest/config/" + request.getParameter("wrk_nm") + ".conf");

				CmmnUtil cu = new CmmnUtil();
				
				cu.createBackrestConf(serverInfo, file);
				
				workVO.setRemote_ip(serverInfo.get("ip").toString());
				workVO.setRemote_port(serverInfo.get("port").toString());
				workVO.setRemote_usr(serverInfo.get("usr").toString());
				workVO.setRemote_pw(serverInfo.get("pw").toString());
				
			}else {
				try {
					workVO.setRemote_use("Y");
					List<DbServerVO> masterServer = backupService.selectMasterServer(dbServerVO);
					
					DbServerVO masterDbServerVO = new DbServerVO();
					masterDbServerVO.setPgdata_pth(masterServer.get(0).getPgdata_pth());
					masterDbServerVO.setPortno(masterServer.get(0).getPortno());
					masterDbServerVO.setIpadr(masterServer.get(0).getIpadr());
					masterDbServerVO.setSvr_spr_usr_id(masterServer.get(0).getSvr_spr_usr_id());
					
					String file = createBackrestRemoteFile(workVO, dbServerVO, request, paramMap, masterDbServerVO);
					
					String remoteMapStr = paramMap.get("remote_map").toString();

					ObjectMapper mapper = new ObjectMapper();
					Map<String,Object> remoteMap = mapper.readValue(remoteMapStr, Map.class);
								
					Map<String, Object> serverInfo = new HashMap<>();
								
					serverInfo.put("ip", remoteMap.get("remote_ip"));
					serverInfo.put("port", remoteMap.get("remote_port"));
					serverInfo.put("usr", remoteMap.get("remote_usr"));
					serverInfo.put("pw", remoteMap.get("remote_pw"));
					serverInfo.put("pth", "/home/remote/pgbackrest/config/" + request.getParameter("wrk_nm") + ".conf");
					
					CmmnUtil cu = new CmmnUtil();
					
					cu.createBackrestConf(serverInfo, file);
					
					workVO.setRemote_ip(serverInfo.get("ip").toString());
					workVO.setRemote_port(serverInfo.get("port").toString());
					workVO.setRemote_usr(serverInfo.get("usr").toString());
					workVO.setRemote_pw(serverInfo.get("pw").toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		return result;
	}

	/**
	 * Dump Backup Work Update
	 * 
	 * @param historyVO, workVO, response, request
	 * @return String
	 * @throws IOException
	 */
	@RequestMapping(value = "/popup/workDumpReWrite.do")
	@ResponseBody
	public String workDumpReWrite(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request)
			throws IOException {
		String result = "F";
		int bck_wrk_id = workVO.getBck_wrk_id();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0025_01");
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			workVO.setLst_mdfr_id(usr_id);
			backupService.updateDumpWork(workVO);

			result = "S";

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}

		// work option delete
		try {
			backupService.deleteWorkOpt(bck_wrk_id);

			result = "S";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}

		// work object delete
		try {
			backupService.deleteWorkObj(bck_wrk_id);

			result = "S";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}

		return result;
	}

	/**
	 * Work scheduleCheck
	 * 
	 * @param wrk_id
	 * @return String
	 * @throws IOException
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/scheduleCheck.do")
	@ResponseBody
	public int scheduleCheck(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO)
			throws IOException, ParseException {
		// Transaction
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		int totCnt = 0;
		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0021_02");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			e2.printStackTrace();
		}

		String wrk_id_Rows = request.getParameter("wrk_id_List").toString().replaceAll("&quot;", "\"");
		JSONArray wrk_ids = (JSONArray) new JSONParser().parse(wrk_id_Rows);
		List<String> ids = new ArrayList<String>();
		HashMap<String, Object> paramvalue = new HashMap<String, Object>();

		try {
			for (int i = 0; i < wrk_ids.size(); i++) {
				ids.add(wrk_ids.get(i).toString());
			}
			paramvalue.put("work_id", ids);

			totCnt = backupService.selectScheduleCheckCnt(paramvalue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return totCnt;

	}

	/**
	 * Work Delete
	 * 
	 * @param WorkVO, response, request, historyVO
	 * @return boolean
	 * @throws IOException
	 * @throws ParseException
	 */
	@RequestMapping(value = "/popup/workDelete.do")
	@ResponseBody
	public boolean workDelete(@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response,
			HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO)
			throws IOException, ParseException {
		boolean result = false;

		// Transaction
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		String bck_wrk_id_Rows = request.getParameter("bck_wrk_id_List").toString().replaceAll("&quot;", "\"");
		JSONArray bck_wrk_ids = (JSONArray) new JSONParser().parse(bck_wrk_id_Rows);

		String wrk_id_Rows = request.getParameter("wrk_id_List").toString().replaceAll("&quot;", "\"");
		JSONArray wrk_ids = (JSONArray) new JSONParser().parse(wrk_id_Rows);
		
		String backupGbn = request.getParameter("backup_gbn").toString();
		
		String wrk_bck_server_Rows = request.getParameter("wrk_bck_server_list").toString().replaceAll("&quot;", "\"");
		JSONArray wrk_bck_servers = (JSONArray) new JSONParser().parse(wrk_bck_server_Rows);
		
		String bck_filenm_Rows = request.getParameter("bck_filenm_list").toString().replaceAll("&quot;", "\"");
		JSONArray bck_filenms = (JSONArray) new JSONParser().parse(bck_filenm_Rows);
		
		String wrk_bck_gbn_list = request.getParameter("wrk_bck_gbn_list").toString().replaceAll("&quot;", "\"");
		JSONArray gbns = (JSONArray) new JSONParser().parse(wrk_bck_gbn_list);
		
		JSONArray ports = null;
		JSONArray usrs = null;
		JSONArray pws = null;
		
		for (int i = 0; i < bck_wrk_ids.size(); i++) {
			if(gbns.get(i).equals("remote")) {
				String wrk_bck_server_port_list = request.getParameter("wrk_bck_server_port_list").toString().replaceAll("&quot;", "\"");
				ports = (JSONArray) new JSONParser().parse(wrk_bck_server_port_list);
				
				String wrk_bck_server_usr_list = request.getParameter("wrk_bck_server_usr_list").toString().replaceAll("&quot;", "\"");
				usrs = (JSONArray) new JSONParser().parse(wrk_bck_server_usr_list);
				
				String wrk_bck_server_pw_list = request.getParameter("wrk_bck_server_pw_list").toString().replaceAll("&quot;", "\"");
				pws = (JSONArray) new JSONParser().parse(wrk_bck_server_pw_list);	
			}
		}
		
		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0021_02");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			e2.printStackTrace();
		}

		try {
			for (int j = 0; j < gbns.size(); j++) {
				if(gbns.get(j).toString().equals("remote")) {
					
					String wrk_bck_server = wrk_bck_servers.get(j).toString();
					String bck_filenm = bck_filenms.get(j).toString();
					String usr = usrs.get(j).toString();
					int port = Integer.parseInt(ports.get(j).toString());
					String pw = pws.get(j).toString();
										
					CmmnUtil cu = new CmmnUtil();
					JSONObject cmdObj = new JSONObject();
					
					cmdObj.put("type", "chk");
					cmdObj.put("usr", usrs.get(j).toString());
					cmdObj.put("bck_filenm", bck_filenm);
					
					String cmd = cu.createBackrestCmd(cmdObj);
					
					Map<String, Object> serverInfo = new HashMap<>();
					serverInfo.put("ip", wrk_bck_server);
					serverInfo.put("usr", usr);
					serverInfo.put("pw", pw);
					serverInfo.put("port", port);
					serverInfo.put("type", "backrest");
										
					String resultStr = cu.executeBackrest(serverInfo, cmd, "backrest", null).get("RESULT_DATA").toString();
					
					cmdObj.put("type", "remove");	
					System.out.println(cmdObj);
					cmd = cu.createBackrestCmd(cmdObj);
					
					if(resultStr.equals("S")) {
						cu.executeBackrest(serverInfo, cmd, "backrest", null);
						result = true;
					}else {
						result = false;
					}
				}
			}
			
			for (int i = 0; i < bck_wrk_ids.size(); i++) {
				int bck_wrk_id = Integer.parseInt(bck_wrk_ids.get(i).toString());
				int wrk_id = Integer.parseInt(wrk_ids.get(i).toString());

				if(backupGbn.equals("del_backrest")) {
					ClientInfoCmmn cic = new ClientInfoCmmn();
					JSONObject result2 = new JSONObject();
					
					String wrk_bck_server = wrk_bck_servers.get(i).toString();
					String bck_filenm = bck_filenms.get(i).toString();
					
					try {
							AgentInfoVO vo = new AgentInfoVO();
							vo.setIPADR(wrk_bck_server);
							AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

							int port = agentInfo.getSOCKET_PORT();
							JSONObject jObj = new JSONObject();
							
							jObj.put(ClientProtocolID.BCK_FILENM, bck_filenm);
							
							result2 = cic.deleteBackrestConf(wrk_bck_server, port, jObj);
						
					} catch (Exception e) {
						e.printStackTrace();
					}
					
				}
				// WORK 옵션 삭제
				backupService.deleteWorkOpt(bck_wrk_id);
				// WORK 오브젝트 삭제
				backupService.deleteWorkObj(bck_wrk_id);
				// 백업작업 삭제
				backupService.deleteBckWork(bck_wrk_id);
				// 전체 작업 삭제
				backupService.deleteWork(wrk_id);
				
				result = true;
			}

			
		} catch (Exception e) {
			e.printStackTrace();
			txManager.rollback(status);
		} finally {
			txManager.commit(status);
		}
		return result;
	}

	/**
	 * Object insert
	 * 
	 * @param WorkObjVO
	 * @return
	 */
	@RequestMapping(value = "/popup/workObjWrite.do")
	@ResponseBody
	public void workObjWrite(@ModelAttribute("WorkObjVO") WorkObjVO workObjVO, HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();

		try {
			workObjVO.setFrst_regr_id(usr_id);
			backupService.insertWorkObj(workObjVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Object delete
	 * 
	 * @param WorkVO
	 * @return
	 */
	@RequestMapping(value = "/popup/workObjDelete.do")
	@ResponseBody
	public void workObjDelete(@ModelAttribute("WorkVO") WorkVO workVO, HttpServletResponse response) {
		try {
			// backupService.deleteWorkObj(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * work명을 중복 체크한다.
	 * 
	 * @param wrk_nm
	 * @return String
	 * @throws
	 */
	@RequestMapping(value = "/wrk_nmCheck.do")
	public @ResponseBody String wrk_nmCheck(@RequestParam("wrk_nm") String wrk_nm) {
		try {
			int resultSet = backupService.wrk_nmCheck(wrk_nm);
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
	 * 스케줄러 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/schedulerView.do")
	public ModelAndView schedulerView(@ModelAttribute("workVO") WorkVO workVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String db_svr_nm = request.getParameter("db_svr_nm");

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		dbSvrAut = cu.selectUserDBSvrAutList(dbAuthorityService, db_svr_id);
		ModelAndView mv = new ModelAndView();
		List<DbVO> resultSet = null;

		try {
			if (dbSvrAut.get(0).get("policy_change_his_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0051");
				accessHistoryService.insertHistory(historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				workVO.setDb_svr_id(db_svr_id);
				workVO.setUsr_id(usr_id);

				resultSet = backupService.selectDbList(workVO);

				SimpleDateFormat frm = new SimpleDateFormat("yyyyMMdd");
				Calendar cal = Calendar.getInstance();
				String end_date = frm.format(cal.getTime());

				mv.addObject("month", end_date);

				mv.addObject("dbList", resultSet);
				mv.addObject("db_svr_id", db_svr_id);
				mv.addObject("db_svr_nm", db_svr_nm);
				mv.setViewName("functions/scheduler/schedulerView");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 백업스케줄 리스트(주별)
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBckSchedule.do")
	@ResponseBody
	public List<Map<String, Object>> selectBckSchedule(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) {

		List<Map<String, Object>> result = null;
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			result = backupService.selectBckSchedule(db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 백업스케줄 리스트(월별)
	 * 
	 * @param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMonthBckSchedule.do")
	@ResponseBody
	public List<Map<String, Object>> selectMonthBckSchedule(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) {

		List<Map<String, Object>> result = null;
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			result = backupService.selectMonthBckSchedule(db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@RequestMapping(value = "/selectMonthBckScheduleSearch.do")
	@ResponseBody
	public List<Map<String, Object>> selectMonthBckScheduleSearch(HttpServletRequest request,
			HttpServletResponse response) {

		List<Map<String, Object>> result = null;
		try {
			HashMap<String, Object> paramvalue = new HashMap<String, Object>();
			paramvalue.put("datest", (String) request.getParameter("stdate"));
			paramvalue.put("dateed", (String) request.getParameter("eddate"));
			paramvalue.put("db_svr_id", (String) request.getParameter("db_svr_id"));

			result = backupService.selectMonthBckScheduleSearch(paramvalue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 백업스케줄 등록 뷰
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/bckScheduleInsertVeiw.do")
	public ModelAndView bckScheduleInsertVeiw(@ModelAttribute("workVO") WorkVO workVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<DbVO> resultSet = null;

		try {
			// 화면접근이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0052");
			accessHistoryService.insertHistory(historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			workVO.setDb_svr_id(db_svr_id);
			workVO.setUsr_id(usr_id);

			resultSet = backupService.selectDbList(workVO);

			mv.addObject("view_dbList", resultSet);
			mv.addObject("db_svr_id", db_svr_id);
			/* mv.setViewName("popup/bckScheduleInsertVeiw"); */

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 백업스케줄 상세정보
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/bckScheduleDtlVeiw.do")
	public ModelAndView bckScheduleDtlVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			String scd_id = request.getParameter("scd_id");
			// mv.setViewName("popup/bakupScheduleDtl");
			mv.addObject("scd_id", scd_id);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mv;
	}

	/**
	 * 백업 간편등록
	 * 
	 * @param WorkVO
	 * @return String
	 * @throws IOException
	 */
	@RequestMapping(value = "/popup/insertBckJob.do")
	public String insertBckJob(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("workVO") WorkVO workVO, HttpServletResponse response, HttpServletRequest request)
			throws IOException {
		String result = "S";

		String wrkid_result = "S";
		WorkVO resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			// historyVO.setExe_dtl_cd("DX-T0022_01");
			// historyVO.setMnu_id(25);
			// accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			workVO.setFrst_regr_id(usr_id);

			// 작업 정보등록
			backupService.insertWork(workVO);
			// backupService.insertRmanWork(workVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = "F";
		}

		// Get Last wrk_id
		if (result.equals("S")) {
			try {
				resultSet = backupService.lastWorkId();
				workVO.setWrk_id(resultSet.getWrk_id());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if (wrkid_result.equals("S")) {
			try {
				backupService.insertRmanWork(workVO);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return result;
	}

	/**
	 * PATH 정보 호출
	 * 
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws
	 */
	@RequestMapping(value = "/selectPathInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectPathInfo(HttpServletRequest request) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		Map<String, Object> pgdataResult = new HashMap<String, Object>();
		Map<String, Object> bckpathResult = new HashMap<String, Object>();
		JSONObject serverObj = new JSONObject();

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			ClientInfoCmmn cic = new ClientInfoCmmn();
			pgdataResult = cic.dbms_inforamtion(IP, PORT, serverObj);
			bckpathResult = cic.back_path_call(IP, PORT);

			list.add(pgdataResult);
			list.add(bckpathResult);

			// System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * RMAN 정보 호출(pg_rman show)
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws
	 */
	@RequestMapping(value = "/rmanShow.do")
	@ResponseBody
	public JSONObject rmanShow(HttpServletRequest request) {

		List<HashMap<String, String>> pgRmanInfo = null;
		JSONObject result = new JSONObject();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String cmd = request.getParameter("cmd");

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
			pgRmanInfo = cic.rmanShow(IP, PORT, cmd);

			if (pgRmanInfo != null) {
				result.put("data", pgRmanInfo);
			} else {
				result.put("data", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * rmanShowView page
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/rmanShowView.do")
	public ModelAndView rmanShowView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0026_03");
			accessHistoryService.insertHistory(historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String bck = request.getParameter("bck");

			mv.addObject("db_svr_id", db_svr_id);
			mv.addObject("bck", bck);

		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return mv;
	}

	/**
	 * dumpShowView page
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/dumpShowView.do")
	public ModelAndView dumpShowView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0026_04");
			accessHistoryService.insertHistory(historyVO);

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String bck = request.getParameter("bck");

			mv.addObject("db_svr_id", db_svr_id);
			mv.addObject("bck", bck);

		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		return mv;
	}

	/**
	 * DUMP 정보 호출(pg_dump show)
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws
	 */
	@RequestMapping(value = "/dumpShow.do")
	@ResponseBody
	public JSONObject dumpShow(HttpServletRequest request) {

		List<HashMap<String, String>> pgDumpInfo = null;
		JSONObject result = new JSONObject();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String cmd = request.getParameter("cmd");

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

			pgDumpInfo = cic.dumpShow(IP, PORT, cmd);

			if (pgDumpInfo != null) {
				result.put("data", pgDumpInfo);
			} else {
				result.put("data", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 백업 즉시 실행
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/backupImmediateExe.do")
	@ResponseBody
	public void backupImmediateExe(HttpServletRequest request) {
		Map<String, Object> result = null;

		String cmd = null;
		String bck_fileNm = "";

		List<Map<String, Object>> resultWork = null;

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
			String bck_bsn_dscd = request.getParameter("bck_bsn_dscd");

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			BackupImmediate bckImd = new BackupImmediate();
			resultWork = backupService.selectBckInfo(wrk_id);

			if (bck_bsn_dscd.equals("TC000201")) {
				cmd = bckImd.rmanBackupMakeCmd(resultWork, dbServerVO);

				System.out.println("RMAN 명령어@@@@@@@@@@@@@@@@@@@@");
				System.out.println(cmd);
			} else {
				List<Map<String, Object>> addOption = null;
				List<Map<String, Object>> addObject = null;

				Calendar calendar = Calendar.getInstance();
				java.util.Date date = calendar.getTime();
				String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));

				if (resultWork.get(0).get("file_fmt_cd_nm") != null && resultWork.get(0).get("file_fmt_cd_nm") != "") {
					if (resultWork.get(0).get("file_fmt_cd_nm").equals("tar")) {
						bck_fileNm = "eXperDB_" + resultWork.get(0).get("wrk_id") + "_" + today + ".tar";
					} else if (resultWork.get(0).get("file_fmt_cd_nm").equals("diretocry")) {
						bck_fileNm = "eXperDB_" + resultWork.get(0).get("wrk_id") + "_" + today;
					} else if (resultWork.get(0).get("file_fmt_cd_nm").equals("plain")) {
						bck_fileNm = "eXperDB_" + resultWork.get(0).get("wrk_id") + "_" + today + ".sql";
					} else {
						bck_fileNm = "eXperDB_" + resultWork.get(0).get("wrk_id") + "_" + today + ".dump";
					}
				}

				// 부가옵션 조회
				addOption = scheduleService.selectAddOption(wrk_id);
				// 오브젝트옵션 조회
				addObject = scheduleService.selectAddObject(wrk_id);

				cmd = bckImd.dumpBackupMakeCmd(dbServerVO, resultWork, addOption, addObject, bck_fileNm);

				System.out.println("DUMP 명령어@@@@@@@@@@@@@@@@@@@@");
				System.out.println(cmd);
			}

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.immediate(IP, PORT, cmd, resultWork, bck_fileNm);

			System.out.println("결과");
			System.out.println(result.get("RESULT_CODE"));
			System.out.println(result.get("ERR_CODE"));
			System.out.println(result.get("ERR_MSG"));

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * pgbackrest immediate start
	 * @param 
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/backrestStart.do")
	@ResponseBody
	public JSONObject pgbackrestLog(HttpServletRequest request) throws Exception{
	
		String IP = request.getParameter("db_svr_ipadr");
		
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(IP);
		AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

		int PORT = agentInfo.getSOCKET_PORT();

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		
		JSONObject jObj = new JSONObject();
		
		jObj.put(ClientProtocolID.LOG_PATH, request.getParameter("log_file_pth"));
		jObj.put(ClientProtocolID.BCK_FILENM, request.getParameter("bck_filenm"));
		jObj.put(ClientProtocolID.BCK_FILE_PTH, request.getParameter("bck_file_pth"));
		jObj.put(ClientProtocolID.WRK_NM, request.getParameter("wrk_nm"));
		jObj.put(ClientProtocolID.WRK_ID, request.getParameter("wrk_id"));
		jObj.put(ClientProtocolID.SERVER_IP, request.getParameter("db_svr_ipadr"));
		jObj.put(ClientProtocolID.DB_SVR_ID, request.getParameter("db_svr_id"));
		jObj.put(ClientProtocolID.BCK_OPT_CD, request.getParameter("bck_opt_cd"));
		jObj.put(ClientProtocolID.BCK_TYPE, request.getParameter("bck_opt_cd_nm"));
		jObj.put(ClientProtocolID.DB_ID, request.getParameter("db_id"));
		jObj.put(ClientProtocolID.USER_ID, usr_id);
		jObj.put(ClientProtocolID.WRK_TYPE, "");

		
		JSONObject result = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		
		result = cic.pgbackrestImmediateStart(IP, PORT, jObj);
		
		return result;
	}
	
	@RequestMapping(value = "/selectBackrestLog.do")
	@ResponseBody
	public JSONObject selectPgbackrestLog(HttpServletRequest request) throws Exception {
		
		String IP = request.getParameter("ipadr");
		
		AgentInfoVO vo = new AgentInfoVO();
		vo.setIPADR(IP);
		AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

		int PORT = agentInfo.getSOCKET_PORT();
				
		JSONObject jObj = new JSONObject();
		
		String pullPath = request.getParameter("log_path");
		
		String backrest_gbn = request.getParameter("backrest_gbn");
				
		jObj.put(ClientProtocolID.CMD_BACKUP_PATH, pullPath);
		
		JSONObject result = new JSONObject(); 

		if(backrest_gbn.equals("remote")) {
			String remote_ip = request.getParameter("remote_ip");
			String remote_port = request.getParameter("remote_port");
			String remote_usr = request.getParameter("remote_usr");
			String remote_pw = request.getParameter("remote_pw");
			String cmd = "cat " + pullPath; 
			
			CmmnUtil cu = new CmmnUtil();
			
			Map<String, Object> serverInfo = new HashMap<>();
			serverInfo.put("ip", remote_ip);
			serverInfo.put("port", remote_port);
			serverInfo.put("usr", remote_usr);
			serverInfo.put("pw", remote_pw);
			
			result = cu.executeBackrest(serverInfo, cmd, "backrest", null);
		}else {
			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.getBackrestLog(IP, PORT, jObj);
		}
		
		return result;
	}

	/**
	 * Backrest config 정보
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectBackrestConfigInfo.do")
	public @ResponseBody String selectBackrestConfigInfo(HttpServletRequest request) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject resultObj = new JSONObject();
		String result = null;
		List<Map<String, Object>> resultWork = null;
		String backrest_gbn = request.getParameter("backrest_gbn");
		int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
		
		if(backrest_gbn.equals("remote")) {
			try {
				
				CmmnUtil cu = new CmmnUtil();
				WorkLogVO vo = backupService.selectSshInfo(wrk_id);
				
				Map<String, Object> serverInfo = new HashMap<>();
				serverInfo.put("ip", vo.getRemote_ip());
				serverInfo.put("port", vo.getRemote_port());
				serverInfo.put("usr", vo.getRemote_usr());
				serverInfo.put("pw", vo.getRemote_pw());
				serverInfo.put("bck_filenm", vo.getBck_filenm());
				
				JSONObject cmdObj = new JSONObject();
				cmdObj.put("bck_filenm", vo.getBck_filenm());
				cmdObj.put("usr", vo.getRemote_usr());
				cmdObj.put("type", "conf");
				
				String cmd = cu.createBackrestCmd(cmdObj);
				
				String conf = cu.executeBackrest(serverInfo, cmd, "backrest", null).get("RESULT_DATA").toString();
				if(conf != null || conf != "") {
					result = conf;
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}else {
			try {
				resultWork = backupService.selectBckInfo(wrk_id);

				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR((resultWork.get(0).get("db_svr_ipadr")).toString());
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

				String ip = (resultWork.get(0).get("db_svr_ipadr")).toString();
				int port = agentInfo.getSOCKET_PORT();

				JSONObject jObj = new JSONObject();
				jObj.put(ClientProtocolID.WRK_NM, resultWork.get(0).get("wrk_nm"));

				resultObj = cic.selectBackrestConf(ip, port, jObj);

				result = (String) resultObj.get(ClientProtocolID.RESULT_DATA);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	/**
	 * Backrest Remote cmd 생성
	 * 
	 * @param workVO, dbServerVO, request, paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public String createBackrestRemoteFile(WorkVO workVO, DbServerVO dbServerVO, HttpServletRequest request, Map<String, Object> paramMap, DbServerVO masterServer)	{
		String conf = "";
		try {
			ClientInfoCmmn cic = new ClientInfoCmmn();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String ip = dbServerVO.getIpadr();
			int port = agentInfo.getSOCKET_PORT();
			Map<String, Object> hostResult = cic.getHostName(ip, port);
			String hostUser = hostResult.get("hostName").toString();
			
			CmmnUtil cu = new CmmnUtil();
			
			String remoteMapStr = paramMap.get("remote_map").toString();

			ObjectMapper mapper = new ObjectMapper();
			Map<String,Object> remoteMap = mapper.readValue(remoteMapStr, Map.class);
						
			Map<String, Object> serverInfo = new HashMap<>();
						
			serverInfo.put("ip", remoteMap.get("remote_ip"));
			serverInfo.put("port", remoteMap.get("remote_port"));
			serverInfo.put("usr", remoteMap.get("remote_usr"));
			serverInfo.put("pw", remoteMap.get("remote_pw"));
			
			String defaultConfPth = "/home/" + serverInfo.get("usr") + "/pgbackrest/default.conf";

			serverInfo.put("confPth", defaultConfPth);
			
			String cmd = "cat " + defaultConfPth;
			JSONObject result = cu.executeBackrest(serverInfo, cmd, "file", null);
			
			conf = result.get("RESULT_DATA").toString();
			
			conf = conf.replaceAll("#pg1-path=", "pg1-path=" + dbServerVO.getPgdata_pth());
			conf = conf.replaceAll("#pg1-host=", "pg1-host=" + dbServerVO.getIpadr());
			conf = conf.replaceAll("#pg1-host-user=", "pg1-host-user=" + hostUser);
			conf = conf.replaceAll("#pg1-host-port=", "pg1-host-port=" + remoteMap.get("remote_port").toString());
			conf = conf.replaceAll("#pg1-port=", "pg1-port=" + String.valueOf(dbServerVO.getPortno()));
			conf = conf.replaceAll("#pg1-user=", "pg1-user=" + String.valueOf(dbServerVO.getSvr_spr_usr_id()));
			conf = conf.replaceAll("#repo1-gbn=", "#repo1-gbn=" + workVO.getBackrest_gbn());
			// backup 경로 수정 필요
			conf = conf.replaceAll("#repo1-path=", "repo1-path=/home/remote/pgbackrest/backup");
			conf = conf.replaceAll("#repo1-retention-full=", "repo1-retention-full=" + String.valueOf(workVO.getBck_mtn_ecnt()));
			// log경로 수정 필요
			conf = conf.replaceAll("#log-path=", "log-path=" + "/home/remote/pgbackrest/logs");
			conf = conf.replaceAll("#log-level-console=detail", "log-level-console=detail");
			conf = conf.replaceAll("#log-level-file=detail", "log-level-file=detail");
			
			if(workVO.getCps_yn().equals("Y")) {
				if(request.getParameter("cps_type").equals("gzip")) {
					conf = conf.replaceAll("#compress-type=", "compress-type=gz");
				}else {
					conf = conf.replaceAll("#compress-type=", "compress-type=" + request.getParameter("cps_type"));
				}
			}else {
				conf = conf.replaceAll("#compress=", "compress=" + workVO.getCps_yn());
			}
			
			conf = conf.replaceAll("#process-max=", "process-max=" + request.getParameter("prcs_cnt"));
			
			if(paramMap.get("custom_map") == null || paramMap.get("custom_map").equals("")) {
				
			}else {
				ArrayList<String> customKeyList = new ArrayList<String>();
				ArrayList<String> customValueList = new ArrayList<String>();
				
				JSONParser parser = new JSONParser();
				JSONObject jsonObject = (JSONObject) parser.parse(String.valueOf(paramMap.get("custom_map")));
				Iterator<String> customKeys = jsonObject.keySet().iterator();
				
				while(customKeys.hasNext()){
	                String key = customKeys.next().toString();
	                customKeyList.add(key);
	                customValueList.add(String.valueOf(jsonObject.get(key)));
	            }
				
				if(customKeyList.size() != 0) {
					conf += "\r\n";
					for(int i=0; i < customKeyList.size(); i++) {
						conf += customKeyList.get(i) + "=" + customValueList.get(i)+ "\r\n";
					}
				}
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conf;	
	}

	/**
	 * Backrest config 생성
	 * 
	 * @param workVO, dbServerVO, request, paramMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void createBackrestConfig(WorkVO workVO, DbServerVO dbServerVO, HttpServletRequest request, Map<String, Object> paramMap, DbServerVO masterServer) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();

		try {
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String ip = dbServerVO.getIpadr();
			int port = agentInfo.getSOCKET_PORT();
			JSONObject jObj = new JSONObject();

			jObj.put(ClientProtocolID.PGDATA, dbServerVO.getPgdata_pth());
			jObj.put(ClientProtocolID.DBMS_PORT, dbServerVO.getPortno());
			jObj.put(ClientProtocolID.SPR_USR_ID, dbServerVO.getSvr_spr_usr_id());
			jObj.put(ClientProtocolID.BCK_FILENM, workVO.getBck_filenm());
			jObj.put(ClientProtocolID.BCK_MTN_ECNT, workVO.getBck_mtn_ecnt());
			jObj.put(ClientProtocolID.LOG_PATH, workVO.getLog_file_pth());
			jObj.put(ClientProtocolID.STORAGE_OPT, workVO.getBackrest_gbn());
			jObj.put(ClientProtocolID.CPS_YN, workVO.getCps_yn());
			jObj.put(ClientProtocolID.MASTER_GBN, dbServerVO.getMaster_gbn());
			jObj.put(ClientProtocolID.PRCS_CNT, request.getParameter("prcs_cnt"));
			jObj.put(ClientProtocolID.CPS_TYPE, request.getParameter("cps_type"));
			jObj.put(ClientProtocolID.CUSTOM_MAP, paramMap.get("custom_map"));
			if(workVO.getBackrest_gbn().equals("cloud")) {
				jObj.put(ClientProtocolID.CLOUD_MAP, paramMap.get("cloud_map"));
			}
			
			if(masterServer != null) {
				jObj.put(ClientProtocolID.MASTER_PGDATA, masterServer.getPgdata_pth());
				jObj.put(ClientProtocolID.MASTER_IP, masterServer.getIpadr());
				jObj.put(ClientProtocolID.MASTER_DBMS_PORT, masterServer.getPortno());
				jObj.put(ClientProtocolID.MASTER_DBMS_USER, masterServer.getSvr_spr_usr_id());
			}

			result = cic.createBackrestConf(ip, port, jObj);

		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
	}

	/**
	 * Backrest config 삭제
	 * 
	 * @param workVO, dbServerVO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void deleteBackrestConfig(WorkVO workVO, DbServerVO dbServerVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();

		try {
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String ip = dbServerVO.getIpadr();
			int port = agentInfo.getSOCKET_PORT();
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.BCK_FILENM, workVO.getBck_filenm());
			
			result = cic.deleteBackrestConf(ip, port, jObj);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Backrest backup, log 경로 조회
	 * 
	 * @param workVO, historyVO, request
	 * @return JSONObject
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/backup/backrestPath.do")
	@ResponseBody
	public JSONObject selectBackrestPath(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request,
			@ModelAttribute("historyVO") HistoryVO historyVO) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject result = new JSONObject();

		try {
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(request.getParameter("ipadr"));
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String ip = request.getParameter("ipadr");
			int port = agentInfo.getSOCKET_PORT();
			JSONObject jObj = new JSONObject();
			
			result = cic.selectBackrestPath(ip, port, jObj);

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * Backrest remote 연결 조회
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/backup/RemoteConn.do")
	@ResponseBody
	public String RemoteConnection(HttpServletRequest request) {
		
		String ip = request.getParameter("remote_ip");
		int port = Integer.parseInt(request.getParameter("remote_port"));
		String usr = request.getParameter("remote_usr");
		String pw = request.getParameter("remote_pw");

		String resultCode = "";
		
		Map<String, Object> serverInfo = new HashMap<>();
		
		serverInfo.put("ip", ip);
		serverInfo.put("port", port);
		serverInfo.put("usr", usr);
		serverInfo.put("pw", pw);
		
		CmmnUtil cu = new CmmnUtil();
		try {
			JSONObject result = cu.executeBackrest(serverInfo, "whoami", "backrest", null);

			if(result.get("RESULT_DATA").equals(usr)) {
				resultCode = "success";
			}
		} catch (Exception e) {
			resultCode = "fail";
			e.printStackTrace();
		}		
	
		return resultCode;
	}
	
	/**
	 * Backrest remote 백업 실행
	 * 
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/backrestImmediateStart.do")
	@ResponseBody
	public void backrestImmediateStart(HttpServletRequest request) {
		
		String TC001801 = "TC001801"; // 대기
		String TC001802 = "TC001802"; // 실행중
		String TC001701 = "TC001701"; // 성공
		String TC001702 = "TC001702"; // 실패
		
		String ip = request.getParameter("remote_ip");
		int port = Integer.parseInt(request.getParameter("remote_port"));
		String usr = request.getParameter("remote_usr");
		String pw = request.getParameter("remote_pw");
		
		Map<String, Object> serverInfo = new HashMap<>();
		
		serverInfo.put("ip", ip);
		serverInfo.put("port", port);
		serverInfo.put("usr", usr);
		serverInfo.put("pw", pw);
		
		CmmnUtil cu = new CmmnUtil();
		String cmd = "";
		try {
			JSONObject cmdInfo = new JSONObject();
			
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String now = dateFormat.format(new Date());
			
			cmdInfo.put("bck_filenm", request.getParameter("bck_filenm").toString());
			cmdInfo.put("bck_opt_cd_nm", request.getParameter("bck_opt_cd_nm").toString());
			cmdInfo.put("log_file_pth", request.getParameter("log_file_pth").toString());
			cmdInfo.put("wrk_nm", request.getParameter("wrk_nm").toString());
			cmdInfo.put("now", now);
			cmdInfo.put("usr", usr);
			cmdInfo.put("type", "backup");
			
			cmd = cu.createBackrestCmd(cmdInfo);
			
			WorkVO wrkVO = new WorkVO();
			wrkVO.setDb_svr_ipadr(request.getParameter("db_svr_ipadr"));
			
			List<DbServerVO> dbServer = backupService.selectBckServer(wrkVO);
			int db_svr_ipadr_id = dbServer.get(0).getDb_svr_ipadr_id();
			
			int exe_sn = backupService.selectQ_WRKEXE_G_01_SEQ();
			int scd_id = backupService.selectScd_id();
			int exe_grp_sn = backupService.selectQ_WRKEXE_G_02_SEQ();
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id").toString());
			String bck_opt_cd = request.getParameter("bck_opt_cd");
			int db_id = Integer.parseInt(request.getParameter("db_id").toString());
			String bck_pth = request.getParameter("bck_pth"); 
			String bck_filenm = cmdInfo.get("log_file_pth").toString() + "/" + cmdInfo.get("wrk_nm").toString() + "_" + now + ".log";
			String frst_regr_id = request.getParameter("frst_regr_id");
			String lst_mdfr_id = request.getParameter("lst_mdfr_id");
			
			WrkExeVO vo = new WrkExeVO(); 
			
			vo.setExe_sn(exe_sn);
			vo.setScd_id(scd_id);
			vo.setWrk_id(wrk_id);
			vo.setBck_opt_cd(bck_opt_cd);
			vo.setDb_id(db_id);
			vo.setBck_file_pth(bck_pth);
			vo.setBck_file_nm(bck_filenm);
			vo.setFrst_regr_id(frst_regr_id);
			vo.setLst_mdfr_id(lst_mdfr_id);
			vo.setExe_grp_sn(exe_grp_sn);
			vo.setExe_rslt_cd(TC001802);
			vo.setWrk_nm(cmdInfo.get("wrk_nm").toString());
			vo.setDb_svr_ipadr_id(db_svr_ipadr_id);
			
			backupService.insertPgbackrestBackup(vo);
			
			JSONObject result = cu.executeBackrest(serverInfo, cmd, "backrest", null);
			int resultCode = Integer.parseInt(result.get("RESULT_CODE").toString());
			
			if(resultCode == 0) {
				cmdInfo.put("type", "info");
				cmd = cu.createBackrestCmd(cmdInfo);
				JSONObject info = cu.executeBackrest(serverInfo, cmd, "backrest", null);
				
				String successObj = info.get("RESULT_DATA").toString();
				org.codehaus.jackson.map.ObjectMapper mapper = new org.codehaus.jackson.map.ObjectMapper();
				JsonNode jsonNode = mapper.readTree(successObj);
				
				int jsonSize = jsonNode.findValue("backup").size();
				long repoSizeInt = jsonNode.findValue("backup").path(jsonSize-1).path("info").path("repository").path("delta").asLong();
				long dbSizeInt = jsonNode.findValue("backup").path(jsonSize-1).path("info").path("delta").asLong();
				int startTimeInt = jsonNode.findValue("backup").path(jsonSize-1).path("timestamp").path("start").asInt();
				int stopTimeInt = jsonNode.findValue("backup").path(jsonSize-1).path("timestamp").path("stop").asInt();
				
				String startDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(startTimeInt * 1000L));
				String stopDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(stopTimeInt * 1000L));
				
				WrkExeVO endVO = new WrkExeVO();
				endVO.setExe_sn(exe_sn);
				endVO.setWrk_strt_dtm(startDateStr);
				endVO.setWrk_end_dtm(stopDateStr);
				endVO.setExe_rslt_cd(TC001701);
				endVO.setFile_sz(repoSizeInt);
				endVO.setDB_SZ(dbSizeInt);
				endVO.setRslt_msg("success");
				
				backupService.updateBackrestWrk(endVO);
			}else {
				
			}
				

		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	
	
}