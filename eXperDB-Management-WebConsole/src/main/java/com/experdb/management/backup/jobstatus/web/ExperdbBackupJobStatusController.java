package com.experdb.management.backup.jobstatus.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.experdb.management.backup.history.service.BackupActivityLogVO;
import com.experdb.management.backup.history.service.ExperdbBackupHistoryService;
import com.experdb.management.backup.jobstatus.service.ExperdbBackupJobStatusService;
import com.experdb.management.backup.jobstatus.service.JobStatusVO;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Controller
public class ExperdbBackupJobStatusController {

	@Autowired
	private ExperdbBackupJobStatusService experdbBackupJobStatusService;
	
	
	/**
	 * JobStatus 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/jobStatusList.do")
	@ResponseBody
	public List<JobStatusVO> backupActivityLogList(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<JobStatusVO> resultSet = null;

		//int jobid = Integer.parseInt(request.getParameter("jobid"));
		
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);*/
			
			resultSet = experdbBackupJobStatusService.selectBackupJobStatusList();
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}	
	
}
