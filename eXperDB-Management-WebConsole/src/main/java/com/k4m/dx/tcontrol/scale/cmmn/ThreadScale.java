package com.k4m.dx.tcontrol.scale.cmmn;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.springframework.util.ResourceUtils;

import com.k4m.dx.tcontrol.scale.service.InstanceScaleService;

/**
* @author 
* @see aws scale thead 관련 class
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
public class ThreadScale extends Thread{

	private InstanceScaleService instanceScaleService;

	String strCmd;
	String timeId;
	String scaleGbn;
	String loginId;
	int iMode; // 0 : scale mode , 1 : watch mode

	public ThreadScale(String _strCmd, String _timeId, String _scaleGbn, int _iMode, String loginId) {
		this.strCmd=_strCmd; //cmd값
		this.timeId=_timeId; //구분 time값(yyyymmddhhmmss)
		this.scaleGbn = _scaleGbn; //스켕릴구분
		this.iMode=_iMode; //구분값
		this.loginId = loginId;
		
		instanceScaleService = (InstanceScaleService) ScaleBeanUtils.getBean("InstanceScaleServiceImpl");
	}

	@Override
	public void run() {//Thread.start()시 실행되는 함수,
		System.out.println("Thread Start: "+this.strCmd);
/*        StringBuffer successOutput = new StringBuffer(); // 성공 스트링 버퍼
        StringBuffer errorOutput = new StringBuffer(); // 오류 스트링 버퍼
        BufferedReader successBufferReaderRe = null; // 성공 버퍼
        BufferedReader errorBufferReaderRe = null; // 오류 버퍼

        String msg = null;
*/
        String errorChk = null;

		if(iMode == 0) {
			System.out.println("Scale Run Start");
			Process p = null;
			try {
				Runtime runtime = Runtime.getRuntime();
				String[] cmdPw = {"/bin/sh","-c", strCmd};
				p = runtime.exec(cmdPw);
				
/*	            successBufferReaderRe = new BufferedReader(new InputStreamReader(p.getInputStream()));
	            while ((msg = successBufferReaderRe.readLine()) != null) {
	            	System.out.println("===msg==" + msg);
	                successOutput.append(msg + System.getProperty("line.separator"));
	            }
	 
	            // shell 실행시 에러가 발생했을 경우
	            errorBufferReaderRe = new BufferedReader(new InputStreamReader(p.getErrorStream()));
	            while ((msg = errorBufferReaderRe.readLine()) != null) {
	            	System.out.println("===msg111==" + msg);
	                errorOutput.append(msg + System.getProperty("line.separator"));
	            }*/
			
				Map<String, Object> logParam = new HashMap<String, Object>();
				logParam.put("errorChk", errorChk);

				instanceScaleService.scaleThreadLogSave(timeId, scaleGbn, loginId, "insert", logParam);

				p.waitFor();
			}catch(Exception e) {
				e.printStackTrace();
				System.out.println("Scale Run Error");
			} finally {
				try {
					p.destroy();
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}

			System.out.println("Scale Run End");

		} else if(iMode == 1) { //scale 진행현황 조회
			for(int i = 0 ; i < 1000 ; i++) {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.out.println("Scale Process End");
				}

				Process pw = null;
				BufferedReader successBufferReader = null; // 성공 버퍼

				try {
					Runtime runtimeW = Runtime.getRuntime();
			        
					Properties props = new Properties();
					props.load(new FileInputStream(ResourceUtils.getFile("classpath:egovframework/tcontrolProps/globals.properties")));	

					String strWatch = props.get("scale_chk_prgress").toString();
					String scaleServer = (String)props.get("scale_server");

					String strPs = String.format(strWatch, timeId);
					String[] cmdPw = {"/bin/sh","-c",scaleServer + " " + strPs};

					pw = runtimeW.exec(cmdPw);

					String strRstCnt = null;  
					successBufferReader = new BufferedReader(new InputStreamReader(pw.getInputStream()));
					
					Map<String, Object> logParam = new HashMap<String, Object>();

    				while ((strRstCnt = successBufferReader.readLine()) != null) {
    					System.out.println("---------------------------------------------------------------------------------------------------------");
        				System.out.println(strRstCnt);
        				System.out.println("---------------------------------------------------------------------------------------------------------");

        				strRstCnt = strRstCnt.trim();
        				if(strRstCnt.equals("0") ) //0일 경우 scale process 완료
        				{
    						//log 수정
							instanceScaleService.scaleThreadLogSave(timeId, scaleGbn, loginId, "update", logParam);
        					return;
        				}
    	            }

					pw.waitFor();
				}catch(IOException e) {
					System.out.println("Scale Process End-IOException");
					e.printStackTrace();
				}catch(RuntimeException e) {
					System.out.println("Scale Process End-RuntimeException");
					e.printStackTrace();
		        } catch (SQLException e) {
					System.out.println("Scale Process End-SQLException");
		            e.printStackTrace();
				}catch(Exception e) {
					System.out.println("Scale Process End");
					e.printStackTrace();
				} finally {      	
		            try {
		            	pw.destroy();
		                if (successBufferReader != null) successBufferReader.close();
		            } catch (IOException e1) {
		                e1.printStackTrace();
		            }
		        }
    		}
    	}
		System.out.println("Thread end :" + this.strCmd);
	}
}