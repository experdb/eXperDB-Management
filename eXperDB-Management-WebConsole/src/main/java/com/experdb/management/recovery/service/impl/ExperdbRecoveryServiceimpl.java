package com.experdb.management.recovery.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import com.experdb.management.backup.cmmn.CmmnUtil;
import com.experdb.management.backup.node.service.ExperdbBackupNodeService;
import com.experdb.management.backup.node.service.TargetMachineVO;
import com.experdb.management.backup.node.service.impl.ExperdbBackupNodeDAO;
import com.experdb.management.backup.service.BackupLocationInfoVO;
import com.experdb.management.backup.service.ServerInfoVO;
import com.experdb.management.backup.service.impl.ExperdbBackupDAO;
import com.experdb.management.backup.storage.service.impl.ExperdbBackupStorageDAO;
import com.experdb.management.recovery.service.ExperdbRecoveryService;

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

	@Override
	public JSONObject getStorageList(HttpServletRequest request) {
		System.out.println("####### getStorageList SERVICE #######");
		System.out.println(request.getParameter("ipadr"));
		JSONObject result = new JSONObject();
		List<BackupLocationInfoVO> storageList = null;
		
		storageList = experdbRecoveryDAO.getStorageList(request.getParameter("ipadr"));
		
		System.out.println("storagelist size : " + storageList.size());
		
		if(storageList.size() > 0){
			for(BackupLocationInfoVO s : storageList){
				System.out.println(">> " + s.getBackupDestLocation());
				System.out.println("  >>> " + experdbRecoveryDAO.getStorageType(s.getBackupDestLocation()));
				s.setType(experdbRecoveryDAO.getStorageType(s.getBackupDestLocation()));
			}
		}
		
		result.put("storageList", storageList);
		
		return result;
	}
	
	

}
