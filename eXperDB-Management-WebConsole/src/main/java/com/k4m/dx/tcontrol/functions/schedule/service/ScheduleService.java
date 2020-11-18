package com.k4m.dx.tcontrol.functions.schedule.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.backup.service.WorkVO;


public interface ScheduleService {

	/**
	 * 전체 work 리스트 조회
	 * @param locale_type 
	 * @param dbServerVO
	 * @throws Exception
	 */
	List<WorkVO> selectWorkList(WorkVO workVO, String locale_type) throws Exception;

	
	/**
	 * 선택된 work 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectScheduleWorkList(HashMap<String, Object> paramvalue) throws Exception;

	
	/**
	 * 스케줄ID 시퀀스 조회
	 * @param 
	 * @throws Exception
	 */
	int selectScd_id() throws Exception;
	
	
	/**
	 * 스케줄 등록
	 * @param 
	 * @throws Exception
	 */
	void insertSchedule(ScheduleVO scheduleVO) throws Exception;

	
	/**
	 * 스케줄 상세정보 등록
	 * @param 
	 * @throws Exception
	 */
	void insertScheduleDtl(ScheduleDtlVO scheduleDtlVO) throws Exception;

	
	/**
	 * 스케줄 리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectScheduleList(ScheduleVO scheduleVO) throws Exception;


	/**
	 * 서버 시작시 시행할 스케줄 리스트
	 * @param 
	 * @throws Exception
	 */
	List<ScheduleVO> selectInitScheduleList()throws Exception;
	
	
	/**
	 * 실행할 스케줄 리스트 정보 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectExeScheduleList(String scd_id) throws Exception;


	/**
	 * JOB 수행전 다음 JOB 실행시간 업데이트
	 * @param 
	 * @throws Exception
	 */
	void updateNxtJobTime(HashMap<String, Object> hp);
	
	
	
	/**
	 *  JOB 수행후 이전 JOB 실행시간 업데이트
	 * @param 
	 * @throws Exception
	 */
	void updatePrevJobTime(HashMap<String , Object> hp) throws Exception;

	
	
	/**
	 * DB서버 접속정보 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDbconn(int scd_id) throws Exception;

	
	/**
	 * 부가옵션 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAddOption(int wrk_id) throws Exception;


	/**
	 * 오브젝트옵션 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAddObject(int wrk_id) throws Exception;


	/**
	 * 스케줄 리스트 삭제
	 * @param 
	 * @throws Exception
	 */
	void deleteScheduleList(int scd_id) throws Exception;

	
	/**
	 * 스케줄리스트 수정 정보 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectModifyScheduleList(int scd_id) throws Exception;

	
	/**
	 * 스케줄마스터 수정
	 * @param 
	 * @throws Exception
	 */
	void updateSchedule(ScheduleVO scheduleVO) throws Exception;

	
	/**
	 * 스케줄 디테일 삭제
	 * @param 
	 * @throws Exception
	 */
	void deleteScheduleDtl(ScheduleDtlVO scheduleDtlVO) throws Exception;


	/**
	 * 스케줄 상태 업데이트
	 * @param 
	 * @throws Exception
	 */
	void updateScheduleStatus(ScheduleVO scheduleVO) throws Exception;

	
	/**
	 * 스케줄명 중복검사
	 * @param scd_nm
	 * @throws Exception
	 */
	int scd_nmCheck(String scd_nm) throws Exception;


	List<Map<String, Object>> selectWrkScheduleList(int scd_id, String locale_type) throws Exception;


	List<Map<String, Object>> selectWorkDivList(String locale_type) throws Exception;


	List<Map<String, Object>> selectScdInfo(int scd_id, String locale_type) throws Exception;


	List<Map<String, Object>> selectWrkInfo(int wrk_nm) throws Exception;


	/**
	 * 실행중인 스케줄리스트 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectRunScheduleList() throws Exception;


	/**
	 * 스케줄 수행상태 업데이트 
	 * @param 
	 * @throws Exception
	 */
	void updateSCD_CNDT(WrkExeVO vo) throws Exception;


	void insertT_WRKEXE_G(WrkExeVO vo) throws Exception;

	
	/**
	 * 스케줄수행이력 시퀀스 조회
	 * @param 
	 * @throws Exception
	 */
	int selectQ_WRKEXE_G_01_SEQ() throws Exception;


	int selectQ_WRKEXE_G_02_SEQ() throws Exception;


	void updateFixRslt(HashMap<String, Object> paramvalue) throws Exception;


	List<Map<String, Object>> selectFixRsltMsg(int exe_sn) throws Exception;


	List<Map<String, Object>> selectDb2pgScheduleWorkList(HashMap<String, Object> paramvalue) throws Exception;

	
	/**
	 *  이관로그 등록
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	void insertMigExe(Map<String, Object> param) throws Exception;

	/**
	 *  이관로그 수정
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	void updateMigExe(Map<String, Object> param) throws Exception;


	/**
	 *  데이터 이관 스케줄 수행전, 기존 저장경로 호출
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	String selectOldSavePath(int wrk_id) throws Exception;

	
	
	/**
	 *  기존 저장경로, 새로운 경로로 업데이트
	 * 
	 * @param Map<String, Object>
	 * @throws Exception
	 */
	void updateSavePth(Map<String, Object> param) throws Exception;


	void updateScheduler(WrkExeVO vo) throws Exception;
}
