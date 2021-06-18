package com.experdb.management.recovery.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.experdb.management.backup.node.service.ExperdbBackupNodeService;
import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.node.service.impl.ExperdbBackupNodeDAO;
import com.experdb.management.backup.service.BackupLocationInfoVO;
import com.experdb.management.backup.service.ServerInfoVO;
import com.experdb.management.backup.service.impl.ExperdbBackupDAO;
import com.experdb.management.backup.storage.service.impl.ExperdbBackupStorageDAO;
import com.experdb.management.recovery.cmmn.RestoreInfoVO;
import com.experdb.management.recovery.cmmn.RestoreMachineMake;
import com.experdb.management.recovery.cmmn.RestoreMake;
import com.experdb.management.recovery.service.ExperdbRecoveryService;
import com.k4m.dx.tcontrol.cmmn.AES256;
import com.k4m.dx.tcontrol.cmmn.AES256_KEY;
import com.k4m.dx.tcontrol.cmmn.SHA256;
import com.k4m.dx.tcontrol.login.service.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbRecoveryServiceImpl")
public class ExperdbRecoveryServiceimpl extends EgovAbstractServiceImpl implements ExperdbRecoveryService {
	
	@Resource(name = "ExperdbBackupNodeDAO")
	private ExperdbBackupNodeDAO experdbBackupNodeDAO;

	@Resource(name = "ExperdbBackupDAO")
	private ExperdbBackupDAO experdbBackupDAO;

	@Resource(name = "ExperdbRecoveryDAO")
	private ExperdbRecoveryDAO experdbRecoveryDAO;
	
    @Resource(name="ExperdbBackupStorageDAO")
    private ExperdbBackupStorageDAO experdbBackupStorageDAO;
	
	@Override
	public JSONObject getNodeInfoList() {
		JSONObject result = new JSONObject();
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> resultList = new ArrayList<>();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
					resultList.add(s);
				}
			}
		}
		
		result.put("serverList", resultList);
		
		
		return result;
	}

	@SuppressWarnings({ "unchecked", "null" })
	@Override
	public JSONObject getStorageList(HttpServletRequest request) {
		System.out.println("####### getStorageList SERVICE #######");
		JSONObject result = new JSONObject();
		List<BackupLocationInfoVO> storageList = null;
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		storageList = experdbRecoveryDAO.getStorageList(request.getParameter("ipadr"));
		
		if(storageList.size() > 0){
			for(BackupLocationInfoVO s : storageList){
				int type = experdbRecoveryDAO.getStorageType(s.getBackupDestLocation());
				if(type>0){
					Map<String, Object> r = new HashMap<>();
					r.put("path", s.getBackupDestLocation());
					r.put("type", type);
					resultList.add(r);
				}
			}
		}
		
		result.put("storageList", resultList);
		
		return result;
	}

	@Override
	public JSONObject getRecoveryDBList() {
		System.out.println("@@ getRecoveryDBList SERVICE @@");
		JSONObject result = new JSONObject();
		RestoreMachineMake encryptMachine = new RestoreMachineMake();
		
		List<RestoreInfoVO> restoreList = null;
		List<RestoreInfoVO> resultList = new ArrayList<>();
		
		restoreList = experdbRecoveryDAO.getRecoveryDBList();
		
		for(int i=0; i<restoreList.size(); i++){
			RestoreInfoVO decInfo = new RestoreInfoVO();
			decInfo = encryptMachine.restoreInfoDecrypt(restoreList.get(i));
			resultList.add(decInfo);
		}
		
		result.put("recoveryList", resultList);
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject serverInfoFileRead(MultipartHttpServletRequest request) throws IllegalStateException, IOException {
		
		RestoreMachineMake encryptMachine = new RestoreMachineMake();
		MultipartFile f = request.getFile("serverInfoFile");
		JSONObject result = new JSONObject();
		JSONObject fileContent = new JSONObject();
		RestoreInfoVO serverInfo = new RestoreInfoVO();
		RestoreInfoVO resultInfo = new RestoreInfoVO();
		File file = File.createTempFile("DBInfoTemp", "txt");
		
		f.transferTo(file);
		
		BufferedReader bufReader = new BufferedReader(new FileReader(file));
		
		String content;
		while((content = bufReader.readLine()) != null){
			String[] s = content.split(" = ");
			fileContent.put(s[0], s[1]);
		}
		
		bufReader.close();
		
		serverInfo.setGuestMac(fileContent.get("mac").toString());
		serverInfo.setGuestIp(fileContent.get("ip").toString());
		serverInfo.setGuestSubnetmask(fileContent.get("subnetmask").toString());
		serverInfo.setGuestGateway(fileContent.get("gateway").toString());
		serverInfo.setGuestDns(fileContent.get("dns").toString());
		serverInfo.setGuestNetwork(fileContent.get("network").toString());
		
		resultInfo = encryptMachine.restoreInfoDecrypt(serverInfo);
		
		result.put("serverInfo", resultInfo);
		
		
		return result;
	}

	@Override
	public JSONObject recoveryDBInsert(HttpServletRequest request) {
		JSONObject result = new JSONObject();
		RestoreMachineMake encryptMachine = new RestoreMachineMake();
		RestoreInfoVO serverInfo = new RestoreInfoVO();
		RestoreInfoVO resultInfo = new RestoreInfoVO();
		
		serverInfo.setGuestIp(request.getParameter("ip"));
		serverInfo.setGuestMac(request.getParameter("mac"));
		serverInfo.setGuestSubnetmask(request.getParameter("snm"));
		serverInfo.setGuestGateway(request.getParameter("gateway"));
		serverInfo.setGuestDns(request.getParameter("dns"));
		serverInfo.setGuestNetwork(request.getParameter("network"));
		
		resultInfo = encryptMachine.restoreInfoEncrypt(serverInfo);
		
		experdbRecoveryDAO.recoveryDBInsert(resultInfo);
		
		return result;
	}

	@Override
	public JSONObject recoveryDBDelete(HttpServletRequest request) {
		System.out.println("### recoveryDBDelete SERVICE ##");
		JSONObject result = new JSONObject();
		System.out.println(request.getParameter("machineId"));
		experdbRecoveryDAO.recoveryDBDelete(request.getParameter("machineId"));
		
		result.put("result_code", 1);
		return result;
	}

	@Override
	public JSONObject completeRecoveryRun(HttpServletRequest request) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException {
		JSONObject result = new JSONObject();
		HttpSession session = request.getSession();
		RestoreMake make = new RestoreMake();
		CmmnUtil util = new CmmnUtil();
		
		Date date = new Date();
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String time = transFormat.format(date);   
        
        String jobName_New = "recovery_"+time;
		
		String password = request.getParameter("password");
		if(!checkAccountPassword(session, password)){
			result.put("result_code", 5);
			return result;
		}
		
		RestoreInfoVO restoreInfoVo = new RestoreInfoVO();
		restoreInfoVo.setJobName(jobName_New);
		restoreInfoVo.setSourceNode(request.getParameter("sourceDB"));
		restoreInfoVo.setStorageLocation(request.getParameter("storagePath"));
		restoreInfoVo.setGuestMac(request.getParameter("targetMac"));
		restoreInfoVo.setGuestIp(request.getParameter("targetIp"));
		restoreInfoVo.setGuestSubnetmask(request.getParameter("targetSNM"));
		restoreInfoVo.setGuestGateway(request.getParameter("targetGW"));
		restoreInfoVo.setGuestDns(request.getParameter("targetDNS"));
		restoreInfoVo.setRecoveryPoint("last");
		restoreInfoVo.setGuestNetwork("static");
		
		if(request.getParameter("storageType").equals("1")){
			restoreInfoVo.setStorageType("nfs");
		}else{
			restoreInfoVo.setStorageType("cifs");
		}
		if(request.getParameter("bmrInstant").equals("1")){
			restoreInfoVo.setBmr("yes");
		}else{
			restoreInfoVo.setBmr("no");
		}
		
		
		make.bmr(restoreInfoVo);
		result = util.recoveryRun(jobName_New, "complete");

		return result;
	}
	
	public boolean checkAccountPassword(HttpSession session, String password) throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);
		
		String user_password = aes.aesDecode(experdbRecoveryDAO.getUserPassword(usr_id));
		
		if(user_password.equals(password)){
			return true;
		}else{
			return false;
		}
	}

	
	@Override
	public JSONObject getRecoveryTimeListList(HttpServletRequest request) {
		System.out.println("####### getRecoveryTimeList SERVICE #######");
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		resultList = experdbRecoveryDAO.getRecoveryTimeList(request.getParameter("ipadr"));
	
		for(int i=0; i<resultList.size(); i++){
			JSONObject jsonObj = new JSONObject();
			Date endDate = new Date(Long.parseLong(resultList.get(i).get("finishtime").toString())* 1000L);

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String endTime = transFormat.format(endDate);	
				
			jsonObj.put("jobid", resultList.get(i).get("jobid"));
			jsonObj.put("finishtime", endTime);
			jsonArray.add(jsonObj);
		}
		
		result.put("data", jsonArray);
		
		return result;
	}

	@Override
	public JSONObject getRecoveryTimeOption(HttpServletRequest request) {
		System.out.println("####### getRecoveryOption SERVICE #######");
		JSONObject result = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultRpoint = new ArrayList<Map<String, Object>>();
		List<BackupLocationInfoVO> list = null;
		
		list = experdbBackupStorageDAO.backupStorageList();
		resultList = experdbRecoveryDAO.getRecoveryTimeOption(request.getParameter("jobid"));
		resultRpoint = experdbRecoveryDAO.getRecoveryPoinList(request.getParameter("jobid"));
		
		
			JSONObject jsonObj = new JSONObject();
			Date endDate = new Date(Long.parseLong(resultList.get(0).get("finishtime").toString())* 1000L);

			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String endTime = transFormat.format(endDate);	
			
			jsonObj.put("jobid", resultList.get(0).get("jobid"));
			jsonObj.put("finishtime", endTime);
			jsonObj.put("location", resultList.get(0).get("destinationlocation"));		
			jsonObj.put("rPoint", resultRpoint.get(0).get("rpoint"));	    			
			
			for (int i=0; i<list.size(); i++){
				if(list.get(i).getBackupDestLocation().equals(resultList.get(0).get("destinationlocation").toString())){
					jsonObj.put("locationType",list.get(i).getType());	
				}
			}
	    	
			jsonArray.add(jsonObj);
	
			result.put("data", jsonArray);
			
		return result;
	}
	
	

}
