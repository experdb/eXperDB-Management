package com.experdb.proxy.db.repository.service;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	 * createNewConfFile JSONObject로 받은 설정 정보를 conf 파일로 생성
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception  
	 */
	@Override
	public JSONObject createNewConfFile(JSONObject jobj) throws Exception {
		socketLogger.info("ProxyLinkServiceImpl.createNewConfFile : "+jobj.toString());

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
			
			String globalConf = util.readTemplateFile("global.cfg", TEMPLATE_DIR);
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
			
			//proxy user, group이 사이트 마다 달라질 수 있다 하여 수정 -- 20210701
			globalConf = globalConf.replace("{proxy_user}", FileUtil.getPropertyValue("context.properties", "proxy.global.user"));
			globalConf = globalConf.replace("{proxy_group}", FileUtil.getPropertyValue("context.properties", "proxy.global.group"));
			
			proxyCfg += globalConf;
			
			String readOnlyConf = util.readTemplateFile("readOnly.cfg", TEMPLATE_DIR);
			String readWriteConf = util.readTemplateFile("readWrite.cfg", TEMPLATE_DIR);
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
					readWriteConf = readWriteConf.replace("{packet_len}", util.getPacketLength(31,db_nm)); //8자, 패딩 0으로 넣기 
					proxyCfg +="\n"+readWriteConf;
				}else if(lsn_nm.equals(readOnlyCdNm)){
					readOnlyConf = readOnlyConf.replace("{lsn_nm}", lsn_nm);
					readOnlyConf = readOnlyConf.replace("{con_bind_port}", bind);
					readOnlyConf = readOnlyConf.replace("{db_nm_hex}", util.getStringToHex(db_nm)+"00");
					readOnlyConf = readOnlyConf.replace("{db_nm}", db_nm);
					readOnlyConf = readOnlyConf.replace("{packet_len}",  util.getPacketLength(31,db_nm));
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
				String vipConf = util.readTemplateFile("vip_instance.conf", TEMPLATE_DIR);
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
				
				if("Y".equals(jobj.getString("KAL_INSTALL_YN"))){
					File initKeepa = new File(initKalPath);
					if(initKeepa.exists()){
						String initBackupKalPath = backupFolder+"/init/"+initKeepa.getName();
						Files.copy(initKeepa.toPath(), Paths.get(initBackupKalPath), REPLACE_EXISTING);
						confChgHistVo.setKal_pth(initBackupKalPath);
					}
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
				File initKeepa = new File(initKalPath);
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

	/**
	 * fileBackupReplace backup 폴더, conf 생성
	 * @param String
	 * @return 
	 * @throws Exception  
	 */
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
	
	/**
	 * keepalvied, haproxy 서비스 중단/시작/재시작 하기
	 * @param JSONObject
	 * @return JSONObject
	 */
	@Override
	public JSONObject executeService(JSONObject jObj) throws Exception {
		socketLogger.info("ProxyLinkServiceImpl.executeService : "+jObj.toString());

		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		String strExecute = "";
		String strExecuteResult = "";
		
		JSONObject outputObj = new JSONObject();
		
		int prySvrId =jObj.getInt("pry_svr_id");
		String sysType =jObj.getString("sys_type"); //PROXY/KEEPALIVED
		String actType =jObj.getString("act_type"); //A : active /R : restart /S : stop
		String userId =jObj.getString("lst_mdfr_id");
		String cmd = "systemctl ";
		String proxySetStatus = "";
/*		String keepalivedSetStatus = "";*/
		
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
				strExecuteResult = "TC001501";
				if(actType.equals("A") || actType.equals("R")) strExecute="TC001501";
				else strExecute="TC001502";
			}else{
				strExecuteResult = "TC001502";
				if(actType.equals("A") || actType.equals("R")) strExecute="TC001502";
				else strExecute="TC001501";
			}
			actHistory.setExe_rslt_cd(strExecuteResult);
			actHistory.setRslt_msg(commandExec.getMessage());
			
			//insert
			proxyDAO.insertPryActCngInfo(actHistory); 
			
			switch(sysType){
				case "PROXY" :
					prySvr.setExe_status(strExecute);
					proxySetStatus = strExecute;
					break;
				case "KEEPALIVED" :
					prySvr.setKal_exe_status(strExecute);
/*					keepalivedSetStatus = strExecute;*/
					break;
			}

			//proxy_svr 상태 변경 및 마스터 구분 체크
	    	try {
	    		String returnMsg = "";
	    		
	    		ProxyServerVO schProxyServerVO = new ProxyServerVO();
	    		schProxyServerVO.setPry_svr_id(prySvrId);

				//proxy 서버 등록 여부 확인
				ProxyServerVO proxyServerInfo = proxyDAO.selectPrySvrInfo(schProxyServerVO);

	    		proxyDAO.updatePrySvrExeStatusInfo(prySvr);

	    		if (proxyServerInfo != null) {
					Map<String, Object> chkParam = new HashMap<String, Object>();

					chkParam.put("ipadr", "");
					chkParam.put("proxySetStatus",proxySetStatus);
					chkParam.put("real_ins_gbn", "dbchk");
					chkParam.put("userId",userId);

					//마스터 실시간 체크
					returnMsg = proxyMasterGbnLinkCheck(chkParam, proxyServerInfo); 	
	    		}

	        } catch(Exception e) {
	            e.printStackTrace();
	        }
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
		outputObj.put(ProtocolID.EXECUTE_RESULT, strExecute);
		
		return outputObj;
	}
	
	/**
	 * 마스터 체크 및 저장
	 * @param chkParam, proxyServerInfo
	 * @return String
	 * @throws Exception
	 */
	@Transactional
	public String proxyMasterGbnLinkCheck(Map<String, Object> chkParam, ProxyServerVO proxyServerInfo) throws Exception  {
		String returnMsg = "";

		try {
			//param setting
			String ipadrPrm = "";
			String proxySetStatusPrm = "";
			String userIdPrm = "";

			String strAcptype = "";
			String strProxyChgVal = "";

			if (proxyServerInfo != null) ipadrPrm = proxyServerInfo.getIpadr();
			if (chkParam.get("proxySetStatus") != null) proxySetStatusPrm = chkParam.get("proxySetStatus").toString();
			if (chkParam.get("userId") != null) userIdPrm = chkParam.get("userId").toString();

			Map<String, Object> mstChkParam = new HashMap<String, Object>();
			ProxyServerVO prySvrChk = null;

			//proxy check - 기동 이력등록
			if (!"".equals(proxySetStatusPrm)) {
				strAcptype = proxySetStatusPrm;

				if (!strAcptype.equals(proxyServerInfo.getExe_status())) {
					strProxyChgVal = strAcptype;
				}
			}

			//마스터 구분 변경
			if (!"".equals(strProxyChgVal)) {
				if ("TC001502".equals(strProxyChgVal)) { //down 된 경우
					if ("M".equals(proxyServerInfo.getMaster_gbn())) { //마스터 일때
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) { //keep 이 없는 경우
							prySvrChk = new ProxyServerVO();
							
							prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
							prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
							prySvrChk.setOld_master_svr_id_chk(null);
							prySvrChk.setLst_mdfr_id(userIdPrm);
		         			prySvrChk.setSel_query_gbn("backup_down");
		         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

							proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);							
						} else {
							//백업 제일 작은수가 마스터로 변경
							mstChkParam.put("pry_svr_id", proxyServerInfo.getPry_svr_id());
							mstChkParam.put("ipadr", ipadrPrm);
							mstChkParam.put("selQueryGbn", "masterM");
							mstChkParam.put("db_svr_id", proxyServerInfo.getDb_svr_id());
							
							prySvrChk = proxyDAO.selectPrySvrMasterSetInfo(mstChkParam);

				         	//backup이 있으면 update 없으면 처리 않함
				         	if (prySvrChk != null) {
				         		//백업중 제일 낮은 Pry_svr_id 존재
				         		if (!"".equals(prySvrChk.getPry_svr_id()) && !"0".equals(prySvrChk.getPry_svr_id())) {
				         			prySvrChk.setMaster_gbn("M");
				         			prySvrChk.setMaster_svr_id_chk(null);
				         			prySvrChk.setLst_mdfr_id(userIdPrm);
				         			
				         			prySvrChk.setOld_pry_svr_id(proxyServerInfo.getPry_svr_id());
				         			prySvrChk.setOld_master_gbn("S");
				         			prySvrChk.setOld_master_svr_id_chk(Integer.toString(prySvrChk.getPry_svr_id()));

				         			prySvrChk.setSel_query_gbn("master_down");
				         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());
				         			socketLogger.info("prySvrChk.getPry_svr_id()123123===" + prySvrChk.getPry_svr_id());
				         			//백업중 제일 낮은 proxy 마스터로 승격
				         			//기존 마스터는 백업으로 변경
				         			//전체 백업의 마스터_id를 변경
				         			proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
				         		}
				         	} else {
								//백업일 경우
								prySvrChk = new ProxyServerVO();
								
								prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
								prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
								
								if (proxyServerInfo.getMaster_svr_id() <= 0) {
									prySvrChk.setOld_master_svr_id_chk(null);
								} else {
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
								}

								prySvrChk.setLst_mdfr_id(userIdPrm);
			         			prySvrChk.setSel_query_gbn("backup_down");
			         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

								proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
				         	}
						}
					} else {//백업일 경우
						//keep 설치 여부 상관없이 현재를 그냥 저장함
						prySvrChk = new ProxyServerVO();
						
						prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
						prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
						prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
						prySvrChk.setLst_mdfr_id(userIdPrm);
	         			prySvrChk.setSel_query_gbn("backup_down");
	         			prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

						proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
					}
				} else { //up
					//마스터 제외하고 전부 등록
					prySvrChk = new ProxyServerVO();
					
					prySvrChk.setPry_svr_id(proxyServerInfo.getPry_svr_id());
					prySvrChk.setLst_mdfr_id(userIdPrm);
					prySvrChk.setDb_svr_id(proxyServerInfo.getDb_svr_id());

					//마스터 일 경우 
					if ("M".equals(proxyServerInfo.getMaster_gbn())) { //마스터 일때

						//현재 master_gbn 저장 
						//현재 마스터 svr_id 값 setting 하여 값 저장
						//up 일경우
						//master 일 경우
						//1. keep 없는 경우
						// 본서버 M 그대로 
						// 혹시 연결되어있는 MASTER_SVR_ID 가 있으면 지우고 MASTER로
						//2. KEEP 있는 경우
						// 본서버 M 그대로
						// 연결되어있는 나머지는 MASTER 하위로 S 가 되어야함
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) {
							prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
							prySvrChk.setMaster_svr_id_chk(null);
							prySvrChk.setOld_master_gbn("M");
							prySvrChk.setOld_master_svr_id_chk(null);
							socketLogger.info("g_master_up :: ");
							prySvrChk.setSel_query_gbn("g_master_up");
							
						} else {
							//기존 마스터 가 있는 경우 확인
							//같은 dbms 이고 본서버보다 pry_svr_id 가 낮은 경우는 본인이  s가 되어야함
							//아닌경우는 본서버가 마스터 나머지는 s
							mstChkParam.put("pry_svr_id", proxyServerInfo.getPry_svr_id());
							mstChkParam.put("ipadr", ipadrPrm);
							mstChkParam.put("selQueryGbn", "backupM");
							mstChkParam.put("db_svr_id", proxyServerInfo.getDb_svr_id());
							
							ProxyServerVO backupChk = proxyDAO.selectPrySvrMasterSetInfo(mstChkParam);
							
							//마스터가 두건이상일때
							//마스터중 가장 앞자리인것이 위로가야함
							//마스터 제외, 현재 서버 의 master_svr_id, 현재 마스터의 svr_id 등 모두 
							prySvrChk.setMaster_gbn("M");
							prySvrChk.setMaster_svr_id_chk(null);

							prySvrChk.setOld_master_gbn("S");
							prySvrChk.setOld_pry_svr_id(proxyServerInfo.getPry_svr_id());
							
							if (backupChk != null && (backupChk.getPry_svr_id() != prySvrChk.getPry_svr_id() ||
								backupChk.getPry_svr_id() < prySvrChk.getPry_svr_id())) {
								//현재서버와 마스터서버아이디로된 것들을 백업으로 변경, pry_svr_id는 조회한 서버로
								//그리고 조회한 서버아이디를 마스터로 나머진 백업으로 한번더 up
								prySvrChk.setPry_svr_id(backupChk.getPry_svr_id());
								socketLogger.info("g_master_up_keep :: ");
								prySvrChk.setSel_query_gbn("g_master_up_keep");
								
							} else {
								//현재꺼를 마스터 그대로
								//기존 마스터나 다른 서버를 본서버 하위로
								//prySvrChk.setPry_svr_id(backupChk.getPry_svr_id());
								socketLogger.info("g_master_up_sel :: ");
								prySvrChk.setSel_query_gbn("g_master_up_sel");
							}
						}
					} else { //백업일때
						// keep 이 없다가 다시 있는 경우
						if (!"Y".equals(proxyServerInfo.getKal_install_yn())) { //keep 이 없는 경우
							//keep 이 없는 경우 master가 됨
							//나머지는 그대로
							prySvrChk.setMaster_gbn("M");
							prySvrChk.setMaster_svr_id_chk(null);
							
							prySvrChk.setSel_query_gbn("g_backup_up_keep");
						} else { //keep 있는 경우
							if ("M".equals(proxyServerInfo.getOld_master_gbn())) { //기본마스터 일때
								//기본마스터 일때 는 제일 1번으로 들어가야함
								//나머지는 현재 pry_svr_id로 master 설정되어야 하며
								//기존 마스터와 기존마스터의 백업들 모두 변경되어야함
								prySvrChk.setMaster_gbn("M"); //M으로 들어감
								prySvrChk.setMaster_svr_id_chk(null);
								
								//기존 마스터와 관련된 백업찾아야함
								//본서버제외
								if (proxyServerInfo.getMaster_svr_id() > 0) {
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
								} else {
									prySvrChk.setOld_master_svr_id_chk("");
								}
								prySvrChk.setOld_master_gbn("S");
								
								socketLogger.info("g_backup_up :: ");

								prySvrChk.setSel_query_gbn("g_backup_up");
							} else { //기본 백업일때
								//마스터 한건도 없을때 마스터 up
								//나머지는 현재건의 하위로
								if (proxyServerInfo.getMaster_exe_cnt() <= 0) {
									prySvrChk.setMaster_gbn("M");
									prySvrChk.setMaster_svr_id_chk(null);
								
									prySvrChk.setOld_master_gbn("S");
									prySvrChk.setOld_master_svr_id_chk(Integer.toString(proxyServerInfo.getPry_svr_id()));
									
									socketLogger.info("g_backup_up123 :: ");
									
									prySvrChk.setSel_query_gbn("g_backup_up");
								} else {

									prySvrChk.setMaster_gbn(proxyServerInfo.getMaster_gbn());
									prySvrChk.setMaster_svr_id_chk(Integer.toString(proxyServerInfo.getMaster_svr_id()));
									
									socketLogger.info("g_backup_up_keep :: ");
									
									prySvrChk.setSel_query_gbn("g_backup_up_keep");
								}
							}
						}
					}

					proxyDAO.updatePrySvrMstGbnInfo(prySvrChk);
				}
			}

			returnMsg = "success";
		} catch (Exception e) {
			errLogger.error("proxyMasterGbnRealCheck {} ", e.toString());
			returnMsg = "false";
		}
		
		return returnMsg;
	}
	
	/**
	 * Agent network Interface 정보
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception
	 */
	@Override
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
	
	/**
	 * Backup Conf 파일 읽어오기
	 * 
	 * @param String
	 * @return String
	 */
	@Override
	public String readBackupConfFile(String filePath){
		String content = null;
 	   	File file = new File(filePath); 
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
	
	/**
	 * keepalived 설치 여부 및 path update
	 * 
	 * @param JSONObject
	 * @return JSONObject
	 * @throws Exception 
	 */
	@Override
	public JSONObject checkKeepalivedInstallYn(JSONObject jObj) throws Exception {
		JSONObject outputObj = new JSONObject();
		
		String strSuccessCode = "0";
		String strErrCode = "";
		String strErrMsg = "";
		String kalPath = "";
		String kalInstYn = jObj.getString("kal_install_yn");//"Y";
		
		if("Y".equals(kalInstYn)){ //사용함으로 변경 시 keepalived.conf 파일 경로를 찾아, T_PRY_SVR_I에 업데이트 
			RunCommandExec commandExec = new RunCommandExec();
			commandExec.runExecRtn3("find /etc/keepalived -name keepalived.conf");
			try {
				commandExec.join();
			} catch (InterruptedException ie) {
				socketLogger.error("find kal_path error {}",ie.toString());
				strErrMsg = ie.toString();
				ie.printStackTrace();
			}
			if(commandExec.call().equals("success")){
				kalPath += commandExec.getMessage();
			}
			
			ProxyServerVO prySvr = new ProxyServerVO();
			prySvr.setPry_svr_id(jObj.getInt("pry_svr_id"));
			prySvr.setLst_mdfr_id(jObj.getString("lst_mdfr_id"));
			prySvr.setKal_pth(kalPath);
			proxyDAO.updatePrySvrKalPathInfo(prySvr);
		}
		
		//context.properties과 테이블 데이터 동기화
		Properties prop = new Properties();
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		File file = new File(loader.getResource("context.properties").getFile());
		String path = file.getParent() + File.separator;
		try {
			prop.load(new FileInputStream(path + "context.properties"));
			prop.setProperty("keepalived.install.yn", kalInstYn);
			prop.store(new FileOutputStream(path + "context.properties"), "");
		} catch(FileNotFoundException e) {
			socketLogger.error("context.properties update FileNotFoundException error {}",e.toString());
		} catch(Exception e) {
			socketLogger.error("context.properties update Exception error {}",e.toString());
		}
		
		if("".equals(kalPath) && "Y".equals(kalInstYn)){
			kalInstYn = "N";
			strSuccessCode = "-1";
			strErrCode = "-1";
			strErrMsg = "keepalived.conf를 찾지 못했습니다.";
		}else{
			strSuccessCode = "0";
			strErrCode = "0";
			strErrMsg = "";
		}
		
		outputObj.put(ProtocolID.KAL_INSTALL_YN, kalInstYn);
		outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		
		return outputObj;
	}
	
	/**
	 * cmd 실행
	 * 
	 * @param String
	 * @return String
	 * @throws Exception 
	 */
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
}