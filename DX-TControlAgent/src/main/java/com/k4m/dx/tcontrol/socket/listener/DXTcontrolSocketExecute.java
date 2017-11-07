package com.k4m.dx.tcontrol.socket.listener;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
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
import com.k4m.dx.tcontrol.server.DxT007;
import com.k4m.dx.tcontrol.server.DxT008;
import com.k4m.dx.tcontrol.server.DxT010;
import com.k4m.dx.tcontrol.server.DxT011;
import com.k4m.dx.tcontrol.server.DxT012;
import com.k4m.dx.tcontrol.server.DxT013;
import com.k4m.dx.tcontrol.server.DxT014;
import com.k4m.dx.tcontrol.server.DxT015;
import com.k4m.dx.tcontrol.server.DxT016;
import com.k4m.dx.tcontrol.server.DxT017;
import com.k4m.dx.tcontrol.server.DxT018;
import com.k4m.dx.tcontrol.server.DxT019;
import com.k4m.dx.tcontrol.server.DxT020;
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
			is = new BufferedInputStream(client.getInputStream());
			os = new BufferedOutputStream(client.getOutputStream());
			
			//while(true) {
				byte[] recvBuff = recv(TotalLengthBit, false);
				
				JSONParser parser=new JSONParser();
				Object obj=parser.parse(new String(recvBuff));
				
				JSONObject jObj = (JSONObject) obj;
				//JSONArray jArray=(JSONArray) jObj.get(ProtocolID._tran_req_data);
					
				String strDX_EX_CODE = (String) jObj.get(ProtocolID.DX_EX_CODE);
				
				JSONObject objSERVER_INFO = null; 

				switch(strDX_EX_CODE) {
				//Database List
				case TranCodeType.DxT001 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT001 dxT001 = new DxT001(client, is, os);
					dxT001.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
				//table List
				case TranCodeType.DxT002 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					String strSchema = (String) jObj.get(ProtocolID.SCHEMA);
					
					DxT002 dxT002 = new DxT002(client, is, os);
					dxT002.execute(strDX_EX_CODE, objSERVER_INFO, strSchema);
					break;
				//connection Test
				case TranCodeType.DxT003 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT003 dxT003 = new DxT003(client, is, os);
					dxT003.execute(strDX_EX_CODE, objSERVER_INFO);
					break;
				//backup management
				case TranCodeType.DxT005 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					JSONArray arrCmd = (JSONArray) jObj.get(ProtocolID.ARR_CMD);
					
					DxT005 dxT005 = new DxT005(client, is, os);
					dxT005.execute(strDX_EX_CODE, arrCmd);
					break;
				//Authentication Management
				case TranCodeType.DxT006 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT006 dxT006 = new DxT006(client, is, os);
					dxT006.execute(strDX_EX_CODE, jObj);

					break;
				//Audit Log Setting
				case TranCodeType.DxT007 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					
					DxT007 dxT007 = new DxT007(client, is, os);
					dxT007.execute(strDX_EX_CODE, jObj);

					break;	
				//Search Audit Log 
				case TranCodeType.DxT008 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT008 dxT008 = new DxT008(client, is, os);
					dxT008.execute(strDX_EX_CODE, jObj);

					break;	
				//Whether to install extension
				case TranCodeType.DxT010 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT010 dxT010 = new DxT010(client, is, os);
					dxT010.execute(strDX_EX_CODE, jObj);

					break;
				//Search role 
				case TranCodeType.DxT011 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT011 dxT011 = new DxT011(client, is, os);
					dxT011.execute(strDX_EX_CODE, objSERVER_INFO);

					break;
				case TranCodeType.DxT012 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					objSERVER_INFO = (JSONObject) jObj.get(ProtocolID.SERVER_INFO);
					
					DxT012 dxT012 = new DxT012(client, is, os);
					dxT012.execute(strDX_EX_CODE, objSERVER_INFO);

					break;
				case TranCodeType.DxT013 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					
					DxT013 dxT013 = new DxT013(client, is, os);
					dxT013.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT014 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	

					DxT014 dxT014 = new DxT014(client, is, os);
					dxT014.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT015 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	

					DxT015 dxT015 = new DxT015(client, is, os);
					dxT015.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT015_DL :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	

					DxT015 dxT015_DL = new DxT015(client, is, os);
					dxT015_DL.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT016 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT016 dxT016 = new DxT016(client, is, os);
					dxT016.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT017 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT017 dxT017 = new DxT017(client, is, os);
					dxT017.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT018 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT018 dxT018 = new DxT018(client, is, os);
					dxT018.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT019 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT019 dxT019 = new DxT019(client, is, os);
					dxT019.execute(strDX_EX_CODE, jObj);

					break;
				case TranCodeType.DxT020 :
					socketLogger.info("DX_EX_CODE : " + strDX_EX_CODE);	
					
					DxT020 dxT020 = new DxT020(client, is, os);
					dxT020.execute(strDX_EX_CODE, jObj);

					break;
				}

			//}
			
		} catch(Exception e) {
			errLogger.error("{} {}", "DXTcontrolSocketExecute", e.toString());
		}
		
	}
	

}
