package com.experdb.management.backup.policy.service.impl;

import java.io.*;
import java.lang.reflect.*;
import java.text.*;
import java.text.ParseException;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;
import javax.xml.parsers.*;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.batch.core.scope.context.*;
import org.springframework.stereotype.Service;
import org.xml.sax.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.policy.service.*;
import com.experdb.management.backup.service.*;
import com.experdb.management.backup.service.impl.*;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupPolicyServiceImpl")
public class ExperdbBackupPolicyServiceImpl  extends EgovAbstractServiceImpl implements ExperdbBackupPolicyService{

	@Resource(name = "ExperdbBackupPolicyDAO")
	private ExperdbBackupPolicyDAO experdbBackupPolicyDAO;

	@Resource(name = "ExperdbBackupDAO")
	private ExperdbBackupDAO experdbBackupDAO;

	
	// 백업 정보 불러오기
	@Override
	@SuppressWarnings({ "unchecked"})
	public JSONObject getScheduleInfo(HttpServletRequest request) throws SAXException, IOException, ParseException, ParserConfigurationException {
		/**
		 *  백업 정책 정보 불러오기
		 *  1. xml 파일 읽어오기
		 *    1-1) 등록된 정책이 없는 경우 (xml 파일이 없는 경우) -> IOException -> 종료
		 *    1-2) 등록된 정책이 있는 경우 (xml 파일이 있는 경우) -> 계속 수행
		 *  2. xml 파일 읽어온 데이터 VO에 넣어주기
		 *  3. 증분 백업 정책 데이터 정리
		 *  4. 풀 백업 정책 데이터 정리
		 *  5. volume 데이터 정리
		 *  6. Map에 데이터 넣고 return
		 */
		JSONObject result = new JSONObject();
		
		String startDate ="";
		
		List<BackupScheduleVO> backupSchedule = null;
		List<VolumeVO> backupVolumes = null;
		BackupScriptVO backupScript = new BackupScriptVO();
		BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
		RetentionVO backupRetention = new RetentionVO();
		ArrayList<Object> weekData = new ArrayList<>();
		ArrayList<Object> volumeList = new ArrayList<>();
		Map<String, Object> readXml = new HashMap<>();
		
		// 1. xml 파일 읽어오기
		String fileName = request.getParameter("ipadr").replace(".", "_").trim()+".xml";
		// String path = "C://test/backupXml/backup2.xml";
		String path = "/opt/Arcserve/d2dserver/bin/jobs/" + fileName;
		
		// 1-1) 등록된 정책이 없는 경우 (xml 파일이 없는 경우) -> IOException -> 종료
		// 1-2) 등록된 정책이 있는 경우 (xml 파일이 있는 경우) -> 계속 수행
		JobXMLRead xml = new JobXMLRead();
		readXml = xml.xmlRead(path);
		
		// 2. xml 파일 읽어온 데이터 VO에 넣어주기
		backupSchedule = (List<BackupScheduleVO>) readXml.get("schedule");
		backupRetention = (RetentionVO) readXml.get("retention");
		backupLocation = (BackupLocationInfoVO) readXml.get("backupLocation");
		backupScript = (BackupScriptVO) readXml.get("backupScript");
		backupVolumes = (List<VolumeVO>) readXml.get("volumes");
		
		// 등록된 증분 백업 정책이 있는 경우
		if(backupSchedule.size()>0){			
			int monthData = Integer.parseInt(backupSchedule.get(0).getMonth()) + 1;
			 startDate = (String) dateSplit(backupSchedule.get(0).getYear() + "-" + monthData + "-" + backupSchedule.get(0).getDay()).get("fullDate");
			 backupSchedule.remove(0);
		}else{ // 등록된 증분 백업 정책이 없는 경우
			 startDate = "";
		}
		
		// 3. 증분 백업 정책 데이터 정리
		for(BackupScheduleVO bs : backupSchedule){
			Map <String, Object> scheduleMap = new HashMap<>();
			Boolean[] dayPick = new Boolean[7];
			Arrays.fill(dayPick, Boolean.FALSE);
			int dayType = Integer.parseInt(bs.getDayType())-1;
			
			scheduleMap.put("startTime", timeSplit(bs.getStartHourOfDay() + ":" + bs.getStartMinute()).get("fullHour"));
			scheduleMap.put("backupType", bs.getBackupType());
			if(Boolean.parseBoolean(bs.getRepeat())){
				scheduleMap.put("repEndTime", timeSplit(bs.getEndHourOfDay() + ":" + bs.getEndMinute()).get("fullHour"));
				scheduleMap.put("repTime", bs.getInterval());
				scheduleMap.put("repTimeUnit", bs.getIntervalUnit());
				scheduleMap.put("repeat", true);
			}else{
				scheduleMap.put("repEndTime", "");
				scheduleMap.put("repTime", "");
				scheduleMap.put("repTimeUnit", "");
				scheduleMap.put("repeat", false);
			}
			dayPick[dayType] = true;
			scheduleMap.put("dayPick", dayPick);
			
			weekData.add(scheduleMap);
		}
		
		// 4. 풀 백업 정책 데이터 정리
		int storageType;
		String fstorage = backupLocation.getBackupDestLocation();
		int fcompress = backupScript.getCompressLevel();
		int fsetNum = backupRetention.getBackupSetCount();
		String jobName = backupScript.getJobName();
		String fdateType = backupRetention.getUseWeekly();
		int monthDate = backupRetention.getDayOfMonth();
		int weekDate = backupRetention.getDayOfWeek();
		// * user 유무에 따라 CIFS, NFS 구분
		if(backupLocation.getBackupDestUser()==null){
			storageType = 1;
		}else{
			storageType = 2;
		}
		
		// 5. volume 데이터 정리
		for(VolumeVO volume : backupVolumes){
			Map <String, Object> volumeMap = new HashMap<>();
			volumeMap.put("filesystem", volume.getFileSystem());
			volumeMap.put("mountOn", volume.getMountOn());
			volumeMap.put("type", volume.getType());
			
			volumeList.add(volumeMap);
		}
		
		
//		System.out.println("=============================");
//		System.out.println("startDate : " + startDate);
//		System.out.println("storageType : " + storageType);
//		System.out.println("storage : " + fstorage);
//		System.out.println("compress : " + fcompress);
//		System.out.println("dateType : " + fdateType);
//		System.out.println("date : " + fdate);
//		System.out.println("setNum : " + fsetNum);
//		System.out.println("=============================");
		
		// 6. Map에 데이터 넣고 return
		result.put("startDate", startDate);
		result.put("storageType", storageType);
		result.put("storage", fstorage);
		result.put("compress", fcompress);
		result.put("dateType", fdateType);
		result.put("jobName", jobName);
		result.put("weekDate", weekDate);
		result.put("monthDate", monthDate);
		result.put("setNum", fsetNum);
		result.put("weekData", weekData);
		result.put("volumes", volumeList);
		
		return result;
	}

	// 백업 정보 등록하기
	@SuppressWarnings("static-access")
	@Override
	public JSONObject scheduleInsert(HttpServletRequest request, Map<Object, String> param) throws Exception {
		
		/**
		 *  백업 정책 등록 (backup policy registration)
		 *  1. 현재 시간으로 jobName 생성
		 *  2. 입력된 서버에 대해 기존에 등록된 job이 있는지 확인
		 *    2-1) 등록되어 있다면 기존에 등록된 job 삭제 진행
		 *    2-2) 등록되지 않았다면 계속 진행
		 *  3. 입력한 정책 등록값을 VO에 넣어줌
		 *    3-1) 증분 백업 정책 스케줄 정보
		 *    3-2) storage 정보
		 *    3-3) 백업 스크립트 (compress, jobName, repeat, scheduleType) 정보
		 *    3-4) volume 정보
		 *    3-5) target server 정보
		 *    3-6) 풀백업 정책의 백업셋, 수행일 정보
		 *  4. xml 파일 만들기 및 IMPORT 
		 *  5. volume Script DB Insert
		 *  
		 */
		
		JSONObject result = new JSONObject();
		List<BackupScheduleVO> backupSchedule = new ArrayList<>();
		BackupScriptVO backupScript = new BackupScriptVO();
		TargetMachineVO targetMachine = new TargetMachineVO();
		BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
		RetentionVO backupRetention = new RetentionVO();
		List<VolumeVO> volumeList = new ArrayList<>();
		
		String weekData = param.get("weekData").toString();
		String ipadr = request.getParameter("nodeIpadr");
		String startDate = request.getParameter("startDate");
		String fstorage = request.getParameter("storage");
		String fcompress = request.getParameter("compress");
		String fdateType = request.getParameter("dateType");
		String weekDate = request.getParameter("weekDate");
		String monthDate = request.getParameter("monthDate");
		String fsetNum = request.getParameter("setNum");
		String jobName_Old = request.getParameter("jobName");
		String volume = request.getParameter("volumeList").toString().replaceAll("&quot;", "\"");
		JSONArray volumeJson = (JSONArray)new JSONParser().parse(volume);
		
		// 1. 현재 시간으로 jobName 생성
		Date date = new Date();
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String time = transFormat.format(date);   
        
        String jobName_New = "backup_"+time;
        String uuid = UUID.randomUUID().toString();
        
		// String path = "/opt/Arcserve/d2dserver/bin/jobs/";
		
		// 2. 입력된 서버에 대해 기존에 등록된 job이 있는지 확인
		int fileExist = experdbBackupPolicyDAO.checkJobExist(ipadr);
		
		// 2-1) 등록되어 있다면 기존에 등록된 job 삭제 진행
		// 새로운 xml 파일 import 되기 전에 수행되어야함
		if(fileExist > 0){
			Job job = new Job();
			result=job.deleteJob(jobName_Old, ipadr);
		}
		
//		System.out.println("=============================");
//		System.out.println("uuid : " + uuid);
//		System.out.println("weekData : " + weekData.length());
//		System.out.println("ipadr : " + ipadr);
//		System.out.println("startDate : " + startDate);
//		System.out.println("startDate.length : " + startDate.length());
//		System.out.println("storageType : " + storageType);
//		System.out.println("storage : " + fstorage);
//		System.out.println("compress : " + fcompress);
//		System.out.println("dateType : " + fdateType);
//		System.out.println("date : " + fdate);
//		System.out.println("setNum : " + fsetNum);
//		System.out.println("jobName_New : " + jobName_New);
//		System.out.println("jobName_Old : " + jobName_Old);
//		System.out.println("volumeJson : " + volumeJson);
//		System.out.println("volumeJson.length : " + volumeJson.size());
//		System.out.println("=============================");
		
		
		// 3. 입력한 정책 등록값들을 VO에 넣어줌
		// 3-1) 증분 백업 정책 스케줄 정보
		// schedule Info List Make
		backupSchedule = scheduleListMake(weekData, startDate);
		
		// 3-2) storage 정보
		// backupLocation Info Make
		backupLocation=experdbBackupPolicyDAO.getScheduleLocationInfo(fstorage);
		backupLocation.setBackupDestLocation(fstorage);
		
		// 3-3) 백업 스크립트 (압축, jobName, repeat, scheduleType) 정보
		// backupScript Info Make
		backupScript.setCompressLevel(Integer.parseInt(fcompress));
		backupScript.setJobName(jobName_New);
		
		// 등록된 증분백업정책이 있다면
		if(backupSchedule.size()>0){
			backupScript.setRepeat("true");
			backupScript.setDisable(false);
			backupScript.setScheduleType(5);
		}else{
			backupScript.setRepeat("false");			
			backupScript.setDisable(true);
			backupScript.setScheduleType(3);
		}
		
		// 3-4) volume 정보
		for(int i=0; i<volumeJson.size(); i++){
			VolumeVO v = new VolumeVO();
			JSONObject obj = (JSONObject) volumeJson.get(i);
			v.setMountOn(obj.get("mountOn").toString());
			v.setFileSystem(obj.get("filesystem").toString());
			v.setType(obj.get("type").toString());
			volumeList.add(v);
		}
		
		// 3-5) 대상 서버 정보
		// target Info Make
		targetMachine = experdbBackupPolicyDAO.getScheduleNodeInfo(ipadr);
		targetMachine.setJobName(jobName_New);
		
		// volume 선택 시 exclude -> false
		if(volumeList.size()==0){			
			targetMachine.setExclude("true");
		}else{
			targetMachine.setExclude("false");
		}
		
		targetMachine.setHypervisor("false");
		targetMachine.setIsProtected("true");
		targetMachine.setTemplateId(uuid);
		if(targetMachine.getDescription()==null){
			targetMachine.setDescription("");
		}
		
		// 3-6) 풀백업 정책의 백업셋, 수행일 정보
		// retention Info Make
		backupRetention.setBackupSetCount(Integer.parseInt(fsetNum));
		backupRetention.setDayOfMonth(Integer.parseInt(monthDate));
		backupRetention.setDayOfWeek(Integer.parseInt(weekDate));
		backupRetention.setUseWeekly(fdateType);
		
		// 4. xml 파일 만들기 및 IMPORT 
		JobXMLMake xmlMake = new JobXMLMake();
		xmlMake.xmlMake(backupLocation, backupScript, targetMachine, backupRetention, backupSchedule, volumeList);
		
		// 5. volume Script DB Insert
		if(volumeList.size()>0){		
			String volumeScript = null;
			JobVolume jobVolume = new JobVolume();
			volumeScript = jobVolume.volumeMake(targetMachine, volumeList);
			
			Map<String, Object> volumeInsert = new HashMap<>();
			volumeInsert.put("ipadr", ipadr);
			volumeInsert.put("volumeScript", volumeScript);
			
			experdbBackupPolicyDAO.volumeUpdate(volumeInsert);
		}
		return result;
	}
	 
	// 증분 백업 정책 리스트에 넣어주기
	public List<BackupScheduleVO> scheduleListMake(String weekData, String startDate) throws Exception {
		/*
		 *  증분 백업 정책 list에 저장 (scheduleInsert 에서 사용)
		 *  1. startDate를 포멧에 맞춰줌
		 *  2. 증분 백업 정책을 요일별로 분리
		 *  3. 요일별로 정책 정보를 List<BackupScheduleVO>에 넣어주기
		 *  
		 */
		List<BackupScheduleVO> backupSchedule = new ArrayList<>();
		
		// 1. startDate를 포멧에 맞춰줌
		Map<String, Object> date = new HashMap<>();
		date = dateSplit(startDate);
		
		// 2. 증분 백업 정책을 요일별로 분리
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(weekData);
		JSONArray mon = (JSONArray) jsonObject.get("mon");
		JSONArray tue = (JSONArray) jsonObject.get("tue");
		JSONArray wed = (JSONArray) jsonObject.get("wed");
		JSONArray thu = (JSONArray) jsonObject.get("thu");
		JSONArray fri = (JSONArray) jsonObject.get("fri");
		JSONArray sat = (JSONArray) jsonObject.get("sat");
		JSONArray sun = (JSONArray) jsonObject.get("sun");
		
		// 3. 요일별로 정책 정보를 List<BackupScheduleVO>에 넣어주기
		// schedule Setting by week of day
		for(int i=0; i<sun.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) sun.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("1");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<mon.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) mon.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("2");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<tue.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) tue.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("3");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<wed.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) wed.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("4");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<thu.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) thu.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("5");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<fri.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) fri.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("6");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<sat.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) sat.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("7");
			backupSchedule.add(schedule);
		}

		return backupSchedule;
	}
	
	// 증분 백업 세팅
	public BackupScheduleVO setSchedule(JSONObject schObj, Map<String, Object> date) throws ParseException{
		/*
		 *  증분 백업 정책 세팅 (scheduleListMake 에서 사용)
		 *  1. 정책 기본 데이터 세팅 (시작 날짜, 반복 유무)
		 *  2. 정책 시작 시간 세팅
		 *  3. repeat 세팅
		 *    3-1) repeat 값이 존재한다면
		 *  
		 */
		BackupScheduleVO schedule = new BackupScheduleVO();
		
		int monthData = (Integer) date.get("month")-1;
		
		// 1. 정책 기본 데이터 세팅 (시작 날짜, 반복 유무)
		schedule.setRepeat(Boolean.toString((boolean) schObj.get("rc")));
		schedule.setYear(date.get("year").toString());
		schedule.setMonth(Integer.toString(monthData));
		schedule.setDay(date.get("day").toString());
		schedule.setBackupType((String) schObj.get("bt"));
		// 2. 정책 시작 시간 세팅
		// start time
		Map<String, Object> startTime = new HashMap<>();
		startTime = timeSplit((String) schObj.get("st"));
		
		schedule.setStartHour(startTime.get("12hour").toString());
		schedule.setStartHourOfDay(startTime.get("24hour").toString());
		schedule.setStartMinute(startTime.get("min").toString());
		schedule.setStartHourType(startTime.get("type").toString());

		// 3. repeat을 설정했다면 endTime 세팅
		// end time
		if((boolean) schObj.get("rc")){		
			// interval setting
			schedule.setInterval(schObj.get("rt").toString());
			schedule.setIntervalUnit(schObj.get("rtu").toString());
			
			Map<String, Object> endTime = new HashMap<>();
			endTime = timeSplit(schObj.get("ret").toString());
			
			schedule.setEndHour(endTime.get("12hour").toString());
			schedule.setEndHourOfDay(endTime.get("24hour").toString());
			schedule.setEndMinute(endTime.get("min").toString());
			schedule.setEndHourType(endTime.get("type").toString());
		}else{
			schedule.setInterval("0");
			schedule.setIntervalUnit("0");
		}
		return schedule;
	}
	
	// date 데이터 format 맞춰주기
	public static Map<String, Object> dateSplit(String date) throws ParseException{
		Map<String, Object> result = new HashMap<>();
		SimpleDateFormat _dateSDF = new SimpleDateFormat("yyyy-mm-dd");
		SimpleDateFormat _yearSDF = new SimpleDateFormat("yyyy");
		SimpleDateFormat _monthSDF = new SimpleDateFormat("mm");
		SimpleDateFormat _daySDF = new SimpleDateFormat("dd");
		
		if(date.length()>0){
			Date _dateDt = _dateSDF.parse(date);
			result.put("year", Integer.parseInt(_yearSDF.format(_dateDt)));
			result.put("month", Integer.parseInt(_monthSDF.format(_dateDt)));
			result.put("day", Integer.parseInt(_daySDF.format(_dateDt)));
			result.put("fullDate", _dateSDF.format(_dateDt));
			
		}else{
			result.put("year", "");
			result.put("month", "");
			result.put("day", "");
			result.put("fullDate", "");
		}

		return result;
	}
	
	// time 데이터 format 맞춰주기
	public static Map<String, Object> timeSplit(String time) throws ParseException{
		
		Map<String, Object> result = new HashMap<>();
      
       String _24HourTime = time;
       SimpleDateFormat _24HourSDF = new SimpleDateFormat("HH:mm");
       SimpleDateFormat _24Hour = new SimpleDateFormat("HH");
       SimpleDateFormat _12Hour = new SimpleDateFormat("hh");
       SimpleDateFormat _12Min = new SimpleDateFormat("mm");
       SimpleDateFormat _12Type = new SimpleDateFormat("a", Locale.ENGLISH);
       
       if(time.length()>0){    	   
    	   Date _24HourDt = _24HourSDF.parse(_24HourTime);
    	   result.put("12hour",Integer.parseInt(_12Hour.format(_24HourDt)));
    	   result.put("min", Integer.parseInt(_12Min.format(_24HourDt)));
    	   result.put("24hour", Integer.parseInt(_24Hour.format(_24HourDt)));
    	   result.put("fullHour", _24HourSDF.format(_24HourDt));
    	   if(_12Type.format(_24HourDt).equals("PM")){
    		   result.put("type", "1");
    	   }else{
    		   result.put("type", "0");
    	   }
       }else{
    	   result.put("12hour","");
    	   result.put("min", "");
    	   result.put("24hour", "");
    	   result.put("fullHour","");
    	   result.put("type", "");
       }
		return result;
	}
}
