package com.experdb.proxy.db.repository.service;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.experdb.proxy.db.repository.dao.ProxyDAO;
import com.experdb.proxy.db.repository.vo.ProxyActStateChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyConfChangeHistoryVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.TranCodeType;
import com.experdb.proxy.util.CommonUtil;
import com.experdb.proxy.util.FileUtil;
import com.experdb.proxy.util.RunCommandExec;

/**
* @author 
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  
*      </pre>
*/
@Service("ProxyLinkService")
public class ProxyLinkServiceImpl implements ProxyLinkService{

	@Resource(name = "ProxyDAO")
	private ProxyDAO proxyDAO;

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public final static String TEMPLATE_DIR = "./template/";

	/**
	 * packet length 구하기
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	public String getPacketLength(int total, String data) throws Exception{
		CommonUtil util = new CommonUtil();
		
		int dataLen = util.getStringToHex(data).length()/2;
		String result = Integer.toHexString(total+dataLen); 
		return util.lpad(8, "0", result);
	}
	
	//파일을 읽어 String으로 반환
	public String readTemplateFile(String filename)
	{   	
		String content = null;
 	   	File file = new File(getClass().getClassLoader().getResource(TEMPLATE_DIR+filename).getFile()); 
 	   	try {
 	   		InputStreamReader reader= new InputStreamReader(new FileInputStream(file),"UTF8"); 
 	   		char[] chars = new char[(int) file.length()];
 	   		reader.read(chars);
 	   		content = new String(chars);
 	   		reader.close();
 	   	} catch (IOException e) {
 		   e.printStackTrace();
 	   	}
 	   	return content;
	}
	
	public String runExeCmd(String cmd) throws Exception {
		//socketLogger.info("runExeCmd : "+cmd);
		String result = "";
		RunCommandExec commandExec = new RunCommandExec();
		commandExec.runExecRtn3(cmd);
		try {
			commandExec.join();
		} catch (InterruptedException ie) {
			socketLogger.error("runExeCmd error {}",ie.toString());
			ie.printStackTrace();
		}
		if(commandExec.call().equals("success")){
			result += "success\n";
			result += commandExec.getMessage();
		}
		return result;
	}

	/**
	 * createNewConfFile JSONObject로 받은 설정 정보를 conf 파일로 생성
	 * 
	 * @return String
	 * @throws UnsupportedEncodingException  
	 */
	@Override
	public JSONObject createNewConfFile(JSONObject jobj) throws Exception {
		socketLogger.info("PsP004.createNewConfFile : "+jobj.toString());
		JSONObject result = new JSONObject();
		CommonUtil util = new CommonUtil();
		
		int prySvrId = 0;
		String lst_mdfr_id = "";
		String newHaPath ="";
		String newKePath ="";
		String dateTime = "";
		String errcd = "0";
		ProxyConfChangeHistoryVO newConfChgHistVo = new ProxyConfChangeHistoryVO();
		String cmdResult = "";
		try{
			//haproxy.cfg 생성
			String proxyCfg = ""; 
			
			String globalConf = readTemplateFile("global.cfg");
			JSONObject global = jobj.getJSONObject("global_info");
			
			prySvrId = global.getInt("pry_svr_id");
			lst_mdfr_id = jobj.getString("lst_mdfr_id");
			
			String logLocal ="";
			cmdResult =runExeCmd("cat /etc/rsyslog.d/haproxy.conf |grep /var/log/haproxy/haproxy.log");
			
			if(!cmdResult.equals("")){
				String[] strTemp = cmdResult.split("\n");
				for(int i=1; i<strTemp.length; i++){
					if(strTemp[i].length() > 1 && !"#".equals(strTemp[i].substring(0, 1))){
						logLocal = strTemp[i].substring(0, strTemp[i].indexOf("."));	
					}
				}
			}
			
			globalConf = globalConf.replace("{log_local}", logLocal);
			globalConf = globalConf.replace("{max_con_cnt}", global.getString("max_con_cnt"));
			globalConf = globalConf.replace("{cl_con_max_tm}", global.getString("cl_con_max_tm"));
			globalConf = globalConf.replace("{con_del_tm}", global.getString("con_del_tm"));
			globalConf = globalConf.replace("{svr_con_max_tm}", global.getString("svr_con_max_tm"));
			globalConf = globalConf.replace("{chk_tm}", global.getString("chk_tm"));
			
			proxyCfg += globalConf;
			
			String readOnlyConf = readTemplateFile("readOnly.cfg");
			String readWriteConf = readTemplateFile("readWrite.cfg"); 
			String readWriteCdNm = jobj.getString("TC004201");
			String readOnlyCdNm = jobj.getString("TC004202");
			
			JSONArray listener = jobj.getJSONArray("listener_list");
			int listenerSize = listener.length();
			for(int i=0 ; i<listenerSize ; i++){
				JSONObject proxyListener = listener.getJSONObject(i);
				String lsn_nm = proxyListener.getString("lsn_nm");
				String bind = proxyListener.getString("con_bind_port");
				String db_nm = proxyListener.getString("db_nm");
				
				if(lsn_nm.equals(readWriteCdNm)){
					readWriteConf = readWriteConf.replace("{lsn_nm}", lsn_nm);
					readWriteConf = readWriteConf.replace("{con_bind_port}", bind);
					readWriteConf = readWriteConf.replace("{db_nm_hex}", util.getStringToHex(db_nm)+"00");
					readWriteConf = readWriteConf.replace("{db_nm}", db_nm);
					readWriteConf = readWriteConf.replace("{packet_len}", getPacketLength(31,db_nm)); //8자, 패딩 0으로 넣기 
					proxyCfg +="\n"+readWriteConf;
				}else if(lsn_nm.equals(readOnlyCdNm)){
					readOnlyConf = readOnlyConf.replace("{lsn_nm}", lsn_nm);
					readOnlyConf = readOnlyConf.replace("{con_bind_port}", bind);
					readOnlyConf = readOnlyConf.replace("{db_nm_hex}", util.getStringToHex(db_nm)+"00");
					readOnlyConf = readOnlyConf.replace("{db_nm}", db_nm);
					readOnlyConf = readOnlyConf.replace("{packet_len}",  getPacketLength(31,db_nm));
					proxyCfg +="\n"+readOnlyConf;
				}
				
				JSONArray listenerSvrList = proxyListener.getJSONArray("server_list");
				int listenerSvrListSize = listenerSvrList.length();
				String serverList = "";
				for(int j =0; j<listenerSvrListSize; j++){
					JSONObject listenSvr = listenerSvrList.getJSONObject(j);
					serverList += "    server db"+j+" "+listenSvr.getString("db_con_addr")+" check port "+listenSvr.getString("chk_portno");
					if("Y".equals(listenSvr.getString("backup_yn"))) serverList +=" backup\n";
					else serverList +="\n";
				}
				
				proxyCfg +=serverList;
				
			}
			
			//keepalived.conf 생성
			String keepalivedCfg = "#add\n";
			keepalivedCfg += "global_defs {\n";
			keepalivedCfg += "        router_id LVS_DEVEL\n";
			keepalivedCfg += "}\n";
			keepalivedCfg += "\n";
			keepalivedCfg += "\n";
			keepalivedCfg += "vrrp_track_process chk_haproxy {\n";
			keepalivedCfg += "        process \"haproxy\"\n";
			keepalivedCfg += "        weight 2\n";
			keepalivedCfg += "}\n";
			
			
			JSONArray vipConfArry = jobj.getJSONArray("vipconfig_list");
			int vipConfSize = vipConfArry.length();
			for(int i=0 ; i<vipConfSize ; i++){
				JSONObject vipConfObj = vipConfArry.getJSONObject(i);
				String vipConf = readTemplateFile("vip_instance.conf");
				vipConf = vipConf.replace("{v_index}", String.valueOf(i+1));  
				vipConf = vipConf.replace("{state_nm}", vipConfObj.getString("state_nm"));
				vipConf = vipConf.replace("{if_nm}", global.getString("if_nm"));
				vipConf = vipConf.replace("{v_rot_id}", vipConfObj.getString("v_rot_id"));
				vipConf = vipConf.replace("{priority}", vipConfObj.getString("priority")); 
				vipConf = vipConf.replace("{chk_tm}", vipConfObj.getString("chk_tm"));
				vipConf = vipConf.replace("{obj_ip}", global.getString("obj_ip"));
				vipConf = vipConf.replace("{peer_server_ip}", global.getString("peer_server_ip"));
				vipConf = vipConf.replace("{v_ip}", vipConfObj.getString("v_ip"));
				vipConf = vipConf.replace("{v_if_nm}", vipConfObj.getString("v_if_nm"));
				keepalivedCfg +="\n"+vipConf;
			}
			
			//파일 backup
			String backupPath = FileUtil.getPropertyValue("context.properties", "proxy.conf_backup_path");
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		  	dateTime = dateFormat.format(new Date());
		  	
		  	ProxyServerVO vo = new ProxyServerVO();
			vo.setPry_svr_id(prySvrId);
			
			ProxyServerVO proxySvr = (ProxyServerVO) proxyDAO.selectPrySvrInfo(vo);
			String initHaPath = proxySvr.getPry_pth();
			String initKalPath = proxySvr.getKal_pth();
			
			File initHaproxy = new File(proxySvr.getPry_pth());
			File initKeepa = new File(proxySvr.getKal_pth());
			//최초 적용 파일 있지만, 백업폴더 없을 경우 백업함
			File backupFolder = new File(backupPath);
			if(!backupFolder.exists() && initHaproxy.exists()){
				ProxyConfChangeHistoryVO confChgHistVo = new ProxyConfChangeHistoryVO();
				confChgHistVo.setPry_svr_id(prySvrId);
				confChgHistVo.setFrst_regr_id(lst_mdfr_id);
				
				//최초 conf 파일 백업 폴더 생성
				new File(backupPath+"/init/").mkdirs();
				
				String initBackupHaPath = backupFolder+"/init/"+initHaproxy.getName();
				Files.copy(initHaproxy.toPath(), Paths.get(initBackupHaPath), REPLACE_EXISTING);
				confChgHistVo.setPry_pth(initBackupHaPath);
				
				if("Y".equals(jobj.getString("KAL_INSTALL_YN")) && initKeepa.exists()){
					String initBackupKalPath = backupFolder+"/init/"+initKeepa.getName();
					Files.copy(initKeepa.toPath(), Paths.get(initBackupKalPath), REPLACE_EXISTING);
					confChgHistVo.setKal_pth(initBackupKalPath);
				}else{
					confChgHistVo.setKal_pth("");
				}
				confChgHistVo.setExe_rst_cd("TC001501");
				//insert T_PRYCHG_G
				proxyDAO.insertPrycngInfo(confChgHistVo);
			}
			
		  	newConfChgHistVo.setPry_svr_id(prySvrId);
			newConfChgHistVo.setFrst_regr_id(lst_mdfr_id);
			
			//신규 파일 생성 및 config 폴더에 덮어쓰기
			newHaPath = backupPath+"/"+dateTime+"/"+initHaproxy.getName();
			fileBackupReplace("PROXY", dateTime, newHaPath, initHaPath, proxyCfg, newConfChgHistVo);
			if("Y".equals(jobj.getString("KAL_INSTALL_YN"))){//keepalived 사용 여부
				newKePath = backupPath+"/"+dateTime+"/"+initKeepa.getName();
				fileBackupReplace("KEEPALIVED", dateTime, newKePath, initKalPath, keepalivedCfg, newConfChgHistVo);
			}else{
				newConfChgHistVo.setKal_pth(newKePath);
			}
			
			result.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP004);
			result.put(ProtocolID.RESULT_CODE, "0");
			result.put(ProtocolID.ERR_CODE, errcd);
			result.put(ProtocolID.ERR_MSG, "");
			result.put(ProtocolID.PRY_PTH, newHaPath);
			result.put(ProtocolID.KAL_PTH, newKePath);
			
			newConfChgHistVo.setExe_rst_cd("TC001501");
			proxyDAO.insertPrycngInfo(newConfChgHistVo);
		}catch(Exception e){
			newConfChgHistVo.setPry_svr_id(prySvrId);
			newConfChgHistVo.setFrst_regr_id(lst_mdfr_id);
			newConfChgHistVo.setPry_pth(newHaPath);
			newConfChgHistVo.setKal_pth(newKePath);
			newConfChgHistVo.setExe_rst_cd("TC001502");
			proxyDAO.insertPrycngInfo(newConfChgHistVo);
			
			errcd = "-1";
			result.put(ProtocolID.DX_EX_CODE, TranCodeType.PsP004);
			result.put(ProtocolID.RESULT_CODE, "1");
			result.put(ProtocolID.ERR_CODE, errcd);
			result.put(ProtocolID.ERR_MSG, e.toString());
			
			errLogger.error("createNewConfFile Error {} ", e.toString());
			throw e;
		}
		
		return result;
	}
	
	public void fileBackupReplace(String sysType,String backupFolder, String newFilePath, String replacePath, String fileContent, ProxyConfChangeHistoryVO confChgHistVo) throws Exception {
		
		String backupPath = FileUtil.getPropertyValue("context.properties", "proxy.conf_backup_path");
		
		//Backup폴더 생성
		if(!new File(backupPath+"/"+backupFolder+"/").exists()) new File(backupPath+"/"+backupFolder+"/").mkdirs();
		
		if("PROXY".equals(sysType)){
			confChgHistVo.setPry_pth(newFilePath);
		}else{
			confChgHistVo.setKal_pth(newFilePath);
		}
		
		//신규 파일 생성 
		File newFile = new File(newFilePath);
		byte[] contentBytes = fileContent.getBytes();
		FileOutputStream os_h = new FileOutputStream(newFile);
		os_h.write(contentBytes);
		os_h.close(); 
		 
		Files.copy(Paths.get(newFilePath), Paths.get(replacePath), REPLACE_EXISTING);
		
	}
	
	public JSONObject executeService(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyLinkServiceImpl.executeService : "+jObj.toString());

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		String strExecuteResult = "";
		
		JSONObject outputObj = new JSONObject();
		
		int prySvrId =jObj.getInt("pry_svr_id");
		String sysType =jObj.getString("sys_type"); //PROXY/KEEPALIVED
		String actType =jObj.getString("act_type"); //A : active /R : restart /S : stop
		String userId =jObj.getString("lst_mdfr_id");
		String cmd = "systemctl ";
		try {
			ProxyServerVO prySvr = new ProxyServerVO();
			prySvr.setLst_mdfr_id(userId);
			prySvr.setPry_svr_id(prySvrId);
			
			ProxyActStateChangeHistoryVO actHistory= new ProxyActStateChangeHistoryVO();
			actHistory.setPry_svr_id(prySvrId);
			actHistory.setFrst_regr_id(userId);
			actHistory.setLst_mdfr_id(userId);
			actHistory.setSys_type(sysType);
			actHistory.setAct_type(actType);
			actHistory.setAct_exe_type("TC004001");
			
			switch(actType){
				case "A" :
					cmd += "start ";
					break;
				case "R" :
					cmd += "restart ";
					break;
				case "S" :
					cmd += "stop ";
					break;
			}
			
			switch(sysType){
				case "PROXY" :
					cmd += "haproxy";
					break;
				case "KEEPALIVED" :
					cmd += "keepalived ";
					break;
			}
			
			socketLogger.info("executeService.cmd :: "+cmd);
			
			
			RunCommandExec commandExec = new RunCommandExec(cmd);
			//명령어 실행
			commandExec.run();

			try {
				commandExec.join();
			} catch (InterruptedException ie) {
				socketLogger.error("executeService error {}",ie.toString());
				ie.printStackTrace();
			}
		
			socketLogger.info("call :: "+commandExec.call());
			socketLogger.info("Message :: "+commandExec.getMessage());
			
			if(commandExec.call().equals("success")){
				if(actType.equals("A") || actType.equals("R")) strExecuteResult="TC001501";
				else strExecuteResult="TC001502";
			}else{
				if(actType.equals("A") || actType.equals("R")) strExecuteResult="TC001502";
				else strExecuteResult="TC001501";
			}
			actHistory.setExe_rslt_cd(strExecuteResult);
			actHistory.setRslt_msg(commandExec.getMessage());
			
			//insert
			proxyDAO.insertPryActCngInfo(actHistory); 
			
			switch(sysType){
				case "PROXY" :
					prySvr.setExe_status(strExecuteResult);
					break;
				case "KEEPALIVED" :
					prySvr.setKal_exe_status(strExecuteResult);
					break;
			}
			
			proxyDAO.updatePrySvrExeStatusInfo(prySvr);
			
			
		} catch (Exception e) {
			errLogger.error("ProxyLinkServiceImpl.executeService {}", e.toString());
			strSuccessCode = "1";
			strErrCode = "-1";
			strErrMsg = "executeService Error [" + e.toString() + "]";
		}
		outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, "");
		outputObj.put(ProtocolID.EXECUTE_RESULT, strExecuteResult);
		
		return outputObj;
	}

	public JSONObject getAgentInterface(JSONObject jobj) throws Exception {
		socketLogger.info("getAgentInterface :: start");
		JSONObject outputObj = new JSONObject();
		
		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		String cmdResult ="";
		String interfList = "";
		
		//명령어 실행
		cmdResult =runExeCmd("ip -o link");
		String[] strTemp = cmdResult.split("\n");
		if(strTemp[0].equals("success")){
			for(int i=1; i<strTemp.length; i++){
				String interf[] = strTemp[i].split(":");
				if(i !=0) {
					if(i !=1) interfList += "\t";
					interfList += interf[1].trim();
				}
			}
		}else{
			strSuccessCode = "1";
			strErrCode = "-1";
			strErrMsg = "Agent 처리 중 오류가 발생하였습니다.";
		}
		
		String interf="";
		
		String ip = FileUtil.getPropertyValue("context.properties", "agent.install.ip");
		cmdResult =runExeCmd("ip -f inet addr |grep "+ip);
		strTemp = cmdResult.split("\n");
		if(strTemp[0].equals("success")){
			String[] interfCmd = strTemp[strTemp.length-1].split(" ");
			interf = interfCmd[interfCmd.length-1];
		}else{
			strSuccessCode = "1";
			strErrCode = "-1";
			strErrMsg = "Agent 처리 중 오류가 발생하였습니다.";
		}

		outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.INTERFACE_LIST, interfList);
		outputObj.put(ProtocolID.INTERFACE, interf);
		
		return outputObj;
	}
}