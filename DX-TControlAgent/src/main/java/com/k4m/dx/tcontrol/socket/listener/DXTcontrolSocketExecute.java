package com.k4m.dx.tcontrol.socket.listener;

import java.net.Socket;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.server.DxT001;
import com.k4m.dx.tcontrol.server.DxT002;
import com.k4m.dx.tcontrol.server.DxT003;
import com.k4m.dx.tcontrol.server.DxT005;
import com.k4m.dx.tcontrol.server.DxT006;
import com.k4m.dx.tcontrol.server.DxT010;
import com.k4m.dx.tcontrol.server.DxT011;
import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;

public class DXTcontrolSocketExecute extends SocketCtl implements Runnable {
	
	private int			localport = 0;
	
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	
	public DXTcontrolSocketExecute(Socket socket) {
		client = socket;
		localport = client.getLocalPort();
	}
	
	public void run() {
		try {
			is = client.getInputStream();
			os = client.getOutputStream();
			
			while(true) {
				byte[] recvBuff = recv(TotalLengthBit, false);
				
				JSONParser parser=new JSONParser();
				Object obj=parser.parse(new String(recvBuff));
				
				JSONObject jObj = (JSONObject) obj;
				//JSONArray jArray=(JSONArray) jObj.get(ProtocolID._tran_req_data);
					
				String strDX_EX_CODE = (String) jObj.get(ProtocolID.DX_EX_CODE);
				
				JSONObject objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
				
				System.out.println("DX_EX_CODE : " + strDX_EX_CODE);	
				System.out.println("server_ip : " + objSERVER_INFO.get(ProtocolID.SERVER_IP));
				System.out.println("server_port : " + objSERVER_INFO.get(ProtocolID.SERVER_PORT));
				
				
				JSONObject resDataObj = new JSONObject();
				
				switch(strDX_EX_CODE) {
				case TranCodeType.DxT001 :
					DxT001 dxT001 = new DxT001(client, is, os);
					dxT001.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
				case TranCodeType.DxT002 :
					String strSchema = (String) jObj.get(ProtocolID.SCHEMA);
					
					DxT002 dxT002 = new DxT002(client, is, os);
					dxT002.execute(strDX_EX_CODE, objSERVER_INFO, strSchema);
					break;
				case TranCodeType.DxT003 :
					
					DxT003 dxT003 = new DxT003(client, is, os);
					dxT003.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
					
				case TranCodeType.DxT005 :
					
					JSONArray arrCmd = (JSONArray) jObj.get(ProtocolID.ARR_CMD);
					
					DxT005 dxT005 = new DxT005(client, is, os);
					dxT005.execute(strDX_EX_CODE, arrCmd);
					break;
				case TranCodeType.DxT006 :
					
					DxT006 dxT006 = new DxT006(client, is, os);
					dxT006.execute(strDX_EX_CODE, jObj);

					break;
					
				case TranCodeType.DxT010 :
					
					DxT010 dxT010 = new DxT010(client, is, os);
					dxT010.execute(strDX_EX_CODE, jObj);

					break;
				//role 조회
				case TranCodeType.DxT011 :
					
					DxT011 dxT011 = new DxT011(client, is, os);
					dxT011.execute(strDX_EX_CODE, objSERVER_INFO);

					break;
				}


		       
			}
			
		} catch(Exception e) {
			errLogger.error("{} {}", "DXTcontrolSocketExecute", e.toString());
		}
		
	}
	

}
