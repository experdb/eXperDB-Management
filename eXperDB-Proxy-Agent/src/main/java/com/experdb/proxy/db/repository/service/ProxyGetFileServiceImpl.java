package com.experdb.proxy.db.repository.service;

import java.io.File;
import java.util.HashMap;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.experdb.proxy.db.repository.dao.ProxyDAO;
import com.experdb.proxy.socket.ProtocolID;
import com.experdb.proxy.util.FileUtil;

/**
* @author 윤정 매니저
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.04.22   윤정 매니저         최초 생성
*      </pre>
*/
@Service("ProxyGetFileService")
public class ProxyGetFileServiceImpl implements ProxyGetFileService{
	
	@Resource(name = "ProxyDAO")
	private ProxyDAO proxyDAO;
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	/**
	 * proxy, vip config file 가져오기
	 * @param strDxExCode, jObj
	 * @return JSONObject
	 * @throws NumberFormatException, Exception
	 */
	@Override
	public JSONObject getConfigFile(String strDxExCode, JSONObject jObj) throws NumberFormatException, Exception {
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject outputObj = new JSONObject();
		
		String strConfigFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);

		String strReadLine = (String) jObj.get(ProtocolID.READLINE);
		String strSeek = (String) jObj.get(ProtocolID.SEEK);
		String dwLen = (String) jObj.get(ProtocolID.DW_LEN);
		
		int intDwlen = Integer.parseInt(dwLen);
		int intReadLine = Integer.parseInt(strReadLine);
		int intLastLine = intDwlen;

		String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
		File inFile = new File(strConfigFileDir, strFileName);

		HashMap hp = FileUtil.getRandomAccessFileView(inFile, intReadLine, Integer.parseInt(strSeek), intLastLine);

		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, hp.get("file_desc"));
		outputObj.put(ProtocolID.FILE_SIZE, hp.get("file_size"));
		outputObj.put(ProtocolID.SEEK, hp.get("seek"));
		outputObj.put(ProtocolID.DW_LEN, intLastLine + Integer.parseInt(strReadLine));
		outputObj.put(ProtocolID.END_FLAG, hp.get("end_flag"));
		
		hp = null;
		inFile = null;		
		
		return outputObj;
	}

	@Override
	public JSONObject getLogFile(String strDxExCode, JSONObject jObj) throws NumberFormatException, Exception {
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";
		
		JSONObject outputObj = new JSONObject();
		
		String strLogFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);

		String strReadLine = (String) jObj.get(ProtocolID.READLINE);
		String strSeek = (String) jObj.get(ProtocolID.SEEK);
		String dwLen = (String) jObj.get(ProtocolID.DW_LEN);
		
		int intDwlen = Integer.parseInt(dwLen);
		int intReadLine = Integer.parseInt(strReadLine);
		int intLastLine = intDwlen;

		String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
//		File inFile = new File(strLogFileDir, strFileName);
		File inFile = new File("/var/log/haproxy/", "haproxy.log-20210422");

		HashMap hp = FileUtil.getRandomAccessFileView(inFile, intReadLine, Integer.parseInt(strSeek), intLastLine);

		outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
		outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
		outputObj.put(ProtocolID.ERR_CODE, strErrCode);
		outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
		outputObj.put(ProtocolID.RESULT_DATA, hp.get("file_desc"));
		outputObj.put(ProtocolID.FILE_SIZE, hp.get("file_size"));
		outputObj.put(ProtocolID.SEEK, hp.get("seek"));
		outputObj.put(ProtocolID.DW_LEN, intLastLine + Integer.parseInt(strReadLine));
		outputObj.put(ProtocolID.END_FLAG, hp.get("end_flag"));
		
		hp = null;
		inFile = null;		
		
		return outputObj;
	}
	
	
}
