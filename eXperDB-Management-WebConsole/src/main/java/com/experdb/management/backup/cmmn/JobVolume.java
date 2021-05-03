package com.experdb.management.backup.cmmn;

import java.io.*;
import java.util.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.json.simple.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.policy.service.VolumeVO;
import com.experdb.management.backup.service.*;

public class JobVolume{
	
		DocumentBuilderFactory docFactory;
		DocumentBuilder docBuilder;
		Document doc;
		
	      
	      public String volumeMake(TargetMachineVO targetMachine, List<VolumeVO> volumes){
	    	  System.out.println("==== volumeMake ====");
	    	  String result = null;

	            try {
	            	 docFactory = DocumentBuilderFactory.newInstance();
					 docBuilder = docFactory.newDocumentBuilder();
					
					// book 엘리먼트
		            doc = docBuilder.newDocument();
		            doc.setXmlStandalone(true); //standalone="no" 를 없애준다.
		            
		            Element target = doc.createElement("backupTarget");
		            doc.appendChild(target);
		            
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
		            jobName.appendChild(doc.createTextNode(targetMachine.getJobName()));
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
		            
		            
		            
					try {
						DOMSource domSource = new DOMSource(doc);
						
						TransformerFactory tf = TransformerFactory.newInstance();
						Transformer transformer = tf.newTransformer();
						
						transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4"); //정렬 스페이스4칸
			            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			            transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //들여쓰기
			            transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes"); //doc.setXmlStandalone(true); 했을때 붙어서 출력되는부분 개행
						
						StringWriter sw = new StringWriter();
						transformer.transform(new DOMSource(doc), new StreamResult(sw));
						System.out.println(sw.toString());
						result = sw.toString();
						
					} catch (TransformerConfigurationException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (TransformerException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
		            
					
		            
				} catch (ParserConfigurationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            
	            
	            return result;
	      }
	      
	 
	      
	      public static void main(String[] args) {
	    	  TargetMachineVO targetMachine = new TargetMachineVO();
	    	  targetMachine.setBackupLocationType(0);
	    	  targetMachine.setTemplateId("57e29e04-79a0-4dbc-bbbe-37ccb7133393");
	    	  targetMachine.setConnectionStatus(0);
	    	  targetMachine.setJobName("backup_test");
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
	    	  
	    	  List<VolumeVO> volumes = new ArrayList<>();
	    	  VolumeVO volume1 = new VolumeVO();
	    	  VolumeVO volume2 = new VolumeVO();
	    	  
	    	  volume1.setFileSystem("/dev/mapper/centos-root");
	    	  volume1.setMountOn("/");
	    	  
	    	  volume2.setFileSystem("/dev/sda2");
	    	  volume2.setMountOn("/boot");
	    	  
	    	  volumes.add(volume1);
	    	  volumes.add(volume2);
	    	  
	    	  JobVolume xml = new JobVolume();
	    	  xml.volumeMake(targetMachine, volumes);
		}
}
