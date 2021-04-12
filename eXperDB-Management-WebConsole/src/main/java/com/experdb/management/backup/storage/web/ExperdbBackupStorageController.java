package com.experdb.management.backup.storage.web;

import java.util.*;

import javax.servlet.http.*;

import org.json.simple.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.service.*;
import com.experdb.management.backup.storage.service.*;
import com.k4m.dx.tcontrol.common.service.*;

@Controller
public class ExperdbBackupStorageController {
	
	@Autowired
	private ExperdbBackupStorageService experdbBackupStorageService;
	
	/**
	 * 스토리지를 등록
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping(value = "/experdb/backupStorageReg.do")
    public JSONObject backupStorageInsert(HttpServletRequest request) throws Exception {
		return experdbBackupStorageService.backupStorageInsert(request);
    }
    
    /**
	 * 스토리지 리스트 조회
	 * 
	 * @param request
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
    @RequestMapping (value = "/experdb/backupStorageList.do")
    public @ResponseBody List<Map<String, Object>> backupStorageList() {
    	return experdbBackupStorageService.backupStorageList();
    }
    
    /**
	 * 스토리지 정보 조회
	 * 
	 * @param request
	 * @return BackupLocationInfoVO
	 * @throws Exception
	 */
    @RequestMapping (value = "/experdb/backupStorageInfo.do")
    public @ResponseBody BackupLocationInfoVO backupStorageInfo(HttpServletRequest request){
    	return experdbBackupStorageService.backupStorageInfo(request);
    }
    
    /**
	 * 스토리지 수정
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping (value="/experdb/backupStorageUpdate.do")
    public @ResponseBody JSONObject backupStoragUpdate(HttpServletRequest request){
    	JSONObject result = new JSONObject();
    	experdbBackupStorageService.backupStorageUpdate(request);
    	return result;
    }
    
    /**
	 * 스토리지 삭제
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping (value="/experdb/backupStorageDel.do")
    public @ResponseBody JSONObject backupStoragDelete(HttpServletRequest request) {
    	JSONObject result = new JSONObject();
    	experdbBackupStorageService.backupStorageDelete(request);
    	return result;
    }
   
    /**
	 * 스토리지 NFS 경로 체크
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping(value="/experdb/nfsValidation.do")
    public @ResponseBody JSONObject nfsValidation(HttpServletRequest request) {
    		JSONObject nfsResult =new JSONObject();
    	try {
    		BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
    		backuplocation.setBackupDestLocation(request.getParameter("path"));

    		 nfsResult = Backuploaction.validateNfs(backuplocation);

    		System.out.println("RESULT_CODE = "+nfsResult.get("RESULT_CODE"));
    		System.out.println("RESULT_DATA = "+nfsResult.get("RESULT_DATA"));
    		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return nfsResult;
    }
    
    /**
	 * 스토리지 CIFS 경로 체크
	 * 
	 * @param request
	 * @return JSONObject
	 * @throws Exception
	 */
    @RequestMapping(value="/experdb/cifsValidation.do")
    public @ResponseBody JSONObject cifsValidation(HttpServletRequest request) {
    		JSONObject cifsResult =new JSONObject();
    	try {
    		BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
    		backuplocation.setBackupDestLocation(request.getParameter("path"));
    		backuplocation.setBackupDestUser(request.getParameter("userName"));
    		backuplocation.setBackupDestPasswd(request.getParameter("passWord"));

    		cifsResult = Backuploaction.validateCifs(backuplocation);

    		System.out.println("RESULT_CODE = "+cifsResult.get("RESULT_CODE"));
    		System.out.println("RESULT_DATA = "+cifsResult.get("RESULT_DATA"));
    		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cifsResult;
    }

}
