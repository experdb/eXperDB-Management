package com.k4m.dx.tcontrol.transfer.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.batch.core.scope.context.SynchronizationManagerSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
	 * 전송설정 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transSetting.do")
	public ModelAndView transSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			
			int db_svr_id=Integer.parseInt(request.getParameter("db_svr_id"));
			
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
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

				mv.addObject("db_svr_id",db_svr_id);
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
	@RequestMapping(value = "/popup/connectRegForm.do")
	public ModelAndView connectRegForm(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView();
		JSONObject result = new JSONObject();
		JSONObject serverObj = new JSONObject();
		ClientInfoCmmn cic = new ClientInfoCmmn();
		
		List<Map<String, Object>> transInfo = null;
		List<Map<String, Object>> mappInfo = null;
		
		JSONArray schemaArray = new JSONArray();
		JSONArray tableArray = new JSONArray();
		
		// Get DB List
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
		
		
		// Get 스냅샷모드 
		try {
			mv.addObject("snapshotModeList", transService.selectSnapshotModeList());
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		try {

			CmmnUtils.saveHistory(request, historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();

			String act = request.getParameter("act");

			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			//int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
			
			if (act.equals("i")) {				
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0016");
				historyVO.setMnu_id(33);
				accessHistoryService.insertHistory(historyVO);
			}
			
			if (act.equals("u")) {
				// 화면접근이력 이력 남기기
				historyVO.setExe_dtl_cd("DX-T0017");
				historyVO.setMnu_id(33);
				accessHistoryService.insertHistory(historyVO);

				int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
				int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
				
				
				try{
					transInfo = transService.selectTransInfo(trans_id);	
					System.out.println("전송정보 : "+transInfo.get(0));
				}catch (Exception e) {
					e.printStackTrace();
				}
				
				try{
					mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
					System.out.println("매핑정보 : "+mappInfo.get(0));
				}catch (Exception e) {
					e.printStackTrace();
				}
								
				String[] schemas = null;
				schemas = mappInfo.get(0).get("exrt_trg_scm_nm").toString().split(",");
		
				for (int i = 0; i < schemas.length; i++) {
					schemaArray.add(schemas[i]);
				}
				
				String[] tables = null;
				tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");
		
				for (int i = 0; i < tables.length; i++) {
					tableArray.add(tables[i]);
				}
					
				mv.addObject("kc_ip", transInfo.get(0).get("kc_ip"));
				mv.addObject("kc_port", transInfo.get(0).get("kc_port"));
				mv.addObject("connect_nm", transInfo.get(0).get("connect_nm"));
				mv.addObject("db_id", transInfo.get(0).get("db_id"));
				mv.addObject("db_nm", transInfo.get(0).get("db_nm"));
				mv.addObject("snapshot_mode", transInfo.get(0).get("snapshot_mode"));
				mv.addObject("snapshot_nm", transInfo.get(0).get("snapshot_nm"));
				mv.addObject("trans_exrt_trg_tb_id", mappInfo.get(0).get("trans_exrt_trg_tb_id"));			
				mv.addObject("schema_total_cnt", mappInfo.get(0).get("schema_total_cnt"));
				mv.addObject("table_total_cnt", mappInfo.get(0).get("table_total_cnt"));
				mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
				mv.addObject("trans_id",trans_id);				
			}
	
			mv.addObject("schemas", schemaArray);
			mv.addObject("tables", tableArray);
			mv.addObject("act", act);
			mv.addObject("db_svr_id", db_svr_id);
			
			mv.setViewName("popup/connectRegForm");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	
	// kafka-Connection 연결 테스트
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
	 * 전송설정 등록한다.
	 * 
	 * @param transVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertConnectInfo.do")
	public @ResponseBody boolean insertConnectInfo(@ModelAttribute("transVO") TransVO transVO, @ModelAttribute("transMappVO") TransMappVO transMappVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {
		
		int trans_exrt_trg_tb_id =0;
		int trans_exrt_exct_tb_id=0;	
		
		String tansExrttrgMapp_status = "success";
		
		try {
			
			/*CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

			// 쓰기권한이 있을경우
			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
			}*/
			
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
							
				transService.insertTransExrttrgMapp(transMappVO);								
			}catch (Exception e) {
				tansExrttrgMapp_status = "fail";
				e.printStackTrace();			
				return false;
			}

			if(tansExrttrgMapp_status.equals("success")){
				
				System.out.println("등록합니다.");
				
				transVO.setTrans_exrt_trg_tb_id(trans_exrt_trg_tb_id);
				transService.insertConnectInfo(transVO);
			}

			/*// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			historyVO.setMnu_id(6);
			accessHistoryService.insertHistory(historyVO);*/

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	
	
	/**
	 * 전송설정 조회한다.
	 * 
	 * @param request
	 * @return resultSet
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
			
			System.out.println(result);
			
		} catch (Exception e) {
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
			serverObj.put(ClientProtocolID.SCHEMA, "%");
			serverObj.put(ClientProtocolID.TABLE_NM, table_nm);
	
			//result = cic.object_List(serverObj, IP, PORT);
			
			result =  TransferTableInfo.getTblList(serverObj);
			
			System.out.println(result);
			
	}catch (Exception e) {
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
	
	
	
	
		// kafka-Connection 시작
		@RequestMapping(value = "/transStart.do")
		@ResponseBody
		public Map<String, Object> transStart(HttpServletResponse response, HttpServletRequest request) {

			Map<String, Object> result = new HashMap<String, Object>();
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
				
				try{
					transInfo = transService.selectTransInfo(trans_id);	
					System.out.println("전송정보 : "+transInfo.get(0));
				}catch (Exception e) {
					e.printStackTrace();
				}
				
				try{
					mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
					System.out.println("매핑정보 : "+mappInfo.get(0));
				}catch (Exception e) {
					e.printStackTrace();
				}
		
				
				ClientInfoCmmn cic = new ClientInfoCmmn();
				connStartResult = cic.connectStart(IP, PORT, dbServerVO, transInfo, mappInfo);
		
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}	
		

		// kafka-Connection 정지
		@RequestMapping(value = "/transStop.do")
		@ResponseBody
		public Map<String, Object> transStop(HttpServletResponse response, HttpServletRequest request) {

			Map<String, Object> result = new HashMap<String, Object>();
			 Map<String, Object> connStopResult = new  HashMap<String, Object>();

			
			try {					

				String kc_ip = request.getParameter("kc_ip");
				String kc_port = request.getParameter("kc_port");
				String connect_nm = request.getParameter("connect_nm");
				String trans_id = request.getParameter("trans_id");
				
				String strCmd =" curl -i -X DELETE -H 'Accept:application/json' "+kc_ip+":"+kc_port+"/connectors/"+connect_nm;
				
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

				ClientInfoCmmn cic = new ClientInfoCmmn();
				connStopResult = cic.connectStop(IP, PORT, strCmd, trans_id);
		
			} catch (Exception e) {
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
			
			String tansExrttrgMapp_status = "success";
			transMappVO.setTrans_exrt_trg_tb_id(Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id")));
			
			
			try {
				
				/*CmmnUtils cu = new CmmnUtils();
				menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

				// 쓰기권한이 있을경우
				if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
					response.sendRedirect("/autError.do");
				}*/
				
				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();
				transVO.setFrst_regr_id(usr_id);
				transVO.setLst_mdfr_id(usr_id);
				
				transMappVO.setFrst_regr_id(usr_id);

				try{			
					if(transMappVO.getSchema_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
						transMappVO.setSchema_total_cnt("0");
					}
					
					if(transMappVO.getTable_total_cnt().equals("") || transMappVO.getSchema_total_cnt().equals(null)){
						transMappVO.setTable_total_cnt("0");
					}
					
					transService.updateTransExrttrgMapp(transMappVO);								
				}catch (Exception e) {
					tansExrttrgMapp_status = "fail";
					e.printStackTrace();			
					return false;
				}
				

				// 전송설정 업데이트				
				if(tansExrttrgMapp_status.equals("success")){
					try{						
						transService.updateConnectInfo(transVO);								
					}catch (Exception e) {			
						e.printStackTrace();			
						return false;
					}	
				}

				/*// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0011_01");
				historyVO.setMnu_id(6);
				accessHistoryService.insertHistory(historyVO);*/

			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
			return true;
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
		public @ResponseBody boolean deleteTransSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
				HttpServletResponse response) {
			
			int trans_id = Integer.parseInt(request.getParameter("trans_id"));
			int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));

			String transSetting_delete = "success";
			
			try {
				
				/*CmmnUtils cu = new CmmnUtils();
				menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

				// 쓰기권한이 있을경우
				if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
					response.sendRedirect("/autError.do");
				}*/
				
				
				// 데이터전송 삭제
				try{			
					transService.deleteTransSetting(trans_id);								
				}catch (Exception e) {
					transSetting_delete = "fail";
					e.printStackTrace();			
					return false;
				}
				
				
				// 맵핑 테이블 삭제
				if(transSetting_delete.equals("success")){
					try{			
						transService.deleteTransExrttrgMapp(trans_exrt_trg_tb_id);								
					}catch (Exception e) {			
						e.printStackTrace();			
						return false;
					}	
				}

				/*// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0011_01");
				historyVO.setMnu_id(6);
				accessHistoryService.insertHistory(historyVO);*/

			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
			return true;
		}
		
		
		
		
		/**
		 * 전송설정등록 팝업 화면을 보여준다.
		 * 
		 * @param
		 * @return ModelAndView mv
		 * @throws Exception
		 */
		@RequestMapping(value = "/popup/connectRegForm2.do")
		public ModelAndView connectRegForm2(@ModelAttribute("historyVO") HistoryVO historyVO,
				HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
			ModelAndView mv = new ModelAndView();
			JSONObject result = new JSONObject();
			JSONObject serverObj = new JSONObject();
			ClientInfoCmmn cic = new ClientInfoCmmn();
			
			List<Map<String, Object>> transInfo = null;
			List<Map<String, Object>> mappInfo = null;
			
			JSONArray schemaArray = new JSONArray();
			JSONArray tableArray = new JSONArray();
			
			// Get DB List
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
			
			
			// Get 스냅샷모드 
			try {
				mv.addObject("snapshotModeList", transService.selectSnapshotModeList());
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			
			// 압축형식
			try {
				mv.addObject("compressionTypeList", transService.selectCompressionTypeList());
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			try {

				CmmnUtils.saveHistory(request, historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();

				String act = request.getParameter("act");

				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				//int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
				
				if (act.equals("i")) {				
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0016");
					historyVO.setMnu_id(33);
					accessHistoryService.insertHistory(historyVO);
				}
				
				if (act.equals("u")) {
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0017");
					historyVO.setMnu_id(33);
					accessHistoryService.insertHistory(historyVO);

					int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
					int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
					
					
					try{
						transInfo = transService.selectTransInfo(trans_id);	
						System.out.println("전송정보 : "+transInfo.get(0));
					}catch (Exception e) {
						e.printStackTrace();
					}
					
					try{
						mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
						System.out.println("매핑정보 : "+mappInfo.get(0));
					}catch (Exception e) {
						e.printStackTrace();
					}
									
					String[] schemas = null;
					schemas = mappInfo.get(0).get("exrt_trg_scm_nm").toString().split(",");
			
					for (int i = 0; i < schemas.length; i++) {
						schemaArray.add(schemas[i]);
					}
					
					String[] tables = null;
					tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");
			
					for (int i = 0; i < tables.length; i++) {
						tableArray.add(tables[i]);
					}
						
					mv.addObject("kc_ip", transInfo.get(0).get("kc_ip"));
					mv.addObject("kc_port", transInfo.get(0).get("kc_port"));
					mv.addObject("connect_nm", transInfo.get(0).get("connect_nm"));
					mv.addObject("db_id", transInfo.get(0).get("db_id"));
					mv.addObject("db_nm", transInfo.get(0).get("db_nm"));
					mv.addObject("snapshot_mode", transInfo.get(0).get("snapshot_mode"));
					mv.addObject("snapshot_nm", transInfo.get(0).get("snapshot_nm"));
					mv.addObject("trans_exrt_trg_tb_id", mappInfo.get(0).get("trans_exrt_trg_tb_id"));			
					mv.addObject("schema_total_cnt", mappInfo.get(0).get("schema_total_cnt"));
					mv.addObject("table_total_cnt", mappInfo.get(0).get("table_total_cnt"));
					mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
					mv.addObject("trans_id",trans_id);				
				}
		
				mv.addObject("schemas", schemaArray);
				mv.addObject("tables", tableArray);
				mv.addObject("act", act);
				mv.addObject("db_svr_id", db_svr_id);
				
				mv.setViewName("popup/connectRegForm2");
			} catch (Exception e) {
				e.printStackTrace();
			}
			return mv;
		}
		
		
		
		
		/**
		 * 수정테스트
		 * 
		 * @param
		 * @return ModelAndView mv
		 * @throws Exception
		 */
		@RequestMapping(value = "/popup/connectRegReForm.do")
		public ModelAndView connectRegReForm(@ModelAttribute("historyVO") HistoryVO historyVO,
				HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) {
			
			ModelAndView mv = new ModelAndView();
			
			JSONObject schemaResult = new JSONObject();
			JSONObject tableResult = new JSONObject();
			
			
			JSONObject serverObj = new JSONObject();
			ClientInfoCmmn cic = new ClientInfoCmmn();
			
			List<Map<String, Object>> transInfo = null;
			List<Map<String, Object>> mappInfo = null;
			
			JSONArray schemaArray = new JSONArray();
			JSONArray tableArray = new JSONArray();
			
			// Get DB List
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
			
			
			// Get 스냅샷모드 
			try {
				mv.addObject("snapshotModeList", transService.selectSnapshotModeList());
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			
			// 압축형식
			try {
				mv.addObject("compressionTypeList", transService.selectCompressionTypeList());
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			try {

				CmmnUtils.saveHistory(request, historyVO);

				HttpSession session = request.getSession();
				LoginVO loginVo = (LoginVO) session.getAttribute("session");
				String usr_id = loginVo.getUsr_id();


				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

	
					// 화면접근이력 이력 남기기
					historyVO.setExe_dtl_cd("DX-T0017");
					historyVO.setMnu_id(33);
					accessHistoryService.insertHistory(historyVO);

					int trans_exrt_trg_tb_id = Integer.parseInt(request.getParameter("trans_exrt_trg_tb_id"));
					int trans_id =  Integer.parseInt(request.getParameter("trans_id"));
					
					
					try{
						transInfo = transService.selectTransInfo(trans_id);	
						System.out.println("전송정보 : "+transInfo.get(0));
					}catch (Exception e) {
						e.printStackTrace();
					}
					
					try{
						mappInfo = transService.selectMappInfo(trans_exrt_trg_tb_id);
						System.out.println("매핑정보 : "+mappInfo.get(0));
					}catch (Exception e) {
						e.printStackTrace();
					}
									
					

					String[] schemas = null;
					schemas = mappInfo.get(0).get("exrt_trg_scm_nm").toString().split(",");
			
						for (int i = 0; i < schemas.length; i++) {
							JSONObject jsonObj = new JSONObject();						
							jsonObj.put("schema_name", schemas[i]);
							schemaArray.add(jsonObj);
						}
						schemaResult.put("data", schemaArray);							
	
				
						
					String[] tables = null;

					tables = mappInfo.get(0).get("exrt_trg_tb_nm").toString().split(",");

					if(mappInfo.get(0).get("exrt_trg_tb_nm").toString().equals("")){
				
					}else {
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
					
					mv.addObject("kc_ip", transInfo.get(0).get("kc_ip"));
					mv.addObject("kc_port", transInfo.get(0).get("kc_port"));
					mv.addObject("connect_nm", transInfo.get(0).get("connect_nm"));
					mv.addObject("db_id", transInfo.get(0).get("db_id"));
					mv.addObject("db_nm", transInfo.get(0).get("db_nm"));
					mv.addObject("snapshot_mode", transInfo.get(0).get("snapshot_mode"));
					mv.addObject("snapshot_nm", transInfo.get(0).get("snapshot_nm"));
					mv.addObject("trans_exrt_trg_tb_id", mappInfo.get(0).get("trans_exrt_trg_tb_id"));			
					mv.addObject("schema_total_cnt", mappInfo.get(0).get("schema_total_cnt"));
					mv.addObject("table_total_cnt", mappInfo.get(0).get("table_total_cnt"));
					mv.addObject("trans_exrt_trg_tb_id", trans_exrt_trg_tb_id);
					mv.addObject("trans_id",trans_id);				
					mv.addObject("compression_type", transInfo.get(0).get("compression_type"));
					mv.addObject("compression_nm", transInfo.get(0).get("compression_nm"));

				mv.addObject("schemas", schemaResult);
				mv.addObject("tables", tableResult);
				mv.addObject("db_svr_id", db_svr_id);
				
				mv.setViewName("popup/connectRegReForm");
			} catch (Exception e) {
				e.printStackTrace();
			}
			return mv;
		}
}
