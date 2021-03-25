package com.experdb.management.backup.job.web;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.experdb.management.backup.cmmn.Job;



@Controller
public class ExperdbBackupJobController {
	
	
    @RequestMapping(value="/experdb/nfsValidation.do")
    public @ResponseBody JSONObject nfsTest(HttpServletRequest request) {
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
    
}
