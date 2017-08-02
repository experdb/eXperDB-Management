package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.DateUtil;
import com.k4m.dx.tcontrol.util.FileEntry;
import com.k4m.dx.tcontrol.util.FileListSearcher;
import com.k4m.dx.tcontrol.util.FileUtil;

/**
 * kafka-connect CRUD
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.05.22   박태혁 최초 생성
 * </pre>
 */

public class DxT015 extends SocketCtl{
	
	private static Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private static Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT015(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT015.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		String strCommandCode = (String) jObj.get(ProtocolID.COMMAND_CODE);
		String strLogFileDir = (String) jObj.get(ProtocolID.FILE_DIRECTORY);


		List<Map<String, Object>> outputArray = new ArrayList<Map<String, Object>>();
		

		
		JSONObject outputObj = new JSONObject();
		
		//strLogFileDir = "/home/devel/experdb/data/pg_log";
		
		try {

			FileListSearcher fs = new FileListSearcher(strLogFileDir);
			
			if(strCommandCode.equals(ProtocolID.COMMAND_CODE_R)) {
				
				JSONObject searchInfoObj = (JSONObject) jObj.get(ProtocolID.SEARCH_INFO);
				String strFrom = (String) searchInfoObj.get(ProtocolID.START_DATE);
				String strTo = (String) searchInfoObj.get(ProtocolID.END_DATE);
				
				Date dtFrom = DateUtil.getDateToString(strFrom);
				Date dtTo = DateUtil.getDateToString(strTo);

				List<HashMap<String, String>> resultFileList = new ArrayList<HashMap<String, String>>();
				
				List<FileEntry> fileList = fs.getSearchFiles();
				
				Collections.sort(fileList, new CompareNameDesc());
				
				for(FileEntry fn: fileList) {
					HashMap<String, String> hp = new HashMap<String, String>();
					
					String strFileName = fn.getFileName();
					String strFileSize = FileUtil.getFileSize(fn.getFileSize(), 2);
					String strLastModified = FileUtil.getFileLastModifiedDate(fn.getLastModified());
					
					Date dtLastModified = DateUtil.getDateToString(strLastModified);
					
					String strExtender = FileUtil.fileExtenderSubString(strFileName);
					
					if(strExtender.equals("log")) {
						if(((dtLastModified.compareTo(dtFrom) > 0) || (dtLastModified.compareTo(dtFrom) == 0))
								&&((dtLastModified.compareTo(dtTo) < 0) || (dtLastModified.compareTo(dtTo) == 0))) {
							hp.put(ProtocolID.FILE_NAME, strFileName);
							hp.put(ProtocolID.FILE_SIZE, strFileSize);
							hp.put(ProtocolID.FILE_LASTMODIFIED, strLastModified);
							
							resultFileList.add(hp);
						}
					}
				}
				
				
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, resultFileList);
				
				sendBuff = outputObj.toString().getBytes();
				send(4, sendBuff);
				
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_V)) {
				

				String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
				File inFile = new File(strLogFileDir, strFileName);
				
				String strFileTxt = FileUtil.getFileView(inFile);
				
				outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
				outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
				outputObj.put(ProtocolID.ERR_CODE, strErrCode);
				outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
				outputObj.put(ProtocolID.RESULT_DATA, strFileTxt);
				
				send(outputObj);
			} else if(strCommandCode.equals(ProtocolID.COMMAND_CODE_DL)) {
				String strFileName = (String) jObj.get(ProtocolID.FILE_NAME);
				File inFile = new File(strLogFileDir, strFileName);
				if(inFile.exists()) {
					send(inFile);
				} else {
					outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT015_DL);
					outputObj.put(ProtocolID.RESULT_CODE, "1");
					outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT015_DL);
					outputObj.put(ProtocolID.ERR_MSG, "DxT015_DL Error [FIle Not Found Error]");
					
					sendBuff = outputObj.toString().getBytes();
					send(4, sendBuff);
				}
			}
			
			//send(TotalLengthBit, outputObj.toString().getBytes());
			
		} catch (Exception e) {
			errLogger.error("DxT015 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT015);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT015);
			outputObj.put(ProtocolID.ERR_MSG, "DxT015 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {

		}	    
	}
	
	  /**
     * String으로 내림차순(Desc) 정렬
     * @author Administrator
     *
     */
    static class CompareNameDesc implements Comparator<FileEntry>{
 
        @Override
        public int compare(FileEntry o1, FileEntry o2) {
            // TODO Auto-generated method stub
            return o2.getFileName().compareTo(o1.getFileName());
        }        
    }
    
    /**
     * String으로 오름차순(Asc) 정렬
     * @author Administrator
     *
     */
    static class CompareNameAsc implements Comparator<FileEntry>{
 
        @Override
        public int compare(FileEntry o1, FileEntry o2) {
            // TODO Auto-generated method stub
            return o1.getFileName().compareTo(o2.getFileName());
        }        
    }
    
    /**
     * int로 내림차순(Desc) 정렬
     * @author Administrator
     *
     */
    static class CompareSeqDesc implements Comparator<FileEntry>{
 
        @Override
        public int compare(FileEntry o1, FileEntry o2) {
            // TODO Auto-generated method stub
            return o1.getLastModified() > o2.getLastModified() ? -1 : o1.getLastModified() < o2.getLastModified() ? 1:0;
        }        
    }
    
    /**
     * int로 오름차순(Asc) 정렬
     * @author Administrator
     *
     */
    static class CompareSeqAsc implements Comparator<FileEntry>{
 
        @Override
        public int compare(FileEntry o1, FileEntry o2) {
            // TODO Auto-generated method stub
            return o1.getLastModified() < o2.getLastModified() ? -1 : o1.getLastModified() > o2.getLastModified() ? 1:0;
        }        
    }

}


