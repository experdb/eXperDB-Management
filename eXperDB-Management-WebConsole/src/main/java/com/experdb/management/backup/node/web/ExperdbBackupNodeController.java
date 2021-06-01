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
import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;

@Controller
public class ExperdbBackupNodeController {
	
	@Autowired
	private ExperdbBackupNodeService experdbBackupNodeService;
	
	@Autowired
	private AccessHistoryService accessHistoryService;
	
	
	/**
	 * 노드 리스트를 조회한다.(안씀)
	 * 
	 * @param request
	 * @return List<TargetMachineVO>
	 * @throws Exception
	 */
	@RequestMapping(value = "/experdb/getNodeList.do")
	public @ResponseBody List<TargetMachineVO> getNodeList(HttpServletRequest request, HttpServletResponse response) {
		List<TargetMachineVO> resultSet = null;
		try {	
			resultSet = experdbBackupNodeService.getNodeList();	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}
	
	/**
	 * 등록된 노드 리스트를 조회한다.
	 * 
	 * @param request
	 * @return List<ServerInfoVO>
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/experdb/backupNodeList.do")
	public @ResponseBody JSONObject getNodeInfoList(){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupNodeService.getNodeInfoList();
		} catch (FileNotFoundException e) {
			result.put("result", 11111);
			e.printStackTrace();
		} catch (IOException e) {
			result.put("result", 11111);
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 등록되지 않은 노드 정보를 조회한다.
	 * 
	 * @param request
	 * @return List<ServerInfoVO>
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/backupUnregNodeList.do")
	public @ResponseBody List<ServerInfoVO> getUnregNodeList(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		
		try {
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0163_01");
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return experdbBackupNodeService.getUnregNodeList();
	}
	
	/**
	 * 노드 정보를 등록한다.
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/backupNodeReg.do")
	public @ResponseBody JSONObject nodeInsert(HttpServletRequest request){
		JSONObject result = new JSONObject();
		result = experdbBackupNodeService.nodeInsert(request);
		return result;
	}
	
	/**
	 * 노드 정보를 조회한다.
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/experdb/backupNodeInfo.do")
	public @ResponseBody JSONObject getNodeInfo(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request){
		JSONObject result = new JSONObject();
		try {
			
			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0163_02");
			accessHistoryService.insertHistory(historyVO);
			
			result = experdbBackupNodeService.getNodeInfo(request);
			result.put("resultCode", "11111");
		} catch (Exception e) {
			result.put("resultCode", "00000");
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 노드 정보를 수정한다.
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/backupNodeModi.do")
	public @ResponseBody JSONObject nodeUpdate(HttpServletRequest request){
		JSONObject result = new JSONObject();
		result = experdbBackupNodeService.nodeUpdate(request);
		return result;
	}
	
	/**
	 * 노드를 삭제한다
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
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

}
