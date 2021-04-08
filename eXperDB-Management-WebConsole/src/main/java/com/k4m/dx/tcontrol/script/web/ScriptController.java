package com.k4m.dx.tcontrol.script.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.quartz.Scheduler;
import org.quartz.impl.StdSchedulerFactory;
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
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.script.service.ScriptService;
import com.k4m.dx.tcontrol.script.service.ScriptVO;


/**
 * Script 컨트롤러 클래스를 정의한다.
 *
 * @author 변승우
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2018.06.08   변승우   최초 생성
 *      </pre>
 */


@Controller
public class ScriptController {
	@Autowired
	private BackupService backupService;

	@Autowired
	private ScriptService scriptService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	/**
	 * Mybatis Transaction 
	 */
	@Autowired
	private PlatformTransactionManager txManager;
	
	/**
	 * 스크립트 화면을 보여준다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/scriptManagement.do")
	public ModelAndView scriptManagement(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125");
			accessHistoryService.insertHistory(historyVO);
			
			mv.addObject("db_svr_id",workVO.getDb_svr_id());		
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.setViewName("script/scriptList");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * Script Registration View page
	 * @param workVO, request, historyVO
	 * @return Map<String, Object>
	 */
	@RequestMapping("/popup/scriptRegForm.do")
	@ResponseBody
	public Map<String, Object> scriptRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id")); 
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0126");
			accessHistoryService.insertHistory(historyVO);
			
			result.put("db_svr_id", db_svr_id);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		return result;
	}

	/**
	 * 스크립트 설정 List
	 * @param scriptVO, request, historyVO
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/selectScriptList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScriptList(@ModelAttribute("ScriptVO") ScriptVO scriptVO,HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<Map<String, Object>> resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = scriptService.selectScriptList(scriptVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}
	
	/**
	 * Script insert
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/popup/insertScript.do")
	@ResponseBody
	public String insertScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		scriptVO.setFrst_regr_id(usr_id);		
			
		String result = "S";		
		String wrkid_result = "S";
		WorkVO resultSet = null;
			
		// Wrk_nm 중복체크 flag 값
		String wrkNmCk = "S";
			
		try{
			String wrk_nm = request.getParameter("wrk_nm");
			int wrkNmCheck = backupService.wrk_nmCheck(wrk_nm);
				
			if (wrkNmCheck > 0) {
				wrkNmCk = "F";
			}
				
		}catch(Exception e){
			e.printStackTrace();
		}
			
		//중복체크 - 사용가능 wrk_nm
		if(wrkNmCk == "S"){		
			try{
				scriptService.insertScriptWork(scriptVO);
			} catch (Exception e) {
				result = "F";
				e.printStackTrace();
			}
				
			// Get Last wrk_id
			if(result.equals("S")){
				try {
					resultSet = backupService.lastWorkId();
					scriptVO.setWrk_id(resultSet.getWrk_id());		
				} catch (Exception e) {
					wrkid_result ="F";
					e.printStackTrace();
				}
			}

			if(wrkid_result.equals("S")){
				try {	
					String cmd = toTEXT(scriptVO.getExe_cmd());
					scriptVO.setExe_cmd(cmd);
						
					scriptService.insertScript(scriptVO);
						
					// 화면접근이력 이력 남기기
					CmmnUtils.saveHistory(request, historyVO);
					historyVO.setExe_dtl_cd("DX-T0126_01");
					accessHistoryService.insertHistory(historyVO);
				} catch (Exception e) {
					e.printStackTrace();
				} 
			}	
		}else{
			return wrkNmCk;
		}
		return Integer.toString(resultSet.getBck_wrk_id());
	}
	
	/**
	 * 스크립트 수정 화면 호출 및 데이터 조회
	 * @param WorkVO
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "/popup/scriptReregForm.do")
	@ResponseBody
	public List<Map<String, Object>> rmanRegReForm(@ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		List<Map<String, Object>> resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0127");
			accessHistoryService.insertHistory(historyVO);

			resultSet = scriptService.selectScriptList(scriptVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return resultSet;	
	}

	/**
	 * Script update
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/popup/updateScript.do")
	@ResponseBody
	public String updateScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		scriptVO.setFrst_regr_id(usr_id);

		String result = "S";	

		try{
			String cmd = toTEXT(scriptVO.getExe_cmd());
			scriptVO.setExe_cmd(cmd);
			
			scriptService.updateScriptWork(scriptVO);
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0127_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			result = "F";
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * Script delete
	 * @param historyVO, scriptVO, request
	 * @return String
	 */
	@RequestMapping(value = "/deleteScript.do")
	@ResponseBody
	public String deleteScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request){
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		scriptVO.setFrst_regr_id(usr_id);

		String result = "S";

		// Transaction 
		DefaultTransactionDefinition def  = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = txManager.getTransaction(def);
		
		try{
			String wrk_id_Rows = request.getParameter("wrk_id_List").toString().replaceAll("&quot;", "\"");
	
			if (wrk_id_Rows == null || "".equals(wrk_id_Rows)) {
				result = "P";
			} else {
				JSONArray wrk_ids = (JSONArray) new JSONParser().parse(wrk_id_Rows);

				//전체 작업 삭제
				for(int i=0; i<wrk_ids.size(); i++){
					int wrk_id = Integer.parseInt(wrk_ids.get(i).toString());
					scriptService.deleteScriptWork(wrk_id);
				}
				
				result = "S";
			}

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_02");
			accessHistoryService.insertHistory(historyVO);
			
			return result;
			
		} catch(Exception e){
			result = "F";
			e.printStackTrace();
			txManager.rollback(status);
		}finally{
			txManager.commit(status);
		}
		
		return result;
	}

	/**
	 * 스케쥴 List를 조회한다.
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectScriptScheduleList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScriptScheduleList(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request, HttpServletResponse response) {
				
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_03");
			historyVO.setMnu_id(3);
			accessHistoryService.insertHistory(historyVO);
			
			//현재 서비스 올라간 스케줄 그룹 정보
			Scheduler scheduler = new StdSchedulerFactory().getScheduler();   
				
			List<Map<String, Object>> result = scriptService.selectScriptScheduleList(scriptVO);

			for(int i=0; i<result.size(); i++){				
				Map<String, Object> mp = new HashMap<String, Object>();
			
				mp.put("rownum", result.get(i).get("rownum"));
				mp.put("idx", result.get(i).get("idx"));
				mp.put("scd_id", result.get(i).get("scd_id"));
				mp.put("scd_nm", result.get(i).get("scd_nm"));
				mp.put("scd_cndt", result.get(i).get("scd_cndt"));
				mp.put("scd_exp", result.get(i).get("scd_exp"));
				mp.put("exe_perd_cd", result.get(i).get("exe_perd_cd"));			
				mp.put("exe_hms", result.get(i).get("exe_hms"));
				mp.put("prev_exe_dtm", result.get(i).get("prev_exe_dtm"));
				mp.put("nxt_exe_dtm", result.get(i).get("nxt_exe_dtm"));
				mp.put("frst_regr_id", result.get(i).get("frst_regr_id"));
				mp.put("frst_reg_dtm", result.get(i).get("frst_reg_dtm"));
				mp.put("lst_mdfr_id", result.get(i).get("lst_mdfr_id"));
				mp.put("lst_mdf_dtm", result.get(i).get("lst_mdf_dtm"));
				mp.put("wrk_cnt", result.get(i).get("wrk_cnt"));
				mp.put("db_svr_nm", result.get(i).get("db_svr_nm"));
				mp.put("exe_dt", result.get(i).get("exe_dt"));
				
				for(int j=0; j<scheduler.getJobGroupNames().size(); j++){	
					if(result.get(i).get("scd_id").toString().equals(scheduler.getJobGroupNames().get(j).toString())){	
						mp.put("status", "s");
					}			
				}		
				resultSet.add(mp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * 스케줄 WRK 리스트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/scriptScheduleWrkListVeiw.do")
	@ResponseBody
	public void scriptScheduleWrkListVeiw(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse response) {
		try {
			//이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0039_03");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 스크립트 이력화면을 보여준다.
	 * 
	 * @param workVO, historyVO, request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/scriptHistory.do")
	public ModelAndView scriptHistory(@ModelAttribute("workVo") WorkVO workVO, @ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();

		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));  
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0128");
			accessHistoryService.insertHistory(historyVO);
			
			mv.addObject("db_svr_id",db_svr_id);
			mv.addObject("db_svr_nm", backupService.selectDbSvrNm(workVO).getDb_svr_nm());
			mv.setViewName("script/scriptHistory");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 스크립트 History List
	 * @param request, scriptVO, historyVO
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/selectScriptHistoryList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScriptHistoryList(@ModelAttribute("ScriptVO") ScriptVO scriptVO,HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<Map<String, Object>> resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0128_01");
			accessHistoryService.insertHistory(historyVO);
			
			resultSet = scriptService.selectScriptHistoryList(scriptVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}

	/**
	 * TEXT 변환
	 * @param historyVO, scriptVO, request
	 * @return String
	 */
	public static String toTEXT(String str) {
		if(str == null)
		return null;

		String returnStr = str;
		returnStr = returnStr.replaceAll("<br>", "\n");
		returnStr = returnStr.replaceAll("&gt;", ">");
		returnStr = returnStr.replaceAll("&lt;", "<");
		returnStr = returnStr.replaceAll("&quot;", "\"");
		returnStr = returnStr.replaceAll("&nbsp;", " ");
		returnStr = returnStr.replaceAll("&amp;", "&");
//		returnStr = returnStr.replaceAll("\"", "&#34;");
		returnStr = returnStr.replaceAll("&#34;", "\"");
		returnStr = returnStr.replaceAll("&apos;", "'");	

		return returnStr;
	}

		/**
		 * 스크립트 즉시 실행
		 * 
		 * @return resultSet
		 * @throws Exception
		 */
		@RequestMapping(value = "/scriptImmediateExe.do")
		@ResponseBody
		public List<HashMap<String, String>> backupImmediateExe (HttpServletRequest request) {

			
			Map<String, Object> result = null;

			try{
				
				int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
				int wrk_id = Integer.parseInt(request.getParameter("wrk_id"));
				String wrk_exp =request.getParameter("wrk_exp"); 
				String exe_cmd = request.getParameter("exe_cmd");
			
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
				//result = cic.immediateScript(IP, PORT, exe_cmd, wrk_id, wrk_exp);
					
				System.out.println("결과");
				System.out.println(result.get("RESULT_CODE"));
				System.out.println(result.get("ERR_CODE"));
				System.out.println(result.get("ERR_MSG"));
				
			}catch(Exception e){
				e.printStackTrace();
			}
			
			return null;			
		}
}