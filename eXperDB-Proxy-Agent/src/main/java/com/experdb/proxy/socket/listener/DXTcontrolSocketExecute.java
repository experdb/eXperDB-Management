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
import com.experdb.proxy.server.PsP007;
import com.experdb.proxy.server.PsP008;
import com.experdb.proxy.server.PsP009;
import com.experdb.proxy.server.PsP010;
import com.experdb.proxy.server.PsP011;
import com.experdb.proxy.server.PsP012;
import com.experdb.proxy.server.PsP013;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.socket.SocketCtl;
import com.experdb.proxy.socket.TranCodeType;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
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
				case TranCodeType.PsP001 : //proxy 에이전트 setting
					
					PsP001 psP001 = new PsP001(client, is, os);
					psP001.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP002 ://proxy 에이전트 연결 Test
					
					PsP002 psP002 = new PsP002(client, is, os);
					psP002.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP003 :// get config file
					
					PsP003 psP003 = new PsP003(client, is, os);
					psP003.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP004 : //proxy conf 파일 백업 & 신규 생성 
					
					PsP004 psP004 = new PsP004(client, is, os);
					psP004.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP005 : //proxy service restart
					
					PsP005 psP005 = new PsP005(client, is, os);
					psP005.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP006 : //proxy service start/stop
					
					PsP006 PsP006 = new PsP006(client, is, os);
					PsP006.execute(strDX_EX_CODE, jObj);
		
					break;
				case TranCodeType.PsP007 : //get network Interface search
					
					PsP007 PsP007 = new PsP007(client, is, os);
					PsP007.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP008 : // get log file search
					
					PsP008 PsP008 = new PsP008(client, is, os);
					PsP008.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP009 : // proxy conf 파일 searh 후 데이터 입력 요청
					
					PsP009 PsP009 = new PsP009(client, is, os);
					PsP009.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP010 : // check installed keepalived
					
					PsP010 PsP010 = new PsP010(client, is, os);
					PsP010.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP011 : // insert conf data
					
					PsP011 PsP011 = new PsP011(client, is, os);
					PsP011.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP012 : // check proxy server
					
					PsP012 PsP012 = new PsP012(client, is, os);
					PsP012.execute(strDX_EX_CODE, jObj);
					
					break;
				case TranCodeType.PsP013 : // delete backup conf File
					
					PsP013 PsP013 = new PsP013(client, is, os);
					PsP013.execute(strDX_EX_CODE, jObj);
					
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