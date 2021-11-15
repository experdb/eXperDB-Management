package com.k4m.dx.tcontrol.db2pg.monitoring.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.db2pg.monitoring.service.Db2pgMonitoringService;
import com.k4m.dx.tcontrol.db2pg.monitoring.service.Db2pgMonitoringVO;

@Controller
public class Db2pgMonitoringController {
	
	@Autowired
	private Db2pgMonitoringService db2pgMonitoringService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;

	/**
	 * 실행중인 work 조회
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/monitoring/selectExeWork.do")
	public @ResponseBody List<Map<String, Object>> selectExeWork(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgMonitoringVO") Db2pgMonitoringVO db2pgHistoryVO, HttpServletRequest request, HttpServletResponse response) {
		List<Map<String, Object>> resultSet = null;
		try {
			// 화면접근이력 이력 남기기
			//CmmnUtils.saveHistory(request, historyVO);
			//historyVO.setExe_dtl_cd("DX-T0143_02");
			//historyVO.setMnu_id(42);
			//accessHistoryService.insertHistory(historyVO);
			
			resultSet = db2pgMonitoringService.selectExeWork();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	
	
	/**
	 * 데이터이관 모니터링 정보 추출
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/db2pg/monitoring/getData.do")
	public @ResponseBody List<Db2pgMonitoringVO> selectDb2pgMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, @ModelAttribute("db2pgMonitoringVO") Db2pgMonitoringVO db2pgHistoryVO, HttpServletRequest request, HttpServletResponse response) {
		List<Db2pgMonitoringVO> resultSet = null;
		try {
			// 화면접근이력 이력 남기기
			//CmmnUtils.saveHistory(request, historyVO);
			//historyVO.setExe_dtl_cd("DX-T0143_02");
			//historyVO.setMnu_id(42);
			//accessHistoryService.insertHistory(historyVO);
			
			Db2pgMonitoringVO mVo = new Db2pgMonitoringVO();
			
			String wrk_nm = request.getParameter("wrk_nm");
			mVo.setWrk_nm(wrk_nm);
					
			resultSet = db2pgMonitoringService.selectDb2pgMonitoring(mVo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
}
