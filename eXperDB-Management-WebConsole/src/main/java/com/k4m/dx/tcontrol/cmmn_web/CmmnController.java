package com.k4m.dx.tcontrol.cmmn_web;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
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
import com.k4m.dx.tcontrol.dashboard.service.DashboardService;
import com.k4m.dx.tcontrol.dashboard.service.DashboardVO;
import com.k4m.dx.tcontrol.encrypt.service.call.AgentMonitoringServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.CommonServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.StatisticsServiceCall;
import com.k4m.dx.tcontrol.functions.schedule.service.ScheduleService;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleService;
import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;
import com.k4m.dx.tcontrol.script.service.ScriptService;

/**
 * 공통 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.24   변승우 최초 생성
 *      </pre>
 */

@Controller
public class CmmnController {

	@Autowired
	private ScriptService scriptService;

	@Autowired
	private BackupService backupService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;

	@Autowired
	private DashboardService dashboardService;

	@Autowired
	private ScheduleService scheduleService;

	@Autowired
	private InstanceScaleService instanceScaleService;

	/**
	 * 메인(홈)을 보여준다.
	 * @return ModelAndView mv
	 */
	@RequestMapping(value = "/experdb.do")
	public ModelAndView experdb(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("experdb/body");
		return mv;	
	}

	/**
	 * 대시보드화면을 보여준다.
	 * @return ModelAndView mv
	 */
	@RequestMapping(value = "/dashboard.do")
	public ModelAndView dashboard(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, ModelMap model) throws Exception {
		ModelAndView mv = new ModelAndView();
		try {
			Properties props = new Properties();
			props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	

			// 메인 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0004");
			accessHistoryService.insertHistory(historyVO);

			// 백업정보
			DashboardVO backupInfoVO = (DashboardVO) dashboardService.selectDashboardBackupInfo();

			// 스케줄 정보
			DashboardVO scheduleInfoVO = (DashboardVO) dashboardService.selectDashboardScheduleInfo();

			DashboardVO dashVo = new DashboardVO();

			//서버정보
			List<DashboardVO> serverInfoVOSelectTot = (List<DashboardVO>) dashboardService.selectDashboardServerInfoNew(dashVo);
			List<DashboardVO> serverInfoTotVO = new ArrayList<DashboardVO>();

			try{
				if(serverInfoVOSelectTot.size()>0){
					for(int i=0; i<serverInfoVOSelectTot.size(); i++){
						dashVo = new DashboardVO();
						dashVo.setDb_svr_nm(serverInfoVOSelectTot.get(i).getDb_svr_nm());
						dashVo.setIpadr(serverInfoVOSelectTot.get(i).getIpadr());
						dashVo.setDb_svr_id(serverInfoVOSelectTot.get(i).getDb_svr_id());

						dashVo.setDb_cnt(serverInfoVOSelectTot.get(i).getDb_cnt());
						dashVo.setUndb_cnt(0);

						dashVo.setConnect_cnt(serverInfoVOSelectTot.get(i).getConnect_cnt());
						dashVo.setExecute_cnt(serverInfoVOSelectTot.get(i).getExecute_cnt());
						dashVo.setLst_mdf_dtm(serverInfoVOSelectTot.get(i).getLst_mdf_dtm());
						dashVo.setAgt_cndt_cd(serverInfoVOSelectTot.get(i).getAgt_cndt_cd());
						dashVo.setAudit_state("-");
						dashVo.setMaster_gbn(serverInfoVOSelectTot.get(i).getMaster_gbn());
						dashVo.setSvr_host_nm(serverInfoVOSelectTot.get(i).getSvr_host_nm());

						serverInfoTotVO.add(dashVo);
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}

			String db2pg_yn = "N";
			if (props.get("db2pg") != null) {
				db2pg_yn = props.get("db2pg").toString();
				if (!"Y".equals(db2pg_yn)) {
					db2pg_yn = "N";
				}
			}

			//scale_yn확인
			String strScaleYn = "N";
			if (props.get("scale") != null) {
				strScaleYn = props.get("scale").toString();
				if (!"Y".equals(strScaleYn)) {
					strScaleYn = "N";
				}
			}

			// proxy_menu_yn 확인
			String strProxyMenuYn = "N";
			if(props.get("proxy.menu.useyn") != null) {
				strProxyMenuYn = props.get("proxy.menu.useyn").toString();
				if(!"Y".equals(strProxyMenuYn)){
					strProxyMenuYn = "N";
				}
			}

			// proxy_yn 확인
			String strProxyYn = "N";
			if(props.get("proxy.useyn") != null) {
				strProxyYn = props.get("proxy.useyn").toString();
				if(!"Y".equals(strProxyYn)){
					strProxyYn = "N";
				}
			}

			mv.addObject("db2pg_yn", db2pg_yn);				//DB2_PG 사용여부
			mv.addObject("scale_yn", strScaleYn);			//scale 사용여부
			mv.addObject("scheduleInfo", scheduleInfoVO);	//스케줄 정보
			mv.addObject("backupInfo", backupInfoVO);		//백업 정보
			mv.addObject("serverTotInfo", serverInfoTotVO);	//서버 정보
			mv.addObject("proxy_yn", strProxyYn); // proxy 사용여부
			mv.addObject("proxy_menu_yn", strProxyMenuYn); // proxy 사용여부
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("dashboard");
		return mv;
	}

	/**
	 * 대쉬보드 서버별 화면 관련 내역 조회
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 * @throws Exception
	 */
	@RequestMapping(value = "/dashboarod_main_search.do")
	public ModelAndView connectRegForm2(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, @ModelAttribute("workVo") WorkVO workVO) throws FileNotFoundException, IOException {
		ModelAndView mv = new ModelAndView("jsonView");

		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	

		//scale yn
		String strScaleYn = "N";
		if (props.get("scale") != null) {
			strScaleYn = props.get("scale").toString();
			if (!"Y".equals(strScaleYn)) {
				strScaleYn = "N";
			}
		}

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

		List<Map<String, Object>> backupScdresult = null; 			//백업일정 조회
		List<Map<String, Object>> scriptScdresult = null; 			//배치일정 조회
		List<Map<String, Object>> scheduleHistoryresult = null; 	//스케줄이력 조회
		Map<String, Object> scheduleHistoryChart = null;			//스케줄이력 chart 조회
		List<Map<String, Object>> backupHistoryresult = null; 		//백업이력 조회
		List<DashboardVO> backupDumpInfoVO = null;					//백업정보(DUMP)
		List<DashboardVO> backupRmanInfoVO = null;					//백업정보(RMAN)
		List<Map<String, Object>> scriptHistoryresult = null; 		//배치이력 조회
		Map<String, Object> scriptHistoryChart = null;				//배치이력 chart 조회

		int backupScdCnt = 0;
		int scriptScdCnt = 0;
		int migtScdCnt = 0;

		List<Map<String, Object>> migtScdresult = null; 			//MIGRATION 일정 조회
		List<Map<String, Object>> migtHistoryresult = null; 		//MIGRATION 이력 조회
		Map<String, Object> migtHistoryChart = null;				//MIGRATION chart 조회

		Map<String, Object> scaleChkresult = new JSONObject();
		String scale_install_yn = "";								//스케일 가능여부
		List<Map<String, Object>> scaleHistoryresult = null; 		//scale 이력 조회
		List<Map<String, Object>> scaleSettingChartresult = new ArrayList<Map<String, Object>>(); 	//scale chart list 조회

		Map<String, Object> scaleHistoryChart = null;				//scale chart 조회
		Map<String, Object> scaleSettingChart = null;				//scale 발생이력 chart 조회

		DashboardVO dashVo = new DashboardVO();
		InstanceScaleVO instanceScaleVO = new InstanceScaleVO();

		JSONObject tablespaceObj = new JSONObject();

		try {
			//백업 스케줄 목록
			dashVo.setDb_svr_id(db_svr_id);
			instanceScaleVO.setDb_svr_id(db_svr_id);

			dashVo.setBsn_dscd("TC001901");
			backupScdresult = dashboardService.selectDashboardScdList(dashVo);
			if (backupScdresult != null) {
				backupScdCnt = backupScdresult.size();
			}

			//배치 스케줄 목록
			dashVo.setBsn_dscd("TC001902");
			scriptScdresult = dashboardService.selectDashboardScdList(dashVo);
			if (scriptScdresult != null) {
				scriptScdCnt = scriptScdresult.size();
			}

			//스케줄 이력 목록
			scheduleHistoryresult = dashboardService.selectDashboardScheduleHistory(dashVo);
			//스케줄 이력 chart 조회
			scheduleHistoryChart = dashboardService.selectDashboardScheduleHistoryChart(dashVo);

			//백업 이력 목록
			dashVo.setBsn_dscd("TC001901");
			backupHistoryresult = dashboardService.selectDashboardBackupHistory(dashVo);

			// 백업정보(DUMP)
			backupDumpInfoVO = (List<DashboardVO>) dashboardService.selectDashboardBackupDumpInfo(dashVo);

			// 백업정보(RMAN)
			backupRmanInfoVO = (List<DashboardVO>) dashboardService.selectDashboardBackupRmanInfo(dashVo);

			//배치 이력 목록
			dashVo.setBsn_dscd("TC001902");
			scriptHistoryresult = dashboardService.selectDashboardBackupHistory(dashVo);
			//배치 이력 chart 조회
			scriptHistoryChart = dashboardService.selectDashboardScriptHistoryChart(dashVo);

			//MIGRATION 스케줄 목록
			migtScdresult = dashboardService.selectDashboardMigtList(dashVo);
			if (migtScdresult != null) {
				migtScdCnt = migtScdresult.size();
			}

			//MIGRATION 이력 목록
			migtHistoryresult = dashboardService.selectDashboardMigtHistory(dashVo);
			//MIGRATION 이력 chart 조회
			migtHistoryChart = dashboardService.selectDashboardMigtHistoryChart(dashVo);

			//scale log확인
			if (strScaleYn.equals("Y")) {
				try {
					//scale log 확인
					scaleChkresult = (Map<String, Object>)instanceScaleService.scaleInstallChk(instanceScaleVO);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				if (scaleChkresult != null) {
					scale_install_yn = (String)scaleChkresult.get("install_yn");
					if (scale_install_yn != null && "Y".equals(scale_install_yn)) {
						//scale 이력 목록
						scaleHistoryresult = dashboardService.selectDashboardScaleHistory(dashVo);

						//scale 이력 chart 조회
						scaleHistoryChart = dashboardService.selectDashboardScaleHistoryChart(dashVo);

						if (scaleHistoryChart != null) {
							if (scaleHistoryChart.get("db_svr_id") != null) {
								for (int i = 0; i < 4; i++) {
									Map<String, Object> chart = new HashMap<String, Object>();
									String scale_nm_val = "scale_nm" +  Integer.toString(i);

									chart.put("scale_nm", scale_nm_val);
									if (i== 0) {
										chart.put("suc", scaleHistoryChart.get("exe_in_auto_suc"));
										chart.put("fal", scaleHistoryChart.get("exe_in_auto_fal"));
									} else if (i== 1) {
										chart.put("suc", scaleHistoryChart.get("exe_out_auto_suc"));
										chart.put("fal", scaleHistoryChart.get("exe_out_auto_fal"));
									} else if (i== 2) {
										chart.put("suc", scaleHistoryChart.get("exe_in_mnl_suc"));
										chart.put("fal", scaleHistoryChart.get("exe_in_mnl_fal"));
									} else if (i== 3) {
										chart.put("suc", scaleHistoryChart.get("exe_out_mnl_suc"));
										chart.put("fal", scaleHistoryChart.get("exe_out_mnl_fal"));
									}
		
									scaleSettingChartresult.add(chart);
								}
							}
						}

						//scale 발생이력 chart 조회
						scaleSettingChart = dashboardService.selectDashboardScaleSetChart(dashVo);
					}
				}
			}

			tablespaceObj = tablespaceSelect(db_svr_id);

			mv.addObject("backupScdresult", backupScdresult);				//백업일정 목록
			mv.addObject("backupScdCnt", backupScdCnt);						//백업일정 cnt

			mv.addObject("scriptScdresult", scriptScdresult);				//배치일정 목록
			mv.addObject("scriptScdCnt", scriptScdCnt);						//배치일정 cnt

			mv.addObject("scheduleHistoryresult", scheduleHistoryresult);	//스케줄 이력 목록
			mv.addObject("scheduleHistoryChart", scheduleHistoryChart);		//스케줄 이력 chart 조회

			mv.addObject("backupHistoryresult", backupHistoryresult);		//백업 이력 목록
			mv.addObject("backupDumpInfo", backupDumpInfoVO);				//dump백업
			mv.addObject("backupRmanInfo", backupRmanInfoVO);				//rman백업

			mv.addObject("scriptHistoryresult", scriptHistoryresult);		//배치 이력 목록
			mv.addObject("scriptHistoryChart", scriptHistoryChart);			//배치 이력 chart 조회

			mv.addObject("migtScdresult", migtScdresult);					//migration 일정 목록
			mv.addObject("migtScdCnt", migtScdCnt);							//migration 일정 cnt
			mv.addObject("migtHistoryresult", migtHistoryresult);			//migration 이력 목록
			mv.addObject("migtHistoryChart", migtHistoryChart);				//migration 이력 chart 조회

			mv.addObject("scale_install_yn", scale_install_yn);				//scale 가능여부
			mv.addObject("scaleHistoryresult", scaleHistoryresult);			//scale 이력 목록 조회
			mv.addObject("scaleSettingChartresult", scaleSettingChartresult);//scale 이력 chart 조회
			mv.addObject("scaleSettingChart", scaleSettingChart);			//scale 발생이력 chart 조회

			mv.addObject("db_svr_id", db_svr_id);

			mv.addObject("tablespaceObj", tablespaceObj);					//테이블 space 조회

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 속성 화면 조회.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	public JSONObject tablespaceSelect(int db_svr_id) {
		ClientInfoCmmn cic = new ClientInfoCmmn();
		JSONObject serverObj = new JSONObject();
		JSONObject result = new JSONObject();

		try {
			AES256 dec = new AES256(AES256_KEY.ENC_KEY);

			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO); //서버정보조회

			String strIpAdr = dbServerVO.getIpadr();
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(strIpAdr);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo); //agent 정보조회

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, dbServerVO.getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, dec.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			result = cic.serverSpace(IP, PORT, serverObj);   //대시보드 서버용량

		}catch(Exception e){
			e.printStackTrace();
		}

		return result;
	}

	/**
	 *  권한 에러 화면을 보여준다.
	 * 
	 * @param 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/autError.do")
	public ModelAndView autError(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			mv.setViewName("error/autError");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * DB서버에 대한 DB 리스트를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectServerDBList.do")
	@ResponseBody
	public Map<String, Object> selectServerDBList (@ModelAttribute("dbServerVO") DbServerVO dbServerVO, HttpServletRequest request) {
		Map<String, Object> result =new HashMap<String, Object>();

		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			String db_svr_nm = request.getParameter("db_svr_nm");

			List<DbServerVO> resultSet = cmmnServerInfoService.selectDbServerList(db_svr_nm);

			JSONObject serverObj = new JSONObject();

			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(resultSet.get(0).getIpadr());

			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = resultSet.get(0).getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			serverObj.put(ClientProtocolID.SERVER_NAME, resultSet.get(0).getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, resultSet.get(0).getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, resultSet.get(0).getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME, resultSet.get(0).getDft_db_nm());
			serverObj.put(ClientProtocolID.USER_ID, resultSet.get(0).getSvr_spr_usr_id());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(resultSet.get(0).getSvr_spr_scm_pwd()));

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.db_List(serverObj, IP, PORT);
	
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * Object 리스트를 조회한다.
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/getObjectList.do")
	@ResponseBody
	public Map<String, Object> getObjectList (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		Map<String, Object> result =new HashMap<String, Object>();

		try {
			AES256 aes = new AES256(AES256_KEY.ENC_KEY);
			DbServerVO dbServerVO = backupService.selectDbSvrNm(workVO);
			JSONObject serverObj = new JSONObject();

			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(dbServerVO.getIpadr());

			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = dbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			String db_nm = request.getParameter("db_nm");

			serverObj.put(ClientProtocolID.SERVER_NAME, dbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, dbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, dbServerVO.getPortno());
			serverObj.put(ClientProtocolID.DATABASE_NAME,  db_nm);
			serverObj.put(ClientProtocolID.USER_ID, dbServerVO.getSvr_spr_usr_id());
			//serverObj.put(ClientProtocolID.USER_PWD, dbServerVO.getSvr_spr_scm_pwd());
			serverObj.put(ClientProtocolID.USER_PWD, aes.aesDecode(dbServerVO.getSvr_spr_scm_pwd()));

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.object_List(serverObj, IP, PORT);

			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 디렉토리 존재유무 체크
	 * @param WorkVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/existDirCheck.do")
	@ResponseBody
	public Map<String, Object> existDirCheck (@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request, @ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		Map<String, Object> result =new HashMap<String, Object>();
		String directory_path = request.getParameter("path");
		List<DbServerVO> ipResult = null;

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		try {
			ipResult = (List<DbServerVO>) cmmnServerInfoService.selectAllIpadrList(db_svr_id);

			for(int i=0; i<ipResult.size(); i++){
				JSONObject serverObj = new JSONObject();

				AgentInfoVO vo = new AgentInfoVO();
				vo.setIPADR(ipResult.get(i).getIpadr());

				AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

				String IP = ipResult.get(i).getIpadr();
				int PORT = agentInfo.getSOCKET_PORT();

				serverObj.put(ClientProtocolID.SERVER_NAME, ipResult.get(i).getDb_svr_nm());
				serverObj.put(ClientProtocolID.SERVER_IP, ipResult.get(i).getIpadr());
				serverObj.put(ClientProtocolID.SERVER_PORT, ipResult.get(i).getPortno());

				ClientInfoCmmn cic = new ClientInfoCmmn();
				result = cic.directory_exist(serverObj,directory_path, IP, PORT);	
				

				int resultCd = Integer.parseInt(result.get("resultCode").toString());
				
				if(resultCd == 1){
					return result;
				}
			}
			//System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 디렉토리 존재유무 체크(master만 체크)
	 * @param WorkVO, request, dbServerVO
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/existDirCheckMaster.do")
	@ResponseBody
	public Map<String, Object> existDirCheckMaster(@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request, @ModelAttribute("dbServerVO") DbServerVO dbServerVO) {
		Map<String, Object> result =new HashMap<String, Object>();
		String directory_path = request.getParameter("path");	
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));

		try {
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO DbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);

			JSONObject serverObj = new JSONObject();

			AgentInfoVO vo = new AgentInfoVO();
			String strIpAdr = DbServerVO.getIpadr();
			vo.setIPADR(strIpAdr);

			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);

			String IP = DbServerVO.getIpadr();
			int PORT = agentInfo.getSOCKET_PORT();

			serverObj.put(ClientProtocolID.SERVER_NAME, DbServerVO.getDb_svr_nm());
			serverObj.put(ClientProtocolID.SERVER_IP, DbServerVO.getIpadr());
			serverObj.put(ClientProtocolID.SERVER_PORT, DbServerVO.getPortno());

			ClientInfoCmmn cic = new ClientInfoCmmn();
			result = cic.directory_exist(serverObj,directory_path, IP, PORT);	

			int resultCd = Integer.parseInt(result.get("resultCode").toString());
				
			if(resultCd == 1){
				return result;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 스케줄 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectScdInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectScdInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int scd_id = Integer.parseInt(request.getParameter("scd_id"));
			String locale_type = LocaleContextHolder.getLocale().getLanguage();
			result = scheduleService.selectScdInfo(scd_id, locale_type);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * WORK 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectWrkInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
			
			result = scheduleService.selectWrkInfo(wrk_id);	
	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * WORK OPTION 정보(DUMP)
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/workOptionLayer.do")
	@ResponseBody
	public List<Map<String, Object>> workOptionLayer(@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int bck_wrk_id = Integer.parseInt(request.getParameter("bck_wrk_id"));	
			result = backupService.selectWorkOptionLayer(bck_wrk_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * WORK Object 리스트 조회
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/workObjectListTreeLayer.do")
	@ResponseBody
	public List<Map<String, Object>> workObjectListTreeLayer(@ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int bck_wrk_id = Integer.parseInt(request.getParameter("bck_wrk_id"));	
			result = backupService.selectWorkObjectLayer(bck_wrk_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 아이피 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectIpadrList.do")
	@ResponseBody
	public List<Map<String, Object>> selectIpadrList(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			result = cmmnServerInfoService.selectIpadrList(db_svr_id);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 작업로그정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectWrkErrorMsg.do")
	@ResponseBody
	public List<Map<String, Object>> selectWrkErrorMsg(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int exe_sn = Integer.parseInt(request.getParameter("exe_sn"));
			result = cmmnServerInfoService.selectWrkErrorMsg(exe_sn);	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	

	/**
	 * HA구성확인
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectHaCnt.do")
	@ResponseBody
	public List<Map<String, Object>> selectHaCnt(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			result = cmmnServerInfoService.selectHaCnt(db_svr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	/**
	 * 대시보드 암호화통계
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectDashSecurityStatistics.do")
	public @ResponseBody JSONObject selectDashSecurityStatistics(HttpServletRequest request) {

		JSONArray agentStatusList = new JSONArray();
		JSONArray tResult = new JSONArray();
		JSONObject result = new JSONObject();

		List<Map<String, Object>> agentList = null;
		List<Map<String, Object>> agentStatusListResult = null;

		//통계결과
		JSONObject statisticsResult = new JSONObject();
		List<Map<String, Object>> statisticsListResult = null;

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();

		try {
			String from = request.getParameter("from");
			String to = request.getParameter("to");
			String categoryColumn = request.getParameter("categoryColumn");
			
			CommonServiceCall csc = new CommonServiceCall();
			AgentMonitoringServiceCall amsc = new AgentMonitoringServiceCall();

			agentList = csc.selectEntityList2(restIp, restPort, strTocken, loginId, entityId);
			agentStatusList = amsc.selectSystemStatus(restIp, restPort, strTocken, loginId, entityId);

			agentStatusListResult = (List<Map<String, Object>>) agentStatusList;

			//암호화통계 결과
			StatisticsServiceCall ssc = new StatisticsServiceCall();
			statisticsResult = ssc.selectAuditLogSiteHourForStat(restIp, restPort, strTocken, loginId, entityId, from, to, categoryColumn);
			statisticsListResult= (List<Map<String, Object>>) statisticsResult.get("list");

			if(statisticsListResult.size() == 0){
				result.put("resultCode", statisticsResult.get("resultCode"));
				result.put("resultMessage", statisticsResult.get("resultMessage"));
			}else{
				for(int i=0; i<agentStatusListResult.size(); i++){	
					agentStatusListResult.get(i).put("encryptSuccessCount", "0");
					agentStatusListResult.get(i).put("encryptFailCount", "0");
					agentStatusListResult.get(i).put("decryptSuccessCount", "0");
					agentStatusListResult.get(i).put("decryptFailCount", "0");
					agentStatusListResult.get(i).put("sumCount", "0");

					tResult.add(agentStatusListResult.get(i));
				}

				if(statisticsListResult.get(0).get("categoryColumn").equals("-")){
					for(int k=0; k<agentList.size(); k++){
						result.put("resultCode", agentList.get(0).get("resultCode"));
						result.put("resultMessage", agentList.get(0).get("resultMessage"));

						agentList.get(k).put("encryptSuccessCount", "0");
						agentList.get(k).put("encryptFailCount", "0");
						agentList.get(k).put("decryptSuccessCount", "0");
						agentList.get(k).put("decryptFailCount", "0");
						agentList.get(k).put("sumCount", "0");

						int temp =0;
						for(int i=0; i<agentStatusListResult.size(); i++){
							if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
								temp ++;
							}
						}

						if(temp == 0){
							JSONObject addList = new JSONObject();
							addList.put("monitoredName", agentList.get(k).get("createName"));
							addList.put("encryptSuccessCount", agentList.get(k).get("encryptSuccessCount"));
							addList.put("encryptFailCount", agentList.get(k).get("encryptFailCount"));
							addList.put("decryptSuccessCount", agentList.get(k).get("decryptSuccessCount"));
							addList.put("decryptFailCount", agentList.get(k).get("decryptFailCount"));
							addList.put("sumCount", agentList.get(k).get("sumCount"));
							addList.put("status", "start");
							tResult.add(addList);
						}
					}		
				}else{
					for(int k=0; k<agentList.size(); k++){
						int temp =0;
						result.put("resultCode", agentList.get(0).get("resultCode"));
						result.put("resultMessage", agentList.get(0).get("resultMessage"));
						for(int i =0; i<statisticsListResult.size(); i++){
							if(agentList.get(k).get("createName").toString().contains(statisticsListResult.get(i).get("categoryColumn").toString())){
								agentList.get(k).put("encryptSuccessCount", statisticsListResult.get(i).get("encryptSuccessCount"));
								agentList.get(k).put("encryptFailCount", statisticsListResult.get(i).get("encryptFailCount"));
								agentList.get(k).put("decryptSuccessCount", statisticsListResult.get(i).get("decryptSuccessCount"));
								agentList.get(k).put("decryptFailCount", statisticsListResult.get(i).get("decryptFailCount"));
								agentList.get(k).put("sumCount", statisticsListResult.get(i).get("sumCount"));
							}
						}

						for(int i=0; i<agentStatusListResult.size(); i++){
							result.put("resultCode", agentStatusListResult.get(0).get("resultCode"));
							result.put("resultMessage", agentStatusListResult.get(0).get("resultMessage"));
							if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
								temp ++;
							}
						}

						if(temp == 0){
							JSONObject addList = new JSONObject();
							addList.put("monitoredName", agentList.get(k).get("createName"));
							addList.put("encryptSuccessCount", agentList.get(k).get("encryptSuccessCount"));
							addList.put("encryptFailCount", agentList.get(k).get("encryptFailCount"));
							addList.put("decryptSuccessCount", agentList.get(k).get("decryptSuccessCount"));
							addList.put("decryptFailCount", agentList.get(k).get("decryptFailCount"));
							addList.put("sumCount", agentList.get(k).get("sumCount"));
							addList.put("status", "start");
							tResult.add(addList);
						}
					}
				}
			}

			/*for(int k=0; k<agentList.size(); k++){
				int temp =0;
				for(int i=0; i<agentStatusListResult.size(); i++){
					result.put("resultCode", agentStatusListResult.get(0).get("resultCode"));
					result.put("resultMessage", agentStatusListResult.get(0).get("resultMessage"));
					if(agentList.get(k).get("createName").equals(agentStatusListResult.get(i).get("monitoredName"))){
						temp ++;
					}
				}
				if(temp == 0){
					JSONObject addList = new JSONObject();
					addList.put("monitoredName", agentList.get(k).get("createName"));
					addList.put("status", "start");
					tResult.add(addList);
				}
			}*/

			result.put("list", tResult);
			System.out.println("결과="+ result);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 데시보드 서버상태
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/serverStatus.do")	
	public @ResponseBody JSONObject serverStatus(HttpServletRequest request) {
		JSONObject result = new JSONObject();

		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String restIp = loginVo.getRestIp();
		int restPort = loginVo.getRestPort();
		String strTocken = loginVo.getTockenValue();
		String loginId = loginVo.getUsr_id();
		String entityId = loginVo.getEctityUid();

		try{
			CommonServiceCall csc = new CommonServiceCall();
			result = csc.selectServerStatus(restIp, restPort, strTocken, loginId, entityId);
		}catch(Exception e){
			result.put("resultCode", "8000000002");
		}
		return result;
	}

	/**
	 * ScriptWORK 정보
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/selectSciptExeInfo.do")
	@ResponseBody
	public List<Map<String, Object>> selectSciptExeInfo(HttpServletRequest request) {
		List<Map<String, Object>> result = null;

		try {
			int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
			
			result = scriptService.selectSciptExeInfo(wrk_id);	

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * Manual Download
	 * @param 
	 * @return resultSet
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/manualDownload.do")
	@ResponseBody
	public void manualDownload(HttpServletRequest request, HttpServletResponse response) {

		String fileName = "manual.pdf"; //파일명

		FileInputStream fileInputStream = null;
		ServletOutputStream servletOutputStream = null;

		try {
			String downName = null;
			String browser = request.getHeader("User-Agent");
			//파일 인코딩
			if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){//브라우저 확인 파일명 encode  
				downName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
			}else{
				downName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			}

			response.setHeader("Content-Disposition","attachment;filename=\"" + downName+"\"");             
			response.setContentType("application/octer-stream");
			response.setHeader("Content-Transfer-Encoding", "binary;");

			fileInputStream = new FileInputStream(ResourceUtils.getFile("classpath:manual/manual.pdf"));
			servletOutputStream = response.getOutputStream();

			byte b [] = new byte[1024];
			int data = 0;

			while((data=(fileInputStream.read(b, 0, b.length))) != -1){
				servletOutputStream.write(b, 0, data);
			}

			servletOutputStream.flush();//출력
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(servletOutputStream!=null){
				try{
					servletOutputStream.close();
				}catch (IOException e){
					e.printStackTrace();
				}
			}
			if(fileInputStream!=null){
				try{
					fileInputStream.close();
				}catch (IOException e){
					e.printStackTrace();
				}
			}
		}
	}
}