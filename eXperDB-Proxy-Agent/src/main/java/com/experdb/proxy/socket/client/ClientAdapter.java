package com.experdb.proxy.socket.client;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

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
		System.out.println(new String(recvBuff));
		JSONObject obj=(JSONObject)parser.parse(new String(recvBuff));
		return obj;
	}
	
	private JSONObject parseToJsonObj(String recvBuff) throws Exception{
		JSONParser parser=new JSONParser();
		JSONObject obj=(JSONObject)parser.parse(recvBuff);
		return obj;
	}
	
	public JSONObject psp001(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject psp002(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp003(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp004(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject psp005(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp006(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	
	public JSONObject psp007(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp008(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp009(JSONObject jObj) throws Exception {

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject psp010(String strDxExCode, JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}

	public JSONObject psp011(JSONObject jObj) throws Exception {

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	

}
