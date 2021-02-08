package com.experdb.management.backup.cmmn;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.springframework.util.ResourceUtils;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;


public class CmmnUtil {

	private Session session = null;
	private Channel channel = null;
	private ChannelExec channelExec = null;
	private static DecimalFormat format = new DecimalFormat("#.00");
	
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
	public JSONObject execute(String command) throws FileNotFoundException, IOException {

		JSONObject result = new JSONObject();
		String output = "";

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
				// System.out.println("=== command result : " + new
				// String(buf,0,length));
			}

			// Invalid 형태이면
			if (output.trim().matches(".*Invalid.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", output.trim());
				System.out.println("※ Invalid command : " + output.trim());
				// invalid 형태이면
			} else if (output.trim().matches(".*invalid.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", output.trim());
				System.out.println("※ invalid command : " + output.trim());
				// Failed 형태이면
			} else if (output.trim().matches(".*Failed.*")) {
				result.put("RESULT_CODE", 1);
				result.put("RESULT_DATA", output.trim());
				System.out.println("※ Failed command : " + output.trim());
			} else {
				result.put("RESULT_CODE", 0);
				result.put("RESULT_DATA", output.trim());
				System.out.println("※ Result command : " + output.trim());
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
				result = cmmUtil.execute(strCmd);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}
	 
	 	
		 /**
			 * BackupLoaction Free
			 * @param  password
			 * @return 
			 */
			public static String backupLocationFreeSize(String location) {
				
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String freeSize = "";
				
				try {
					String strCmd = "df -B1 --output=avail '"+location+"' | tail -n 1";
					result = cmmUtil.execute(strCmd);			
					freeSize = bytes2String(Double.parseDouble(result.get("RESULT_DATA").toString()));				
				} catch (Exception e) {
					e.printStackTrace();
				}
				return freeSize;
			}
		 
		 	
			 /**
			 * BackupLoaction Total Size
			 * @param  password
			 * @return 
			 */
			public static String backupLocationTotalSize(String location) {
				
				JSONObject result = new JSONObject();		
				CmmnUtil cmmUtil = new CmmnUtil();
				
				String totalSize = "";
				
				try {
					String strCmd = "df -B1 --output=size '"+location+"' |tail -n 1";
					result = cmmUtil.execute(strCmd);									
					totalSize = bytes2String(Double.parseDouble(result.get("RESULT_DATA").toString()));					
				} catch (Exception e) {
					e.printStackTrace();
				}
				return totalSize;
			}
		 

			public static void main(String[] args) {
				
				//String v = bytes2String(29673590784);
				//System.out.println(v);
					
				String freeSize = backupLocationFreeSize("/backup");
				String totalSize = backupLocationTotalSize("/backup");
				System.out.println(freeSize);
				System.out.println(totalSize);
				
				
				//System.out.println("root = 6LXkUDgmZ+e7/PKqfq20Rw==");
				//System.out.println("root0225!!  = 6jpUshj1Yyyb57HRdjRDXA== ");
				encPassword("root0225!!");
			
			}
			


	
	
}
