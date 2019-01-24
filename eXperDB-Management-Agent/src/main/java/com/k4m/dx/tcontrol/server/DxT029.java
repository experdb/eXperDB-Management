package com.k4m.dx.tcontrol.server;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.k4m.dx.tcontrol.socket.ProtocolID;
import com.k4m.dx.tcontrol.socket.SocketCtl;
import com.k4m.dx.tcontrol.socket.TranCodeType;
import com.k4m.dx.tcontrol.util.FileEntry;
import com.k4m.dx.tcontrol.util.FileListSearcher;
import com.k4m.dx.tcontrol.util.FileUtil;

/**
 * rman restore log 조회
 *
 * @author 박태혁
 * @see <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2019.01.16   박태혁 최초 생성
 * </pre>
 */

public class DxT029 extends SocketCtl{
	
	private Logger errLogger = LoggerFactory.getLogger("errorToFile");
	private Logger socketLogger = LoggerFactory.getLogger("socketLogger");
	
	public DxT029(Socket socket, BufferedInputStream is, BufferedOutputStream	os) {
		this.client = socket;
		this.is = is;
		this.os = os;
	}

	public void execute(String strDxExCode, JSONObject jObj) throws Exception {
		
		socketLogger.info("DxT029.execute : " + strDxExCode);
		byte[] sendBuff = null;
		String strErrCode = "";
		String strErrMsg = "";
		String strSuccessCode = "0";

		String strRESTORE_SN = (String) jObj.get(ProtocolID.RESTORE_SN);
		
		String strLogFileName = "restore_" + strRESTORE_SN + ".log";
		String logDir = "../logs/pg_resLog/";
		
		JSONObject outputObj = new JSONObject();
		
		//strLogFileDir = "/home/devel/experdb/data/pg_reslog"
		//socketLogger.info("File Dir : " + strLogFileDir);
		
		try {

			//strLogFileDir = "C:\\logs\\";
			//strFileName = "webconsole.log.2017-05-31";
			File inFile = new File(logDir, strLogFileName);
			
			String strFileView = FileUtil.getFileView(inFile);
			
			socketLogger.info("strFileView : " + strFileView);
			
			outputObj.put(ProtocolID.DX_EX_CODE, strDxExCode);
			outputObj.put(ProtocolID.RESULT_CODE, strSuccessCode);
			outputObj.put(ProtocolID.ERR_CODE, strErrCode);
			outputObj.put(ProtocolID.ERR_MSG, strErrMsg);
			outputObj.put(ProtocolID.RESULT_DATA, strFileView);

			inFile = null;
			send(TotalLengthBit, outputObj.toString().getBytes());
		
			//send(TotalLengthBit, outputObj.toString().getBytes());
			
		} catch (Exception e) {
			errLogger.error("DxT029 {} ", e.toString());
			
			outputObj.put(ProtocolID.DX_EX_CODE, TranCodeType.DxT029);
			outputObj.put(ProtocolID.RESULT_CODE, "1");
			outputObj.put(ProtocolID.ERR_CODE, TranCodeType.DxT029);
			outputObj.put(ProtocolID.ERR_MSG, "DxT029 Error [" + e.toString() + "]");
			
			sendBuff = outputObj.toString().getBytes();
			send(4, sendBuff);

		} finally {
			outputObj = null;
			sendBuff = null;
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
    
    public static void main(String[] args) throws Exception {
		String strLogFileDir = "C:\\logs\\";
		String strFileName = "webconsole.log.2017-05-31";
		String startLen = "100";
		String seek = "0";
		
		File inFile = new File(strLogFileDir, strFileName);
		
		//byte[] buffer = FileUtil.getFileToByte(inFile);
		//HashMap hp = FileUtil.getFileView(inFile, Integer.parseInt(startLen), Integer.parseInt(dwLen));
		HashMap hp = FileUtil.getRandomAccessFileView(inFile, Integer.parseInt(startLen), Integer.parseInt(seek), 0);
		
		System.out.println(hp.get("file_desc"));
		System.out.println(hp.get("file_size"));
		System.out.println(hp.get("seek"));
		System.out.println(hp.get("end_flag"));
    }

}


