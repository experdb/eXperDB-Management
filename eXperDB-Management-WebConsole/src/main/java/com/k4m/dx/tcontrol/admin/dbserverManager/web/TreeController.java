package com.k4m.dx.tcontrol.admin.dbserverManager.web;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlHistoryVO;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlService;
import com.k4m.dx.tcontrol.accesscontrol.service.AccessControlVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerManagerService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.CmmnVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;

/**
 * [DB TREE] 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.31   변승우 최초 생성
 *      </pre>
 */

@Controller
public class TreeController {

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	@Autowired
	private DbServerManagerService dbServerManagerService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	@Autowired
	private TransferService transferService;

	private List<Map<String, Object>> menuAut;

	/**
	 * [DB TREE] DB Tree 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbTree.do")
	public ModelAndView dbTree(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("cmmnVO") CmmnVO cmmnVO, HttpServletRequest request) {

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		
		// 해당메뉴 권한 조회 (공통메소드호출),
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		ModelAndView mv = new ModelAndView();
		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0005");
				historyVO.setMnu_id(9);
				accessHistoryService.insertHistory(historyVO);

				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));
				mv.addObject("encpUse", loginVo.getEncp_use_yn());
				mv.setViewName("admin/dbServerManager/dbTree");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * [DB TREE] DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectTreeDbServerList.do")
	@ResponseBody
	public List<DbServerVO> selectDbServerList(@ModelAttribute("dbServerVO") DbServerVO dbServerVO,
			HttpServletResponse response) {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		List<DbServerVO> result = null;
		List<DbServerVO> resultSet = null;
		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			} else {
				System.out.println("=======parameter=======");
				System.out.println("서버명 : " + dbServerVO.getDb_svr_id());
				System.out.println("서버명 : " + dbServerVO.getDb_svr_nm());
				System.out.println("아이피 : " + dbServerVO.getIpadr());
				System.out.println("Database : " + dbServerVO.getDft_db_nm());
				System.out.println("=====================");

				resultSet = dbServerManagerService.selectDbServerList(dbServerVO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * [DB TREE] DB서버에 대한 DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectTreeServerDBList.do")
	@ResponseBody
	public Map<String, Object> selectServerDBList(@ModelAttribute("dbServerVO") DbServerVO dbServerVO,
			HttpServletRequest request, HttpServletResponse response) {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return result;
			} else {
				AES256 aes = new AES256(AES256_KEY.ENC_KEY);
				String db_svr_nm = request.getParameter("db_svr_nm");

				List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);

				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(resultSet.get(0).getIpadr());

				AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

				String IP = resultSet.get(0).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				JSONObject serverObj = new JSONObject();

				serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
				serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
				serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
				serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(resultSet.get(0).getSvr_spr_scm_pwd()));

				ClientInfoCmmn cic = new ClientInfoCmmn();
				result = cic.db_List(serverObj, IP, PORT);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * [DB TREE] Reposytory DB서버 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectTreeDBList.do")
	@ResponseBody
	public List<DbVO> selectTreeDBList(@ModelAttribute("dbVO") DbVO dbVO, HttpServletResponse response,
			HttpServletRequest request) {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		List<DbVO> resultSet = null;
		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			} else {
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				resultSet = dbServerManagerService.selectDbListTree(db_svr_id);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * [DB TREE] DB를 등록 한다.
	 * 
	 * @param dbServerVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTreeDB.do")
	public @ResponseBody boolean insertTreeDB(
			@ModelAttribute("accessControlHistoryVO") AccessControlHistoryVO accessControlHistoryVO,
			@ModelAttribute("accessControlVO") AccessControlVO accessControlVO,
			@ModelAttribute("dbServerVO") DbServerVO dbServerVO, @ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) throws ParseException {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");
		List<DbVO> resultSet = null;
		
		try {
			// 쓰기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return false;
			} else {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0005_01");
				historyVO.setMnu_id(9);
				accessHistoryService.insertHistory(historyVO);

				String id = (String) request.getSession().getAttribute("usr_id");

				dbServerVO.setFrst_regr_id(id);
				dbServerVO.setLst_mdfr_id(id);

				String strRows = request.getParameter("rows").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);

				HashMap<String, Object> paramvalue = new HashMap<String, Object>();
				
				int db_svr_id = dbServerVO.getDb_svr_id();
				resultSet = dbServerManagerService.selectDbListTree(db_svr_id);

				if(resultSet.size() != 0){				
					for (int i = 0; i < rows.size(); i++) {					
						int cnt = 0; 
						for(int j=0; j<resultSet.size(); j++){					
							JSONObject jsrow = (JSONObject) rows.get(i);
							String dft_db_nm = jsrow.get("dft_db_nm").toString();
							String useyn = jsrow.get("useyn").toString();
							String db_exp = jsrow.get("db_exp").toString();
							if(dft_db_nm.equals(resultSet.get(j).getDb_nm())){
								cnt ++;
							}	
							paramvalue.put("db_svr_id", dbServerVO.getDb_svr_id());
							paramvalue.put("dft_db_nm", dft_db_nm);
							paramvalue.put("frst_regr_id", dbServerVO.getFrst_regr_id());
							paramvalue.put("lst_mdfr_id", dbServerVO.getLst_mdfr_id());
							paramvalue.put("useyn", useyn);
							paramvalue.put("db_exp", db_exp);
						}	
						if(cnt == 1){
							System.out.println("============== update Data ==============");
							System.out.println("DB 명 : "+ paramvalue.get("dft_db_nm"));
							System.out.println("사용여부 : "+ paramvalue.get("useyn"));
							System.out.println("====================================");
							dbServerManagerService.updateDB(paramvalue);			
						}else{
							System.out.println("============== insert data ==============");
							System.out.println("DB 명 : "+ paramvalue.get("dft_db_nm"));
							System.out.println("사용여부 : "+ paramvalue.get("useyn"));
							System.out.println("====================================");
							dbServerManagerService.insertDB(paramvalue);	
						}							
					}
				}else{
					for (int i = 0; i < rows.size(); i++) {
						JSONObject jsrow = (JSONObject) rows.get(i);
						String dft_db_nm = jsrow.get("dft_db_nm").toString();
						String useyn = jsrow.get("useyn").toString();
						String db_exp = jsrow.get("db_exp").toString();

						paramvalue.put("db_svr_id", dbServerVO.getDb_svr_id());
						paramvalue.put("dft_db_nm", dft_db_nm);
						paramvalue.put("frst_regr_id", dbServerVO.getFrst_regr_id());
						paramvalue.put("lst_mdfr_id", dbServerVO.getLst_mdfr_id());
						paramvalue.put("useyn", useyn);
						paramvalue.put("db_exp", db_exp);

						dbServerManagerService.insertDB(paramvalue);	
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	
	/**
	 * [DB TREE] Reposytory DB 갯수를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/fn_repoDBcnt.do")
	@ResponseBody
	public List<DbVO> fn_repoDBcnt(HttpServletResponse response,
			HttpServletRequest request) {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		List<DbVO> resultSet = null;
		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			} else {
			
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * 실행중인 커넥터, 스케줄 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/exeCheck.do")
	@ResponseBody
	public Map exeCheck(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {

		Map result = null;	
		
		try {					
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));				
				result = dbServerManagerService.exeCheck(db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	/**
	 * 서버를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/dbSvrDelete.do")
	public @ResponseBody boolean dbSvrDelete(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
		try {	
			/*CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN0004");
			
			//쓰기권한이 없는경우
			if(menuAut.get(0).get("wrt_aut_yn").equals("N")){
				response.sendRedirect("/autError.do");
				return false;
			}*/
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			
			/*전송대상 topic 공백으로 업데이트하기! */
			JSONObject serverObj = new JSONObject();
			ClientInfoCmmn cic = new ClientInfoCmmn();
			List<Map<String, Object>> connectInfo = null;
			JSONObject result = new JSONObject();
			JSONObject param = new JSONObject();
			String topic = "";
			
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			TransferVO tengInfo = (TransferVO) transferService.selectTengInfo(usr_id);
			if(tengInfo!=null){
				String IP = tengInfo.getTeng_ip();
				int PORT = tengInfo.getTeng_port();
				connectInfo= transferService.selectConnectorInfo(db_svr_id);
				if(connectInfo.size()!=0){
					for(int i=0; i<connectInfo.size(); i++){
						String trf_trg_cnn_nm = (String) connectInfo.get(i).get("trf_trg_cnn_nm");
						String strServerIp = (String) connectInfo.get(i).get("cnr_ipadr");
						String strServerPort = String.valueOf(connectInfo.get(i).get("cnr_portno"));
						serverObj.put(ClientProtocolID.SERVER_IP, strServerIp);
						serverObj.put(ClientProtocolID.SERVER_PORT, strServerPort);
						result = cic.kafakConnect_select(serverObj, trf_trg_cnn_nm, IP, PORT);
						for (int j = 0; j < result.size(); j++) {
							JSONArray data = (JSONArray) result.get("data");
							for (int m = 0; m < data.size(); m++) {
								JSONObject jsonObj = (JSONObject) data.get(m);
								JSONObject hp = (JSONObject) jsonObj.get("hp");

								param.put("strName", (String) hp.get("name"));
								param.put("strConnector_class", (String) hp.get("connector.class"));
								param.put("strTasks_max", (String) hp.get("tasks.max"));
								param.put("strTopics", topic);
								param.put("strHdfs_url", (String) hp.get("hdfs.url"));
								param.put("strHadoop_conf_dir", (String) hp.get("hadoop.conf.dir"));
								param.put("strHadoop_home", (String) hp.get("hadoop.home"));
								param.put("strFlush_size", (String) hp.get("flush.size"));
								param.put("strRotate_interval_ms", (String) hp.get("rotate.interval.ms"));
							}
						}
						/* kafakConnect_update topic 업데이트 */
						cic.kafakConnect_update(serverObj, param, IP, PORT);
					}
					
				}
				
			}
			
			dbServerManagerService.dbSvrDelete(db_svr_id);

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0005_02");
			historyVO.setMnu_id(9);
			accessHistoryService.insertHistory(historyVO);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}	
	
	
	/**
	 * [DB TREE] Reposytory DB서버 리스트를 조회한다. [USE_YN = Y  데이터베이스 동기]
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/selectDBSync.do")
	@ResponseBody
	public List<DbVO> selectDBSync(@ModelAttribute("dbVO") DbVO dbVO, HttpServletResponse response,
			HttpServletRequest request) {

		// 해당메뉴 권한 조회 (공통메소드호출)
		CmmnUtils cu = new CmmnUtils();
		menuAut = cu.selectMenuAut(menuAuthorityService, "MN000301");

		List<DbVO> resultSet = null;
		try {
			// 읽기 권한이 없는경우 error페이지 호출 , [추후 Exception 처리예정]
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			} else {
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				resultSet = dbServerManagerService.selectDBSync(db_svr_id);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * 데이터베이스를 동기화한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return 
	 * @throws Exception
	 */
	@RequestMapping(value = "/syncUpdate.do")
	public @ResponseBody void syncUpdate(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletResponse response, HttpServletRequest request) {
			try {	
				String strRows = request.getParameter("db_id").toString().replaceAll("&quot;", "\"");
				JSONArray rows = (JSONArray) new JSONParser().parse(strRows);
	
				List<String> ids = new ArrayList<String>(); 
				HashMap<String , Object> paramvalue = new HashMap<String, Object>();
				
				for(int i=0; i<rows.size(); i++){
					ids.add(rows.get(i).toString()); 
				}
				paramvalue.put("db_id", ids);
				
				System.out.println(paramvalue.get("db_id"));
				
				dbServerManagerService.syncUpdate(paramvalue);
					
			} catch (Exception e) {
				e.printStackTrace();
			}		
		}	
	}
