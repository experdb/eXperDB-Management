package com.k4m.dx.tcontrol.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;


/**
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class ScaleRunCommandExec extends Thread{

	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");

	public String strCmd;
	public String timeId;
	public String scaleGbn;
	public String loginId;
	public int iMode;
	public String retVal;
	
	private String returnMessage = "";
	
	ApplicationContext context;

	public ScaleRunCommandExec(String _strCmd, String _timeId, String _scaleGbn, int _iMode, String loginId) {
		this.strCmd=_strCmd; //cmd값
		this.timeId=_timeId; //구분 time값(yyyymmddhhmmss)
		this.scaleGbn = _scaleGbn; //스켕릴구분
		this.iMode=_iMode; //구분값
		this.loginId = loginId;
		
		context = new ClassPathXmlApplicationContext(new String[] { "context-tcontrol.xml" });
	}
	
	public String call(){
		return this.retVal;
	}
	
	public String getMessage() {
		return this.returnMessage;
	}

	@Override
	public void run() {//Thread.start()시 실행되는 함수,
		String strResult = "";
		String strReturnVal = "";
		String strResultErrInfo = "";
		
        BufferedReader successBufferReaderRe = null; // 성공 버퍼
        BufferedReader errorBufferReaderRe = null; // 오류 버퍼

        SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
        Map<String, Object> logParam = new HashMap<String, Object>();			

		if(iMode == 0) {
			Process p = null;
			try {
				Runtime runtime = Runtime.getRuntime();
				String[] cmdPw = {"/bin/sh","-c", strCmd};
				p = runtime.exec(cmdPw);

				logParam = logSetting(timeId, scaleGbn, loginId, "insert", strResult, retVal);
				service.insertScaleLog_G(logParam);

				p.waitFor();

				if ( p.exitValue() != 0 ) {   
					successBufferReaderRe = new BufferedReader(new InputStreamReader(p.getInputStream()));
					while ( successBufferReaderRe.ready() ) {
						strResultErrInfo += successBufferReaderRe.readLine();
					}
	
					errorBufferReaderRe = new BufferedReader ( new InputStreamReader ( p.getErrorStream() ) );
					while ( errorBufferReaderRe.ready() ) {
						strResult += errorBufferReaderRe.readLine();
					}
						
					strResult += strResultErrInfo;
					strReturnVal = "failed";
	
					socketLogger.info("err.ready() --> " + strResult);
						
				} else {
					successBufferReaderRe = new BufferedReader ( new InputStreamReader ( p.getInputStream() ) );
	
					while ( successBufferReaderRe.ready() ) {
						strResult += successBufferReaderRe.readLine();
						
						socketLogger.info("out.ready() --> " + strResult);
					}
							
					strReturnVal = "success";		
				}

				this.returnMessage = strResult;
				this.retVal = strReturnVal;
				
				logParam = logSetting(timeId, scaleGbn, loginId, "update", strResult, retVal);
				service.insertScaleLog_G(logParam);

			}catch(IOException e){
				System.out.println(e);
				this.retVal = "IOException" + e.toString();
				this.returnMessage = "IOException" + e.toString();
			}catch(Exception e) {
				System.out.println(e);
				this.retVal = "Exception" + e.toString();
				this.returnMessage = "Exception" + e.toString();
			}finally {
				p.destroy();
				if (successBufferReaderRe != null) {
					try {
						successBufferReaderRe.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
	
				if (errorBufferReaderRe != null) {
					try {
						errorBufferReaderRe.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
						
				System.out.println("Exec End");
			}
				
		} else if(iMode == 1) { //scale 진행현황 조회
			for(int i = 0 ; i < 1000 ; i++) {
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					socketLogger.info("Scale Process End");
				}

				Process pw = null;
				BufferedReader successBufferReader = null; // 성공 버퍼

				try {
					Runtime runtimeW = Runtime.getRuntime();
					String[] cmdPw = {"/bin/sh","-c", strCmd};

					pw = runtimeW.exec(cmdPw);

					String strRstCnt = null;  
					successBufferReader = new BufferedReader(new InputStreamReader(pw.getInputStream()));

    				while ((strRstCnt = successBufferReader.readLine()) != null) {
    					socketLogger.info("---------------------------------------------------------------------------------------------------------");
    					socketLogger.info(strRstCnt);
    					socketLogger.info("---------------------------------------------------------------------------------------------------------");

        				strRstCnt = strRstCnt.trim();
        				if(strRstCnt.equals("0") ) //0일 경우 scale process 완료
        				{
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
	}

	public static void main(String[] args) throws Exception {
		RunCommandExec runCommandExec = new RunCommandExec();
		
		String path = runCommandExec.getClass().getResource("/").getPath();
		
		System.out.println(path);
	}
	/**
	 * log값 setting
	 * 
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> logSetting(String timeId, String scaleGbn, String loginId, String saveGbn, String strResult, String retVal){
		Map<String, Object> logParam = new HashMap<String, Object>();

		if ("insert".equals(saveGbn)) {		   	
			if ("scaleIn".equals(scaleGbn)) {  //scale_gbn setting
				logParam.put("scale_gbn", "1");
			} else {
				logParam.put("scale_gbn", "2");
			}
			
			logParam.put("wrk_id", 1);

		    logParam.put("wrk_strt_dtm", nowTime());
		    logParam.put("wrk_end_dtm", nowTime());
		    logParam.put("exe_rslt_cd", "TC001701");

			if (strResult != null) {
				if (strResult.length() > 1000) {
					logParam.put("rslt_msg", strResult.substring(0, 1000));
				} else {
					logParam.put("rslt_msg", strResult);
				}
			} else {
				logParam.put("rslt_msg", "");
			}
			
			logParam.put("frst_regr_id", loginId);
			logParam.put("lst_mdfr_id", loginId);

			//차후 추가
			logParam.put("instance_id", timeId);
			logParam.put("instance_nm", "");

		    logParam.put("saveGbn", saveGbn);
		    logParam.put("return_val", "");
		} else {
			logParam.put("login_id", loginId);
			logParam.put("instance_id", timeId);
			logParam.put("wrk_id", 2);
			logParam.put("wrk_end_dtm", nowTime());
		    logParam.put("saveGbn", saveGbn);
		    logParam.put("return_val", retVal);

			if (!retVal.isEmpty()) {
				if (!"success".equals(retVal)) {
					logParam.put("exe_rslt_cd", "TC001702");
					logParam.put("rslt_msg", strResult);
				} else {
					logParam.put("exe_rslt_cd", "TC001701");
					logParam.put("rslt_msg", "");
				}
			}
		}

		return logParam;
	}

	/**
	 * 현재시간 조회
	 * 
	 * @return String
	 * @throws Exception
	 */
	public static String nowTime(){
		Calendar calendar = Calendar.getInstance();				
        java.util.Date date = calendar.getTime();
        String today = (new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		return today;
	}
}