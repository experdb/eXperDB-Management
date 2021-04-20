package com.experdb.management.backup.policy.web;

import java.io.*;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.xml.sax.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.policy.service.*;
import com.k4m.dx.tcontrol.cmmn.client.ClientInfoCmmn;
import com.k4m.dx.tcontrol.common.service.AgentInfoVO;
import com.k4m.dx.tcontrol.common.service.CmmnServerInfoService;

@Controller
public class ExperdbBackupPolicyController {
	
	@Autowired
	private ExperdbBackupPolicyService experdbBackupPolicyService;
	
	@Autowired
	private CmmnServerInfoService cmmnServerInfoService;
	
	/**
	 * 백업 정책을 등록한다
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/backupScheduleReg.do")
	public @ResponseBody JSONObject scheduleInsert(HttpServletRequest request,@RequestParam Map<Object, String> param){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupPolicyService.scheduleInsert(request, param);
			result.put("RESULT_CODE", 0);
		} catch (IOException e) {
			System.out.println("Controller IOException");
			result.put("RESULT_CODE", 2);
		} catch (Exception e) {
			System.out.println("Controller Exception");
			result.put("RESULT_CODE", 1);
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 백업 정책을 불러온다
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/getScheduleInfo.do")
	public @ResponseBody JSONObject getScheduleInfo(HttpServletRequest request){
		JSONObject result = new JSONObject();
		try {
			result = experdbBackupPolicyService.getScheduleInfo(request);
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
	
	/**
	 * 백업 정책을 삭제한다
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping(value="/experdb/jobDelete.do")
    public @ResponseBody JSONObject jobDelete(HttpServletRequest request) {
    		JSONObject result =new JSONObject();
    	try {

    		String ipadr = request.getParameter("ipadr");
    		String jobName = request.getParameter("jobName");
    		
    		result = Job.deleteJob(jobName, ipadr);

    		System.out.println("RESULT_CODE = "+result.get("RESULT_CODE"));
    		System.out.println("RESULT_DATA = "+result.get("RESULT_DATA"));
    		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
    }
	
    
    
	/**
	 * 볼륨리스트
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
	@RequestMapping(value="/experdb/getVolumes.do")
	public @ResponseBody JSONObject getVolumes(HttpServletRequest request,@RequestParam Map<Object, String> param){
		
		JSONObject result = new JSONObject();
		AgentInfoVO vo = new AgentInfoVO();
		try {
			
			String ipadr = request.getParameter("ipadr");
			
			vo.setIPADR(ipadr);
			
			AgentInfoVO agentInfo =  (AgentInfoVO) cmmnServerInfoService.selectAgentInfo(vo);
			String IP = ipadr;
			int PORT = agentInfo.getSOCKET_PORT();

			ClientInfoCmmn conn  = new ClientInfoCmmn();
			result = conn.getVolumes( IP, PORT);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}
