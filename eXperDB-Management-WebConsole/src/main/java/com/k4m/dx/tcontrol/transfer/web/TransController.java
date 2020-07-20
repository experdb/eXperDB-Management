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
import org.json.simple.parser.JSONParser;
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
import com.k4m.dx.tcontrol.backup.service.BackupService;
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
import com.k4m.dx.tcontrol.transfer.TransferTableInfo;
import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransService;
import com.k4m.dx.tcontrol.transfer.service.TransVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailMappingVO;

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
				historyVO.setExe_dtl_cd("DX-T0011");
				historyVO.setMnu_id(6);
				accessHistoryService.insertHistory(historyVO);
				
				//db서버명 조회
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

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

				// Get 스냅샷모드 (use)
				try {
					mv.addObject("snapshotModeList", transService.selectSnapshotModeList());
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				
				// 압축형식  (use)
				try {
					mv.addObject("compressionTypeList", transService.selectCompressionTypeList());
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
				mv.addObject("db_svr_id", db_svr_id);

				mv.setViewName("transfer/transSetting");
			}

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
			historyVO.setExe_dtl_cd("DX-T0016");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			mv.addObject("act", act);
			mv.addObject("db_svr_id", db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * kafka-Connection 연결 테스트
	 * 
	 * @param response, request
	 * @return result
	 * @throws Exception
	 */
	// 
	@RequestMapping(value = "/kafkaConnectionTest.do")
	@ResponseBody
	public Map<String, Object> kafkaConnectionTest(HttpServletResponse response, HttpServletRequest request) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {					
			
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String kafkaIp = request.getParameter("kafkaIp");
			String kafkaPort = request.getParameter("kafkaPort");
			
			String cmd = "curl -H 'Accept:application/json' "+kafkaIp+":"+kafkaPort+"/";
			
			System.out.println("명령어 = "+cmd);

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
			result = cic.kafkaConnectionTest(IP, PORT, cmd);
					
			System.out.println(result);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	/**
	 * 커넥터명을 중복 체크한다.
	 * 
	 * @param connect_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/connect_nm_Check.do")
	public @ResponseBody String connect_nm_Check(@RequestParam("connect_nm") String connect_nm) {
		try {
			int resultSet = transService.connect_nm_Check(connect_nm);
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
	 * 전송설정 등록한다.
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
			transService.insertConnectInfo(transVO);		
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
			txManager.rollback(status);
			return result;
		}finally{
			txManager.commit(status);
		}
		return result                                                                ;
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
		
		String trans_id_Rows = request.getParameter("trans_id_List").toString().replaceAll("&quot;", "\"");
		JSONArray trans_ids = (JSONArray) new JSONParser().parse(trans_id_Rows);		
		
		String trans_exrt_trg_tb_id_Rows = request.getParameter("trans_exrt_trg_tb_id_List").toString().replaceAll("&quot;", "\"");
		JSONArray trans_exrt_trg_tb_ids = (JSONArray) new JSONParser().parse(trans_exrt_trg_tb_id_Rows);
		
		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			historyVO.setMnu_id(6);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			e2.printStackTrace();
		}

		try {			
			if (trans_exrt_trg_tb_ids != null && trans_exrt_trg_tb_ids.size() > 0) {
				for(int i=0; i<trans_exrt_trg_tb_ids.size(); i++){
					String transSetting_delete = "success";
					int trans_id = Integer.parseInt(trans_ids.get(i).toString());
					int trans_exrt_trg_tb_id = Integer.parseInt(trans_exrt_trg_tb_ids.get(i).toString());

					// 데이터전송 삭제
					try{			
						transService.deleteTransSetting(trans_id);								
					}catch (Exception e) {
						transSetting_delete = "fail";
						e.printStackTrace();
						txManager.rollback(status);
						return false;
					}
					
					// 맵핑 테이블 삭제
					if(transSetting_delete.equals("success")){
						try{			
							transService.deleteTransExrttrgMapp(trans_exrt_trg_tb_id);								
						}catch (Exception e) {			
							e.printStackTrace();			
							txManager.rollback(status);
							return false;
						}	
					}
					
				}
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
	 * 전송설정 조회한다.
	 * 
	 * @param transVO, request, response
	 * @return result
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransSetting.do")
	public @ResponseBody List<Map<String, Object>> selectTransSetting(@ModelAttribute("transVO") TransVO transVO, HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> result = null;
		try {
			/*CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

			// 읽기권한이 있을경우
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			}*/
			
			result = transService.selectTransSetting(transVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 수정테스트
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

		JSONArray tableArray = new JSONArray();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			CmmnUtils.saveHistory(request, historyVO);
			
			// 화면접근이력 이력 남기기
			historyVO.setExe_dtl_cd("DX-T0017");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
				
			transInfo = transService.selectTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));

			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));

			String[] tables = null;
			tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");

			if(mappInfo.get(0).get("exrt_trg_tb_nm") != null) {
				if (!"".equals(mappInfo.get(0).get("exrt_trg_tb_nm").toString())) {
					for (int i = 0; i < tables.length; i++) {
						JSONObject jsonObj = new JSONObject();
						String[] datas = null;
						System.out.println("tables = "+tables[i]);
						datas = tables[i].toString().split("\\.");
							for(int j = 0; j < 1; j++){
								jsonObj.put("schema_name", datas[0]);
								jsonObj.put("table_name", datas[1]);
								tableArray.add(jsonObj);
							}
					}
					tableResult.put("data", tableArray);
				}
			}
				
			mv.addObject("kc_ip", transInfo.get(0).get("kc_ip"));				//use
			mv.addObject("kc_port", transInfo.get(0).get("kc_port"));			//use
			mv.addObject("connect_nm", transInfo.get(0).get("connect_nm"));		//use
			mv.addObject("db_id", transInfo.get(0).get("db_id"));				//use
			mv.addObject("db_nm", transInfo.get(0).get("db_nm"));				//use
			mv.addObject("snapshot_mode", transInfo.get(0).get("snapshot_mode"));	//use
			mv.addObject("snapshot_nm", transInfo.get(0).get("snapshot_nm"));		//use
			mv.addObject("compression_type", transInfo.get(0).get("compression_type"));	//use
			mv.addObject("compression_nm", transInfo.get(0).get("compression_nm"));		//use
			mv.addObject("meta_data", transInfo.get(0).get("meta_data"));				//use
			
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
				
				transService.updateTransExrttrgMapp(transMappVO);								
			}catch (Exception e) {
				e.printStackTrace();
				txManager.rollback(status);
				return false;
			}
			
			transService.updateConnectInfo(transVO);
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
	 * kafka-Connection 시작
	 * @param response, request
	 * @return result
	 * @throws
	 */
	@RequestMapping(value = "/transStart.do")
	@ResponseBody
	public String transStart(HttpServletResponse response, HttpServletRequest request) {
		String result = "fail";
		String result_code = "";
		
		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		try {					
			
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);
			
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id = Integer.parseInt(request.getParameter("trans_id"));

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
			
			transInfo = transService.selectTransInfo(trans_id);	
			System.out.println("전송정보 : "+transInfo.get(0));
			
			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));
	
			ClientInfoCmmn cic = new ClientInfoCmmn();
			connStartResult = cic.connectStart(IP, PORT, dbServerVO, transInfo, mappInfo);
			
			if (connStartResult != null) {
				result_code = connStartResult.get("RESULT_CODE").toString();
				if ("0".equals(result_code)) {
					result = "success";
				} else {
					result = "fail";
				}
			}
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
		String result = "fail";
		String result_code = "";

		Map<String, Object> connStopResult = new  HashMap<String, Object>();

		try {
			String kc_ip = request.getParameter("kc_ip");
			String kc_port = request.getParameter("kc_port");
			String connect_nm = request.getParameter("connect_nm");
			String trans_id = request.getParameter("trans_id");
			
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			String strCmd =" curl -i -X DELETE -H 'Accept:application/json' "+kc_ip+":"+kc_port+"/connectors/"+connect_nm;

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
			connStopResult = cic.connectStop(IP, PORT, strCmd, trans_id);
			
			if (connStopResult != null) {
				result_code = connStopResult.get("RESULT_CODE").toString();
				if ("0".equals(result_code)) {
					result = "success";
				} else {
					result = "fail";
				}
			}
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		return result;
	}	
	
	/**
	 * 전송대상상세 화면을 보여준다.
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

		JSONArray tableArray = new JSONArray();

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0018");
			historyVO.setMnu_id(33);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
			int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
			
			transInfo = transService.selectTransInfo(trans_id);
			System.out.println("전송정보 : "+transInfo.get(0));

			mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
			System.out.println("매핑정보 : "+mappInfo.get(0));

			String[] tables = null;
			tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");

			if(mappInfo.get(0).get("exrt_trg_tb_nm") != null) {
				if (!"".equals(mappInfo.get(0).get("exrt_trg_tb_nm").toString())) {
					for (int i = 0; i < tables.length; i++) {
						JSONObject jsonObj = new JSONObject();
						String[] datas = null;
						System.out.println("tables = "+tables[i]);
						datas = tables[i].toString().split("\\.");
							for(int j = 0; j < 1; j++){
								jsonObj.put("schema_name", datas[0]);
								jsonObj.put("table_name", datas[1]);
								tableArray.add(jsonObj);
							}
					}
					tableResult.put("data", tableArray);
				}
			}
				
			mv.addObject("kc_ip", transInfo.get(0).get("kc_ip"));				//use
			mv.addObject("kc_port", transInfo.get(0).get("kc_port"));			//use
			mv.addObject("connect_nm", transInfo.get(0).get("connect_nm"));		//use
			mv.addObject("db_id", transInfo.get(0).get("db_id"));				//use
			mv.addObject("db_nm", transInfo.get(0).get("db_nm"));				//use
			mv.addObject("snapshot_mode", transInfo.get(0).get("snapshot_mode"));	//use
			mv.addObject("snapshot_nm", transInfo.get(0).get("snapshot_nm"));		//use
			mv.addObject("compression_type", transInfo.get(0).get("compression_type"));	//use
			mv.addObject("compression_nm", transInfo.get(0).get("compression_nm"));		//use
			mv.addObject("meta_data", transInfo.get(0).get("meta_data"));				//use
			
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
	 * 스키마리스트 등록 팝업 화면을 보여준다.
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
		
		System.out.println("db_svr_id= "+db_svr_id);
		System.out.println("db_nm= "+db_nm);
		System.out.println("schema_nm= "+schema_nm);
		
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
			
			System.out.println(result);
			
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

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		String execute_gbn = request.getParameter("execute_gbn").toString();

		String result = "fail";
		String result_code = "";
		int sucCnt = 0;
		
		String trans_id_Rows = "";
		String trans_exrt_trg_tb_id_Rows = "";
		String kc_ip_Rows = "";
		String kc_port_Rows = "";
		String connect_nm_Rows = "";
		JSONArray trans_ids = null;
		JSONArray trans_exrt_trg_tb_ids = null;
		JSONArray kc_ips = null;
		JSONArray kc_ports = null;
		JSONArray connect_nms = null;

		if (request.getParameter("trans_id_List") != null) {
			trans_id_Rows = request.getParameter("trans_id_List").toString().replaceAll("&quot;", "\"");
			trans_ids = (JSONArray) new JSONParser().parse(trans_id_Rows);
		}
		
		if (request.getParameter("trans_exrt_trg_tb_id_List") != null) {
			trans_exrt_trg_tb_id_Rows = request.getParameter("trans_exrt_trg_tb_id_List").toString().replaceAll("&quot;", "\"");
			trans_exrt_trg_tb_ids = (JSONArray) new JSONParser().parse(trans_exrt_trg_tb_id_Rows);
		}

		if (request.getParameter("kc_ip_List") != null) {
			kc_ip_Rows = request.getParameter("kc_ip_List").toString().replaceAll("&quot;", "\"");
			kc_ips = (JSONArray) new JSONParser().parse(kc_ip_Rows);
		}
		
		if (request.getParameter("kc_port_List") != null) {
			kc_port_Rows = request.getParameter("kc_port_List").toString().replaceAll("&quot;", "\"");
			kc_ports = (JSONArray) new JSONParser().parse(kc_port_Rows);
		}

		if (request.getParameter("connect_nm_List") != null) {
			connect_nm_Rows = request.getParameter("connect_nm_List").toString().replaceAll("&quot;", "\"");
			connect_nms = (JSONArray) new JSONParser().parse(connect_nm_Rows);
		}

		Map<String, Object> connStartResult = new  HashMap<String, Object>();

		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;

		try {			
			if (trans_exrt_trg_tb_ids != null && trans_exrt_trg_tb_ids.size() > 0) {
				
				AES256 dec = new AES256(AES256_KEY.ENC_KEY);
	
				DbServerVO schDbServerVO = new DbServerVO();
				schDbServerVO.setDb_svr_id(db_svr_id);
				DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
				
				String strIpAdr = dbServerVO.getIpadr();
				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(strIpAdr);
				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

				String IP = dbServerVO.getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				dbServerVO.setSvr_spr_scm_pwd(dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));
				ClientInfoCmmn cic = new ClientInfoCmmn();

				for(int i=0; i<trans_exrt_trg_tb_ids.size(); i++){
					if ("active".equals(execute_gbn)) {
						int trans_exrt_trg_tb_id = Integer.parseInt(trans_exrt_trg_tb_ids.get(i).toString());
						int trans_id = Integer.parseInt(trans_ids.get(i).toString());
						
						transInfo = transService.selectTransInfo(trans_id);	
						System.out.println("전송정보 : "+transInfo.get(0));
						
						mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
						System.out.println("매핑정보 : "+mappInfo.get(0));

						connStartResult = cic.connectStart(IP, PORT, dbServerVO, transInfo, mappInfo);
					} else {
						String kc_ip = kc_ips.get(i).toString();
						String kc_port = kc_ports.get(i).toString();
						String connect_nm = connect_nms.get(i).toString();
						String trans_id_str = trans_ids.get(i).toString();

						String strCmd =" curl -i -X DELETE -H 'Accept:application/json' "+kc_ip+":"+kc_port+"/connectors/"+connect_nm;

						connStartResult = cic.connectStop(IP, PORT, strCmd, trans_id_str);
					}

					if (connStartResult != null) {
						result_code = connStartResult.get("RESULT_CODE").toString();
						if ("0".equals(result_code)) {
							//result = "success";
							sucCnt = sucCnt + 1;
						}
					}
				}
				
				if (sucCnt == trans_exrt_trg_tb_ids.size() ) {
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
