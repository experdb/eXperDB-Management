package com.k4m.dx.tcontrol.functions.schedule.service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;


import com.k4m.dx.tcontrol.backup.service.WorkVO;

public interface ScheduleService {

	/**
	 * 전체 work 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	List<WorkVO> selectWorkList(WorkVO workVO) throws Exception;

	
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


	
		
}
