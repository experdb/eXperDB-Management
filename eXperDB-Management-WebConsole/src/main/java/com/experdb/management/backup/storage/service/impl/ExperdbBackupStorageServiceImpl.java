package com.experdb.management.backup.storage.service.impl;

import java.util.*;

import javax.annotation.*;
import javax.servlet.http.*;

import org.json.simple.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.experdb.management.backup.cmmn.*;
import com.experdb.management.backup.service.*;
import com.experdb.management.backup.storage.service.*;

import egovframework.rte.fdl.cmmn.*;

@Service("ExperdbBackupStorageServiceImpl")
public class ExperdbBackupStorageServiceImpl extends EgovAbstractServiceImpl implements ExperdbBackupStorageService{
    
    @Autowired
    @Resource(name="ExperdbBackupStorageDAO")
    private ExperdbBackupStorageDAO experdbBackupStorageDAO;
    
    @Override
    public void backupStorageInsert(HttpServletRequest request) {
    	int type = Integer.parseInt(request.getParameter("type"));
    	long time = new Date().getTime();
    	String [] pth = request.getParameter("path").split("/", 4);
    	String path = "/"+pth[3];
    	// System.out.println("path : " + path);
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		
        locationVO.setUuid(UUID.randomUUID().toString());
        locationVO.setType(type);
        locationVO.setBackupDestLocation(request.getParameter("path"));
        locationVO.setBackupDestUser(request.getParameter("userName"));
        locationVO.setJobLimit(Integer.parseInt(request.getParameter("jobLimit")));
        locationVO.setFreeSizeAlert(Long.parseLong(request.getParameter("freeSizeAlert")));
        locationVO.setFreeSizeAlertUnit(Integer.parseInt(request.getParameter("freeSizeAlertUnit")));
        locationVO.setIsRunScript(Integer.parseInt(request.getParameter("runScript")));
        locationVO.setTotalSize(Long.parseLong(CmmnUtil.backupLocationTotalSize(path).get("RESULT_DATA").toString()));
        locationVO.setFreeSize(Long.parseLong(CmmnUtil.backupLocationFreeSize(path).get("RESULT_DATA").toString()));
        locationVO.setTime(time);
        if(type == 2){        	
            locationVO.setBackupDestPasswd(CmmnUtil.encPassword(request.getParameter("passWord")).get("RESULT_DATA").toString());
        }else{
            locationVO.setBackupDestPasswd(request.getParameter("passWord"));
        }

        // System.out.println(locationVO.toString());
        
        experdbBackupStorageDAO.backupStorageInsert(locationVO);        
    }
    
    @Override
    public boolean checkStoragePath(HttpServletRequest request) {
    	System.out.println("///////// path check controller!!! //////////");
    	// JSONObject result = new JSONObject();
    	String [] pth = request.getParameter("path").split("/", 4);
    	String path = "/"+pth[3];
    	String check = CmmnUtil.backupLocationTotalSize(path).get("RESULT_DATA").toString();
    	if(check == null || check.equals("")){
    		// result.put("result", false);
    		return false;
    		
    	}else{
    		// result.put("result", true);   
    		return true;
    	}
    	
    	// return result;
    }
    
    @Override
    public List<Map<String, Object>> backupStorageList(){
    	
    	List<BackupLocationInfoVO> list = null;
//    	Map<String, Object> result = new HashMap<>();
    	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
    	
    	list = experdbBackupStorageDAO.backupStorageList();
    	// System.out.println("list.size() : " + list.size());

    	for(int i = 0; i<list.size(); i++){
    		Map<String, Object> result = new HashMap<>();
    		// System.out.println(i+" th toString!! : " + list.get(i).toString());
    		if(list.get(i).getType()== 1){
    			result.put("type", "NFS Share");
    		}else {
    			result.put("type", "CIFS Share");
    		}		
    		result.put("freeSize", CmmnUtil.bytes2String((double)list.get(i).getFreeSize()));
    		result.put("totalSize", CmmnUtil.bytes2String((double)list.get(i).getTotalSize()));
    		result.put("path", list.get(i).getBackupDestLocation());
    		result.put("rJobCount", list.get(i).getCurrentJobCount());
    		result.put("wJobCount", list.get(i).getWaitingJobCount());
    		resultList.add(result);
    	}
    	return resultList;
    }

	@Override
	public BackupLocationInfoVO backupStorageInfo(HttpServletRequest request) {
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		locationVO.setBackupDestLocation(request.getParameter("path"));
		return experdbBackupStorageDAO.backupStorageInfo(locationVO);
	}

	@Override
	public void backupStorageUpdate(HttpServletRequest request) {
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		int type = Integer.parseInt(request.getParameter("type"));
    	long time = new Date().getTime();
		
        locationVO.setType(type);
        locationVO.setBackupDestLocation(request.getParameter("path"));
        locationVO.setBackupDestUser(request.getParameter("userName"));
        locationVO.setJobLimit(Integer.parseInt(request.getParameter("jobLimit")));
        locationVO.setFreeSizeAlert(Long.parseLong(request.getParameter("freeSizeAlert")));
        locationVO.setFreeSizeAlertUnit(Integer.parseInt(request.getParameter("freeSizeAlertUnit")));
        locationVO.setIsRunScript(Integer.parseInt(request.getParameter("runScript")));
        locationVO.setTime(time);
        
        if(type == 2){        	
            locationVO.setBackupDestPasswd(CmmnUtil.encPassword(request.getParameter("passWord")).get("RESULT_DATA").toString());
        }else{
            locationVO.setBackupDestPasswd(request.getParameter("passWord"));
        }
        System.out.println("update data : " + locationVO.toString());
        experdbBackupStorageDAO.backupStorageUpdate(locationVO);
		
	}

	@Override
	public void backupStorageDelete(HttpServletRequest request){
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		locationVO.setBackupDestLocation(request.getParameter("path"));
		experdbBackupStorageDAO.backupStorageDelete(locationVO);
	}
	
	

}
