package com.experdb.management.backup.history.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.experdb.management.backup.history.service.BackupActivityLogVO;
import com.experdb.management.backup.history.service.BackupJobHistoryVO;
import com.experdb.management.backup.history.service.ExperdbBackupHistoryService;
import com.k4m.dx.tcontrol.common.service.HistoryVO;




@Controller
public class ExperdbBackupHistoryController {
		
	@Autowired
	private ExperdbBackupHistoryService experdbBackupHistoryService;
	
	
	/**
	 * JobHistory 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/backupJobHistoryList.do")
	@ResponseBody
	public List<BackupJobHistoryVO> backupJobHistoryList(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<BackupJobHistoryVO> resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);*/
			
			resultSet = experdbBackupHistoryService.selectJobHistoryList();
		
			for(int i=0; i<resultSet.size(); i++){
				Date startDate = new Date(Long.parseLong(resultSet.get(i).getExecutetime())* 1000L);
				Date endDate = new Date(Long.parseLong(resultSet.get(i).getFinishtime())* 1000L);
				
				SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String startTime = transFormat.format(startDate);	
				String endTime = transFormat.format(endDate);	
				
				String reduceTime;
				
				long diff = endDate.getTime() -  startDate.getTime();
				long diffSeconds = diff / 1000 % 60;  
				long diffMinutes = diff / (60 * 1000) % 60; 
				long diffHours = diff / (60 * 60 * 1000);       
				
				reduceTime = (diffHours+":"+diffMinutes+":"+diffSeconds);

				String dataSize = CmmnUtil.bytes2String(resultSet.get(i).getWritedata()*1024);
				
				resultSet.get(i).setDatasize(dataSize);
				
				resultSet.get(i).setExecutetime(startTime);
				resultSet.get(i).setFinishtime(endTime);
				resultSet.get(i).setReducetime(reduceTime);

			}
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}
	
	
	
	/**
	 * ActivityLog 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/backupActivityLogList.do")
	@ResponseBody
	public List<BackupActivityLogVO> backupActivityLogList(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<BackupActivityLogVO> resultSet = null;

		int jobid = Integer.parseInt(request.getParameter("jobid"));
		
		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);*/
			
			resultSet = experdbBackupHistoryService.selectBackupActivityLogList(jobid);
			
			for(int i=0; i<resultSet.size(); i++){
				Date date = new Date(Long.parseLong(resultSet.get(i).getTime())* 1000L);
				SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String time = transFormat.format(date);	
				resultSet.get(i).setTime(time);
			}
				
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return resultSet;
	}

}
