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
    public JSONObject backupStorageInsert(HttpServletRequest request) throws Exception{
    	JSONObject result = new JSONObject();
    	BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
    	int type = Integer.parseInt(request.getParameter("type"));
    	long time = new Date().getTime();
    	// System.out.println("path : " + path);
    	BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
    	
    	if(type == 2){        	
    		String [] pth = request.getParameter("path").split("/", 4);
    		String path = "/"+pth[3];	
    		backuplocation.setBackupDestLocation(request.getParameter("path"));
    		backuplocation.setBackupDestUser(request.getParameter("userName"));
    		backuplocation.setBackupDestPasswd(request.getParameter("passWord"));
    		locationVO.setTotalSize(Long.parseLong(CmmnUtil.backupLocationTotalSize(path).get("RESULT_DATA").toString()));
    		locationVO.setFreeSize(Long.parseLong(CmmnUtil.backupLocationFreeSize(path).get("RESULT_DATA").toString()));
    		locationVO.setBackupDestPasswd(CmmnUtil.encPassword(request.getParameter("passWord")).get("RESULT_DATA").toString());
    	}else{
    		String [] pth = request.getParameter("path").split("/", 2);
    		String path = "/"+pth[1];
    		locationVO.setTotalSize(Long.parseLong(CmmnUtil.backupLocationTotalSize(path).get("RESULT_DATA").toString()));
    		locationVO.setFreeSize(Long.parseLong(CmmnUtil.backupLocationFreeSize(path).get("RESULT_DATA").toString()));
    		locationVO.setBackupDestPasswd(request.getParameter("passWord"));
    	}
    	
        locationVO.setUuid(UUID.randomUUID().toString());
        locationVO.setType(type);
        locationVO.setBackupDestLocation(request.getParameter("path"));
        locationVO.setBackupDestUser(request.getParameter("userName"));
        locationVO.setJobLimit(Integer.parseInt(request.getParameter("jobLimit")));
        locationVO.setFreeSizeAlert(Long.parseLong(request.getParameter("freeSizeAlert")));
        locationVO.setFreeSizeAlertUnit(Integer.parseInt(request.getParameter("freeSizeAlertUnit")));
        locationVO.setIsRunScript(Integer.parseInt(request.getParameter("runScript")));
        locationVO.setTime(time);
//        if(type == 2){        	
//        	locationVO.setBackupDestPasswd(CmmnUtil.encPassword(request.getParameter("passWord")).get("RESULT_DATA").toString());
//        }else{
//        	locationVO.setBackupDestPasswd(request.getParameter("passWord"));
//        }

        System.out.println(locationVO.toString());
        experdbBackupStorageDAO.backupStorageInsert(locationVO);     
        
        return result;
    }
    
    @Override
    public int checkStoragePath(HttpServletRequest request) throws Exception {
    	int type = Integer.parseInt(request.getParameter("type"));
    	String [] pth = null;
    	String path = null;
    	String check = null;
    	if(type == 2){
    		pth = request.getParameter("path").split("/", 4);
    		path = "/"+pth[3];
    		check = CmmnUtil.backupLocationCheck(path).get("RESULT_DATA").toString();
    	}else{
    		pth = request.getParameter("path").split("/", 2);
    		path = "/"+pth[1];
    		check = CmmnUtil.backupLocationCheck(path).get("RESULT_DATA").toString();
    	}
//    	System.out.println(" check : " + check);
    	if(!path.equals(check)){
    		System.out.println("path check << FALSE >>");
    		return 1;
    	}else{
    		System.out.println("path check << TRUE >>");
    		return 0;
    	}
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
    		 		
    		double diskUsage = ((double)list.get(i).getTotalSize() - (double)list.get(i).getFreeSize()) * 100d / (double)list.get(i).getTotalSize();
    	
    		  		
    		result.put("freeSize", CmmnUtil.bytes2String((double)list.get(i).getFreeSize()));
    		result.put("totalSize", CmmnUtil.bytes2String((double)list.get(i).getTotalSize()));		
    		result.put("diskUsage", String.format("%.0f",diskUsage));
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
//        System.out.println("update data : " + locationVO.toString());
        experdbBackupStorageDAO.backupStorageUpdate(locationVO);
		
	}

	@Override
	public void backupStorageDelete(HttpServletRequest request){
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		locationVO.setBackupDestLocation(request.getParameter("path"));
		experdbBackupStorageDAO.backupStorageDelete(locationVO);
	}
	
	

}
