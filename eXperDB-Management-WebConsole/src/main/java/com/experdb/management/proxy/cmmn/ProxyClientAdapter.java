package com.experdb.management.proxy.cmmn;

import java.util.ArrayList;
import java.util.List;

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

public class ProxyClientAdapter {
	private final ProxyClientConnector cc;
	private final String IP;
	private final int PORT;
	public ProxyClientAdapter(String IP, int PORT){
		cc = new ProxyClientConnector();
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
		JSONArray jArray=(JSONArray) obj.get(ProxyClientProtocolID.RESULT_DATA);
		String _tran_err_msg = (String)obj.get(ProxyClientProtocolID.ERR_MSG);
		
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

	/* proxy agent setting */
	public JSONObject psP001(JSONObject jObj) throws Exception{
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	/* proxy agent Connection Test*/
	public JSONObject psP002(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy config file */
	public JSONObject psP003(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		JSONObject obj = (JSONObject) cc.recvObject();
		return obj;
	}
	
	/* proxy agent config file edit*/
	public JSONObject psP004(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy config file Read*/
	public JSONObject psP005(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy service stop/start*/
	public JSONObject psP006(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy agent interface*/
	public JSONObject psP007(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy log file*/
	public JSONObject psP008(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		JSONObject obj = (JSONObject) cc.recvObject();
		return obj;
	}
	
	/* proxy conf 파일 읽어서 데이터 입력 요청*/
	public JSONObject psP009(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
		
	}
	/* proxy keepalived 설치 확인 요청*/
	public JSONObject psP010(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}

	/* proxy backup conf 폴더 삭제 요청 */
	public JSONObject psP011(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* proxy 서버 연결 확인 */
	public JSONObject psP012(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
	
	/* 백업 설정 파일 삭제 */
	public JSONObject psP013(JSONObject jObj) throws Exception {
		byte[] bt = jObj.toString().getBytes();
		cc.send(4, bt);
		byte[]	recvBuff = cc.recv(4, false);

		return parseToJsonObj(recvBuff);
	}
}
