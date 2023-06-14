package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.socket.client.ClientProtocolID;
import com.k4m.dx.tcontrol.util.CommonUtil;
import com.k4m.dx.tcontrol.util.FileUtil;

public class DxT049 extends SocketCtl{
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT049(Socket socket, BufferedInputStream is, BufferedOutputStream os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT049.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		String filePath = "";
		
		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		
		try {
			String backrestPathCmd = "echo $PGBBAK";
			String backrestPath =  util.getPidExec(backrestPathCmd);
			
			String pghomePathCmd = "echo $PGHOME";
			String pghomePath =  util.getPidExec(pghomePathCmd);
			
			String hostUserCmd = "echo $HOSTUSER";
			String hostUser =  util.getPidExec(hostUserCmd);

			String backrestConfigPath = pghomePath + "/etc/pgbackrest/pgbackrest.conf";
			
			BufferedReader br2 = new BufferedReader(new FileReader(backrestConfigPath));
			StringBuilder content = new StringBuilder();
			
			String backerestConfigContent;
			while((backerestConfigContent = br2.readLine()) != null) {
				if(backerestConfigContent.contains("log-path")) {
					String logPath[] = backerestConfigContent.split("=");
					backerestConfigContent = backerestConfigContent.replaceAll("log-path="+logPath[1], "log-path=" + String.valueOf(jObj.get(ClientProtocolID.LOG_PATH)));
				}
				content.append(backerestConfigContent).append(System.lineSeparator());
			}
			
			br2.close();
			
			BufferedWriter bw2 = new BufferedWriter(new FileWriter(new File (backrestConfigPath)));
			
			bw2.write(content.toString());
			bw2.close();
			
			String configPath = pghomePath + "/etc/pgbackrest/default.conf";
			filePath = pghomePath + "/etc/pgbackrest/config/" + String.valueOf(jObj.get(ProtocolID.BCK_FILENM));
			
			BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
			BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
			
			String prcs_cnt = String.valueOf(jObj.get(ClientProtocolID.PRCS_CNT));	//병렬도
			String cps_type = String.valueOf(jObj.get(ClientProtocolID.CPS_TYPE));	//압축타입
			
			ArrayList<String> customKeyList = new ArrayList<String>();
			ArrayList<String> customValueList = new ArrayList<String>();

			
			if(jObj.get(ClientProtocolID.CUSTOM_MAP) == null || jObj.get(ClientProtocolID.CUSTOM_MAP).equals("")) {
				
			}else {
				try {
					JSONParser parser = new JSONParser();
					JSONObject jsonObject = (JSONObject) parser.parse(String.valueOf(jObj.get(ClientProtocolID.CUSTOM_MAP)));
					Iterator<String> customKeys = jsonObject.keySet().iterator();
					
					while(customKeys.hasNext()){
		                String key = customKeys.next().toString();
		                customKeyList.add(key);
		                customValueList.add(String.valueOf(jsonObject.get(key)));
		            }
					
				} catch (ParseException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			
			String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("#repo1-retention-full=", "repo1-retention-full=" + String.valueOf(jObj.get(ClientProtocolID.BCK_MTN_ECNT)));
				fileContent = fileContent.replaceAll("#log-path=", "log-path=" + String.valueOf(jObj.get(ClientProtocolID.LOG_PATH)));
				fileContent = fileContent.replaceAll("#log-level-console=detail", "log-level-console=detail");
				fileContent = fileContent.replaceAll("#log-level-file=detail", "log-level-file=detail");
				
				if(String.valueOf(jObj.get(ClientProtocolID.MASTER_GBN)).equals("S")) {
					fileContent = fileContent.replaceAll("#pg1-path=", "pg1-path=" + String.valueOf(jObj.get(ClientProtocolID.MASTER_PGDATA)));
					fileContent = fileContent.replaceAll("#pg1-host-user=", "pg1-host-user=" + hostUser);
					fileContent = fileContent.replaceAll("#pg1-host=", "pg1-host=" + String.valueOf(jObj.get(ClientProtocolID.MASTER_IP)));
					fileContent = fileContent.replaceAll("#pg1-port=", "pg1-port=" + String.valueOf(jObj.get(ClientProtocolID.MASTER_DBMS_PORT)));
					fileContent = fileContent.replaceAll("#pg1-user=", "pg1-user=" + String.valueOf(jObj.get(ClientProtocolID.MASTER_DBMS_USER)));
				}else {
					fileContent = fileContent.replaceAll("#pg1-path=", "pg1-path=" + String.valueOf(jObj.get(ClientProtocolID.PGDATA)));
					fileContent = fileContent.replaceAll("#pg1-port=", "pg1-port=" + String.valueOf(jObj.get(ClientProtocolID.DBMS_PORT)));
					fileContent = fileContent.replaceAll("#pg1-user=", "pg1-user=" + String.valueOf(jObj.get(ClientProtocolID.SPR_USR_ID)));
				}
				
				fileContent = fileContent.replaceAll("#repo1-gbn=", "#repo1-gbn=" + String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)));
				fileContent = fileContent.replaceAll("#process-max=", "process-max=" + prcs_cnt);
				
				if(String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)).toLowerCase().equals("cloud")) {
					ArrayList<String> cloudKeyList = new ArrayList<String>();
					ArrayList<String> cloudValueList = new ArrayList<String>();

					if(jObj.get(ClientProtocolID.CLOUD_MAP) == null || jObj.get(ClientProtocolID.CLOUD_MAP).equals("")) {
						
					}else {
						try {
							JSONParser parser = new JSONParser();
							JSONObject jsonObject = (JSONObject) parser.parse(String.valueOf(jObj.get(ClientProtocolID.CLOUD_MAP)));
							Iterator<String> cloudKeys = jsonObject.keySet().iterator();
							
							while(cloudKeys.hasNext()){
				                String key = cloudKeys.next().toString();
				                cloudKeyList.add(key);
				                cloudValueList.add(String.valueOf(jsonObject.get(key)));
				            }
							
						} catch (ParseException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
					}
					
					if(cloudKeyList.size() != 0) {
						for(int i=0; i < cloudKeyList.size(); i++) {
							if(cloudKeyList.get(i).equals("s3_bucket")) {
								fileContent = fileContent.replaceAll("#repo1-s3-bucket=", "repo1-s3-bucket=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("s3_region")) {
								fileContent = fileContent.replaceAll("#repo1-s3-region=", "repo1-s3-region=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("s3_key")) {
								fileContent = fileContent.replaceAll("#repo1-s3-key=", "repo1-s3-key=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("s3_endpoint")) {
								fileContent = fileContent.replaceAll("#repo1-s3-endpoint=", "repo1-s3-endpoint=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("s3_path")) {
								fileContent = fileContent.replaceAll("#repo1-path=", "repo1-path=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("s3_key-secret")) {
								fileContent = fileContent.replaceAll("#repo1-s3-key-secret=", "repo1-s3-key-secret=" + cloudValueList.get(i));
							}else if(cloudKeyList.get(i).equals("cloud_type")) {
								fileContent = fileContent.replaceAll("#repo1-type=", "repo1-type=" + cloudValueList.get(i).toLowerCase());
							}
						}
					}
				}else {
					fileContent = fileContent.replaceAll("#repo1-path=", "repo1-path=" + backrestPath);
				}
				
				if(String.valueOf(jObj.get(ProtocolID.CPS_YN)).equals("Y")) {
					if(cps_type.toString().equals("gzip")) {
						fileContent = fileContent.replaceAll("#compress-type=", "compress-type=gz");
					}else {
						fileContent = fileContent.replaceAll("#compress-type=", "compress-type=" + cps_type);
					}
				}else {
					fileContent = fileContent.replaceAll("#compress=", "compress=" + String.valueOf(jObj.get(ClientProtocolID.CPS_YN)).toLowerCase());
				}
				
				bw.write(fileContent + "\r\n");
				bw.flush();
			}
			
			if(customKeyList.size() != 0) {
				for(int i=0; i < customKeyList.size(); i++) {
					fileContent = customKeyList.get(i) + "=" + customValueList.get(i);
					
					bw.write(fileContent + "\r\n");
					bw.flush();
				}
				
			}
			
			bw.close();
			br.close();
			
			boolean blnIsFile = FileUtil.isFile(filePath);
			
			if(blnIsFile) {
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
			}else {
				errLogger.info("DxT049 {} : file no create");
			}
		}catch (Exception e) {
			errLogger.error("DxT049 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT049);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT049);
			outputObj.put(ProtocolID.ERR_MSG, "DxT049 Error [" + e.toString() + "]");
			HashMap hp = new HashMap();
			outputObj.put(ProtocolID.RESULT_DATA, hp);
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
		} finally {
			outputObj = null;
			sendBuff = null;
		}
	}
	
	
}
