package com.k4m.dx.tcontrol.backup.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.backup.service.BackupService;
import com.k4m.dx.tcontrol.backup.service.DbVO;
import com.k4m.dx.tcontrol.backup.service.WorkLogVO;
import com.k4m.dx.tcontrol.backup.service.WorkObjVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptDetailVO;
import com.k4m.dx.tcontrol.backup.service.WorkOptVO;
import com.k4m.dx.tcontrol.backup.service.WorkVO;
import com.k4m.dx.tcontrol.functions.schedule.service.WrkExeVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


@Service("backupServiceImpl")
public class BackupServiceImpl extends EgovAbstractServiceImpl implements BackupService{
	
	@Resource(name = "BackupDAO")
	private BackupDAO backupDAO;

	public List<WorkVO> selectWorkList(WorkVO workVO) throws Exception {
		return backupDAO.selectWorkList(workVO);	
	}

	public List<WorkOptDetailVO> selectOptDetailList(WorkOptDetailVO WorkOptDetailVO) throws Exception {
		return backupDAO.selectOptDetailList(WorkOptDetailVO);	
	}
	
	public void insertRmanWork(WorkVO workVO) throws Exception {
		 backupDAO.insertRmanWork(workVO);
	}
	
	public void insertBackrestWork(WorkVO workVO) throws Exception {
		backupDAO.insertBackrestWork(workVO);
	}
	
	public void insertDumpWork(WorkVO workVO) throws Exception {
		 backupDAO.insertDumpWork(workVO);
	}
	
	public void updateRmanWork(WorkVO workVO) throws Exception{
		backupDAO.updateRmanWork(workVO);
	}
	
	public void updateBackrestWork(WorkVO workVO) throws Exception{
		backupDAO.updateBackrestWork(workVO);
	}
	
	public void updateDumpWork(WorkVO workVO) throws Exception{
		backupDAO.updateDumpWork(workVO);
	}
	
	public WorkVO lastWorkId() throws Exception{
		return backupDAO.lastWorkId();
	}
	
	public void insertWorkOpt(WorkOptVO workOptVO) throws Exception{
		backupDAO.insertWorkOpt(workOptVO);
	}
	
	public List<WorkOptVO> selectWorkOptList(WorkVO workVO) throws Exception{
		return backupDAO.selectWorkOptList(workVO);
	}
	
	public void deleteWorkOpt(int  bck_wrk_id) throws Exception{
		backupDAO.deleteWorkOpt(bck_wrk_id);
	}
	
	public void deleteWork(int wrk_id) throws Exception{
		backupDAO.deleteWork(wrk_id);
	}
	
	public void deleteWorkExe(int wrk_id) throws Exception{
		backupDAO.deleteWorkExe(wrk_id);
	}
	
	public List<DbVO> selectDbList(WorkVO workVO) throws Exception{
		return backupDAO.selectDbList(workVO);
	}
	
	public List<WorkLogVO> selectWorkLogList(WorkLogVO workLogVO) throws Exception{
		return backupDAO.selectWorkLogList(workLogVO);
	}
	
	public DbServerVO selectDbSvrNm(WorkVO workVO) throws Exception{
		return backupDAO.selectDbSvrNm(workVO);
	}
	
	public void insertWorkObj(WorkObjVO workObjVO) throws Exception{
		backupDAO.insertWorkObj(workObjVO);
	}
	
	public List<WorkObjVO> selectWorkObj(WorkVO workVO) throws Exception{
		return backupDAO.selectWorkObj(workVO);
	}
	
	public void deleteWorkObj(int bck_wrk_id) throws Exception{
		backupDAO.deleteWorkObj(bck_wrk_id);
	}

	@Override
	public int wrk_nmCheck(String wrk_nm) throws Exception {
		return backupDAO.wrk_nmCheck(wrk_nm);
	}

	@Override
	public void insertWork(WorkVO workVO) {
		backupDAO.insertWork(workVO);
	}

	@Override
	public List<Map<String, Object>> selectBckSchedule(int db_svr_id) {
		return backupDAO.selectBckSchedule(db_svr_id);
	}

	@Override
	public List<Map<String, Object>> selectWorkOptionLayer(int bck_wrk_id) throws Exception {
		return backupDAO.selectWorkOptionLayer(bck_wrk_id);
	}

	@Override
	public List<Map<String, Object>> selectWorkObjectLayer(int bck_wrk_id) throws Exception {
		return backupDAO.selectWorkObjectLayer(bck_wrk_id);
	}

	@Override
	public List<Map<String, Object>> selectMonthBckSchedule(int db_svr_id) throws Exception {
		return backupDAO.selectMonthBckSchedule(db_svr_id);
	}

	@Override
	public void deleteBckWork(int bck_wrk_id) throws Exception {
		backupDAO.deleteBckWork(bck_wrk_id);
	}

	@Override
	public WorkVO lastBckWorkId() throws Exception {
		return backupDAO.lastBckWorkId();
	}

	@Override
	public List selectMonthBckScheduleSearch(HashMap<String,Object> hp) throws Exception {
		return backupDAO.selectMonthBckScheduleSearch(hp);
	}

	@Override
	public int selectScheduleCheckCnt(HashMap<String, Object> paramvalue) {
		return backupDAO.selectScheduleCheckCnt(paramvalue);
	}

	@Override
	public List<Map<String, Object>> selectBckInfo(int wrk_id) throws Exception{
		return backupDAO.selectBckInfo(wrk_id);
	}
	
	@Override
	public List<DbServerVO> selectAgentInfo(DbServerVO dbServerVO) throws Exception {
		return backupDAO.selectAgentInfo(dbServerVO);	
	}
	
	@Override
	public List<Map<String, Object>> selectBackrestCstOpt(DbServerVO dbServerVO) throws Exception {
		return backupDAO.selectBackrestCstOpt(dbServerVO);
	}
	
	@Override
	public List<DbServerVO> selectBckServer(WorkVO workVO) throws Exception {
		return backupDAO.selectBckServer(workVO);
	}
	
	@Override
	public List<DbServerVO> selectBckTargetServer(int bck_target_ipadr_id) throws Exception {
		return backupDAO.selectBckTargetServer(bck_target_ipadr_id);
	}
	
	@Override
	public List<DbServerVO> selectMasterServer(DbServerVO dbServerVO) throws Exception {
		return backupDAO.selectMasterServer(dbServerVO);
	}
	
	@Override
	public int selectQ_WRKEXE_G_01_SEQ() throws Exception  {
		return backupDAO.selectQ_WRKEXE_G_01_SEQ();
	}
	
	@Override
	public int selectScd_id() throws Exception {
		return backupDAO.selectScd_id();
	}
	
	@Override
	public int selectQ_WRKEXE_G_02_SEQ() throws Exception  {
		return backupDAO.selectQ_WRKEXE_G_02_SEQ();
	}

	@Override
	public void insertPgbackrestBackup(WrkExeVO wrkExeVO) {
		backupDAO.insertPgbackrestBackup(wrkExeVO);
	}

	@Override
	public void updateBackrestWrk(WrkExeVO wrkExeVO) {
		backupDAO.updateBackrestWrk(wrkExeVO);
	}

	@Override
	public WorkLogVO selectSshInfo(int wrkId) {
		return backupDAO.selectSshInfo(wrkId);
	}
	
	@Override
	public void updateBackrestErr(WrkExeVO vo) {
		backupDAO.updateBackrestErr(vo);		
	}

	@Override
	public Map<String, Object> selectSchedule(int scdId) {
		return backupDAO.selectSchedule(scdId);
	}
	
	@Override
	public int selectSingleCheck(WorkVO workVO) throws Exception {
		return backupDAO.selectSingleCheck(workVO);
	}
	
	@Override
	public List<DbServerVO> selectAllAgentInfo(DbServerVO dbServerVO) throws Exception {
		return backupDAO.selectAllAgentInfo(dbServerVO);	
	}
	
	@Override
	public WrkExeVO selectBackupSvrInfo(WorkVO workVO) throws Exception {
		return backupDAO.selectBackupSvrInfo(workVO);
	}
}
