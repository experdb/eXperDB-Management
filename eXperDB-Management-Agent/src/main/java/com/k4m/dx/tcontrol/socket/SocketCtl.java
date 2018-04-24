package com.k4m.dx.tcontrol.socket;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.db.repository.vo.PgAuditSettingVO;
import com.k4m.dx.tcontrol.db.repository.vo.PgAuditVO;
import com.k4m.dx.tcontrol.util.CommonUtil;

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
public class SocketCtl {
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public static final int TotalLengthBit = 4;
	private static int		DEFAULT_TIMEOUT = 30;
	private static int		DEFAULT_BUFFER_SIZE = 1024;
	
	protected String		_caller = "unknown";	
	
	protected String	ipaddr;
	protected int		port;
	protected int		timeout = DEFAULT_TIMEOUT;
	protected int		bufferSize = DEFAULT_BUFFER_SIZE;
	
	protected Socket		client = null;
	protected BufferedInputStream	is = null;
	protected BufferedOutputStream	os = null;
	
	private String		sendmsg = "";
	private String		recvmsg = "";
	
	private String		srccharset = "";
	private String		dstcharset = "";
	
	public void setTimeout(int timeout) {
		this.timeout	= timeout;
		
		if (client != null) {
			try {
				client.setSoTimeout(this.timeout * 1000);
			} catch (Exception e) {
			}
		}
	}
	
	public int getTimeout() {
		return this.timeout;
	}
	
	public void setBufferSize(int bufferSize) {
		this.bufferSize		= bufferSize;
	}
	
	public int getBufferSize() {
		return this.bufferSize;
	}
	
	public void trx(String msg) throws Exception, IOException {
		sendmsg = msg;
		
		send(sendmsg.getBytes());
		recvmsg	= new String(recv(10, false));
	}
	public String getSendMsg() {
		return sendmsg;
	}
	
	public String getRecvMsg() {
		return recvmsg;
	}
	
	public void send(byte[] buff) throws Exception{
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		
		os.write(buff);
		os.flush();
	}
	
	public void send(int lengthFieldSize, byte[] buff) throws Exception{
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		CommonUtil util = new CommonUtil();
		byte[] intb = util.intToByteArray(lengthFieldSize+buff.length);
		util = null;
		
		byte[] temp = new byte[lengthFieldSize + buff.length];
		System.arraycopy(intb, 0, temp, 0, lengthFieldSize);
		System.arraycopy(buff, 0, temp, 4, buff.length);
		os.write(temp);
		intb = null;
		buff = null;
		temp = null;
		os.flush();
		os.close();
	
	}
	
	public void send(byte[] buff, int index, int length) throws Exception {
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
	
		os.write(buff, index, length);
		os.flush();
		os.close();
	}
	
	public void send(Object obj) throws Exception{
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		
		ObjectOutputStream oos = new ObjectOutputStream(os);
		oos.writeObject(obj);
		oos.flush();
		
		obj = null;
		oos.close();
		oos = null;
	}
	
	public void send(File file) throws Exception{
		
		BufferedInputStream bufferedinputstream = null;
		try {
			socketLogger.info("send : " + TranCodeType.DxT015_DL);
			
			//BufferedOutputStream out = new BufferedOutputStream( client.getOutputStream() );
			
			//OutputStream outputstream = client.getOutputStream();
			client.setReceiveBufferSize(50000);
			client.setSendBufferSize(50000);

			 bufferedinputstream = new BufferedInputStream(new FileInputStream(file));
			 
			 byte readByte[] = new byte[4096];
             int readCount = 0;
             while ((readCount = bufferedinputstream.read(readByte, 0, 4096)) != -1) {
            // while ((bytesRead = fileIn.read(buffer)) != -1) {
            	 socketLogger.info(readByte + " " + readCount);
                 os.write(readByte, 0, readCount);
             }
             socketLogger.info("out.flush() : " + TranCodeType.DxT015_DL);
             os.flush();
             os.close();


		} catch(Exception e) {
			e.printStackTrace();
			errLogger.info(e.toString());
		} finally {
			if (bufferedinputstream != null) {
				try {
					bufferedinputstream.close();
				} catch (Exception e) {
				}
			}
		}
	}
	
	public byte[] recv() throws IOException, SocketTimeoutException, Exception {
		return recv(this.bufferSize);
	}
	
	public byte[] recv(int recvSize) throws IOException, SocketTimeoutException, Exception {
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		
		
		
		byte[]	buff = new byte[recvSize];
		int		i = 0;
		
		try {
			
		while (true) {
			if (i >= recvSize)
				break;
			
			int		r = is.read(buff, i, recvSize - i);
			
			if (r == -1)
				break;
			
			i	+= r;
		}
		
		if (i < recvSize) {
			throw new Exception("수신오류");
		}
		
		} catch(Exception e) {
			e.printStackTrace();
		}
			
		return buff;
	}
	
	public byte[] recv(int lengthFieldSize, boolean containLengthField) throws IOException, SocketTimeoutException, Exception {
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		
		byte[]	lenBuff = recv(lengthFieldSize);
	
		int		totalLength;
		
		try {
			totalLength		= new BigInteger(lenBuff).intValue();
		} catch (NumberFormatException nfe) {
			throw new Exception("길이부 데이타가 잘못되었습니다. : [" + new String(lenBuff) + "]");
		}
		
		if (!containLengthField){
			totalLength		= totalLength - lengthFieldSize;
		}else{
			totalLength		= totalLength + lengthFieldSize;
		}
		
		lenBuff = null;
		byte[]	dataBuff = recv(totalLength);
		
		return dataBuff;
	}
	
	public Object recvObject() throws IOException, SocketTimeoutException, Exception {
		if (client == null) {
			throw new Exception("SocketExecutor : Socket이 생성되지 않았습니다.");
		}
		
		ObjectInputStream ois = new ObjectInputStream(is);
		Object obj = ois.readObject();
		return obj;
	}
	public int getLocalPort() {
		if (client == null)
			return 0;
		
		return client.getLocalPort();
	}
	
	protected JSONObject ResultJSON(List<Object> resultData, String strDxExCode
										, String strResultCode
										, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, resultData);

		return outputObj;
	}
	
	protected JSONObject DxT005ResultJSON(String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		
		return outputObj;
	}
	
	
	protected JSONObject DxT006ResultJSON(List<LinkedHashMap<String, String>> resultData, String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, resultData);
		
		return outputObj;
	}
	
	protected JSONObject DxT007ResultJSON(List<PgAuditVO> resultData, String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, resultData);
		
		return outputObj;
	}
	
	protected JSONObject DxT007ResultJSON(PgAuditSettingVO resultData, String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{

		HashMap hp = new HashMap();
		hp.put("log", resultData.getLog());
		hp.put("log_level", resultData.getLog_level());
		hp.put("log_relation", resultData.getLog_relation());
		hp.put("log_catalog", resultData.getLog_catalog());
		hp.put("log_parameter", resultData.getLog_parameter());
		hp.put("log_statement_once", resultData.getLog_statement_once());
		hp.put("log_roles", resultData.getRole());
		
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, hp);
		
		return outputObj;
	}
	
	protected JSONObject DxT013ResultJSON(String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		
		return outputObj;
	}
	
	protected JSONObject DxT014ResultJSON(List<Map<String, Object>> resultData, String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg) throws Exception{
		JSONObject outputObj = new JSONObject();
		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, resultData);
		
		return outputObj;
	}


}
