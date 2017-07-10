package com.k4m.dx.tcontrol.functions.schedule.service;

import java.util.List;

import com.k4m.dx.tcontrol.backup.service.WorkVO;

public interface ScheduleService {

	/**
	 * 스케쥴 work 리스트 조회
	 * @param dbServerVO
	 * @throws Exception
	 */
	List<WorkVO> selectWorkList(WorkVO workVO) throws Exception;


	
	
	
	
	
	
	
}
