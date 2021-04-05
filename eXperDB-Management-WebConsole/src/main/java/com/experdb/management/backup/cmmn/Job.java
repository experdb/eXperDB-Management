package com.experdb.management.backup.cmmn;

import java.io.FileNotFoundException;
import java.io.IOException;

import org.json.simple.JSONObject;

public class Job {
	
	/**
	 * deleteJob 잡 삭제
	 * @param  job name  
	 * @return 
	 */
	public static JSONObject deleteJob(String jobName, String ipadr) {
		
		JSONObject result = new JSONObject();	
		CmmnUtil cmmUtil = new CmmnUtil();
			
		try {
			
			String path = ServiceContext.getInstance().getHomePath()+"/bin";
			String cmd = "./d2djob --delete='" + jobName+"'";
			String strCmd = "cd " + path + ";" + cmd;

			System.out.println("Job Delete CMD = " + strCmd);
		
			result = cmmUtil.execute(strCmd,"job");
			
			if (result.get("RESULT_CODE").equals(0)) {

				System.out.println("Job Delete Success ");
				 try {
					 	String fileName = ipadr.toString().replace(".", "_").trim()+".xml";				 	
					 	result = cmmUtil.execute("rm -rf "+ServiceContext.getInstance().getHomePath()+"/bin/jobs/"+fileName,"job");
					} catch (FileNotFoundException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}			
			}else{
				System.out.println("Job Delete Fail ");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	
	public static void main(String[] args) {

	}
	
}
