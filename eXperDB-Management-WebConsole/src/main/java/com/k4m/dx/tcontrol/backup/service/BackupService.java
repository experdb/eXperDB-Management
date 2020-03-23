package com.k4m.dx.tcontrol.backup.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface BackupService {

	/**
	 * 백업 목록 조회
	 * @param WorkVO
	 * @return List<WorkVO>
	 * @throws Exception
	 */
	public List<WorkVO> selectWorkList(WorkVO workVO) throws Exception;
	
	/**
	 * 옵션별 상세내역 조회
	 * @param WorkOptDetailVO
	 * @return List<WorkOptDetailVO>
	 * @throws Exception
	 */
	public List<WorkOptDetailVO> selectOptDetailList(WorkOptDetailVO workOptDetailVO) throws Exception;
	
	/**
	 * Rman백업내역 insert
	 * @param WorkVOworkVO
	 * @throws Exception
	 */
	public void insertRmanWork(WorkVO workVO) throws Exception;
	
	/**
	 * Dump백업내역 insert
	 * @param WorkVO
	 * @throws Exception
	 */
	public void insertDumpWork(WorkVO workVO) throws Exception;
	
	/**
	 * Rman백업수정 내역 update
	 * @param WorkVO
	 * @throws Exception
	 */
	public void updateRmanWork(WorkVO workVO) throws Exception;
	
	/**
	 * Dump백업수정 내역 update
	 * @param WorkVO
	 * @throws Exception
	 */
	public void updateDumpWork(WorkVO workVO) throws Exception;
	
	/**
	 * get wrk_id MAX value
	 * @return WorkVO
	 * @throws Exception
	 */
	public WorkVO lastWorkId() throws Exception;

	/**
	 * Work Option Insert
	 * @param WorkOptVO
	 * @return 
	 * @throws Exception
	 */
	public void insertWorkOpt(WorkOptVO workOptVO) throws Exception;
	
	/**
	 * Work별 등록 옵션 내역 조회
	 * @param WorkVO
	 * @return List<WorkOptVO>
	 * @throws Exception
	 */
	public List<WorkOptVO> selectWorkOptList(WorkVO workVO) throws Exception;
	
	/**
	 * Work별 등록 옵션 delete
	 * @param WorkOptVO
	 * @throws Exception
	 */
	public void deleteWorkOpt(int bck_wrk_id) throws Exception;
	
	/**
	 * Work delete
	 * @param WorkVO
	 * @throws Exception
	 */
	public void deleteWork(int wrk_id) throws Exception;
	
	/**
	 * DB 목록 조회
	 * @param WorkVO
	 * @return List<DbVO>
	 * @throws Exception
	 */
	public List<DbVO> selectDbList(WorkVO workVO) throws Exception;
	
	/**
	 * Work Log List
	 * @param WorkLogVO
	 * @return List<WorkLogVO>
	 * @throws Exception
	 */
	public List<WorkLogVO> selectWorkLogList(WorkLogVO workLogVO) throws Exception;
	
	/**
	 * Select DB Server Name
	 * @param WorkVO
	 * @return DbServerVO
	 * @throws Exception
	 */
	public DbServerVO selectDbSvrNm(WorkVO workVO) throws Exception;

	/**
	 * Insert Backup Object
	 * @param WorkObjVO
	 * @throws Exception
	 */
	public void insertWorkObj(WorkObjVO workObjVO) throws Exception;

	/**
	 * Select Backup Object
	 * @param WorkVO
	 * @return WorkObjVO
	 * @throws Exception
	 */
	public List<WorkObjVO> selectWorkObj(WorkVO workVO) throws Exception;
	
	/**
	 * Delete Backup Object
	 * @param WorkVO
	 * @throws Exception
	 */
	public void deleteWorkObj(int bck_wrk_id) throws Exception;

	
	/**
	 * work명 중복검사
	 * @param wrk_nm
	 * @throws Exception
	 */
	public int wrk_nmCheck(String wrk_nm) throws Exception;
	
	
	/**
	 * 잡등록
	 * @param WorkVO
	 * @throws Exception
	 */
	public void insertWork(WorkVO workVO) throws Exception;

	
	/**
	 * 주별 백업스케줄 조회
	 * @param db_svr_id 
	 * @param 
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectBckSchedule(int db_svr_id) throws Exception;

	
	public List<Map<String, Object>> selectWorkOptionLayer(int bck_wrk_id) throws Exception;

	public List<Map<String, Object>> selectWorkObjectLayer(int bck_wrk_id) throws Exception;

	/**
	 * 월별 백업스케줄 조회
	 * @param db_svr_id 
	 * @param 
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectMonthBckSchedule(int db_svr_id) throws Exception;

	public void deleteBckWork(int bck_wrk_id) throws Exception;

	public WorkVO lastBckWorkId() throws Exception;
	
	public List selectMonthBckScheduleSearch(HashMap<String,Object> hp) throws Exception;

	public int selectScheduleCheckCnt(HashMap<String, Object> paramvalue);

	public List<Map<String, Object>> selectBckInfo(int wrk_id) throws Exception;
	
}
