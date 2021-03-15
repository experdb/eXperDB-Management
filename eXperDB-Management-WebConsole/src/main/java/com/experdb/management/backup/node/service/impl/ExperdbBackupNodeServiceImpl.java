package com.experdb.management.backup.node.service.impl;

import java.io.*;
import java.lang.reflect.*;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.*;
import net.sf.json.JSONArray;

import org.json.simple.*;
import org.json.simple.parser.*;
import org.springframework.batch.core.scope.context.*;
import org.springframework.stereotype.Service;

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



	@Override
	public List<ServerInfoVO> getNodeInfoList() {
		List<TargetMachineVO> nodeList = null;
		List<ServerInfoVO> serverList = null;
		ArrayList<ServerInfoVO> result = new ArrayList<>();
		nodeList = experdbBackupNodeDAO.getNodeList();
		serverList = experdbBackupDAO.getServerInfo();
		
		for(ServerInfoVO s : serverList){
			for(TargetMachineVO n : nodeList){
				if(s.getIpadr().equals(n.getName())){
//					System.out.println("REG LIST : " + s.getIpadr() + " || " + n.getName());
					result.add(s);
				}
			}
		}
		return result;
	}



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
//					System.out.println("UNREG LIST : " + s.getIpadr() + " || " + n.getName());
					result.add(s);
				}
			}
		}
		serverList.removeAll(result);
		return serverList;
	}



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

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getNodeInfo(HttpServletRequest request) throws Exception{
//		System.out.println("GET NODE INFO SERVICE!!!");
//		System.out.println("REQUEST : " + request.getParameter("path"));
		TargetMachineVO nodeInfo = new TargetMachineVO();
		JSONObject result = new JSONObject();
		String path = request.getParameter("path");
		nodeInfo = experdbBackupNodeDAO.getNodeInfo(path);
		
//		System.out.println("nodeInfo to String : " + nodeInfo.toString());
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
	
	@Override
	public JSONObject nodeDelete(HttpServletRequest request) throws Exception{
		JSONObject result = new JSONObject();
		result = Node.deleteNode(request.getParameter("ipadr"));
		return result;
	}



	 @Override
//	public static void scheduleInsert(String exJson){
	public void scheduleInsert(HttpServletRequest request, Map<Object, String> param) {
		System.out.println("========= scheduleInsert SERVICE !!! =========");
		List<Map<String, Object>> aa = new ArrayList<Map<String, Object>>();
		String mon = param.get("mon").toString();
		String tue = param.get("tue").toString();
		String wed = param.get("wed").toString();
		String thu = param.get("thu").toString();
		String e = request.getParameter("startDate");
		System.out.println(mon);
		System.out.println(tue);
		System.out.println(wed);
		System.out.println(thu);
		System.out.println(e);
//		try {
//			JSONParser jsonParser = new JSONParser();
//			System.out.println("aaaaaaaa");
//			
//			// 여기까지
//			JSONArray jsonArray = (JSONArray) jsonParser.parse(exJson);
////			JSONObject jsonObject = (JSONObject) jsonParser.parse(exJson);
//			System.out.println("bbbbbbbbb : " + jsonArray);
//			
////			JSONArray jsonArray = (JSONArray) jsonObject.get("mon");
//			System.out.println("ddddddddd");
//
////			for(int i=0; i<jsonArray.size(); i++){
////				System.out.println("for문");
////				JSONObject schObj = (JSONObject) jsonArray.get(i);
////				System.out.println(schObj.get("st"));
////			}
//			
//		} catch (ParseException e1) {
//			e1.printStackTrace();
//			System.out.println(e1);
//		}
		////////////
		
	}
	
//	public static void main (String[] args){
////		String jsonExample = "{\"mon\":[{\"st\":\"09:45\",\"rc\":false,\"rt\":\"\",\"ret\":\"\",\"rtu\":\"\",\"repeat\":\"<b>09:45</b>\"}, {\"st\":\"09:45\",\"rc\":false,\"rt\":\"\",\"ret\":\"\",\"rtu\":\"\",\"repeat\":\"<b>09:45</b>\"}]}";
//		String jsonExample = "[{\"st\":\"09:45\",\"rc\":false,\"rt\":\"\",\"ret\":\"\",\"rtu\":\"\",\"repeat\":\"<b>09:45</b>\"}, {\"st\":\"09:45\",\"rc\":false,\"rt\":\"\",\"ret\":\"\",\"rtu\":\"\",\"repeat\":\"<b>09:45</b>\"}]";
////		String jsonExample1 = "[{'st':'09:45','rc':false,'rt':'','ret':'','rtu':'','repeat':'<b>09:45</b>'}]";
//		
//		scheduleInsert(jsonExample);
//		
//		
//	}



//	@Override
//	public void scheduleInsert(HttpServletRequest request, Map<Object, String> param) {
//		// TODO Auto-generated method stub
//		
//	}

}
