package com.experdb.management.backup.cmmn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;
import org.w3c.dom.Document;

import com.experdb.management.backup.node.service.TargetMachineVO;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;


public class CmmnUtil {

	public static String PATH_D2D_SERVER_HOME = "/opt/Arcserve/d2dserver"; 
	public static final String D2D_SERVER_HOME = "D2DSVR_HOME";
	private Session session = null;
	private Channel channel = null;
	private ChannelExec channelExec = null;
	private static DecimalFormat format = new DecimalFormat("#.00");
	
	
	static {
		String homePath = System.getenv("D2DSVR_HOME");
		 if (homePath != null && !homePath.isEmpty())
		 PATH_D2D_SERVER_HOME = homePath; 
	}
	
	/**
	 * * 서버와 연결 * *
	 * 
	 * @throws IOException
	 * @throws FileNotFoundException
	 */

	public Channel getChannel() throws FileNotFoundException, IOException {

		Properties props = new Properties();
		props.load(
				new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));

		String host = props.getProperty("backup.url");
		String userName = props.getProperty("backup.username");
		String password = props.getProperty("backup.password");
		int port = Integer.parseInt(props.getProperty("backup.port"));

		JSch jsch = new JSch();

		try {

			session = jsch.getSession(userName, host, port);
			session.setPassword(password);

			java.util.Properties config = new java.util.Properties();
			config.put("StrictHostKeyChecking", "no");

			session.setConfig(config);
			session.connect();

			channel = session.openChannel("exec");
			channelExec = (ChannelExec) channel;

		} catch (JSchException e) {
			e.printStackTrace();
		}
		return channel;
	}

	
	
	/**
	 * * 명령어를 실행 시킨다. * *
	 * 
	 * @param command
	 *            * 실행시킬 명령어
	 * @throws IOException
	 * @throws FileNotFoundException
	 */

	@SuppressWarnings("unchecked")
	public JSONObject execute(String command, String type) throws FileNotFoundException, IOException {

		JSONObject result = new JSONObject();
		String output = "";
		String validateOutput = "";
		String validateCifsOutput = "";
		
		try {
			getChannel();

			channel = session.openChannel("exec");
			channelExec = (ChannelExec) channel;

			// 실행할 명령어를 설정한다.
			channelExec.setCommand(command);
			OutputStream out = channelExec.getOutputStream();
			InputStream in = channelExec.getInputStream();
			InputStream err = channelExec.getErrStream();

			// 명령어를 실행한다.
			channelExec.connect(15000);

			byte[] buf = new byte[1024];
			int length;
				

			while ((length = in.read(buf)) != -1) {
				output += new String(buf, 0, length);
				validateOutput = new String(buf, 0, length);
			}
			
			
			if(type.equals("cifs")){
				System.out.println("CIFS Validation");
				result = ResultCode.cifsResultCode(output);
			}else if(type.equals("nfs")){
				System.out.println("NFS Validation");
				result = ResultCode.nfsResultCode(validateOutput, command);
			}else if(type.equals("node")){
				System.out.println("NODE Validation");
				result = ResultCode.nodeResultCode(output);
			}else if(type.equals("job")){
				System.out.println("JOB Validation");
				result = ResultCode.jobResultCode(output);
			}
			
		} catch (JSchException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
		/** * 서버와의 연결을 끊는다. */
		public void disconnectionSSH() {
			channelExec.disconnect();
			session.disconnect();
		}

	 
	 public static String bytes2String(double bytes) {
		      String bytesString = "";		      
		      try {
		        DecimalFormat number = new DecimalFormat("0.00");		        
		        if (bytes < 1024L) {
		          bytesString = bytes + " Bytes";
		        } else if (bytes < 1048576L) {
		          String kb = number.format(bytes / 1024.0D);
		          if (kb.startsWith("1024")) {
		            bytesString = "1 MB";
		          }
		         bytesString = kb + " KB";
		        } else if (bytes < 1073741824L) {
		          String mb = number.format(bytes / 1048576.0D);
		          if (mb.startsWith("1024")) {
		            bytesString = "1 GB";
		          }
		          bytesString = mb + " MB";
		        } else {
		          bytesString = number.format(bytes / 1.073741824E9D) + " GB";
		        }      
		      } catch (Exception e) {
		        return bytesString;
		      } 
		      return bytesString;
		    }
	 
	 
	 /**
		 * encrypt password
		 * @param  password
		 * @return 
		 */
		public static JSONObject encPassword(String password) {
			
			JSONObject result = new JSONObject();		
			CmmnUtil cmmUtil = new CmmnUtil();
			
			try {
				String strCmd = "echo -e '"+password+"'|/opt/Arcserve/d2dserver/bin/d2dutil --encrypt";
				result = cmmUtil.execute(strCmd,"password");
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}
	 
	 	
		 /**
			 * BackupLoaction Free
			 * @param  location
			 * @return 
			 */
			public static JSONObject backupLocationFreeSize(String location) {
				
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String freeSize = "";
				
				try {
					String strCmd = "df -B1 --output=avail '"+location+"' | tail -n 1";
					result = cmmUtil.execute(strCmd, "");			
					// freeSize = bytes2String(Double.parseDouble(result.get("RESULT_DATA").toString()));				
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
		 
		 	
			 /**
			 * BackupLoaction Total Size
			 * @param  password
			 * @return 
			 */
			public static JSONObject backupLocationTotalSize(String location) {
				
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String totalSize = "";
				
				try {
					String strCmd = "df -B1 --output=size '"+location+"' |tail -n 1";
					result = cmmUtil.execute(strCmd, "");									
					// totalSize = bytes2String(Double.parseDouble(result.get("RESULT_DATA").toString()));					
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
		 
			public static JSONObject backupLocationCheck(String location) {
				JSONObject result = new JSONObject();
				CmmnUtil cmmUtil = new CmmnUtil();
				
				try{
					String strCmd = "find " + location + " -maxdepth 0";
					result = cmmUtil.execute(strCmd, "");
				}catch(Exception e){
					e.printStackTrace();
				}
				return result;
			}
		 

			
			
			 /**
			 * RunNow
			 * @param  jobname, jobtype
			 * @return 
			 */
			public static JSONObject RunNow(String jobname, int jobtype) {
				
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String path = "/opt/Arcserve/d2dserver/bin";
				String cmd =null;
				
				try {
					cmd = "cd " + path + ";"+ "./d2djob --run='"+ jobname +"' --jobtype=" + jobtype;
					System.out.println(cmd);
					result = cmmUtil.execute(cmd,"job");			
					// freeSize = bytes2String(Double.parseDouble(result.get("RESULT_DATA").toString()));				
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
			
			
			 /**
			 * JobScript 디렉토리 및 파일생성
			 * @param  
			 * @return 
			 */
			public static void xmlFileCreate (Document  doc, TargetMachineVO targetMachine){

				JSONObject importResult = new JSONObject();
				
				 try{
					 String path = "/opt/Arcserve/d2dserver/bin/jobs";
					 
					 boolean dirStatus	= createDir(path);
					 
					 if(dirStatus){
	
			    	  TransformerFactory transformerFactory = TransformerFactory.newInstance();
			    	  
			            Transformer transformer = transformerFactory.newTransformer();
			            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4"); //정렬 스페이스4칸
			            transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			            transformer.setOutputProperty(OutputKeys.INDENT, "yes"); //들여쓰기
			            transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes"); //doc.setXmlStandalone(true); 했을때 붙어서 출력되는부분 개행
			 
			            DOMSource source = new DOMSource(doc);
			            StreamResult  streamResult = new StreamResult(new FileOutputStream(new File(path+"/"+targetMachine.getName().replace(".", "_").trim()+".xml")));
			            
			            transformer.transform(source, streamResult);
					 }
					 					 
					 importResult = JobScriptApply(path,targetMachine);
		 
			    	  }catch(Exception e){
			    		  e.printStackTrace();
			    	  }
			}
			
			
			
			private static JSONObject JobScriptApply(String jobPath, TargetMachineVO targetMachine) {
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String path = "/opt/Arcserve/d2dserver/bin";
				String cmd =null;
				
				try {
					cmd = "cd " + path + ";"+ "./d2djob --import="+jobPath+"/"+targetMachine.getName().replace(".", "_").trim()+".xml";
					System.out.println(cmd);
					result = cmmUtil.execute(cmd,"job");			
			
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
				
			}


			public static boolean createDir (String path){
				
				CmmnUtil cmmUtil = new CmmnUtil();
				String d2dhome = "/opt/Arcserve/d2dserver/bin";
				
				try{
					String cmd = "cd " + d2dhome + "; mkdir jobs ;"+ "chmod 777 -R " +path;
					System.out.println("Create Dir = "+cmd);
					cmmUtil.execute(cmd,"job");
					
					return true;
				}catch(Exception e){
					e.printStackTrace();
					return false;
				}
			}
			
		
			
			public static void main(String[] args) {
				//46068
				//5906844
				
				String nodeName =  "192.168.56.130";
				
				
				//JobScriptApply("",nodeName);
				
	
					
				// String freeSize = backupLocationFreeSize("/backup");
				// String totalSize = backupLocationTotalSize("/backup");
				// System.out.println(freeSize);
				// System.out.println(totalSize);
				
/*				 int i = (int) new Date().getTime();
				 System.out.println("Integer : " + i);
				 System.out.println("Long : "+ new Date().getTime());*/
				
				//System.out.println("root = 6LXkUDgmZ+e7/PKqfq20Rw==");
				//System.out.println("root0225!!  = 6jpUshj1Yyyb57HRdjRDXA== ");
				// encPassword("root0225!!");
			
			}
			


	
	
}
