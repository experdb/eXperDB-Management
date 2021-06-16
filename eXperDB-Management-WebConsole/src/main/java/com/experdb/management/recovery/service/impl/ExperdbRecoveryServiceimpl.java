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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
	public JSONObject completeRecoveryRun(HttpServletRequest request) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		JSONObject result = new JSONObject();
		HttpSession session = request.getSession();
		String password = request.getParameter("password");
		if(!checkAccountPassword(session, password)){
			result.put("result_code", 5);
			return result;
		}
		
		
		
		
		
		return result;
	}
	
	public boolean checkAccountPassword(HttpSession session, String password) throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{
		LoginVO loginVo = (LoginVO) session.getAttribute("session");
		String usr_id = loginVo.getUsr_id();
		AES256 aes = new AES256(AES256_KEY.ENC_KEY);
		
		System.out.println("### checkAccountPassword ###");
		System.out.println("user ID : " + usr_id);
		System.out.println("password : " + password);
		System.out.println("password enc : " + aes.aesEncode(password));
		String user_password = aes.aesDecode(experdbRecoveryDAO.getUserPassword(usr_id));
		
		if(user_password.equals(password)){
			return true;
		}else{
			return false;
		}
	}
	
	

}
