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
import com.k4m.dx.tcontrol.transfer.service.TransVO;


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
	 * trans 모니터링 CPU, Memory 정보
	 * 
	 * @param historyVO,request
	 * @return ModelAndView
	 */
	@RequestMapping("/transMonitoringCpuMemList")
	public ModelAndView transMonitoringCpuMemList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		List<Map<String, Object>> processCpuList = transMonitoringService.selectProcessCpuList();
		List<Map<String, Object>> memoryList = transMonitoringService.selectMemoryList();
		List<Map<String, Object>> allErrorList = transMonitoringService.selectAllErrorList();
		
		mv.addObject("processCpuList", processCpuList);
		mv.addObject("memoryList", memoryList);
		mv.addObject("allErrorList", allErrorList);
		
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
		
		// 소스 연결 테이블
		Map<String, Object> tableList = transMonitoringService.selectSourceConnectorTableList(trans_id);
		
		// 소스 connect 정보
		List<Map<String, Object>> connectInfo = transMonitoringService.selectSourceConnectInfo(trans_id);
		// 소스 연결 테이블 분리
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
		List<Map<String, Object>> sourceInfo = transMonitoringService.selectSourceInfo(trans_id);
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
		mv.addObject("sourceInfo", sourceInfo);
		mv.addObject("sourceErrorChart", sourceErrorChart);
		mv.addObject("sourceErrorInfo", sourceErrorInfo);
		mv.addObject("targetConnectorList", targetConnectorList);
		
		return mv;
	}
	
	/**
	 * trans 모니터링 소스 Connector Snapshot
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/transSrcSnapshotInfo")
	public ModelAndView transSrcSnapshotInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String strTransId = request.getParameter("trans_id");
		int trans_id = Integer.parseInt(strTransId);
		
		List<Map<String, Object>> snapshotChart = transMonitoringService.selectSourceSnapshotChart(trans_id);
		List<Map<String, Object>> snapshotInfo = transMonitoringService.selectSourceSnapshotInfo(trans_id);
		
		mv.addObject("snapshotChart", snapshotChart);
		mv.addObject("snapshotInfo", snapshotInfo);
		
		return mv;
	}
	
	/**
	 * trans 모니터링 소스 Connector Streaming
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/transSrcStreamingInfo")
	public ModelAndView transSrcStreamingInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String strTransId = request.getParameter("trans_id");
		int trans_id = Integer.parseInt(strTransId);
		
		List<Map<String, Object>> streamingChart = transMonitoringService.selectStreamingChart(trans_id);
		List<Map<String, Object>> streamingInfo = transMonitoringService.selectStreamingInfo(trans_id);
		
		mv.addObject("streamingChart", streamingChart);
		mv.addObject("streamingInfo", streamingInfo);
		
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
		
		String strTransId = request.getParameter("trans_id");
		int trans_id = Integer.parseInt(strTransId);
		
		// 타겟 DBMS 정보
		List<Map<String, Object>> targetDBMSInfo = transMonitoringService.selectTargetDBMSInfo(trans_id);
		// 타겟 전송대상 테이블 목록
		Map<String, Object> targetTopic = transMonitoringService.selectTargetTopicList(trans_id);
		String[] topicTemp = targetTopic.get("topic_name").toString().split(",");
		List<Map<String, Object>> targetTopicList = new ArrayList<Map<String, Object>>(); 
		for(int i = 0; i < topicTemp.length; i++){
			Map<String, Object> temp = new HashMap<String, Object>();
			temp.put("rownum", i+1);
			temp.put("topic_name", topicTemp[i]);
			targetTopicList.add(temp);
		}
		
		// 타겟 record sink chart
		List<Map<String, Object>> targetSinkRecordChart = transMonitoringService.selectTargetSinkRecordChart(trans_id);
		// 타겟 complete sink chart
		List<Map<String, Object>> targetSinkCompleteChart = transMonitoringService.selectTargetSinkCompleteChart(trans_id);
		// 타겟 sink info
		List<Map<String, Object>> targetSinkInfo = transMonitoringService.selectTargetSinkInfo(trans_id);
		// 타겟 error chart
		List<Map<String, Object>> targetErrorChart = transMonitoringService.selectTargetErrorChart(trans_id);
		// 타겟 error info
		List<Map<String, Object>> targetErrorInfo = transMonitoringService.selectTargetErrorInfo(trans_id);
		
		mv.addObject("targetDBMSInfo", targetDBMSInfo);
		mv.addObject("targetTopicList", targetTopicList);
		mv.addObject("targetSinkRecordChart", targetSinkRecordChart);
		mv.addObject("targetSinkCompleteChart", targetSinkCompleteChart);
		mv.addObject("targetSinkInfo", targetSinkInfo);
		mv.addObject("targetErrorChart", targetErrorChart);
		mv.addObject("targetErrorInfo", targetErrorInfo);
		
		return mv;
	}
	
	/**
	 * trans 모니터링 타겟 sink 차트
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/transTarSinkChart")
	public ModelAndView transTarSinkChart(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		
		String strTransId = request.getParameter("trans_id");
		int trans_id = Integer.parseInt(strTransId);
		
		// 타겟 record sink chart
		List<Map<String, Object>> targetSinkRecordChart = transMonitoringService.selectTargetSinkRecordChart(trans_id);
		// 타겟 complete sink chart
		List<Map<String, Object>> targetSinkCompleteChart = transMonitoringService.selectTargetSinkCompleteChart(trans_id);
		// 타겟 error chart
		List<Map<String, Object>> targetErrorChart = transMonitoringService.selectTargetErrorChart(trans_id);
		
		mv.addObject("targetSinkRecordChart", targetSinkRecordChart);
		mv.addObject("targetSinkCompleteChart", targetSinkCompleteChart);
		mv.addObject("targetErrorChart", targetErrorChart);
		
		return mv;
	}
	
	/**
	 * trans log view
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/transLogView.do")
	public ModelAndView transConnectorLogView(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		
		int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
		mv.addObject("db_svr_id", db_svr_id);
		mv.setViewName("transfer/popup/transLogView");
		return mv;
	}
	
	/**
	 * trans log file
	 * 
	 * @param historyVO, request
	 * @return ModelAndView
	 */
	@RequestMapping("/transLogViewAjax")
	public ModelAndView transConnectorLogViewAjax(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("jsonView");
		String strBuffer = "";
		System.out.println("----------------------------------");
		try {
			int db_svr_id = Integer.parseInt(request.getParameter("db_svr_id"));
			String strTransId = request.getParameter("trans_id");
			String type = request.getParameter("type");
//			int trans_id = Integer.parseInt(strTransId);
			String strSeek = request.getParameter("seek");
			String strReadLine = request.getParameter("readLine");
			String dwLen = request.getParameter("dwLen");
			String strDate = request.getParameter("date").substring(0, 10).replace("-", "");
			String todayYN = request.getParameter("todayYN");
			
			TransVO transVO = new TransVO();
			transVO.setDb_svr_id(db_svr_id);
			
			Map<String, Object> param = new HashMap<>();
			param.put("seek", strSeek);
			param.put("readLine", strReadLine);
			param.put("dwLen", dwLen);
			param.put("date", strDate);
			param.put("todayYN", todayYN);
			param.put("type", type);
//			Map<String, Object> result = transMonitoringService.getLogFile(trans_id, type, param);
			Map<String, Object> result = transMonitoringService.getLogFile(transVO, param);
			strBuffer = (String) result.get("RESULT_DATA"); 
			if(strBuffer != null) {
				mv.addObject("fSize", strBuffer.length());
			}
			mv.addObject("data", strBuffer);
//			mv.addObject("pry_svr_nm", result.get("pry_svr_nm"));
			mv.addObject("dwLen", result.get("DW_LEN"));
			mv.addObject("file_name", result.get("file_name"));
			mv.addObject("status", result.get("status"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mv;
	}
}