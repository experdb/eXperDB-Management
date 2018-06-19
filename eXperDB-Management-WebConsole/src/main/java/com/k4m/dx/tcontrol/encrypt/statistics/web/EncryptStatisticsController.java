package com.k4m.dx.tcontrol.encrypt.statistics.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.encrypt.service.call.EncryptSettingServiceCall;
import com.k4m.dx.tcontrol.encrypt.service.call.StatisticsServiceCall;

@Controller
public class EncryptStatisticsController {
	
	
	/**
	 * 암호화 통계 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/securityStatistics.do")
	public ModelAndView securityStatistics(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0118");
			historyVO.setMnu_id(36);
			accessHistoryService.insertHistory(historyVO);*/
											
			mv.setViewName("encrypt/statistics/securityStatistics");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}
	
	
	/**
	 * 암호화 통계 조회
	 * 
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSecurityStatistics.do")
	public @ResponseBody JSONObject selectSecurityStatistics(HttpServletRequest request) {
		
		JSONObject result = new JSONObject();
		
		HttpSession session = request.getSession();
		String restIp = (String)session.getAttribute("restIp");
		int restPort = (int)session.getAttribute("restPort");
		String strTocken = (String)session.getAttribute("tockenValue");
		String loginId = (String)session.getAttribute("usr_id");
		String entityId = (String)session.getAttribute("ectityUid");	
		
		String from = request.getParameter("from");
		String to = request.getParameter("to");
		String categoryColumn = request.getParameter("categoryColumn");
		
		StatisticsServiceCall ssc = new StatisticsServiceCall();
			
		try{
			result = ssc.selectAuditLogSiteHourForStat(restIp, restPort, strTocken, loginId, entityId, from, to, categoryColumn);
		}catch(Exception e){
			result.put("resultCode", "8000000002");
		}
		return result;
	}
}
