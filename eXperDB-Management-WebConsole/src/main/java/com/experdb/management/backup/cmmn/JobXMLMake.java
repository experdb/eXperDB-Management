package com.experdb.management.backup.cmmn;

import java.io.File;
import java.io.FileOutputStream;
import java.util.UUID;

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
import com.experdb.management.backup.service.BackupLocationInfoVO;
import com.experdb.management.backup.service.BackupScriptVO;
import com.experdb.management.backup.service.RetentionVO;

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
		
	      
	      public void xmlMake(BackupLocationInfoVO locationInfo, BackupScriptVO backupScript, TargetMachineVO targetMachine, RetentionVO retentionVO){

 	  
	    	  System.out.println("xmlMake");

	            try {
	            	 docFactory = DocumentBuilderFactory.newInstance();
					 docBuilder = docFactory.newDocumentBuilder();
					
					// book 엘리먼트
		            doc = docBuilder.newDocument();
		            doc.setXmlStandalone(true); //standalone="no" 를 없애준다.
		            
		            //backupConfiguration========================================================
		            Element backupConfiguration = doc.createElement("backupConfiguration");
		            doc.appendChild(backupConfiguration);
		            backupConfiguration.setAttribute("xmlns:ns2", "http://backup.data.webservice.arcflash.ca.com/xsd");
		            backupConfiguration.setAttribute("xmlns:ns3", "http://catalog.data.webservice.arcflash.ca.com/xsd");

		            // backupLocationInfo
		            backupLocationInfoXml(locationInfo, backupConfiguration);
		            		            
		            // jonbInfo
		            jobInfoXml(backupScript, backupConfiguration, targetMachine);
		            
		            //fullInfoXml
		            fullInfoXml(retentionVO, backupConfiguration);
		            
		            //targetInfoXml
		            targetInfoXml(targetMachine, backupConfiguration, backupScript);
		            
		            //scheduleInfoXml
		            scheduleXml(backupConfiguration);
			            
	
			            
			            xmlFile(doc);
					
				} catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	      }
	      
	 
	      
	    private void scheduleXml(Element backupConfiguration) {
	    	// target 엘리먼트==================================================
            Element weeklySchedule = doc.createElement("weeklySchedule");
            backupConfiguration.appendChild(weeklySchedule);  
            
           // for(){
            	  // backupLocationType 엘리먼트
	            Element scheduleList = doc.createElement("scheduleList");
	            	

            	
            	
           // }
			
		}



		private void targetInfoXml(TargetMachineVO targetMachine, Element backupConfiguration, BackupScriptVO backupScript) {
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
            repeat.appendChild(doc.createTextNode("true"));
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
            templateID.appendChild(doc.createTextNode(UUID.randomUUID().toString()));
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
            disable.appendChild(doc.createTextNode("false"));
            backupConfiguration.appendChild(disable);
            
         // scheduleType 엘리먼트
            Element scheduleType = doc.createElement("scheduleType");
            scheduleType.appendChild(doc.createTextNode("5"));
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
		         // backupDestPasswd 엘리먼트
		            Element backupDestPasswd = doc.createElement("backupDestPasswd");
		            backupDestPasswd.appendChild(doc.createTextNode(locationInfo.getBackupDestPasswd()));
		            backupLocationInfo.appendChild(backupDestPasswd);		            
		         // backupDestUser 엘리먼트
		            Element backupDestUser = doc.createElement("backupDestUser");
		            backupDestUser.appendChild(doc.createTextNode(locationInfo.getBackupDestUser()));
		            backupLocationInfo.appendChild(backupDestUser);	            
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
						            enableDedup.appendChild(doc.createTextNode("0"));
						            dataStoreInfo.appendChild(enableDedup);					            
					         // sharePath 엘리먼트
						            Element sharePath = doc.createElement("sharePath");
						            sharePath.appendChild(doc.createTextNode(locationInfo.getBackupDestLocation()));
						            dataStoreInfo.appendChild(sharePath);					            
					         // sharePathPassword 엘리먼트
						            Element sharePathPassword = doc.createElement("sharePathPassword");
						            sharePathPassword.appendChild(doc.createTextNode(locationInfo.getBackupDestPasswd()));
						            dataStoreInfo.appendChild(sharePathPassword);				            
					         // sharePathUsername 엘리먼트
						            Element sharePathUsername = doc.createElement("sharePathUsername");
						            sharePathUsername.appendChild(doc.createTextNode(locationInfo.getBackupDestUser()));
						            dataStoreInfo.appendChild(sharePathUsername);		            
		         // enableS3CifsShare 엘리먼트
		            Element enableS3CifsShare = doc.createElement("enableS3CifsShare");
		            enableS3CifsShare.appendChild(doc.createTextNode("false"));
		            backupLocationInfo.appendChild(enableS3CifsShare);		            
		         // freeSize 엘리먼트
		            Element freeSize = doc.createElement("freeSize");
		            freeSize.appendChild(doc.createTextNode("29672251392"));
		            backupLocationInfo.appendChild(freeSize);		            
		         // freeSizeAlert 엘리먼트
		            Element freeSizeAlert = doc.createElement("freeSizeAlert");
		            freeSizeAlert.appendChild(doc.createTextNode(Integer.toString((int) locationInfo.getFreeSizeAlert())));
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
		            totalSize.appendChild(doc.createTextNode("37558423552"));
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



		public void xmlFile (Document  doc){
	    	  
	    	  try{
	    	  TransformerFactory transformerFactory = TransformerFactory.newInstance();
	    	  
	            Transformer transformer = transformerFactory.newTransformer();
	            //transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4"); //정렬 스페이스4칸
	            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	            transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //들여쓰기
	            transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes"); //doc.setXmlStandalone(true); 했을때 붙어서 출력되는부분 개행
	 
	            DOMSource source = new DOMSource(doc);
	            StreamResult result = new StreamResult(new FileOutputStream(new File("C://test/backup.xml")));
	 
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
	    	  backupScript.setJobName("backup_schedule_20210209");
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
	    	  targetMachine.setConnectionStatus(0);
	    	  targetMachine.setDescription("he description of that node");
	    	  targetMachine.setLastResult(0);
	    	  targetMachine.setMachineType(0);
	    	  targetMachine.setName("192.168.50.131");
	    	  targetMachine.setOperatingSystem("CentOS Linux release 8.2.2004");
	    	  targetMachine.setPassword("6jpUshj1Yyyb57HRdjRDXA==");
	    	  targetMachine.setIsProtected("true");
	    	  targetMachine.setRecoveryPointCount(0);
	    	  targetMachine.setRecoverySetCount(0);
	    	  targetMachine.setUser("root");
	    	  targetMachine.setExclude("true");
	    	  targetMachine.setHypervisor("false");
	    	  targetMachine.setPriority(0);
	    	  
	    	  //배열생성
	    	  
	    	  
	    	  
	    	  JobXMLMake xml = new JobXMLMake();
	    	  xml.xmlMake(locationInfo,backupScript,targetMachine,retentionVO);
		}
}
