package com.k4m.dx.tcontrol.socket.client;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class ClientAdapter {
	private final ClientConnector cc;
	private final String IP;
	private final int PORT;
	public ClientAdapter(String IP, int PORT){
		cc = new ClientConnector();
		this.IP = IP;
		this.PORT = PORT;
	}
	
	/**
	 * socket Open
	 * @throws Exception
	 */
	public void open() throws Exception{
		cc.create(IP, PORT);
	}
	
	/**
	 * socket close
	 * @throws Exception
	 */
	public void close() throws Exception{

		JSONObject jObj = new JSONObject();

		jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.CLOSE);
		
		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		cc.close();
	}
	
	private List<String> SubReqMsg(byte[] recvBuff) throws Exception{
		JSONParser parser=new JSONParser();
		JSONObject obj=(JSONObject)parser.parse(new String(recvBuff));
		JSONArray jArray=(JSONArray) obj.get(ClientProtocolID.RESULT_DATA);
		String _tran_err_msg = (String)obj.get(ClientProtocolID.ERR_MSG);
		
		if (_tran_err_msg == null){
			List<String> _tran_req_data = new ArrayList<String>();
			if (jArray != null){		
				for(Object map: jArray){
					_tran_req_data.add((String)map);
				}
			}
			
			return _tran_req_data;
		}else{
			throw new Exception(_tran_err_msg);
		}
		
	}
	
	/**
	 * 
	 * @param recvBuff
	 * @return
	 * @throws Exception
	 */
	private JSONObject parseToJsonObj(byte[] recvBuff) throws Exception{
		JSONParser parser=new JSONParser();
		JSONObject obj=(JSONObject)parser.parse(new String(recvBuff));
		return obj;
	}
	
	/**
	 * DB List 조회
	 * @param tran_cd
	 * @param serverObj
	 * @return
	 * @throws Exception
	 */
	public JSONObject dxT001(String strDxExCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	
	/**
	 * table List 조회
	 * @param tran_cd
	 * @param serverObj
	 * @return
	 * @throws Exception
	 */
	public JSONObject dxT002(String strDxExCode, JSONObject serverObj, String strSchema) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
		jObj.put(ClientProtocolID.SCHEMA, strSchema);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT003(String strDxExCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);


		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT005(JSONObject reqJObj) throws Exception{


		byte[] bt = reqJObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT006(String strDxExCode, JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT010(String strDxExCode, JSONObject serverObj, String extname) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
		jObj.put(ClientProtocolID.EXTNAME, extname);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	/**
	 * role name 조회
	 * @param strDxExCode
	 * @param serverObj
	 * @return
	 * @throws Exception
	 */
	public JSONObject dxT011(String strDxExCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
}
