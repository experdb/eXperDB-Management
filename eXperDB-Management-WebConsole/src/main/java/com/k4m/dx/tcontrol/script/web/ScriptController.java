package com.k4m.dx.tcontrol.script.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
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

	/**
	 * 스크립트 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
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
	 * @param 
	 * @return ModelAndView
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/popup/scriptRegForm.do")
	public ModelAndView scriptRegForm(@ModelAttribute("workVo") WorkVO workVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();

		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id")); 
		System.out.println(db_svr_id); 
		
		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0126");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
				
		mv.addObject("db_svr_id",db_svr_id);
		mv.setViewName("popup/scriptRegForm");
		return mv;
	}
	
	
	
	
	/**
	 * 스크립트 이력화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
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
	 * 스크립트 List
	 * @param WorkVO
	 * @return List<WorkVO>
	 */
	@RequestMapping(value="/selectScriptList.do")
	@ResponseBody
	public List<Map<String, Object>> selectScriptList(@ModelAttribute("ScriptVO") ScriptVO scriptVO,HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<Map<String, Object>> resultSet = null;
		String result;
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
	 * 스크립트 History List
	 * @param WorkVO
	 * @return List<WorkVO>
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
		 * Script insert
		 * @param 
		 * @return
		 */
		@RequestMapping(value = "/popup/insertScript.do")
		@ResponseBody
		public void insertScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, @ModelAttribute("workVO") WorkVO workVO, HttpServletRequest request){
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			scriptVO.setFrst_regr_id(usr_id);		
			
			String result = "S";		
			String wrkid_result = "S";
			WorkVO resultSet = null;
			
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
			
			System.out.println(scriptVO.getWrk_id());
			
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
		}
		
		
		
		/**
		 * 스크립트 수정 화면을 보여준다
		 * @param 
		 * @return ModelAndView
		 */
		@SuppressWarnings("null")
		@RequestMapping(value = "/popup/scriptReregForm.do")
		public ModelAndView rmanRegReForm(@ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO)  {
			ModelAndView mv = new ModelAndView();
			try {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0127");
				accessHistoryService.insertHistory(historyVO);
				
				mv.addObject("db_svr_id",scriptVO.getDb_svr_id());
				mv.addObject("wrk_id",scriptVO.getWrk_id());
				
				mv.setViewName("popup/scriptReregForm");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return mv;	
		}		
		
		
		
		/**
		 * Script update
		 * @param 
		 * @return
		 */
		@RequestMapping(value = "/popup/updateScript.do")
		@ResponseBody
		public void updateScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request){
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			scriptVO.setFrst_regr_id(usr_id);		

			try{
				String cmd = toTEXT(scriptVO.getExe_cmd());
				scriptVO.setExe_cmd(cmd);

				scriptService.updateScriptWork(scriptVO);
				
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0127_01");
				accessHistoryService.insertHistory(historyVO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		
		/**
		 * Script delete
		 * @param 
		 * @return
		 */
		@RequestMapping(value = "/deleteScript.do")
		@ResponseBody
		public void deleteScript(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("ScriptVO") ScriptVO scriptVO, HttpServletRequest request){
			HttpSession session = request.getSession();
			String usr_id = (String) session.getAttribute("usr_id");
			scriptVO.setFrst_regr_id(usr_id);		
			
			try{
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0125_02");
				accessHistoryService.insertHistory(historyVO);
				
				scriptService.deleteScriptWork(scriptVO);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
		
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
			returnStr = returnStr.replaceAll("\"", "&#34;");
			returnStr = returnStr.replaceAll("&apos;", "'");
			return returnStr;
			}

}
