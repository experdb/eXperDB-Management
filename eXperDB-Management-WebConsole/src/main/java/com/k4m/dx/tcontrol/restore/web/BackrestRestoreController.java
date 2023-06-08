package com.k4m.dx.tcontrol.restore.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.cmmn.client.ClientProtocolID;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import com.k4m.dx.tcontrol.restore.service.RestoreService;

@Controller
public class BackrestRestoreController {

	@Autowired
	private BackupService backupService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private RestoreService restoreService;

	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;


	/**
	 * [Restore] 복원 설정 화면을 보여준다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/backrestRestore.do")
	public ModelAndView backrestRestore(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			@ModelAttribute("workVo") WorkVO workVO) {
		ModelAndView mv = new ModelAndView("jsonView");
		int db_svr_id = workVO.getDb_svr_id();

		// 화면접근이력 이력 남기기
		try {
			CmmnUtils.saveHistory(request, historyVO);
			accessHistoryService.insertHistory(historyVO);

			mv.setViewName("restore/backrestRestore");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			DbServerVO dbServerVO = new DbServerVO();
			dbServerVO = backupService.selectDbSvrNm(workVO);
			
			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm());
		}catch (Exception e) {
			e.printStackTrace();
		}

		mv.addObject("db_svr_id", db_svr_id);

		return mv;

	}

	/**
	 * [Restore] BACKREST 복구 정보 등록한다.
	 * 
	 * @param historyVO, workVO, request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertBackrestRestore.do")
	public ModelAndView insertBackrestRestore(
			@ModelAttribute("restoreRmanVO") RestoreRmanVO restoreBackrestVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request, HttpServletResponse respons) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String snResult = "S";

		try {
			CmmnUtils.saveHistory(request, historyVO);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String id = loginVo.getUsr_id();
			restoreBackrestVO.setRegr_id(id);
			
			Calendar calendar = Calendar.getInstance();
			java.util.Date date = calendar.getTime();
			String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
			
			restoreBackrestVO.setExelog(restoreBackrestVO.getRestore_nm() + "_" + today);
			
			mv.addObject("exelog", restoreBackrestVO.getRestore_nm() + "_" + today);

			restoreService.insertRmanRestore(restoreBackrestVO);
		} catch (Exception e) {
			snResult = "F";
			e.printStackTrace();
		}
		
		mv.addObject("snResult", snResult);

		return mv;
	}
	
	
	/**
	 * [Restore] BACKREST 복구 정보 등록한다.
	 * 
	 * @param request
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/executeBackrestRestore.do")
	public void executeBackrestRestore(HttpServletRequest request, HttpServletResponse respons) {
		try {
			String IP = request.getParameter("ipadr");
			
			AgentInfoVO vo = new AgentInfoVO();
			vo.setIPADR(IP);
			AgentInfoVO agentInfo = (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			int PORT = agentInfo.getSOCKET_PORT();
			
			JSONObject jObj = new JSONObject();
			
			jObj.put(ClientProtocolID.EXELOG, request.getParameter("exelog"));
			jObj.put(ClientProtocolID.RESTORE_FLAG, request.getParameter("restore_type"));
			jObj.put(ClientProtocolID.TIME_RESTORE, request.getParameter("time_restore"));
			
			ClientInfoCmmn cic = new ClientInfoCmmn();
			JSONObject result = new JSONObject(); 
			
			result = cic.executeBackrestRestore(IP, PORT, jObj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		
	}
}
