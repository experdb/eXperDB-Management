package com.k4m.dx.tcontrol.backup.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkObjVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptDetailVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
@Transactional
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
	
	public void insertBackrestWork(WorkVO workVO) throws Exception {
		insert("backupSQL.insertBackrestWork",workVO);
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
		update("backupSQL.updateWork",workVO);
		update("backupSQL.updateRmanWork",workVO);
	}
	
	public void updateBackrestWork(WorkVO workVO) {
		update("backupSQL.updateWork",workVO);
		update("backupSQL.updateBackrestWork",workVO);
	}
	
	public void updateDumpWork(WorkVO workVO) throws Exception{
		update("backupSQL.updateWork",workVO);
		update("backupSQL.updateDumpWork",workVO);
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<WorkOptVO> selectWorkOptList(WorkVO workVO) throws Exception{
		return (List<WorkOptVO>) list("backupSQL.selectWorkOptList",workVO);
	}
	
	public void deleteWorkOpt(int bck_wrk_id) throws Exception{
		delete("backupSQL.deleteWorkOpt",bck_wrk_id);
	}
	
	public void deleteWork(int wrk_id) throws Exception{
		delete("backupSQL.deleteWork",wrk_id);
	}
	
	public void deleteWorkExe(int wrk_id) throws Exception{
		delete("backupSQL.deleteWorkExe",wrk_id);
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
	
	public void deleteWorkObj(int bck_wrk_id) throws Exception{
		delete("backupSQL.deleteWorkObj",bck_wrk_id);
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

	public List<Map<String, Object>> selectWorkOptionLayer(int bck_wrk_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectWorkOptionLayer", bck_wrk_id);		
		return sl;
	}

	public List<Map<String, Object>> selectWorkObjectLayer(int bck_wrk_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectWorkObjectLayer", bck_wrk_id);		
		return sl;
	}

	public List<Map<String, Object>> selectMonthBckSchedule(int db_svr_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectMonthBckSchedule", db_svr_id);		
		return sl;
	}

	public void deleteBckWork(int bck_wrk_id) {
		delete("backupSQL.deleteBckWork",bck_wrk_id);
	}

	public WorkVO lastBckWorkId() {
		return (WorkVO)getSqlSession().selectOne("backupSQL.lastBckWorkId");
	}
	
	public List selectMonthBckScheduleSearch(HashMap<String,Object> hp) throws Exception{
		return (List) getSqlSession().selectList("backupSQL.selectMonthBckScheduleSearch", hp);	
	}

	public int selectScheduleCheckCnt(HashMap<String, Object> paramvalue) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("backupSQL.selectScheduleCheckCnt", paramvalue);
		return resultSet;
	}

	public List<Map<String, Object>> selectBckInfo(int wrk_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectBckInfo", wrk_id);		
		return sl;
	}
	
	public List<DbServerVO> selectAgentInfo(DbServerVO dbServerVO) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("backupSQL.selectAgentInfo", dbServerVO);
		return sl;
	}
	
	public List<Map<String, Object>> selectBackrestCstOpt(DbServerVO dbServerVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("backupSQL.selectBackrestCstOpt", dbServerVO);
		return sl;
	}
	
	public List<DbServerVO> selectBckServer(WorkVO workVO) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("backupSQL.selectBckServer", workVO);
		return sl;
	}
	
	public List<DbServerVO> selectBckTargetServer(int bck_target_ipadr_id) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("backupSQL.selectBckTargetServer", bck_target_ipadr_id);
		return sl;
	}
	
	public List<DbServerVO> selectMasterServer(DbServerVO dbServerVO) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("backupSQL.selectMasterServer", dbServerVO);
		return sl;
	}
	
	public int selectQ_WRKEXE_G_01_SEQ() {
		return (int) selectOne("backupSQL.selectQ_WRKEXE_G_01_SEQ");
	}
	
	public int selectScd_id() {
		return (int) selectOne("backupSQL.selectScd_id");
		
	}
	
	public int selectQ_WRKEXE_G_02_SEQ() {
		return (int) selectOne("backupSQL.selectQ_WRKEXE_G_02_SEQ");
	}
	
	public void insertPgbackrestBackup(WrkExeVO wrkExeVO) {
		insert("backupSQL.insertPgbackrestBackup", wrkExeVO);
	}
	
	public void updateBackrestWrk(WrkExeVO wrkExeVO) {
		update("backupSQL.updateBackrestWrk", wrkExeVO);
	}
	
	public WorkLogVO selectSshInfo(int wrkId) {
		return (WorkLogVO)getSqlSession().selectOne("backupSQL.selectSshInfo", wrkId);
	}
	
	public void updateBackrestErr(WrkExeVO vo) {
		update("backupSQL.updateBackrestErr", vo);
	}
	
	public Map<String, Object> selectSchedule(int scdId){
		Map<String, Object> result = null;
		result = getSqlSession().selectOne("backupSQL.selectSchedule", scdId);
		return result;
	}
	
	public int selectSingleCheck(WorkVO workVo) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("backupSQL.dbmsSingleCheck", workVo);
		return resultSet;
	}
	
	public List<DbServerVO> selectAllAgentInfo(DbServerVO dbServerVO) {
		List<DbServerVO> sl = null;
		sl = (List<DbServerVO>) list("backupSQL.selectAllAgentInfo", dbServerVO);
		return sl;
	}
	
	public WrkExeVO selectBackupSvrInfo(WorkVO workVo) throws Exception{
		return (WrkExeVO)getSqlSession().selectOne("backupSQL.selectBackupSvrInfo", workVo);
	}
	
	
}
