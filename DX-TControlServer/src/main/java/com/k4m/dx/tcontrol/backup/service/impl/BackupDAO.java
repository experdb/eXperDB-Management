package com.k4m.dx.tcontrol.backup.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptDetailVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("BackupDAO")
public class BackupDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<WorkVO> selectWorkList(WorkVO workVO) throws SQLException {
		List<WorkVO> sl = null;
		sl = (List<WorkVO>) list("backupSQL.selectWorkList",workVO);
		return sl;
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<WorkOptDetailVO> selectOptDetailList(WorkOptDetailVO WorkOptDetailVO) throws SQLException {
		List<WorkOptDetailVO> sl = null;
		sl = (List<WorkOptDetailVO>) list("backupSQL.selectOptDetailList",WorkOptDetailVO);
		return sl;
	}
	
	public void insertRmanWork(WorkVO workVO) throws Exception {
		insert("backupSQL.insertRmanWork",workVO);
	}
	
	public void insertDumpWork(WorkVO workVO) throws Exception {
		insert("backupSQL.insertDumpWork",workVO);
	}
	
	public WorkVO lastWorkId() throws Exception{
		return (WorkVO)getSqlSession().selectOne("backupSQL.lastWorkId");
	}

	public void insertWorkOpt(WorkOptVO workOptVO) throws Exception{
		insert("backupSQL.insertWorkOpt",workOptVO);
	}
	
	public void updateRmanWork(WorkVO workVO) throws Exception{
		update("backupSQL.updateRmanWork",workVO);
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<WorkOptVO> selectWorkOptList(WorkVO workVO) throws Exception{
		return (List<WorkOptVO>) list("backupSQL.selectWorkOptList",workVO);
	}
	
	public void deleteWorkOpt(WorkOptVO workOptVO) throws Exception{
		delete("backupSQL.deleteWorkOpt",workOptVO);
	}
	
	public void deleteWork(WorkVO workVO) throws Exception{
		delete("backupSQL.deleteWork",workVO);
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<DbVO> selectDbList(WorkVO workVO) throws Exception{
		return (List<DbVO>) list("backupSQL.selectDbList",workVO);
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<WorkLogVO> selectWorkLogList(WorkLogVO workLogVO) throws Exception{
		return (List<WorkLogVO>) list("backupSQL.selectWorkLogList",workLogVO);
	}
	

}
