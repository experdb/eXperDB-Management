package com.experdb.management.backup.node.web;

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.xml.sax.*;

import com.experdb.management.backup.node.service.*;
import com.experdb.management.backup.service.*;

@Controller
public class ExperdbBackupNodeController {
	
	@Autowired
	private ExperdbBackupNodeService experdbBackupNodeService;
	
	
	
	/**
	 * 노드 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/getNodeList.do")
	public @ResponseBody List<TargetMachineVO> getNodeList(HttpServletRequest request, HttpServletResponse response) {
			
		List<TargetMachineVO> resultSet = null;
		//Map<String, Object> param = new HashMap<String, Object>();
		try {	
					resultSet = experdbBackupNodeService.getNodeList();	
					
					// System.out.println(resultSet.get(0).getOperatingSystem());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;

	}
	
	@RequestMapping(value="/experdb/backupNodeList.do")
	public @ResponseBody List<ServerInfoVO> getNodeInfoList(){
		return experdbBackupNodeService.getNodeInfoList();
	}
	
	@RequestMapping(value="/experdb/backupUnregNodeList.do")
	public @ResponseBody List<ServerInfoVO> getUnregNodeList(){
		return experdbBackupNodeService.getUnregNodeList();
	}
	
	@RequestMapping(value="/experdb/backupNodeReg.do")
	public @ResponseBody JSONObject nodeInsert(HttpServletRequest request){
		JSONObject result = new JSONObject();
		result = experdbBackupNodeService.nodeInsert(request);
		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value="/experdb/backupNodeInfo.do")
	public @ResponseBody JSONObject getNodeInfo(HttpServletRequest request){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupNodeService.getNodeInfo(request);
			result.put("resultCode", "11111");
		} catch (Exception e) {
			result.put("resultCode", "00000");
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value="/experdb/backupNodeModi.do")
	public @ResponseBody JSONObject nodeUpdate(HttpServletRequest request){
		JSONObject result = new JSONObject();
		result = experdbBackupNodeService.nodeUpdate(request);
		return result;
	}
	
	@RequestMapping(value="/experdb/backupNodeDel.do")
	public @ResponseBody JSONObject nodeDelete(HttpServletRequest request){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupNodeService.nodeDelete(request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value="/experdb/backupScheduleReg.do")
	public @ResponseBody JSONObject scheduleInsert(HttpServletRequest request,@RequestParam Map<Object, String> param){
		JSONObject result = new JSONObject();
		try {
			experdbBackupNodeService.scheduleInsert(request, param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value="/experdb/getScheduleInfo.do")
	public @ResponseBody JSONObject getScheduleInfo(HttpServletRequest request){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupNodeService.getScheduleInfo(request);
			result.put("RESULT_CODE", 0);
		} catch (IOException e){
			System.out.println("Controller IOException");
			result.put("RESULT_CODE", 2);
		} catch (SAXException e) {
			System.out.println("Controller SAXException");
			result.put("RESULT_CODE", 3);
			e.printStackTrace();
		} catch (Exception e) {
			System.out.println("Controller Exception");
			result.put("RESULT_CODE", 1);
			e.printStackTrace();
		}
		return result;
	}

}
