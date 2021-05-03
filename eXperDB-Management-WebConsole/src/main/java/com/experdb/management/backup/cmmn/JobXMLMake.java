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
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.policy.service.VolumeVO;
import com.experdb.management.backup.service.*;

public class JobXMLMake{
	
	/*   public static final String SEPARATOR = "_";
	   public static final String XML_SUFFIX = ".xml";
	   public static final String RESTORE_PREFIX = "restore";
	   public static final String FULL_SCHEDULE = "fullSchedule";
	   public static final String INCREMENTAL_SCHEDULE = "incrementalSchedule";
	   public static final String RESYNC_SCHEDULE = "resyncSchedule";
	   private String jobScriptDirectoryPath = "jobscript";*/

	   
	    /*  public JobXML(String path) {
		        this.jobScriptDirectoryPath = path;
		        File directory = new File(this.jobScriptDirectoryPath);
		        if (!directory.exists()) {
		          directory.mkdirs();
		        }
		      }*/
		DocumentBuilderFactory docFactory;
		DocumentBuilder docBuilder;
		Document doc;
		
	      
	      public void xmlMake(BackupLocationInfoVO locationInfo, BackupScriptVO backupScript, TargetMachineVO targetMachine, RetentionVO retentionVO, List<BackupScheduleVO> backupSchedule, List<VolumeVO> volume){
				
				// ** 태그 쓰는 순서 변경 금지 **
				// --> xmlRead 에서 문제 발생할 수 있음
				
	    	  System.out.println("==== xmlMake ====");

	            try {
	            	 docFactory = DocumentBuilderFactory.newInstance();
					 docBuilder = docFactory.newDocumentBuilder();
					
					// book 엘리먼트
		            doc = docBuilder.newDocument();
		            doc.setXmlStandalone(true); //standalone="no" 를 없애준다.
		            
		            //exportJob========================================================
		            Element exportJob = doc.createElement("exportJob");
		            doc.appendChild(exportJob);
		            exportJob.setAttribute("xmlns:ns2", "http://backup.data.webservice.arcflash.ca.com/xsd");
		            exportJob.setAttribute("xmlns:ns3", "http://catalog.data.webservice.arcflash.ca.com/xsd");
		            
		            Element buildNumber = doc.createElement("buildNumber");
		            buildNumber.appendChild(doc.createTextNode("4455392"));
		            exportJob.appendChild(buildNumber);
		            
		            Element jobList = doc.createElement("jobList");
		            exportJob.appendChild(jobList);
		            
		            Element version = doc.createElement("version");
		            version.appendChild(doc.createTextNode("7.0"));
		            exportJob.appendChild(version);
		            

		            // backupLocationInfo
		            backupLocationInfoXml(locationInfo, jobList);
		            		            
		            // jonbInfo
		            jobInfoXml(backupScript, jobList, targetMachine);
		            
		            //fullInfoXml
		            fullInfoXml(retentionVO, jobList);
		            
		            //targetInfoXml
		            targetInfoXml(targetMachine, jobList, backupScript, volume);
		            
		            //scheduleInfoXml
		            if(backupSchedule.size()>0){		            	
		            	scheduleXml(jobList, backupSchedule);
		            }
			            		            
		            CmmnUtil.xmlFileCreate(doc, targetMachine);
		            // xmlFile(doc, targetMachine.getName());
					
				} catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	      }
	      
	 
	      
	    private void scheduleXml(Element jobList, List<BackupScheduleVO> backupSchedule) {
	    	System.out.println("#### scheduleXml ####");
	    	// target 엘리먼트==================================================
            Element weeklySchedule = doc.createElement("weeklySchedule");
            jobList.appendChild(weeklySchedule);  

            for(BackupScheduleVO bs : backupSchedule){
        	   Element scheduleList = doc.createElement("scheduleList");
        	   weeklySchedule.appendChild(scheduleList);
        	   
        	   // repeat
        	   Element ns2_enabled = doc.createElement("ns2:enabled");
        	   ns2_enabled.appendChild(doc.createTextNode(bs.getRepeat()));
        	   scheduleList.appendChild(ns2_enabled);
        	   // interval
        	   Element ns2_interval = doc.createElement("ns2:interval");
        	   ns2_interval.appendChild(doc.createTextNode(bs.getInterval()));
        	   scheduleList.appendChild(ns2_interval);
        	   // interval unit
        	   Element ns2_intervalUnit = doc.createElement("ns2:intervalUnit");
        	   ns2_intervalUnit.appendChild(doc.createTextNode(bs.getIntervalUnit()));
        	   scheduleList.appendChild(ns2_intervalUnit);
        	   
        	   // start time 시작
        	   Element startTime = doc.createElement("startTime");
        	   scheduleList.appendChild(startTime);
        	   		
        	   		Element start_year = doc.createElement("ns2:year");
        	   		start_year.appendChild(doc.createTextNode("0"));
        	   		startTime.appendChild(start_year);
        	   		Element start_month = doc.createElement("ns2:month");
        	   		start_month.appendChild(doc.createTextNode("0"));
        	   		startTime.appendChild(start_month);
        	   		Element start_day = doc.createElement("ns2:day");
        	   		start_day.appendChild(doc.createTextNode("0"));
        	   		startTime.appendChild(start_day);
        	   		
        	   		Element start_hour = doc.createElement("ns2:hour");
        	   		start_hour.appendChild(doc.createTextNode(bs.getStartHour()));
        	   		startTime.appendChild(start_hour);
        	   		Element start_minute = doc.createElement("ns2:minute");
        	   		start_minute.appendChild(doc.createTextNode(bs.getStartMinute()));
        	   		startTime.appendChild(start_minute);
        	   		Element start_hourOfday = doc.createElement("ns2:hourOfday");
        	   		start_hourOfday.appendChild(doc.createTextNode(bs.getStartHourOfDay()));
        	   		startTime.appendChild(start_hourOfday);
        	   		Element start_amPM = doc.createElement("ns2:amPM");
        	   		start_amPM.appendChild(doc.createTextNode(bs.getStartHourType()));
        	   		startTime.appendChild(start_amPM);
        	   		
        	   		Element start_ready = doc.createElement("ready");
        	   		start_ready.appendChild(doc.createTextNode("false"));
        	   		startTime.appendChild(start_ready);
        	   		Element start_runNow = doc.createElement("runNow");
        	   		start_runNow.appendChild(doc.createTextNode("false"));
        	   		startTime.appendChild(start_runNow);
        	   	
        	   	// end time 시작
        	   if(bs.getRepeat().equals("true")){
        		   Element endTime = doc.createElement("endTime");
        		   scheduleList.appendChild(endTime);
        		   
        		   Element end_year = doc.createElement("ns2:year");
        		   end_year.appendChild(doc.createTextNode("0"));
        		   endTime.appendChild(end_year);
       	   		   Element end_month = doc.createElement("ns2:month");
       	   		   end_month.appendChild(doc.createTextNode("0"));
       	   		   endTime.appendChild(end_month);
       	   		   Element end_day = doc.createElement("ns2:day");
       	   		   end_day.appendChild(doc.createTextNode("0"));
       	   		   endTime.appendChild(end_day);
        		   		
        		   		Element end_hour = doc.createElement("ns2:hour");
        		   		end_hour.appendChild(doc.createTextNode(bs.getEndHour()));
        		   		endTime.appendChild(end_hour);
            	   		Element end_minute = doc.createElement("ns2:minute");
            	   		end_minute.appendChild(doc.createTextNode(bs.getEndMinute()));
            	   		endTime.appendChild(end_minute);
            	   		Element end_hourOfday = doc.createElement("ns2:hourOfday");
            	   		end_hourOfday.appendChild(doc.createTextNode(bs.getEndHourOfDay()));
            	   		endTime.appendChild(end_hourOfday);
            	   		Element end_amPM = doc.createElement("ns2:amPM");
            	   		end_amPM.appendChild(doc.createTextNode(bs.getEndHourType()));
            	   		endTime.appendChild(end_amPM);
        		   		
            	   		Element end_ready = doc.createElement("ready");
            	   		end_ready.appendChild(doc.createTextNode("false"));
        		   		endTime.appendChild(end_ready);
        		   		Element end_runNow = doc.createElement("runNow");
        		   		end_runNow.appendChild(doc.createTextNode("false"));
        		   		endTime.appendChild(end_runNow);
        	   }
        	   // day of week
        	   Element day = doc.createElement("day");
        	   day.appendChild(doc.createTextNode(bs.getDayType()));
        	   scheduleList.appendChild(day);
        	   
        	   // backup jobType
        	   Element jobType = doc.createElement("jobType");
       	       jobType.appendChild(doc.createTextNode(bs.getBackupType()));
        	   scheduleList.appendChild(jobType);
           }
            
            Element startTime = doc.createElement("startTime");
            weeklySchedule.appendChild(startTime);
            
            Element year = doc.createElement("ns2:year");
            year.appendChild(doc.createTextNode(backupSchedule.get(0).getYear()));
            startTime.appendChild(year);
            
            Element month = doc.createElement("ns2:month");
            month.appendChild(doc.createTextNode(backupSchedule.get(0).getMonth()));
            startTime.appendChild(month);
            
            Element day = doc.createElement("ns2:day");
            day.appendChild(doc.createTextNode(backupSchedule.get(0).getDay()));
            startTime.appendChild(day);
            
            Element hour = doc.createElement("ns2:hour");
            hour.appendChild(doc.createTextNode("0"));
	   		startTime.appendChild(hour);
	   		Element minute = doc.createElement("ns2:minute");
	   		minute.appendChild(doc.createTextNode("0"));
	   		startTime.appendChild(minute);
	   		Element hourOfday = doc.createElement("ns2:hourOfday");
	   		hourOfday.appendChild(doc.createTextNode("0"));
	   		startTime.appendChild(hourOfday);
	   		Element amPM = doc.createElement("ns2:amPM");
	   		amPM.appendChild(doc.createTextNode("0"));
	   		startTime.appendChild(amPM);
	   		
	   		Element ready = doc.createElement("ready");
	   		ready.appendChild(doc.createTextNode("true"));
	   		startTime.appendChild(ready);
	   		Element runNow = doc.createElement("runNow");
	   		runNow.appendChild(doc.createTextNode("false"));
	   		startTime.appendChild(runNow);
            
		}



		private void targetInfoXml(TargetMachineVO targetMachine, Element backupConfiguration, BackupScriptVO backupScript, List<VolumeVO> volumes) {
	    	System.out.println("#### targetInfoXml ####");
	    	// target 엘리먼트==================================================
            Element target = doc.createElement("target");
            backupConfiguration.appendChild(target);          
		            // backupLocationType 엘리먼트
		            Element backupLocationType = doc.createElement("backupLocationType");
		            backupLocationType.appendChild(doc.createTextNode(Integer.toString(targetMachine.getBackupLocationType())));
		            target.appendChild(backupLocationType);	
		            // connectionStatus 엘리먼트
		            Element connectionStatus = doc.createElement("connectionStatus");
		            connectionStatus.appendChild(doc.createTextNode(Integer.toString(targetMachine.getConnectionStatus())));
		            target.appendChild(connectionStatus);	
		            // description 엘리먼트
		            Element description = doc.createElement("description");
		            description.appendChild(doc.createTextNode(targetMachine.getDescription()));
		            target.appendChild(description);	
		            // jobName 엘리먼트
		            Element jobName = doc.createElement("jobName");
		            jobName.appendChild(doc.createTextNode(backupScript.getJobName()));
		            target.appendChild(jobName);	
		            // lastResult 엘리먼트
		            Element lastResult = doc.createElement("lastResult");
		            lastResult.appendChild(doc.createTextNode(Integer.toString(targetMachine.getLastResult())));
		            target.appendChild(lastResult);	
		            // machineType 엘리먼트
		            Element machineType = doc.createElement("machineType");
		            machineType.appendChild(doc.createTextNode(Integer.toString(targetMachine.getMachineType())));
		            target.appendChild(machineType);	
		            // name 엘리먼트
		            Element name = doc.createElement("name");
		            name.appendChild(doc.createTextNode(targetMachine.getName()));
		            target.appendChild(name);	
		            // operatingSystem 엘리먼트
		            Element operatingSystem = doc.createElement("operatingSystem");
		            operatingSystem.appendChild(doc.createTextNode(targetMachine.getOperatingSystem()));
		            target.appendChild(operatingSystem);	
		            // password 엘리먼트
		            Element password = doc.createElement("password");
		            password.appendChild(doc.createTextNode(targetMachine.getPassword()));
		            target.appendChild(password);	
		            // protected 엘리먼트
		            Element isProtected = doc.createElement("protected");
		            isProtected.appendChild(doc.createTextNode(targetMachine.getIsProtected()));
		            target.appendChild(isProtected);	
		            // backupLocationType 엘리먼트
		            Element recoveryPointCount = doc.createElement("recoveryPointCount");
		            recoveryPointCount.appendChild(doc.createTextNode(Integer.toString(targetMachine.getRecoveryPointCount())));
		            target.appendChild(recoveryPointCount);	
		            // recoverySetCount 엘리먼트
		            Element recoverySetCount = doc.createElement("recoverySetCount");
		            recoverySetCount.appendChild(doc.createTextNode(Integer.toString(targetMachine.getRecoverySetCount())));
		            target.appendChild(recoverySetCount);	
		            // user 엘리먼트
		            Element user = doc.createElement("user");
		            user.appendChild(doc.createTextNode(targetMachine.getUser()));
		            target.appendChild(user);	
		            // exclude 엘리먼트
		            Element exclude = doc.createElement("exclude");
		            exclude.appendChild(doc.createTextNode(targetMachine.getExclude()));
		            target.appendChild(exclude);
		            
		            // exclude 값이 false 일 때 volume 작성
		            if(targetMachine.getExclude().equals("false")){
		            	// excludeVolumes list 시작
		            	for(VolumeVO volume : volumes){
		            		// excludeVolumes 엘리먼트
		            		Element excludeVolumes = doc.createElement("excludeVolumes");
		            		target.appendChild(excludeVolumes);
		            		
		            		// fileSystem 엘리먼트
		            		Element fileSystem = doc.createElement("fileSystem");
		            		fileSystem.appendChild(doc.createTextNode(volume.getFileSystem()));
		            		excludeVolumes.appendChild(fileSystem);
		            		
		            		// mountOn 엘리먼트
		            		Element mountOn = doc.createElement("mountOn");
		            		mountOn.appendChild(doc.createTextNode(volume.getMountOn()));
		            		excludeVolumes.appendChild(mountOn);
		            		
		            		// necessary 엘리먼트
		            		Element necessary = doc.createElement("necessary");
		            		necessary.appendChild(doc.createTextNode("false"));
		            		excludeVolumes.appendChild(necessary);
		            		
		            		// size 엘리먼트
		            		Element size = doc.createElement("size");
		            		size.appendChild(doc.createTextNode("0"));
		            		excludeVolumes.appendChild(size);
		            		
		            		// type 엘리먼트
		            		Element type = doc.createElement("type");
		            		type.appendChild(doc.createTextNode(volume.getType()));
		            		excludeVolumes.appendChild(type);
		            	}
		            }
		            
		            // hypervisor 엘리먼트
		            Element hypervisor = doc.createElement("hypervisor");
		            hypervisor.appendChild(doc.createTextNode(targetMachine.getHypervisor()));
		            target.appendChild(hypervisor);	
		            // priority 엘리먼트
		            Element priority = doc.createElement("priority");
		            priority.appendChild(doc.createTextNode(Integer.toString(targetMachine.getPriority())));
		            target.appendChild(priority);	
		            
			
		}



		private void fullInfoXml(RetentionVO retentionVO, Element backupConfiguration) {
	    	System.out.println("#### fullInfoXml ####");
	    	// retention 엘리먼트==================================================
            Element retention = doc.createElement("retention");
            backupConfiguration.appendChild(retention);          
		            // backupSetCount 엘리먼트
		            Element backupSetCount = doc.createElement("backupSetCount");
		            backupSetCount.appendChild(doc.createTextNode(Integer.toString(retentionVO.getBackupSetCount())));
		            retention.appendChild(backupSetCount);	
		            // dayOfMonth 엘리먼트
		            Element dayOfMonth = doc.createElement("dayOfMonth");
		            dayOfMonth.appendChild(doc.createTextNode(Integer.toString(retentionVO.getDayOfMonth())));
		            retention.appendChild(dayOfMonth);
		            // dayOfWeek 엘리먼트
		            Element dayOfWeek = doc.createElement("dayOfWeek");
		            dayOfWeek.appendChild(doc.createTextNode(Integer.toString(retentionVO.getDayOfWeek())));
		            retention.appendChild(dayOfWeek);
		            // useWeekly 엘리먼트
		            Element useWeekly = doc.createElement("useWeekly");
		            useWeekly.appendChild(doc.createTextNode(retentionVO.getUseWeekly()));
		            retention.appendChild(useWeekly);		
		}



		private void jobInfoXml(BackupScriptVO backupScript, Element backupConfiguration, TargetMachineVO targetMachine) {
	    	System.out.println("#### jobInfoXml ####");
	    	 // compressLevel 엘리먼트
            Element compressLevel = doc.createElement("compressLevel");
            compressLevel.appendChild(doc.createTextNode(Integer.toString(backupScript.getCompressLevel())));
            backupConfiguration.appendChild(compressLevel);

            // encryptAlgoName 엘리먼트
            Element encryptAlgoName = doc.createElement("encryptAlgoName");
            encryptAlgoName.appendChild(doc.createTextNode(backupScript.getEncryptAlgoName()));
            backupConfiguration.appendChild(encryptAlgoName);
            
         // encryptAlgoType 엘리먼트
            Element encryptAlgoType = doc.createElement("encryptAlgoType");
            encryptAlgoType.appendChild(doc.createTextNode(Integer.toString(backupScript.getEncryptAlgoType())));
            backupConfiguration.appendChild(encryptAlgoType);
            
         // exclude 엘리먼트
            Element exclude = doc.createElement("exclude");
            exclude.appendChild(doc.createTextNode("true"));
            backupConfiguration.appendChild(exclude);
            
         // id 엘리먼트  ============ 확인필요
            Element id = doc.createElement("id");
            id.appendChild(doc.createTextNode(Integer.toString(backupScript.getId())));
            backupConfiguration.appendChild(id);
            
         // jobMethod 엘리먼트  ============ 확인필요
            Element jobMethod = doc.createElement("jobMethod");
            jobMethod.appendChild(doc.createTextNode("0"));
            backupConfiguration.appendChild(jobMethod);
            
         // jobName 엘리먼트
            Element jobName = doc.createElement("jobName");
            jobName.appendChild(doc.createTextNode(backupScript.getJobName()));
            backupConfiguration.appendChild(jobName);
            
         // jobType 엘리먼트
            Element jobType = doc.createElement("jobType");
            jobType.appendChild(doc.createTextNode("1"));
            backupConfiguration.appendChild(jobType);
            
         // logLevel 엘리먼트
            Element logLevel = doc.createElement("logLevel");
            logLevel.appendChild(doc.createTextNode("0"));
            backupConfiguration.appendChild(logLevel);
            
         // priority 엘리먼트
            Element priority = doc.createElement("priority");
            priority.appendChild(doc.createTextNode("0"));
            backupConfiguration.appendChild(priority);
            
         // repeat 엘리먼트
            Element repeat = doc.createElement("repeat");
            repeat.appendChild(doc.createTextNode(backupScript.isRepeat()));
            backupConfiguration.appendChild(repeat);
            
         // targetServer 엘리먼트
            Element targetServer = doc.createElement("targetServer");
            targetServer.appendChild(doc.createTextNode(targetMachine.getName()));
            backupConfiguration.appendChild(targetServer);
            
         // targetServerPwd 엘리먼트
            Element targetServerPwd = doc.createElement("targetServerPwd");
            targetServerPwd.appendChild(doc.createTextNode(targetMachine.getPassword()));
            backupConfiguration.appendChild(targetServerPwd);
            
         // targetServerUser 엘리먼트
            Element targetServerUser = doc.createElement("targetServerUser");
            targetServerUser.appendChild(doc.createTextNode(targetMachine.getUser()));
            backupConfiguration.appendChild(targetServerUser);
            
         // template 엘리먼트
            Element template = doc.createElement("template");
            template.appendChild(doc.createTextNode("true"));
            backupConfiguration.appendChild(template);
            
         // templateID 엘리먼트
            Element templateID = doc.createElement("templateID");
            templateID.appendChild(doc.createTextNode(targetMachine.getTemplateId()));
            backupConfiguration.appendChild(templateID);
            
         // uuid 엘리먼트
            Element uuid = doc.createElement("uuid");
            uuid.appendChild(doc.createTextNode(UUID.randomUUID().toString()));
            backupConfiguration.appendChild(uuid);
            
            
         // backupToRps 엘리먼트
            Element backupToRps = doc.createElement("backupToRps");
            backupToRps.appendChild(doc.createTextNode("false"));
            backupConfiguration.appendChild(backupToRps);
            
         // disable 엘리먼트 
            Element disable = doc.createElement("disable");
            disable.appendChild(doc.createTextNode(Boolean.toString(backupScript.isDisable())));
            backupConfiguration.appendChild(disable);
            
         // scheduleType 엘리먼트
            Element scheduleType = doc.createElement("scheduleType");
            scheduleType.appendChild(doc.createTextNode(Integer.toString(backupScript.getScheduleType())));
            backupConfiguration.appendChild(scheduleType);
            
         // sessionType 엘리먼트
            Element sessionType = doc.createElement("sessionType");
            sessionType.appendChild(doc.createTextNode("0"));
            backupConfiguration.appendChild(sessionType);
			
         // throttle 엘리먼트
            Element throttle = doc.createElement("throttle");
            throttle.appendChild(doc.createTextNode("0"));
            backupConfiguration.appendChild(throttle);
		}



		private void backupLocationInfoXml(BackupLocationInfoVO locationInfo, Element backupConfiguration) {
			System.out.println("#### backupLocationInfoXml ####");
	    	// backupLocationInfo 엘리먼트==================================================
            Element backupLocationInfo = doc.createElement("backupLocationInfo");
            backupConfiguration.appendChild(backupLocationInfo);          
		            // archiveTape 엘리먼트
		            Element archiveType = doc.createElement("archiveType");
		            archiveType.appendChild(doc.createTextNode(locationInfo.getIsArchiveType()));
		            backupLocationInfo.appendChild(archiveType);		            
		         // backupDestLocation 엘리먼트
		            Element backupDestLocation = doc.createElement("backupDestLocation");
		            backupDestLocation.appendChild(doc.createTextNode(locationInfo.getBackupDestLocation()));
		            backupLocationInfo.appendChild(backupDestLocation);	
		            if(locationInfo.getBackupDestUser()!=null){		            	
		            	// backupDestPasswd 엘리먼트
		            	Element backupDestPasswd = doc.createElement("backupDestPasswd");
		            	backupDestPasswd.appendChild(doc.createTextNode(locationInfo.getBackupDestPasswd()));
		            	backupLocationInfo.appendChild(backupDestPasswd);		            
		            	// backupDestUser 엘리먼트
		            	Element backupDestUser = doc.createElement("backupDestUser");
		            	backupDestUser.appendChild(doc.createTextNode(locationInfo.getBackupDestUser()));
		            	backupLocationInfo.appendChild(backupDestUser);	  
		            }
		            
		         // currentJobCount 엘리먼트
		            Element currentJobCount = doc.createElement("currentJobCount");
		            currentJobCount.appendChild(doc.createTextNode(Integer.toString(locationInfo.getCurrentJobCount())));
		            backupLocationInfo.appendChild(currentJobCount);
		         // dataStoreInfo 엘리먼트 ===================================================
		            Element dataStoreInfo = doc.createElement("dataStoreInfo");
		            backupLocationInfo.appendChild(dataStoreInfo);		            		
					         // compressLevel 엘리먼트  압축률,입력받은값
						            Element dataStore_compressLevel = doc.createElement("compressLevel");
						            dataStore_compressLevel.appendChild(doc.createTextNode("0"));
						            dataStoreInfo.appendChild(dataStore_compressLevel);		            
					         // enableDedup 엘리먼트
						            Element enableDedup = doc.createElement("enableDedup");
						            enableDedup.appendChild(doc.createTextNode(Integer.toString(locationInfo.getEnablededup())));
						            dataStoreInfo.appendChild(enableDedup);					            
					         // sharePath 엘리먼트
						            Element sharePath = doc.createElement("sharePath");
						            sharePath.appendChild(doc.createTextNode(locationInfo.getBackupDestLocation()));
						            dataStoreInfo.appendChild(sharePath);	
						     if(locationInfo.getBackupDestUser()!=null){						    	 
						    	 // sharePathPassword 엘리먼트
						    	 Element sharePathPassword = doc.createElement("sharePathPassword");
						    	 sharePathPassword.appendChild(doc.createTextNode(locationInfo.getBackupDestPasswd()));
						    	 dataStoreInfo.appendChild(sharePathPassword);				            
						    	 // sharePathUsername 엘리먼트
						    	 Element sharePathUsername = doc.createElement("sharePathUsername");
						    	 sharePathUsername.appendChild(doc.createTextNode(locationInfo.getBackupDestUser()));
						    	 dataStoreInfo.appendChild(sharePathUsername);	
						     }
		         // enableS3CifsShare 엘리먼트
		            Element enableS3CifsShare = doc.createElement("enableS3CifsShare");
		            enableS3CifsShare.appendChild(doc.createTextNode("false"));
		            backupLocationInfo.appendChild(enableS3CifsShare);		            
		         // freeSize 엘리먼트
		            Element freeSize = doc.createElement("freeSize");
		            freeSize.appendChild(doc.createTextNode(Long.toString(locationInfo.getFreeSize())));
		            backupLocationInfo.appendChild(freeSize);		            
		         // freeSizeAlert 엘리먼트
		            Element freeSizeAlert = doc.createElement("freeSizeAlert");
		            freeSizeAlert.appendChild(doc.createTextNode(Long.toString(locationInfo.getFreeSizeAlert())));
		            backupLocationInfo.appendChild(freeSizeAlert);		            
		         // freeSizeAlertUnit 엘리먼트
		            Element freeSizeAlertUnit = doc.createElement("freeSizeAlertUnit");
		            freeSizeAlertUnit.appendChild(doc.createTextNode(Integer.toString(locationInfo.getFreeSizeAlertUnit())));
		            backupLocationInfo.appendChild(freeSizeAlertUnit);	            
		         // jobLimit 엘리먼트
		            Element jobLimit = doc.createElement("jobLimit");
		            jobLimit.appendChild(doc.createTextNode(Integer.toString(locationInfo.getJobLimit())));
		            backupLocationInfo.appendChild(jobLimit);		            
		         // runScript 엘리먼트
		            Element runScript = doc.createElement("runScript");
		            if(locationInfo.getIsRunScript() == 0){
		            	runScript.appendChild(doc.createTextNode("false"));
		            }else{
		            	runScript.appendChild(doc.createTextNode("true"));
		            }
		            backupLocationInfo.appendChild(runScript);		            
		         // s3CifsSharePort 엘리먼트
		            Element s3CifsSharePort = doc.createElement("s3CifsSharePort");
		            s3CifsSharePort.appendChild(doc.createTextNode(Integer.toString(locationInfo.getS3CifsSharePort())));
		            backupLocationInfo.appendChild(s3CifsSharePort);		            
		         // s3CifsShareUser 엘리먼트
		            Element s3CifsShareUser = doc.createElement("s3CifsShareUser");
		            s3CifsShareUser.appendChild(doc.createTextNode(locationInfo.getS3CifsShareUser()));
		            backupLocationInfo.appendChild(s3CifsShareUser);		            
		         // serverInfo 엘리먼트
		            Element serverInfo = doc.createElement("serverInfo");
		            backupLocationInfo.appendChild(serverInfo);		            
					         // cidrNetwork 엘리먼트
					            Element cidrNetwork = doc.createElement("cidrNetwork");
					            serverInfo.appendChild(cidrNetwork);		            
					         // enableDesignateBackupNetWork 엘리먼트
					            Element enableDesignateBackupNetWork = doc.createElement("enableDesignateBackupNetWork");
					            enableDesignateBackupNetWork.appendChild(doc.createTextNode("0"));
					            serverInfo.appendChild(enableDesignateBackupNetWork);					            
					         // cidrNetwork 엘리먼트
					            Element serverInfo_id = doc.createElement("id");
					            serverInfo_id.appendChild(doc.createTextNode("0"));
					            serverInfo.appendChild(serverInfo_id);					            
					         // local 엘리먼트
					            Element local = doc.createElement("local");
					            local.appendChild(doc.createTextNode("false"));
					            serverInfo.appendChild(local);					            
					         // port 엘리먼트
					            Element port = doc.createElement("port");
					            port.appendChild(doc.createTextNode("0"));
					            serverInfo.appendChild(port);		            
				            // serverType 엘리먼트
					            Element serverType = doc.createElement("serverType");
					            serverType.appendChild(doc.createTextNode("0"));
					            serverInfo.appendChild(serverType);		            				            
		         // totalSize 엘리먼트
		            Element totalSize = doc.createElement("totalSize");
		            totalSize.appendChild(doc.createTextNode(Long.toString(locationInfo.getTotalSize())));
		            backupLocationInfo.appendChild(totalSize);		            
		         // type 엘리먼트
		            Element type = doc.createElement("type");
		            type.appendChild(doc.createTextNode(Integer.toString(locationInfo.getType())));
		            backupLocationInfo.appendChild(type);		            
		         // uuid 엘리먼트
		            Element uuid = doc.createElement("uuid");
		            uuid.appendChild(doc.createTextNode(locationInfo.getUuid()));
		            backupLocationInfo.appendChild(uuid);		            
		         // waitingJobCount 엘리먼트
		            Element waitingJobCount = doc.createElement("waitingJobCount");
		            waitingJobCount.appendChild(doc.createTextNode(Integer.toString(locationInfo.getWaitingJobCount())));
		            backupLocationInfo.appendChild(waitingJobCount);		                     
		}



		public void xmlFile (Document  doc, String jobName){
			System.out.println("xmlFile");
	    	  
	    	  try{
	    		  
	    	   TransformerFactory transformerFactory = TransformerFactory.newInstance();
//	    	   TransformerFactory transformerFactory = new org.apache.xalan.processor.TransformerFactoryImpl();
	    	  
	            Transformer transformer = transformerFactory.newTransformer();
	            // transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4"); //정렬 스페이스4칸
	            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	            transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //들여쓰기
	            transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes"); //doc.setXmlStandalone(true); 했을때 붙어서 출력되는부분 개행

	            DOMSource source = new DOMSource(doc);
	            StreamResult result = new StreamResult(new FileOutputStream(new File("C:\\test\\backupXml\\" + jobName + ".xml")));
	            
	            transformer.transform(source, result);
	            
	            System.out.println("end");
	            
	    	  }catch(Exception e){
	    		  e.printStackTrace();
	    	  }
	      }
	      
	      public static void main(String[] args) {
	    	 
	    	  BackupLocationInfoVO locationInfo = new BackupLocationInfoVO(); 
	    	  
	    	  locationInfo.setBackupDestLocation("//192.168.50.130");
	    	  locationInfo.setBackupDestPasswd("6LXkUDgmZ+e7/PKqfq20Rw==");
	    	  locationInfo.setBackupDestUser("root");
	    	  locationInfo.setCurrentJobCount(0);
	    	  locationInfo.setEnableS3CifsShare("false");
	    	  locationInfo.setFreeSizeAlert(0);
	    	  locationInfo.setFreeSizeAlertUnit(0);
	    	  locationInfo.setIsRunScript(0);
	    	  locationInfo.setS3CifsSharePort(445);
	    	  locationInfo.setS3CifsShareUser("root");
	    	  locationInfo.setType(2);
	    	  locationInfo.setUuid("705ddf11-0600-4a69-ab78-6d18ee6dc448");
	    	  locationInfo.setWaitingJobCount(0);
	    	  
	    	  
	    	  BackupScriptVO backupScript = new BackupScriptVO(); 
	    	  backupScript.setCompressLevel(1);
	    	  backupScript.setEncryptAlgoName("No Encryption");
	    	  backupScript.setEncryptAlgoType(0);
	    	  backupScript.setExclude(true);
	    	  backupScript.setId(0);
	    	  backupScript.setJobMethod(0);
	    	  backupScript.setJobName("backup_20210209");
	    	  backupScript.setJobType("1");
	    	  backupScript.setLogLevel("0");
	    	  backupScript.setPriority(0);
	    	  backupScript.setRepeat("true");
	    	  
	    	  backupScript.setTemplate(true);
	    	  backupScript.setBackupToRps(false);
	    	  backupScript.setDisable(false);
	    	  backupScript.setScheduleType(5);
	    	  backupScript.setSessionType(0);
	    	  backupScript.setThrottle(0);
	    	  
	    	  
	    	  RetentionVO retentionVO = new RetentionVO();
	    	  retentionVO.setBackupSetCount(2);
	    	  retentionVO.setDayOfMonth(1);
	    	  retentionVO.setDayOfWeek(6);
	    	  retentionVO.setUseWeekly("true");
	    	  
	    	  TargetMachineVO targetMachine = new TargetMachineVO();
	    	  targetMachine.setBackupLocationType(0);
	    	  targetMachine.setTemplateId("57e29e04-79a0-4dbc-bbbe-37ccb7133393");
	    	  targetMachine.setConnectionStatus(0);
	    	  targetMachine.setDescription("he description of that node");
	    	  targetMachine.setLastResult(0);
	    	  targetMachine.setMachineType(0);
	    	  targetMachine.setName("backup_test");
	    	  targetMachine.setOperatingSystem("CentOS Linux release 8.2.2004");
	    	  targetMachine.setPassword("6jpUshj1Yyyb57HRdjRDXA==");
	    	  targetMachine.setIsProtected("true");
	    	  targetMachine.setRecoveryPointCount(0);
	    	  targetMachine.setRecoverySetCount(0);
	    	  targetMachine.setUser("root");
	    	  targetMachine.setExclude("false");
	    	  targetMachine.setHypervisor("false");
	    	  targetMachine.setPriority(0);
	    	  
	    	  //배열생성
	    	  List<BackupScheduleVO> backupSchedule = new ArrayList<>();
//	    	  BackupScheduleVO schedule = new BackupScheduleVO();
//	    	  schedule.setYear(2021);
//	    	  schedule.setMonth(3);
//	    	  schedule.setDay(11);
//	    	  schedule.setRepeat(true);
//	    	  schedule.setInterval(15);
//	    	  schedule.setIntervalUnit(0);
//	    	  schedule.setStartHour(1);
//	    	  schedule.setStartMinute(30);
//	    	  schedule.setStartHourType(0);
//	    	  schedule.setEndHour(11);
//	    	  schedule.setEndMinute(50);
//	    	  schedule.setEndHourType(1);
//	    	  schedule.setDayType(1);
//	    	  backupSchedule.add(schedule);
//	    	  
//	    	  BackupScheduleVO schedule1 = new BackupScheduleVO();
//	    	  schedule1.setRepeat(true);
//	    	  schedule1.setInterval(3);
//	    	  schedule1.setIntervalUnit(1);
//	    	  schedule1.setStartHour(2);
//	    	  schedule1.setStartMinute(20);
//	    	  schedule1.setStartHourType(0);
//	    	  schedule1.setEndHour(10);
//	    	  schedule1.setEndMinute(40);
//	    	  schedule1.setEndHourType(1);
//	    	  schedule1.setDayType(2);
//	    	  backupSchedule.add(schedule1);
//	    	  
//	    	  BackupScheduleVO schedule2 = new BackupScheduleVO();
//	    	  schedule2.setRepeat(false);
//	    	  schedule2.setInterval(0);
//	    	  schedule2.setIntervalUnit(0);
//	    	  schedule2.setStartHour(2);
//	    	  schedule2.setStartMinute(20);
//	    	  schedule2.setStartHourType(0);
//	    	  schedule2.setEndHour(10);
//	    	  schedule2.setEndMinute(40);
//	    	  schedule2.setEndHourType(1);
//	    	  schedule2.setDayType(2);
//	    	  backupSchedule.add(schedule2);
	    	  
	    	  List<VolumeVO> volumes = new ArrayList<>();
	    	  VolumeVO volume1 = new VolumeVO();
	    	  VolumeVO volume2 = new VolumeVO();
	    	  
	    	  volume1.setFileSystem("/dev/mapper/centos-root");
	    	  volume1.setMountOn("/");
	    	  
	    	  volume2.setFileSystem("/dev/sda2");
	    	  volume2.setMountOn("/boot");
	    	  
	    	  volumes.add(volume1);
	    	  volumes.add(volume2);
	    	  
	    	  JobXMLMake xml = new JobXMLMake();
	    	  xml.xmlMake(locationInfo,backupScript,targetMachine,retentionVO, backupSchedule, volumes);
		}
}
