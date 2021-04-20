package com.k4m.dx.tcontrol.cmmn.client;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

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

/*		JSONObject jObj = new JSONObject();

		jObj.put(ClientProtocolID.DX_EX_CODE, ClientTranCodeType.CLOSE);
		
		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);*/
		
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
	
	public JSONObject dxT007(String strDxExCode, String strCommandCode, JSONObject serverObj, JSONObject objSettingInfo) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.COMMAND_CODE, strCommandCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
		jObj.put(ClientProtocolID.SETTING_INFO, objSettingInfo);
		
		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT007(String strDxExCode, String strCommandCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.COMMAND_CODE, strCommandCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);
		
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
	
	public JSONObject dxT012(String strDxExCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT013(String strDxExCode, JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT014(String strDxExCode, JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT015(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		


		//String strData = cc.receiveMessage();
		//String strData = cc.receiveMessageData();
		byte[]	recvBuff = cc.recv(4, false);
		//JSONObject obj = (JSONObject) cc.recvObject();
		//String strData = cc.byteArrayOutputStreamReceiveMessage();
		return parseToJsonObj(recvBuff);

	}
	
	public JSONObject dxT015_V(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		


		//String strData = cc.receiveMessage();
		//String strData = cc.receiveMessageData();
		//byte[]	recvBuff = cc.recv(4, false);
		JSONObject obj = (JSONObject) cc.recvObject();
		//String strData = cc.byteArrayOutputStreamReceiveMessage();
		//return parseToJsonObj(strData);
		return obj;
	}
	
	public void dxT015_DL(JSONObject jObj, HttpServletRequest request, HttpServletResponse response ) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		
		String strFileName = (String) jObj.get(ClientProtocolID.FILE_NAME);

		cc.recvFileDownLoad(strFileName, request, response);

	}
	
	public JSONObject dxT016(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT017(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT018(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT019(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT020(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT021(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT022(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT023(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT024(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT025(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT026(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT027(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT028(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT029(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT030(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	public JSONObject dxT031(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT032(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	

	public JSONObject dxT033(String strDxExCode, JSONObject serverObj) throws Exception {
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}
	
	
	public JSONObject dxT034(JSONObject jObj) throws Exception{

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	/* scale 관련 agent*/
	public JSONObject dxT036(JSONObject jObj) throws Exception{
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT037(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT038(JSONObject jObj) throws Exception {

		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT039(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT040(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	/**
	 * topic 조회
	 * @param strDxExCode
	 * @param serverObj
	 * @return
	 * @throws Exception
	 */
	public JSONObject dxT041(String strDxExCode, JSONObject serverObj) throws Exception{
		JSONObject jObj = new JSONObject();
		jObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		jObj.put(ClientProtocolID.SERVER_INFO, serverObj);

		byte[] bt = jObj.toString().getBytes();
		
		cc.send(4, bt);
		
		byte[]	recvBuff = cc.recv(4, false);
		return parseToJsonObj(recvBuff);
	}

	public JSONObject dxT042(JSONObject jObj) throws Exception {
		
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
}
