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
    
    // 스토리지 등록
    @SuppressWarnings("unchecked")
	@Override
    public JSONObject backupStorageInsert(HttpServletRequest request) throws Exception{
    	/**
    	 *  스토리지 등록
    	 *  CIFS/NFS에 따라 등록 데이터 다름
    	 *  CIFS : USER/PASSWORD 필요, PATH split 3번째 부터
    	 *  NFS : USER/PASSWORD 필요 없음, PATH split 1번째 부터
    	 */
    	JSONObject result = new JSONObject();
    	BackupLocationInfoVO backuplocation = new BackupLocationInfoVO();
    	int type = Integer.parseInt(request.getParameter("type"));
    	long time = new Date().getTime();
    	BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
    	
    	Map<String, Object> pathUrlInfo = new HashMap<>();
    	
    	pathUrlInfo.put("local", request.getParameter("pathUrlTF"));
    	pathUrlInfo.put("user", request.getParameter("storageUser"));
    	
    	
    	if(type == 2){        	
    		String [] pth = request.getParameter("path").split("/", 4);
    		String ipadr = pth[2];
    		String path = "/"+pth[3];	
    		pathUrlInfo.put("ipadr", ipadr);
    		pathUrlInfo.put("path", path);
    		backuplocation.setBackupDestLocation(request.getParameter("path"));
    		backuplocation.setBackupDestUser(request.getParameter("userName"));
    		backuplocation.setBackupDestPasswd(request.getParameter("passWord"));
    		String totalSize = CmmnUtil.backupLocationTotalSize(pathUrlInfo).get("RESULT_DATA").toString();
    		String freeSize = CmmnUtil.backupLocationFreeSize(pathUrlInfo).get("RESULT_DATA").toString();
    		System.out.println(totalSize);
    		System.out.println(freeSize);
    		if(totalSize == ""){
    			result.put("RESULT_CODE", 2);
    			return result;
    		}
    		if(freeSize == ""){
    			result.put("RESULT_CODE", 2);
    			return result;
    		}
    		
    		locationVO.setTotalSize(Long.parseLong(totalSize));
    		locationVO.setFreeSize(Long.parseLong(freeSize));
    		locationVO.setBackupDestPasswd(CmmnUtil.encPassword(request.getParameter("passWord")).get("RESULT_DATA").toString());
    	}else{
    		String [] pth = request.getParameter("path").split("/", 2);
    		String [] ip = request.getParameter("path").split(":", 2);
    		String ipadr = ip[0];
    		String path = "/"+pth[1];
    		pathUrlInfo.put("ipadr", ipadr);
    		pathUrlInfo.put("path", path);
    		String totalSize = CmmnUtil.backupLocationTotalSize(pathUrlInfo).get("RESULT_DATA").toString();
    		String freeSize = CmmnUtil.backupLocationFreeSize(pathUrlInfo).get("RESULT_DATA").toString();
    		System.out.println(totalSize);
    		System.out.println(freeSize);
    		if(totalSize == ""){
    			result.put("RESULT_CODE", 2);
    			return result;
    		}
    		if(freeSize == ""){
    			result.put("RESULT_CODE", 2);
    			return result;
    		}
    		
    		locationVO.setTotalSize(Long.parseLong(totalSize));
    		locationVO.setFreeSize(Long.parseLong(freeSize));
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

        System.out.println(locationVO.toString());
        experdbBackupStorageDAO.backupStorageInsert(locationVO);     
        result.put("RESULT_CODE", 0);
        return result;
    }
    
    // 스토리지 리스트 조회
    @Override
    public List<Map<String, Object>> backupStorageList(){
    	
    	List<BackupLocationInfoVO> list = null;
    	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
    	
    	list = experdbBackupStorageDAO.backupStorageList();

    	for(int i = 0; i<list.size(); i++){
    		Map<String, Object> result = new HashMap<>();
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
        experdbBackupStorageDAO.backupStorageUpdate(locationVO);
		
	}

	@Override
	public void backupStorageDelete(HttpServletRequest request){
		BackupLocationInfoVO locationVO = new BackupLocationInfoVO();
		locationVO.setBackupDestLocation(request.getParameter("path"));
		experdbBackupStorageDAO.backupStorageDelete(locationVO);
	}
	
	

}
