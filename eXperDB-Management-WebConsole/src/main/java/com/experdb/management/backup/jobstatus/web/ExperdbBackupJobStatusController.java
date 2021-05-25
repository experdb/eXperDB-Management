package com.experdb.management.backup.jobstatus.web;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.experdb.management.backup.jobstatus.service.ExperdbBackupJobStatusService;
import com.experdb.management.backup.jobstatus.service.JobStatusVO;
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Controller
public class ExperdbBackupJobStatusController {

	@Autowired
	private ExperdbBackupJobStatusService experdbBackupJobStatusService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	/**
	 * JobStatus 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/jobStatusList.do")
	@ResponseBody
	public List<JobStatusVO> backupActivityLogList(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<JobStatusVO> resultSet = null;
		
		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		//int jobid = Integer.parseInt(request.getParameter("jobid"));
		
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);*/
			
			
			//String jobname = request.getParameter("jobname");
			
			//paramvalue.put("jobname", jobname);
			
			resultSet = experdbBackupJobStatusService.selectBackupJobStatusList();
						
		    /* for(int i=0; i<resultSet.size(); i++){
		    	 	Date nextRunTime = JobStatus.getInstance().getNextRunTime(resultSet.get(i));

		    	 	System.out.println("nextRunTime = "+nextRunTime);
					//SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					//String time = transFormat.format(date);	
					//resultSet.get(i).setTime(time);
				}*/
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}	
	
	
	/**
	 * JobEnd 잡 수행 종료 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/selectJobEnd.do")
	@ResponseBody
	public int selectJobEnd(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		
		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		int result = 0;
		int jobid = 0;
		
		try {
			String jobname = request.getParameter("jobname");
			paramvalue.put("jobname", jobname);
			
			jobid= experdbBackupJobStatusService.selectJobid(paramvalue);
			
			if(jobid  != 0 ){
				result = experdbBackupJobStatusService.selectJobEnd(jobid);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
	}	
	
	
	/**
	 * JobId 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/selectJobId.do")
	@ResponseBody
	public int selectJobId(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
	
		int jobid = 0;
		HashMap<String, Object> paramvalue = new HashMap<String, Object>();
		
		try {
			String jobname = request.getParameter("jobname");
			paramvalue.put("jobname", jobname);
				
			jobid= experdbBackupJobStatusService.selectJobid(paramvalue);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return jobid;
	}	
	
	
	
	/**
	 * 즉시실행
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/runNow.do")
	@ResponseBody
	public void runNow(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){

		JSONObject result = new JSONObject();
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0166_01");
			accessHistoryService.insertHistory(historyVO);
			
			String jobname = request.getParameter("jobname");
			int jobtype = Integer.parseInt(request.getParameter("jobtype"));
					
			CmmnUtil.RunNow(jobname, jobtype);
						
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}	
	
	
	
	/**
	 * 작업삭제
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/jobCancel.do")
	@ResponseBody
	public void jobCancel(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){

		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0166_01");
			accessHistoryService.insertHistory(historyVO);
			
			String jobname = request.getParameter("jobname");
			
			CmmnUtil.jobCancel(jobname);
						
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
}
