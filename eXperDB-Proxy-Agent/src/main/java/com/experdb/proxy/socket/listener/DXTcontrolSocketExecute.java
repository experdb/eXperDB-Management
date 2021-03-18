package com.experdb.proxy.socket.listener;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.Socket;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.experdb.proxy.server.DxT001;
import com.experdb.proxy.server.DxT003;
import com.experdb.proxy.server.DxT010;
import com.experdb.proxy.server.DxT019;
import com.experdb.proxy.server.DxT020;
import com.experdb.proxy.server.DxT021;
import com.experdb.proxy.server.DxT022;
import com.experdb.proxy.server.DxT027;
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
				case TranCodeType.DxT001 :
						
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT001 dxT001 = new DxT001(client, is, os);
					dxT001.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
				case TranCodeType.DxT003 :
						
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT003 dxT003 = new DxT003(client, is, os);
					dxT003.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
				//Whether to install extension
				case TranCodeType.DxT010 :
						
					
					DxT010 dxT010 = new DxT010(client, is, os);
					dxT010.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT019 :
						
					
					DxT019 dxT019 = new DxT019(client, is, os);
					dxT019.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT020 :
						
					
					DxT020 dxT020 = new DxT020(client, is, os);
					dxT020.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT021 :
						
					
					DxT021 dxT021 = new DxT021(client, is, os);
					dxT021.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT022 :
						
					
					DxT022 dxT022 = new DxT022(client, is, os);
					dxT022.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT027 :

					
					DxT027 dxT027 = new DxT027(client, is, os);
					dxT027.execute(strDX_EX_CODE, jObj);
			
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
