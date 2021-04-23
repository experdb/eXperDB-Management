package com.experdb.proxy.socket.listener;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.Socket;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.experdb.proxy.server.PsP001;
import com.experdb.proxy.server.PsP002;
import com.experdb.proxy.server.PsP003;
import com.experdb.proxy.server.PsP004;
import com.experdb.proxy.server.PsP005;
import com.experdb.proxy.server.PsP006;
import com.experdb.proxy.server.PsP008;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;

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
public class DXTcontrolSocketExecute extends SocketCtl implements Runnable {
	
	private int			localport = 0;
	
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DXTcontrolSocketExecute(Socket socket) {
		client = socket;
		localport = client.getLocalPort();
	}
	
	public void run() {
		try {
			is = new BufferedInputStream(client.getInputStream());
			os = new BufferedOutputStream(client.getOutputStream());
			
			//while(true) {
				byte[] recvBuff = recv(TotalLengthBit, false);
				
				JSONParser parser=new JSONParser();
				Object obj=parser.parse(new String(recvBuff));
				
				recvBuff = null;
				
				JSONObject jObj = (JSONObject) obj;
				//JSONArray jArray=(JSONArray) jObj.get(ProtocolID._tran_req_data);
					
				String strDX_EX_CODE = (String) jObj.get(ProtocolID.DX_EX_CODE);
				
				JSONObject objSERVER_INFO = new JSONObject(); 

				switch(strDX_EX_CODE) {
				//Database List
				case TranCodeType.PsP001 :
					
					PsP001 psP001 = new PsP001(client, is, os);
					psP001.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP002 ://연결 Test
					
					PsP002 psP002 = new PsP002(client, is, os);
					psP002.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP003 :// get config file
					
					PsP003 psP003 = new PsP003(client, is, os);
					psP003.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP004 : //Config 생성
					
					PsP004 psP004 = new PsP004(client, is, os);
					psP004.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP005 : //restart
					
					PsP005 psP005 = new PsP005(client, is, os);
					psP005.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP006 : //service excute
					
					PsP006 PsP006 = new PsP006(client, is, os);
					PsP006.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP008 : // get log file
					
					PsP008 PsP008 = new PsP008(client, is, os);
					PsP008.execute(strDX_EX_CODE, jObj);
					
					break;
				}
				objSERVER_INFO = null;

			//}
			
		} catch(Exception e) {
			errLogger.error("{} {}", "experDB Socket Execute Error : ", e.toString());
		}finally{
			try{
				client.close();
			}catch(IOException e){
				errLogger.error("{} {}", "experDB Socket Close Error : ", e.toString());
			}
		}
		
	}
	

}
