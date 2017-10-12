package com.k4m.dx.tcontrol.backup.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkObjVO;
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
	
	public void updateDumpWork(WorkVO workVO) throws Exception{
		update("backupSQL.updateDumpWork",workVO);
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
	
	public DbServerVO selectDbSvrNm(WorkVO workVO) throws Exception{
		return (DbServerVO)getSqlSession().selectOne("backupSQL.selectDbSvrNm",workVO);
	}
	
	public void insertWorkObj(WorkObjVO workObjVO) throws Exception{
		insert("backupSQL.insertWorkObj",workObjVO);
	}
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<WorkObjVO> selectWorkObj(WorkVO workVO) throws Exception{
		return (List<WorkObjVO>) list("backupSQL.selectWorkObj",workVO);
	}
	
	public void deleteWorkObj(WorkVO workVO) throws Exception{
		delete("backupSQL.deleteWorkObj",workVO);
	}

	public int wrk_nmCheck(String wrk_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("backupSQL.wrk_nmCheck", wrk_nm);
		return resultSet;
	}

	public void insertWork(WorkVO workVO) {
		insert("backupSQL.insertWork",workVO);	
	}

	public List<Map<String, Object>> selectBckSchedule(int db_svr_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectBckSchedule", db_svr_id);		
		return sl;
	}
}
