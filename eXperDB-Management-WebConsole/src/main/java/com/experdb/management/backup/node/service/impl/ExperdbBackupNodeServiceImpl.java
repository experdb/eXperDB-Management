package com.experdb.management.backup.node.service.impl;

import java.io.*;
import java.lang.reflect.*;
import java.text.*;
import java.text.ParseException;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.batch.core.scope.context.*;
import org.springframework.stereotype.Service;
import org.xml.sax.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.node.service.*;
import com.experdb.management.backup.service.*;
import com.experdb.management.backup.service.impl.*;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupNodeServiceImpl")
public class ExperdbBackupNodeServiceImpl  extends EgovAbstractServiceImpl implements ExperdbBackupNodeService{

	@Resource(name = "ExperdbBackupNodeDAO")
	private ExperdbBackupNodeDAO experdbBackupNodeDAO;

	@Resource(name = "ExperdbBackupDAO")
	private ExperdbBackupDAO experdbBackupDAO;

	
	
	@Override
	public List<TargetMachineVO> getNodeList() throws Exception {
		return experdbBackupNodeDAO.getNodeList();	
	}



	@Override
	public List<ServerInfoVO> getNodeInfoList() {
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> result = new ArrayList<>();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
//					System.out.println("REG LIST : " + s.getIpadr() + " || " + n.getName());
					result.add(s);
				}
			}
		}
		return result;
	}



	@Override
	public List<ServerInfoVO> getUnregNodeList() {
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> result = new ArrayList<>();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
//					System.out.println("UNREG LIST : " + s.getIpadr() + " || " + n.getName());
					result.add(s);
				}
			}
		}
		serverList.removeAll(result);
		return serverList;
	}



	@Override
	public JSONObject nodeInsert(HttpServletRequest request) {
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		nodeInfo.setName(request.getParameter("ipadr"));
		nodeInfo.setUser(request.getParameter("rootName"));
		nodeInfo.setPassword(request.getParameter("rootPW"));
		nodeInfo.setIsUser(request.getParameter("userCred"));
		nodeInfo.setUserName(request.getParameter("userName"));
		nodeInfo.setUserPw(request.getParameter("userPW"));
		nodeInfo.setDescription("'"+request.getParameter("description")+"'");
		
		result = Node.addNode(nodeInfo);
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getNodeInfo(HttpServletRequest request) throws Exception{
//		System.out.println("GET NODE INFO SERVICE!!!");
//		System.out.println("REQUEST : " + request.getParameter("path"));
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		String path = request.getParameter("path");
		nodeInfo = experdbBackupNodeDAO.getNodeInfo(path);
		
//		System.out.println("nodeInfo to String : " + nodeInfo.toString());
		String[] name= nodeInfo.getUser().split("\t");
		
		if(name.length >1){			
			result.put("userName", name[0]);
			result.put("rootName", name[1]);
		}else{
			result.put("rootName", name[0]);
			result.put("userName", "");
		}
		
		result.put("ipadr", nodeInfo.getName());
		result.put("description", nodeInfo.getDescription());
		
		return result;
	}

	@Override
	public JSONObject nodeUpdate(HttpServletRequest request) {
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		nodeInfo.setName(request.getParameter("ipadr"));
		nodeInfo.setUser(request.getParameter("rootName"));
		nodeInfo.setPassword(request.getParameter("rootPW"));
		nodeInfo.setIsUser(request.getParameter("userCred"));
		nodeInfo.setUserName(request.getParameter("userName"));
		nodeInfo.setUserPw(request.getParameter("userPW"));
		nodeInfo.setDescription("'"+request.getParameter("description")+"'");
		
		result = Node.modifyNode(nodeInfo);
		
		return result;
	}
	
	@Override
	public JSONObject nodeDelete(HttpServletRequest request) throws Exception{
		JSONObject result = new JSONObject();
		result = Node.deleteNode(request.getParameter("ipadr"));
		return result;
	}

	@Override
	@SuppressWarnings({ "unchecked"})
	public JSONObject getScheduleInfo(HttpServletRequest request) throws SAXException, IOException, ParseException {
		System.out.println("@@@@@  getScheduleInfo  @@@@@");
		JSONObject result = new JSONObject();
		
		List<BackupScheduleVO> backupSchedule = null;
		BackupScriptVO backupScript = new BackupScriptVO();
		BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
		RetentionVO backupRetention = new RetentionVO();
		ArrayList<Object> weekData = new ArrayList<>();
		Map<String, Object> readXml = new HashMap<>();
		
		String fileName = request.getParameter("ipadr").replace(".", "_").trim()+".xml";
//		String fileName = string.replace(".", "_").trim()+".xml";
		
		String path = "C://test//backupXml//" + fileName;
//		String path = "/opt/Arcserve/d2dserver/bin/jobs" + fileName;
		
		JobXMLRead xml = new JobXMLRead();
		readXml = xml.xmlRead(path);
		
//		System.out.println("schedule 정보 불러온 결과!!!!!!");
		backupSchedule = (List<BackupScheduleVO>) readXml.get("schedule");
		backupRetention = (RetentionVO) readXml.get("retention");
		backupLocation = (BackupLocationInfoVO) readXml.get("backupLocation");
		backupScript = (BackupScriptVO) readXml.get("backupScript");
//		System.out.println("backupRetention : " + backupRetention.toString());
//		System.out.println("backupLocation : " + backupLocation.toString());
//		System.out.println("backupScript : " + backupScript.toString());
		
		String startDate = backupSchedule.get(0).getYear() + "-" + backupSchedule.get(0).getMonth() + "-" + backupSchedule.get(0).getDay();
		
		backupSchedule.remove(0);
		
		// 스케줄 정보를 정리해서 담아줌
		for(BackupScheduleVO bs : backupSchedule){
			Map <String, Object> scheduleMap = new HashMap<>();
			Boolean[] dayPick = new Boolean[7];
			Arrays.fill(dayPick, Boolean.FALSE);
			int dayType = Integer.parseInt(bs.getDayType())%7;
			
			scheduleMap.put("startTime", timeSplit(bs.getStartHourOfDay() + ":" + bs.getStartMinute()).get("fullHour"));
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
			
//			System.out.println("bs : " + bs.toString());
//			System.out.println(scheduleMap);
			
			weekData.add(scheduleMap);
		}
		
		int storageType;
		String fstorage = backupLocation.getBackupDestLocation();
		int fcompress = backupScript.getCompressLevel();
		int fsetNum = backupRetention.getBackupSetCount();
		String fdateType = backupRetention.getUseWeekly();
		int fdate = backupRetention.getDayOfMonth();
		
		if(backupLocation.getBackupDestUser()==null){
			storageType = 0;
		}else{
			storageType = 1;
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
		
		result.put("startDate", startDate);
		result.put("storageType", storageType);
		result.put("storage", fstorage);
		result.put("compress", fcompress);
		result.put("dateType", fdateType);
		result.put("date", fdate);
		result.put("setNum", fsetNum);
		result.put("weekData", weekData);
		
		
		return result;
	}


	 @Override
	public void scheduleInsert(HttpServletRequest request, Map<Object, String> param) throws Exception {
		System.out.println("========= scheduleInsert SERVICE !!! =========");
		List<BackupScheduleVO> backupSchedule = new ArrayList<>();
		BackupScriptVO backupScript = new BackupScriptVO();
		TargetMachineVO targetMachine = new TargetMachineVO();
		BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
		RetentionVO backupRetention = new RetentionVO();
		
		Date date = new Date();
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String time = transFormat.format(date);   
        
        String jobName = "backup_"+time;
        String uuid = UUID.randomUUID().toString();
        
        int schExist = 0;
		
		
		String weekData = param.get("weekData").toString();
		String ipadr = request.getParameter("nodeIpadr");
		String startDate = request.getParameter("startDate");
		String storageType = request.getParameter("storageType");
		String fstorage = request.getParameter("storage");
		String fcompress = request.getParameter("compress");
		String fdateType = request.getParameter("dateType");
		String fdate = request.getParameter("date");
		String fsetNum = request.getParameter("setNum");
		
		System.out.println("=============================");
		System.out.println("uuid : " + uuid);
		System.out.println("weekData : " + weekData);
		System.out.println("ipadr : " + ipadr);
		System.out.println("startDate : " + startDate);
		System.out.println("storageType : " + storageType);
		System.out.println("storage : " + fstorage);
		System.out.println("compress : " + fcompress);
		System.out.println("dateType : " + fdateType);
		System.out.println("date : " + fdate);
		System.out.println("setNum : " + fsetNum);
		System.out.println("=============================");
		
		// schedule Info List Make
		backupSchedule = scheduleListMake(weekData, startDate);
		
		// backupLocation Info Make
		backupLocation=experdbBackupNodeDAO.getScheduleLocationInfo(fstorage);
		backupLocation.setBackupDestLocation(fstorage);
		System.out.println("backupLocation : " + backupLocation.toString());
		
		// backupScript Info Make
		backupScript.setCompressLevel(Integer.parseInt(fcompress));
		backupScript.setJobName(jobName);
		
		if(backupSchedule.size()>0){
			schExist = 1;
			backupScript.setRepeat("true");
			backupScript.setScheduleType(5);
		}else{
			schExist = 0;
			backupScript.setRepeat("false");			
			backupScript.setScheduleType(3);
		}
		System.out.println("backupScript : " + backupScript.toString());
		
		// target Info Make
		targetMachine = experdbBackupNodeDAO.getScheduleNodeInfo(ipadr);
		targetMachine.setJobName(jobName);
		targetMachine.setExclude("true");
		targetMachine.setHypervisor("false");
		targetMachine.setIsProtected("true");
		targetMachine.setTemplateId(uuid);
		if(targetMachine.getDescription()==null){
			targetMachine.setDescription("");
		}
		System.out.println("targetMachine : "+targetMachine.toString());
		
		// retention Info Make
		backupRetention.setBackupSetCount(Integer.parseInt(fsetNum));
		backupRetention.setDayOfMonth(Integer.parseInt(fdate));
		backupRetention.setDayOfWeek(Integer.parseInt(fdate));
		backupRetention.setUseWeekly(fdateType);
		System.out.println("backupRetention : "+backupRetention.toString());
		
		// schedule 찍어보기
		for(BackupScheduleVO bs : backupSchedule){
			System.out.println(bs.toString());
		}
		
		JobXMLMake xmlMake = new JobXMLMake();
		xmlMake.xmlMake(backupLocation, backupScript, targetMachine, backupRetention, backupSchedule);
		
		
		Map<String, Object> jobInsert = new HashMap<>();
		
		jobInsert.put("jobType", 1);
		jobInsert.put("templateID", uuid);
		jobInsert.put("ipadr", ipadr);
		jobInsert.put("isRepeat", schExist);
		jobInsert.put("jobStatus", -1);
		jobInsert.put("lastResult", 0);
		jobInsert.put("uuid", UUID.randomUUID().toString());
		jobInsert.put("backupLocation", backupLocation.getUuid());
		jobInsert.put("jobName", jobName);
		
		experdbBackupNodeDAO.scheduleInsert(jobInsert);
		
		System.out.println("========= scheduleInsert SERVICE END ==========");
	
	}
	 
	public List<BackupScheduleVO> scheduleListMake(String weekData, String startDate) throws Exception {
		List<BackupScheduleVO> backupSchedule = new ArrayList<>();
		
		Map<String, Object> date = new HashMap<>();
		date = dateSplit(startDate);
		
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(weekData);
		JSONArray mon = (JSONArray) jsonObject.get("mon");
		JSONArray tue = (JSONArray) jsonObject.get("tue");
		JSONArray wed = (JSONArray) jsonObject.get("wed");
		JSONArray thu = (JSONArray) jsonObject.get("thu");
		JSONArray fri = (JSONArray) jsonObject.get("fri");
		JSONArray sat = (JSONArray) jsonObject.get("sat");
		JSONArray sun = (JSONArray) jsonObject.get("sun");
		
		// schedule Setting by week of day
		for(int i=0; i<mon.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) mon.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("1");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<tue.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) tue.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("2");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<wed.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) wed.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("3");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<thu.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) thu.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("4");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<fri.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) fri.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("5");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<sat.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) sat.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("6");
			backupSchedule.add(schedule);
		}
		for(int i=0; i<sun.size(); i++){
			BackupScheduleVO schedule = new BackupScheduleVO();
			JSONObject schObj = (JSONObject) sun.get(i);
			schedule = setSchedule(schObj, date);
			schedule.setDayType("7");
			backupSchedule.add(schedule);
		}

		return backupSchedule;
	}
	
	// schedules setting
	public BackupScheduleVO setSchedule(JSONObject schObj, Map<String, Object> date) throws ParseException{
		BackupScheduleVO schedule = new BackupScheduleVO();
		
		schedule.setRepeat(Boolean.toString((boolean) schObj.get("rc")));

		schedule.setYear(date.get("year").toString());
		schedule.setMonth(date.get("month").toString());
		schedule.setDay(date.get("day").toString());
		
		// start time
		Map<String, Object> startTime = new HashMap<>();
		startTime = timeSplit((String) schObj.get("st"));
		
		schedule.setStartHour(startTime.get("12hour").toString());
		schedule.setStartHourOfDay(startTime.get("24hour").toString());
		schedule.setStartMinute(startTime.get("min").toString());
		schedule.setStartHourType(startTime.get("type").toString());

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
	
	public static Map<String, Object> dateSplit(String date) throws ParseException{
		Map<String, Object> result = new HashMap<>();
		
		SimpleDateFormat _dateSDF = new SimpleDateFormat("yyyy-mm-dd");
		SimpleDateFormat _yearSDF = new SimpleDateFormat("yyyy");
		SimpleDateFormat _monthSDF = new SimpleDateFormat("mm");
		SimpleDateFormat _daySDF = new SimpleDateFormat("dd");

		Date _dateDt = _dateSDF.parse(date);
		result.put("year", Integer.parseInt(_yearSDF.format(_dateDt)));
		result.put("month", Integer.parseInt(_monthSDF.format(_dateDt)));
		result.put("day", Integer.parseInt(_daySDF.format(_dateDt)));

		return result;
	}
	
	public static Map<String, Object> timeSplit(String time) throws ParseException{
		
		Map<String, Object> result = new HashMap<>();
      
       String _24HourTime = time;
       SimpleDateFormat _24HourSDF = new SimpleDateFormat("HH:mm");
       SimpleDateFormat _24Hour = new SimpleDateFormat("HH");
       SimpleDateFormat _12Hour = new SimpleDateFormat("hh");
       SimpleDateFormat _12Min = new SimpleDateFormat("mm");
       SimpleDateFormat _12Type = new SimpleDateFormat("a", Locale.ENGLISH);
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

		return result;
		
	}
	
	public static void main (String[] args){
//		dateSplit("2020-03-15");
		Map<String, Object> result = new HashMap<>();
		try {
			result = timeSplit("3:2");
			System.out.println("24hour : " + result.get("24hour"));
			System.out.println("fullHour : " + result.get("fullHour"));
			System.out.println(timeSplit("3:2").get("fullHour"));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}



//	@Override
//	public JSONObject getScheduleInfo(HttpServletRequest request) throws SAXException, IOException {
//		// TODO Auto-generated method stub
//		return null;
//	}


}
