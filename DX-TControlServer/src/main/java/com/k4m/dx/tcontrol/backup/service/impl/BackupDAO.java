package com.k4m.dx.tcontrol.backup.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptDetailVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;

@Repository("BackupDAO")
public class BackupDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<WorkVO> selectWorkList(WorkVO workVO) {
		List<WorkVO> sl = null;
		try {
			sl = (List<WorkVO>) sqlMapClient.queryForList("backupSQL.selectWorkList",workVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}
	
	@SuppressWarnings("unchecked")
	public List<WorkOptDetailVO> selectOptDetailList(WorkOptDetailVO WorkOptDetailVO) {
		List<WorkOptDetailVO> sl = null;
		try {
			sl = (List<WorkOptDetailVO>) sqlMapClient.queryForList("backupSQL.selectOptDetailList",WorkOptDetailVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}
	
	public void insertRmanWork(WorkVO workVO) throws Exception {
		sqlMapClient.insert("backupSQL.insertRmanWork",workVO);
	}
	
	public void insertDumpWork(WorkVO workVO) throws Exception {
		sqlMapClient.insert("backupSQL.insertDumpWork",workVO);
	}
	
	public WorkVO lastWorkId() throws Exception{
		return (WorkVO)sqlMapClient.queryForObject("backupSQL.lastWorkId");
	}

	public void insertWorkOpt(WorkOptVO workOptVO) throws Exception{
		sqlMapClient.insert("backupSQL.insertWorkOpt",workOptVO);
	}
	
	public void updateRmanWork(WorkVO workVO) throws Exception{
		sqlMapClient.update("backupSQL.updateRmanWork",workVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<WorkOptVO> selectWorkOptList(WorkVO workVO) throws Exception{
		return sqlMapClient.queryForList("backupSQL.selectWorkOptList",workVO);
	}
	
	public void deleteWorkOpt(WorkOptVO workOptVO) throws Exception{
		sqlMapClient.delete("backupSQL.deleteWorkOpt",workOptVO);
	}
	
	public void deleteWork(WorkVO workVO) throws Exception{
		sqlMapClient.delete("backupSQL.deleteWork",workVO);
	}

	@SuppressWarnings("unchecked")
	public List<DbVO> selectDbList(WorkVO workVO) throws Exception{
		return sqlMapClient.queryForList("backupSQL.selectDbList",workVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<WorkLogVO> selectWorkLogList(WorkLogVO workLogVO) throws Exception{
		return sqlMapClient.queryForList("backupSQL.selectWorkLogList",workLogVO);
	}
	

}
