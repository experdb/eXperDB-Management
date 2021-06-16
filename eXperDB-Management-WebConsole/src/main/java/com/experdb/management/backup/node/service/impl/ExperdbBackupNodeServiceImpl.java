package com.experdb.management.backup.node.service.impl;

import java.io.*;
import java.lang.reflect.*;
import java.text.*;
import java.text.ParseException;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;
import javax.xml.parsers.*;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.batch.core.scope.context.*;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;
import org.xml.sax.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.node.service.*;
import com.experdb.management.backup.service.*;
import com.experdb.management.backup.service.impl.*;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ExperdbBackupNodeServiceImpl")
public class ExperdbBackupNodeServiceImpl  extends EgovAbstractServiceImpl implements ExperdbBackupNodeService{

	@Resource(name = "ExperdbBackupNodeDAO")
	private ExperdbBackupNodeDAO experdbBackupNodeDAO;

	@Resource(name = "ExperdbBackupDAO")
	private ExperdbBackupDAO experdbBackupDAO;

	
	
	@Override
	public List<TargetMachineVO> getNodeList() throws Exception {
		return experdbBackupNodeDAO.getNodeList();	
	}

	// 노드 리스트 조회
	@Override
	public JSONObject getNodeInfoList() throws FileNotFoundException, IOException {
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> resultList = new ArrayList<>();
		JSONObject result = new JSONObject();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));			
		//props.load(new FileInputStream(ResourceUtils.getFile("C:\\Users\\yeeun\\git\\eXperDB-Management_2\\eXperDB-Management-WebConsole\\src\\main\\resources\\egovframework\\tcontrolProps\\globals.properties")));			
		String license = props.get("bnr.license").toString();
		
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
					resultList.add(s);
				}
			}
		}
		
		for(int i=0; i<resultList.size(); i++){
			if(resultList.get(i).getMasterGbn().equals("S")){
				for(int j=0; j<resultList.size(); j++){
					if(resultList.get(j).getMasterGbn().equals("M") && resultList.get(i).getDbSvrId().equals(resultList.get(j).getDbSvrId())){
						resultList.get(i).setMasterGbn("SS");
						break;
					}
				}
			}
		}
		
		result.put("serverList", resultList);
		result.put("license", license);
		
		return result;
	}


	// 등록되지 않은 노드리스트 조회
	@Override
	public List<ServerInfoVO> getUnregNodeList() {
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> result = new ArrayList<>();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
					result.add(s);
				}
			}
		}
		serverList.removeAll(result);
		return serverList;
	}


	// 노드 등록
	@Override
	public JSONObject nodeInsert(HttpServletRequest request) {
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		nodeInfo.setName(request.getParameter("ipadr"));
		nodeInfo.setUser(request.getParameter("rootName"));
		nodeInfo.setPassword(request.getParameter("rootPW"));
		nodeInfo.setIsUser(request.getParameter("userCred"));
		nodeInfo.setUserName(request.getParameter("userName"));
		nodeInfo.setUserPw(request.getParameter("userPW"));
		nodeInfo.setDescription("'"+request.getParameter("description")+"'");
		
		result = Node.addNode(nodeInfo);
		
		return result;
	}
	
	// 노드 정보 불러오기
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getNodeInfo(HttpServletRequest request) throws Exception{
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		String path = request.getParameter("path");
		nodeInfo = experdbBackupNodeDAO.getNodeInfo(path);
		
		String[] name= nodeInfo.getUser().split("\t");
		
		if(name.length >1){			
			result.put("userName", name[0]);
			result.put("rootName", name[1]);
		}else{
			result.put("rootName", name[0]);
			result.put("userName", "");
		}
		
		result.put("ipadr", nodeInfo.getName());
		result.put("description", nodeInfo.getDescription());
		
		return result;
	}
	
	// 노드 수정
	@Override
	public JSONObject nodeUpdate(HttpServletRequest request) {
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		nodeInfo.setName(request.getParameter("ipadr"));
		nodeInfo.setUser(request.getParameter("rootName"));
		nodeInfo.setPassword(request.getParameter("rootPW"));
		nodeInfo.setIsUser(request.getParameter("userCred"));
		nodeInfo.setUserName(request.getParameter("userName"));
		nodeInfo.setUserPw(request.getParameter("userPW"));
		nodeInfo.setDescription("'"+request.getParameter("description")+"'");
		
		result = Node.modifyNode(nodeInfo);
		
		return result;
	}
	
	// 노드 삭제
	@Override
	public JSONObject nodeDelete(HttpServletRequest request) throws Exception{
		JSONObject result = new JSONObject();
		result = Node.deleteNode(request.getParameter("ipadr"));
		return result;
	}


}
