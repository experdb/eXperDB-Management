package com.experdb.management.backup.cmmn;

import java.io.*;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.json.simple.JSONObject;
import org.springframework.batch.core.scope.context.*;
import org.w3c.dom.*;
import org.w3c.dom.Node;
import org.xml.sax.*;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.policy.service.VolumeVO;
import com.experdb.management.backup.service.*;

public class JobXMLRead{

		DocumentBuilderFactory docFactory;
		DocumentBuilder docBuilder;
		Document doc;
		
		public Map<String, Object> xmlRead(String file) throws SAXException, IOException, ParserConfigurationException{
			System.out.println("=== xmlReader ===");
			List<BackupScheduleVO> scheduleList = new ArrayList<>();
			List<VolumeVO> volumes = new ArrayList<>();
			RetentionVO retention = new RetentionVO();
			BackupScriptVO backupScript = new BackupScriptVO();
			BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
			
			Map<String, Object> result = new HashMap<>();

			docFactory = DocumentBuilderFactory.newInstance();
			docBuilder = docFactory.newDocumentBuilder();
			
			doc = docBuilder.parse(new File(file));
			doc.getDocumentElement().normalize();
			
			retention=fullInfoXml();
			backupScript=jobInfoXml();
			backupLocation = backupLocationInfoXml();
			scheduleList = scheduleXml();
			volumes = volumeXml();
			
			result.put("schedule", scheduleList);
			result.put("retention", retention);
			result.put("backupScript", backupScript);
			result.put("backupLocation", backupLocation);
			result.put("volumes", volumes);
			
			return result;
			
		}
		
		private List<VolumeVO> volumeXml() {
			System.out.println("#### volumeXml ####");
			List<VolumeVO> volumes = new ArrayList<>();
			
			NodeList excludeVolumes = doc.getElementsByTagName("excludeVolumes");
			
			for(int v =0; v< excludeVolumes.getLength(); v++){
				VolumeVO volume = new VolumeVO();
				Node node = excludeVolumes.item(v);
				Element elements = (Element) node;
				
				volume.setFileSystem(elements.getElementsByTagName("fileSystem").item(0).getTextContent());
				volume.setMountOn(elements.getElementsByTagName("mountOn").item(0).getTextContent());
				volume.setType(elements.getElementsByTagName("type").item(0).getTextContent());
				
				volumes.add(volume);
			}
			return volumes;
		}
		
		
		private List<BackupScheduleVO> scheduleXml(){
			System.out.println("#### scheduleXml ####");
			List<BackupScheduleVO> backupSchedule = new ArrayList<>();
			
			String ns2 = "http://backup.data.webservice.arcflash.ca.com/xsd";
			NodeList weekly = doc.getElementsByTagName("weeklySchedule");  // weeklySchedule
			NodeList schedules = doc.getElementsByTagName("scheduleList");
			
			// weeklySchedule tag must be used once
			Node n_week = weekly.item(0);
			
			// <weeklySchedule> TAG exist check
			if(n_week == null || n_week.equals("")){
				System.out.println("## scheduleXml_weeklySchedule null ##");
				return backupSchedule;
			}
			
			// weeklySchedule-startDate
			// add in BackupScheduleVO List's first index(0)
			BackupScheduleVO weekDate = new BackupScheduleVO();
			Element e_week = (Element) n_week;
			int index = schedules.getLength();
			
			NodeList weekStart = e_week.getElementsByTagName("startTime");
			Node n_weekStart = weekStart.item(index);
			Element e_weekStart = (Element) n_weekStart;
			
			
			weekDate.setYear(e_weekStart.getElementsByTagName("ns2:year").item(0).getTextContent());
			weekDate.setMonth(e_weekStart.getElementsByTagName("ns2:month").item(0).getTextContent());
			weekDate.setDay(e_weekStart.getElementsByTagName("ns2:day").item(0).getTextContent());

			// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//			weekDate.setYear(e_weekStart.getElementsByTagNameNS(ns2, "year").item(0).getTextContent());
//			weekDate.setMonth(e_weekStart.getElementsByTagNameNS(ns2, "month").item(0).getTextContent());
//			weekDate.setDay(e_weekStart.getElementsByTagNameNS(ns2, "day").item(0).getTextContent());
			
			
			backupSchedule.add(weekDate);
//			e_weekStart.getElementsByTagNameNS(ns2, "year");

			// schedules for
			for(int sh=0; sh<schedules.getLength(); sh++){
				BackupScheduleVO schedule = new BackupScheduleVO();
				Node node = schedules.item(sh);
				Element elements = (Element) node;
				
				schedule.setRepeat(elements.getElementsByTagName("ns2:enabled").item(0).getTextContent());
				schedule.setDayType(elements.getElementsByTagName("day").item(0).getTextContent());
				schedule.setBackupType(elements.getElementsByTagName("jobType").item(0).getTextContent());
				schedule.setInterval(elements.getElementsByTagName("ns2:interval").item(0).getTextContent());
				schedule.setIntervalUnit(elements.getElementsByTagName("ns2:intervalUnit").item(0).getTextContent());

				// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				// elements.getElementsByTagNameNS(ns2, "year")
//				schedule.setRepeat(elements.getElementsByTagNameNS(ns2, "enabled").item(0).getTextContent());
//				schedule.setDayType(elements.getElementsByTagNameNS("","day").item(0).getTextContent());
//				schedule.setInterval(elements.getElementsByTagNameNS(ns2, "interval").item(0).getTextContent());
//				schedule.setIntervalUnit(elements.getElementsByTagNameNS(ns2, "intervalUnit").item(0).getTextContent());
				
				
				
				
				// startTime
				NodeList startTime = elements.getElementsByTagName("startTime");
				Node n_start = startTime.item(0);
				Element e_startTime = (Element) n_start;
				
				schedule.setStartHour(e_startTime.getElementsByTagName("ns2:hour").item(0).getTextContent());
				schedule.setStartHourOfDay(e_startTime.getElementsByTagName("ns2:hourOfday").item(0).getTextContent());
				schedule.setStartMinute(e_startTime.getElementsByTagName("ns2:minute").item(0).getTextContent());
				schedule.setStartHourType(e_startTime.getElementsByTagName("ns2:amPM").item(0).getTextContent());

				// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				// e_startTime.getElementsByTagNameNS(ns2, "year")
//				schedule.setStartHour(e_startTime.getElementsByTagNameNS(ns2, "hour").item(0).getTextContent());
//				schedule.setStartHourOfDay(e_startTime.getElementsByTagNameNS(ns2, "hourOfday").item(0).getTextContent());
//				schedule.setStartMinute(e_startTime.getElementsByTagNameNS(ns2, "minute").item(0).getTextContent());
//				schedule.setStartHourType(e_startTime.getElementsByTagNameNS(ns2, "amPM").item(0).getTextContent());
					
				// endTime
				if(elements.getElementsByTagName("ns2:enabled").item(0).getTextContent().equals("true")){
//				if(elements.getElementsByTagNameNS(ns2, "enabled").item(0).getTextContent().equals("true")){
					NodeList endTime = elements.getElementsByTagName("endTime");
					Node n_end = endTime.item(0);
					Element e_endTime = (Element) n_end;
					
					
					schedule.setEndHour(e_endTime.getElementsByTagName("ns2:hour").item(0).getTextContent());
					schedule.setEndHourOfDay(e_endTime.getElementsByTagName("ns2:hourOfday").item(0).getTextContent());
					schedule.setEndMinute(e_endTime.getElementsByTagName("ns2:minute").item(0).getTextContent());
					schedule.setEndHourType(e_endTime.getElementsByTagName("ns2:amPM").item(0).getTextContent());

					// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					// e_endTime.getElementsByTagNameNS(ns2, "year")
//					schedule.setEndHour(e_endTime.getElementsByTagNameNS(ns2, "hour").item(0).getTextContent());
//					schedule.setEndHourOfDay(e_endTime.getElementsByTagNameNS(ns2, "hourOfday").item(0).getTextContent());
//					schedule.setEndMinute(e_endTime.getElementsByTagNameNS(ns2, "minute").item(0).getTextContent());
//					schedule.setEndHourType(e_endTime.getElementsByTagNameNS(ns2, "amPM").item(0).getTextContent());
				}

				// add the schedule in VO List
				backupSchedule.add(schedule);
				
			} // schedule for() end
			return backupSchedule;
			
		}
		
		// retention
		private RetentionVO fullInfoXml(){
			System.out.println("#### fullInfoXML (retention) ####");
			RetentionVO retentionVO = new RetentionVO();
			NodeList retention = doc.getElementsByTagName("retention");
			Node n_retention = retention.item(0);
			
			// <retention> TAG exist check
			if(n_retention == null || n_retention.equals("")){
				System.out.println("## fullInfoXML (retention) null ##");
				return retentionVO;
			}
			
			Element e_retention = (Element) n_retention;
			
			retentionVO.setBackupSetCount(Integer.parseInt(e_retention.getElementsByTagName("backupSetCount").item(0).getTextContent()));
			retentionVO.setDayOfMonth(Integer.parseInt(e_retention.getElementsByTagName("dayOfMonth").item(0).getTextContent()));
			retentionVO.setDayOfWeek(Integer.parseInt(e_retention.getElementsByTagName("dayOfWeek").item(0).getTextContent()));
			retentionVO.setUseWeekly(e_retention.getElementsByTagName("useWeekly").item(0).getTextContent());

			// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			// e_retention.getElementsByTagNameNS("", "hour")
//			retentionVO.setBackupSetCount(Integer.parseInt(e_retention.getElementsByTagNameNS("", "backupSetCount").item(0).getTextContent()));
//			retentionVO.setDayOfMonth(Integer.parseInt(e_retention.getElementsByTagNameNS("", "dayOfMonth").item(0).getTextContent()));
//			retentionVO.setDayOfWeek(Integer.parseInt(e_retention.getElementsByTagNameNS("", "dayOfWeek").item(0).getTextContent()));
//			retentionVO.setUseWeekly(e_retention.getElementsByTagNameNS("", "useWeekly").item(0).getTextContent());
			
			// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//			System.out.println(retentionVO.toString());
			
			return retentionVO;
		}
		
		private BackupLocationInfoVO backupLocationInfoXml(){
			System.out.println("#### backupLocationInfoXML ####");
			BackupLocationInfoVO backupLocation = new BackupLocationInfoVO();
			NodeList backupLocationInfo = doc.getElementsByTagName("backupLocationInfo");
			Node n_backupLocation = backupLocationInfo.item(0);
			
			if(n_backupLocation == null || n_backupLocation.equals("")){
				System.out.println("## backupLocationInfo null ##");
				return backupLocation;
			}
			Element e_backupLocation = (Element) n_backupLocation;
			
			if(e_backupLocation.getElementsByTagName("backupDestUser").item(0) == null){
				backupLocation.setBackupDestUser(null);
			}else{
				backupLocation.setBackupDestUser(e_backupLocation.getElementsByTagName("backupDestUser").item(0).getTextContent());
			}
			backupLocation.setBackupDestLocation(e_backupLocation.getElementsByTagName("backupDestLocation").item(0).getTextContent());
			
			// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//			System.out.println(backupLocation.toString());
			
			return backupLocation;
		}
		
		private BackupScriptVO jobInfoXml(){
			BackupScriptVO backupScript = new BackupScriptVO();
			System.out.println("#### jobInfoXML ####");
			NodeList jobList = doc.getElementsByTagName("jobList");
			Node n_jobList = jobList.item(0);
			
			if(n_jobList == null || n_jobList.equals("")){
				System.out.println("## jobInfoXML_backupScript null ##");
				return backupScript;
			}
			
			Element e_jobList = (Element) n_jobList;
			backupScript.setCompressLevel(Integer.parseInt(e_jobList.getElementsByTagName("compressLevel").item(1).getTextContent()));
			backupScript.setJobName(e_jobList.getElementsByTagName("jobName").item(1).getTextContent());
			
			// v@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//			System.out.println(backupScript.toString());
			
			return backupScript;
		}
		
		
	    public static void main(String[] args) throws ParserConfigurationException {
	    	 String file = "C:\\test\\backupXml\\aaa.xml";
	    	 
    		 JobXMLRead xml = new JobXMLRead();
    		 Map<String, Object> result = new HashMap<>();
				try {
					result = xml.xmlRead(file);
				} catch (SAXException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
	    	
		}
}
