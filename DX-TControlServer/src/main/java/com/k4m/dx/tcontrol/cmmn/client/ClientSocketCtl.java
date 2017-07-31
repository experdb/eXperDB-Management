package com.k4m.dx.tcontrol.cmmn.client;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.math.BigInteger;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.LinkedHashMap;
import java.util.List;

import org.json.simple.JSONObject;


public class ClientSocketCtl {
	public static final int TotalLengthBit = 4;
	private static int		DEFAULT_TIMEOUT = 600;
	private static int		DEFAULT_BUFFER_SIZE = 1024;
	
	protected String		_caller = "unknown";	
	
	protected String	ipaddr;
	protected int		port;
	protected int		timeout = DEFAULT_TIMEOUT;
	protected int		bufferSize = DEFAULT_BUFFER_SIZE;
	
	protected Socket		client = null;
	protected BufferedInputStream 	is = null;
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
		
		byte[] intb = intToByteArray(lengthFieldSize+buff.length);
		byte[] temp = new byte[lengthFieldSize + buff.length];
		System.arraycopy(intb, 0, temp, 0, lengthFieldSize);
		System.arraycopy(buff, 0, temp, 4, buff.length);
		os.write(temp);
		os.flush();
	}
	
	public void send(byte[] buff, int index, int length) throws Exception {
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
	
		os.write(buff, index, length);
		os.flush();
	}
	
	public void send(Object obj) throws Exception{
		if (client == null) {
			throw new Exception("TRConnector : Socket이 생성되지 않았습니다.");
		}
		
		ObjectOutputStream oos = new ObjectOutputStream(os);
		oos.writeObject(obj);
		oos.flush();
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
										, String strErrCode, String strErrMsg){
		JSONObject outputObj = new JSONObject();
		outputObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ClientProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ClientProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ClientProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ClientProtocolID.RESULT_DATA, resultData);

		return outputObj;
	}
	
	
	protected JSONObject DxT006ResultJSON(List<LinkedHashMap<String, String>> resultData, String strDxExCode
			, String strResultCode
			, String strErrCode, String strErrMsg){
		JSONObject outputObj = new JSONObject();
		outputObj.put(ClientProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ClientProtocolID.RESULT_CODE, strResultCode);
		outputObj.put(ClientProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ClientProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ClientProtocolID.RESULT_DATA, resultData);
		
		return outputObj;
	}
	
	public  static byte[] intToByteArray(int value) {
		byte[] byteArray = new byte[4];
		byteArray[0] = (byte)(value >> 24);
		byteArray[1] = (byte)(value >> 16);
		byteArray[2] = (byte)(value >> 8);
		byteArray[3] = (byte)(value);
		return byteArray;
	}
	
	public String receiveMessage() throws IOException {
		byte[] b = new byte[4];
		StringBuffer buffer = new StringBuffer();
		
		//ByteBuffer bBuffer = ByteBuffer.wrap(b);
		//bBuffer.flip();

		int i;
		while((i = is.read(b, 0, b.length)) != -1) {
			buffer.append(new String(b, 0, i));
			//bBuffer.put(b, 0, i);
		}
		
		//String buffer = new String(bBuffer.array() , "UTF-8" );

		return buffer.toString();
	}
	
	public String receiveMessageData() throws IOException {
		DataInputStream dis = new DataInputStream(is);
		
		String msg = dis.readUTF();
		
		return msg;
	}
	
	public String byteArrayOutputStreamReceiveMessage() throws IOException {
		
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		int nRead;
		byte[] data = new byte[2];
		while( (nRead = is.read(data)) != -1 ) {
		 buffer.write(data, 0, nRead);
		}
		buffer.flush();

		String str = new String(buffer.toByteArray());
		
		return str;
	}

}