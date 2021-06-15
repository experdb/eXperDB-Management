package com.experdb.management.backup.jobstatus.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.management.backup.jobstatus.service.JobStatusVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ExperdbBackupJobStatusDAO")
public class ExperdbBackupJobStatusDAO extends EgovAbstractMapper {
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession backupDBsql;
	
	@Autowired 
	@Resource(name="jobhistoryDB") 
	private SqlSession jobhistoryDBsql;
	
	@Autowired 
	@Resource(name="activitylogDB") 
	private SqlSession activitylogDBsql;
	

	public List<JobStatusVO> selectJobStatusList() {
	       List<JobStatusVO> result = null;
	       
	       result =backupDBsql.selectList("jobStatuSsql.selectJobStatusList");
	       
	       for(int i=0; i>result.size(); i++){
	    	   if (result.get(i).getStatus() == 10) {
	    		   result.get(i).setStatus(10);
 	            } else if (!result.get(i).isRepeat() && result.get(i).getStatus() != -1 && result.get(i) .getLastResult() != 0 && result.get(i).getStatus() != 5) {
 	            	result.get(i).setStatus(100);
 	           } else if (result.get(i).isRepeat() && result.get(i).getStatus() != 5) {
 	        	  result.get(i).setStatus(-1);
 	           } 
	    	   
	    	   if (JobStatusVO.isStandbyJob(result.get(i).getJobType())) {
		             result.get(i).setJobPhase(12);
		           }
	       }	       
	        return result;
	}

	
	public int selectJobEnd(int jobid) {
		int TotCnt = 0;
			TotCnt =jobhistoryDBsql.selectOne("jobStatuSsql.selectJobEndTotCnt",jobid);
		return TotCnt;
	}

	
	public int selectJobid(HashMap<String, Object> paramvalue) {
		int jobid = 0;
			jobid =activitylogDBsql.selectOne("jobStatuSsql.selectJobid",paramvalue);
		return jobid;
	}

}
