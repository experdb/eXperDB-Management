package com.experdb.management.backup.history.web;

import java.text.*;
import java.util.*;

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
	 * JobHistory 백업히스토리 리스트 조회
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
			
			Map<String, Object> param = new HashMap<>();
			
			// 검색조건 세팅 시작
			
			DateFormat _dateSDF = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			
			String stDate = request.getParameter("startDate");
			String edDate = request.getParameter("endDate");
			
			// 입력된 startDate, endDate 값을 "yyyy-MM-dd" 포멧으로 맞춰준다
			Date _sDate = _dateSDF.parse(stDate);
			Date _eDate = _dateSDF.parse(edDate);
			
			// endDate를 하루 늘려준다. --> 다음날 00시 기준으로 검색 (Long 으로 검색하므로)
			cal.setTime(_eDate);
			cal.add(Calendar.DATE, 1); 
			
			// DATE 값을 LONG으로 변경
			long sDate = _sDate.getTime()/1000;
			long eDate = cal.getTimeInMillis()/1000;
			
			System.out.println("sDate : " + sDate);
			System.out.println("eDate : " + eDate);
			
			// 검색 조건을 Map으로 전달
			param.put("startDate", sDate);
			param.put("endDate", eDate);
			param.put("server", request.getParameter("server").replace(".", "").trim());
			param.put("type", request.getParameter("type"));
			param.put("status", request.getParameter("status"));
			
			resultSet = experdbBackupHistoryService.selectJobHistoryList(param);
		
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
				
				reduceTime = (String.format("%02d", diffHours)+":"+String.format("%02d", diffMinutes)+":"+String.format("%02d", diffSeconds));
				
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
	 * JobHistory 복구히스토리 리스트 조회
	 * @param 
	 * @return List<Map<String, Object>>
	 */
	@RequestMapping(value="/experdb/restoreJobHistoryList.do")
	@ResponseBody
	public List<BackupJobHistoryVO> restoreJobHistoryList(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO){
		List<BackupJobHistoryVO> resultSet = null;

		try {
			// 화면접근이력 이력 남기기
			/*CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0125_01");
			accessHistoryService.insertHistory(historyVO);*/
			
			Map<String, Object> param = new HashMap<>();
			DateFormat _dateSDF = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			
			System.out.println("startDate : " + request.getParameter("startDate"));
			
			String stDate = request.getParameter("startDate");
			String edDate = request.getParameter("endDate");
			Date _sDate = _dateSDF.parse(stDate);
			Date _eDate = _dateSDF.parse(edDate);
			
			cal.setTime(_eDate);
			cal.add(Calendar.DATE, 1);
			
			long sDate = _sDate.getTime()/1000;
			long eDate = cal.getTimeInMillis()/1000;
			
			System.out.println("sDate : " + sDate);
			System.out.println("eDate : " + eDate);
			
			param.put("startDate", sDate);
			param.put("endDate", eDate);
			
			System.out.println("server = "+request.getParameter("server").replace(".", "").trim());
			
			param.put("server", request.getParameter("server").replace(".", "").trim());
			param.put("type", request.getParameter("type"));
			param.put("status", request.getParameter("status"));
			
			resultSet = experdbBackupHistoryService.selectRestoreJobHistoryList(param);
		
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
				
				reduceTime = (String.format("%02d", diffHours)+":"+String.format("%02d", diffMinutes)+":"+String.format("%02d", diffSeconds));
				
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
