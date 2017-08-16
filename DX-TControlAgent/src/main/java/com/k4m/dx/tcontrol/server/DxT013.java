package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.k4m.dx.tcontrol.db.repository.service.SystemServiceImpl;
import com.k4m.dx.tcontrol.db.repository.vo.TrfTrgCngVO;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

/**
 * BottledWater 실행/종료
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 * </pre>
 */

public class DxT013 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DxT013(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		
		String execTxt = (String) jObj.get(ProtocolID.EXEC_TXT);
		String commandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		String trfTrgId = (String) jObj.get(ProtocolID.TRF_TRG_ID);
		
		ApplicationContext context;

		context = new ClassPathXmlApplicationContext(new String[] {"context-tcontrol.xml"});
		SystemServiceImpl service = (SystemServiceImpl) context.getBean("SystemService");
		
	
		
		JSONObject outputObj = new JSONObject();
		
		try {
			
			if(commandCode.equals(ProtocolID.RUN)) {
				
				
				long pid = shellCmd(execTxt);
				
				if(pid > 0) {
					TrfTrgCngVO vo = new TrfTrgCngVO();
					vo.setBW_PID((int)pid);
					vo.setTRF_TRG_ID(Integer.parseInt(trfTrgId));
					
					service.updateT_TRFTRGCNG_I(vo);
				}
			} else if(commandCode.equals(ProtocolID.STOP)) {
				shellCmd(execTxt);
				
				TrfTrgCngVO vo = new TrfTrgCngVO();
				vo.setBW_PID(0);
				vo.setTRF_TRG_ID(Integer.parseInt(trfTrgId));
				
				service.updateT_TRFTRGCNG_I(vo);
			}
			
			
			outputObj = DxT013ResultJSON(strDxExCode, strSuccessCode, strErrCode, strErrMsg);
	        
	        sendBuff = outputObj.toString().getBytes();
	        send(4, sendBuff);

			
		} catch (Exception e) {
			errLogger.error("DxT013 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT013);
			outputObj.put(ProtocolID.ERR_MSG, "DxT013 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);
			
		} finally {
		}	

	}
	
	   public static long shellCmd(String command) throws Exception {
           Runtime runtime = Runtime.getRuntime();
           
           Process process = runtime.exec(new String[]{"/bin/sh", "-c", command});
           
           long pid = getPidOfProcess(process);
           
           InputStream is = process.getInputStream();
           InputStreamReader isr = new InputStreamReader(is);
           BufferedReader br = new BufferedReader(isr);
           String line;
           while((line = br.readLine()) != null) {
                          System.out.println(line);
           }
           
           return pid;
	   }
	   
	   public static synchronized long getPidOfProcess(Process p) {
		    long pid = -1;

		    try {
		      if (p.getClass().getName().equals("java.lang.UNIXProcess")) {
		        Field f = p.getClass().getDeclaredField("pid");
		        f.setAccessible(true);
		        pid = f.getLong(p);
		        f.setAccessible(false);
		      }
		    } catch (Exception e) {
		      pid = -1;
		    }
		    return pid;
		  }


}
