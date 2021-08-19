package com.k4m.dx.tcontrol.transfer.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.transfer.service.TransMonitoringService;


/**
 * Transfer 모니터링 Controller
 *
 * @author
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2021.07.30  			 최초 생성
 *      </pre>
 */
@Controller
public class TransMonitoringController {
	
	@Autowired
	private TransMonitoringService transMonitoringService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	
	/**
	 * trans 모니터링 view
	 * 
	 * @param historyVO,request
	 * @return ModelAndView
	 */
	@RequestMapping("/transMonitoring.do")
	public ModelAndView transMonitoring(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		int db_svr_id=Integer.parseInt(request.getParameter("db_svr_id"));
		
		try {

			//db서버명 조회
			DbServerVO schDbServerVO = new DbServerVO();
			schDbServerVO.setDb_svr_id(db_svr_id);
			DbServerVO dbServerVO = (DbServerVO) cmmnServerInfoService.selectServerInfo(schDbServerVO);
			
			mv.addObject("db_svr_nm", dbServerVO.getDb_svr_nm()); //db서버명
			mv.addObject("db_svr_id", db_svr_id);
		
			// 소스 connector list
			List<Map<String, Object>> srcConnectorList = transMonitoringService.selectSrcConnectorList();
			
			mv.addObject("srcConnectorList", srcConnectorList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		mv.setViewName("transfer/monitoring/transMonitoring");
		return mv;
	}
	
	/**
	 * trans 모니터링 소스 connector info
	 * 
	 * @param historyVO,request
	 * @return ModelAndView
	 */
	@RequestMapping("/transSrcConnectInfo")
	public ModelAndView transSrcConnectInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String strTransId = request.getParameter("trans_id");
		int trans_id = Integer.parseInt(strTransId);
		System.out.println(trans_id);
//		JSONObject connectInfo = new JSONObject();
		// 연결 테이블수(split 후 count), 
		Map<String, Object> tableList = transMonitoringService.selectSourceConnectorTableList(trans_id);
		
		
		List<Map<String, Object>> connectInfo = transMonitoringService.selectSourceConnectInfo(trans_id);
		String[] tableNmList = tableList.get("exrt_trg_tb_nm").toString().split(",");
		List<Map<String, Object>> table_name_list = new ArrayList<Map<String, Object>>(); 
		
		for(String tab : tableNmList){
			Map<String, Object> temp = new HashMap<String, Object>();
			String strTemp[] = tab.split("\\.");
			if(strTemp.length == 1){
				temp.put("table_nm", strTemp[0]);
			} else {
				temp.put("schema_nm", strTemp[0]);
				temp.put("table_nm", strTemp[1]);
			}
			table_name_list.add(temp);
		}
		
		List<Map<String, Object>> snapshotChart = transMonitoringService.selectSourceSnapshotChart(trans_id);
		List<Map<String, Object>> snapshotInfo = transMonitoringService.selectSourceSnapshotInfo(trans_id);
		List<Map<String, Object>> sourceChart1 = transMonitoringService.selectSourceChart_1(trans_id);
		List<Map<String, Object>> sourceChart2 = transMonitoringService.selectSourceChart_2(trans_id);
		List<Map<String, Object>> sourceErrorChart = transMonitoringService.selectSourceErrorChart(trans_id);
		List<Map<String, Object>> sourceErrorInfo = transMonitoringService.selectSourceErrorInfo(trans_id);
		
		List<Map<String, Object>> targetConnectorList = transMonitoringService.selectTargetConnectList(trans_id);

		mv.addObject("table_cnt", tableNmList.length);
		mv.addObject("connectInfo", connectInfo);
		mv.addObject("table_name_list", table_name_list);
		mv.addObject("snapshotChart", snapshotChart);
		mv.addObject("snapshotInfo", snapshotInfo);
		mv.addObject("sourceChart1", sourceChart1);
		mv.addObject("sourceChart2", sourceChart2);
		mv.addObject("sourceErrorChart", sourceErrorChart);
		mv.addObject("sourceErrorInfo", sourceErrorInfo);
		mv.addObject("targetConnectorList", targetConnectorList);
		// 폴링 레코드 / 오류수 연결된 sink connector list
		return mv;
	}
	
	/**
	 * trans 모니터링 타겟 connector info
	 * 
	 * @param historyVO,request
	 * @return ModelAndView
	 */
	@RequestMapping("/transTarConnectInfo")
	public ModelAndView transTarConnectInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		return mv;
	}
	
}
