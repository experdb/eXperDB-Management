package com.k4m.dx.tcontrol.scale.cmmn;

import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Component;
import org.springframework.util.ResourceUtils;

/**
* @author 
* @see aws scale 연동 관련 class
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
@Component
public class InstanceScaleConnect {
	public static JSONObject scaleSetStart(JSONObject obj) throws Exception {	
        JSONObject result = new JSONObject();

        
        
        String scale_path = "";
        String strCmd = "";
        
        String loginId = obj.get("login_id").toString();
        
		Properties props = new Properties();
		props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	
		
		//구분값 : yyyMMddHHmmss
		SimpleDateFormat formatDate = new SimpleDateFormat ( "yyyMMddHHmmss");
		Date time = new Date();
		String timeId = formatDate.format(time);
		
		String scaleServer = (String)props.get("scale_server");

		//명령어 setting
		String scaleGbn = obj.get("scale_gbn").toString();
		if ("scaleIn".equals(scaleGbn)) {
			scale_path = props.get("scale_in_cmd").toString();
			//strCmd = "ssh -o StrictHostKeyChecking=no ec2-user@13.125.214.46 \"sudo su - experdb -c \'/home/experdb/.scale_inout/pg_aws scale-in -id " + timeId + "\'\"";
			strCmd = String.format(scaleServer + " " + scale_path + " ", timeId);
		} else if ("scaleOut".equals(scaleGbn)) {
			scale_path = props.get("scale_out_cmd").toString();
			//strCmd = "ssh -o StrictHostKeyChecking=no ec2-user@13.125.214.46 \"sudo su - experdb -c \'/home/experdb/.scale_inout/pg_aws scale-out -id " + timeId + "\'\"";
			strCmd = String.format(scaleServer + " " + scale_path + " ", timeId);
		}

        try {    
			//scale 일경우 실행함
			if ("scaleIn".equals(scaleGbn) || "scaleOut".equals(scaleGbn)) {
				//scale thread
				ThreadScale threadScale = new ThreadScale(strCmd, timeId, scaleGbn, 0, loginId);
				threadScale.start();
				
				//scale 확인
				ThreadScale threadScaleWatch = new ThreadScale(strCmd, timeId, scaleGbn, 1, loginId);
				threadScaleWatch.start();

	            result.put("RESULT", "SUCCESS");
			}
        } catch (Exception e) {
        	result.put("RESULT", "FAIL");
            e.printStackTrace();
        }

		return result;		
	}
	
	@SuppressWarnings("unchecked")
	public static void main(String args[]) {
		
		JSONObject obj = new JSONObject();

		try {
			Map<String, Object> result  = scaleSetStart(obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}