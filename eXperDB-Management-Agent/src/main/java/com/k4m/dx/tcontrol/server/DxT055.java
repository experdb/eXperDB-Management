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

public class DxT055 extends SocketCtl{
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT055(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}
	
	@SuppressWarnings("unchecked")
	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		socketLogger.info("DxT055.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		String filePath = "";
		
		CommonUtil util = new CommonUtil();
		JSONObject outputObj = new JSONObject();
		
		try {		
			String pghomePathCmd = "echo $PGHOME";
			String pghomePath =  util.getPidExec(pghomePathCmd);
			
			String backrestLogPathCmd = "echo $PGBLOG";
			String backrestLogPath =  util.getPidExec(backrestLogPathCmd);
			
			String hostUserCmd = "echo $HOSTUSER";
			String hostUser =  util.getPidExec(hostUserCmd);
						
			String configPath = pghomePath + "/etc/pgbackrest/default.conf";
			filePath = pghomePath + "/etc/pgbackrest/config/" + String.valueOf(jObj.get(ProtocolID.WRK_NM) + ".conf");
			
			BufferedReader br = new BufferedReader(new FileReader(new File(configPath)));
			BufferedWriter bw = new BufferedWriter(new FileWriter(new File(filePath)));
			
			socketLogger.info("DxT055.execute Restore Type: " + String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)));
			
			String fileContent;
			while((fileContent = br.readLine()) != null) {
				fileContent = fileContent.replaceAll("#log-path=", "log-path=" + backrestLogPath);
				fileContent = fileContent.replaceAll("#log-level-console=detail", "log-level-console=detail");
				fileContent = fileContent.replaceAll("#log-level-file=detail", "log-level-file=detail");
				fileContent = fileContent.replaceAll("#pg1-path=", "pg1-path=" + String.valueOf(jObj.get(ClientProtocolID.PGDATA)));
				fileContent = fileContent.replaceAll("#pg1-port=", "pg1-port=" + String.valueOf(jObj.get(ClientProtocolID.DBMS_PORT)));
				fileContent = fileContent.replaceAll("#pg1-user=", "pg1-user=" + String.valueOf(jObj.get(ClientProtocolID.SPR_USR_ID)));
				
				
				
				if(String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)).equals("cloud")) {
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
							errLogger.info("DxT055 {} : JSON Parser Error (Cloud Opt)");
						}
					}
					
					if(cloudKeyList.size() != 0) {
						for(int i=0; i < cloudKeyList.size(); i++) {
							socketLogger.info("DxT055.execute : cloudKeyList " + cloudKeyList.get(i) );
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
								fileContent = fileContent.replaceAll("#repo1-type=", "repo1-type=s3");
							}
						}
					}
				}else if(String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)).toLowerCase().equals("remote")){
					fileContent = fileContent.replaceAll("#repo1-host=", "repo1-host=" + String.valueOf(jObj.get(ClientProtocolID.REMOTE_IP)));
					fileContent = fileContent.replaceAll("#repo1-host-port=", "repo1-host-port=" + String.valueOf(jObj.get(ClientProtocolID.REMOTE_PORT)));
					fileContent = fileContent.replaceAll("#repo1-host-user=", "repo1-host-user=" + String.valueOf(jObj.get(ClientProtocolID.REMOTE_USR)));
				}else if(String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)).equals("localRemote")){
					fileContent = fileContent.replaceAll("#repo1-host-user=", "repo1-host-user=" + String.valueOf(jObj.get(ClientProtocolID.HOSTUSER)));
					fileContent = fileContent.replaceAll("#repo1-host-port=", "repo1-host-port=" + String.valueOf(jObj.get(ClientProtocolID.SSH_PORT)));
					fileContent = fileContent.replaceAll("#repo1-host=", "repo1-host=" + String.valueOf(jObj.get(ClientProtocolID.DBMS_IP)));
				}else if(String.valueOf(jObj.get(ClientProtocolID.STORAGE_OPT)).equals("HAlocal")){
					fileContent = fileContent.replaceAll("#repo1-host-user=", "repo1-host-user=" + hostUser);
					fileContent = fileContent.replaceAll("#repo1-host=", "repo1-host=" + String.valueOf(jObj.get(ClientProtocolID.DBMS_IP)));
				}
				
				fileContent = fileContent.replaceAll("#repo1-path=", "repo1-path=" + String.valueOf(jObj.get(ClientProtocolID.BCK_FILE_PTH)));
				
				bw.write(fileContent + "\r\n");
				bw.flush();
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
				errLogger.info("DxT055 {} : file no create");
			}
		}catch (Exception e) {
			errLogger.info("DxT055 {} : " + e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT055);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT055);
			outputObj.put(ProtocolID.ERR_MSG, "DxT055 Error [" + e.toString() + "]");
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
