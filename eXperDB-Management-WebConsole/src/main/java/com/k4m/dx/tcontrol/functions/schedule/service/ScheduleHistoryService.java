package com.k4m.dx.tcontrol.functions.schedule.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.sample.service.PagingVO;

public interface ScheduleHistoryService {

	List<Map<String, Object>> selectScheduleHistory(PagingVO pagingVO, Map<String, Object> param) throws Exception;

	int selectScheduleHistoryTotCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectScheduleHistoryFail(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectWrkNmList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectScheduleHistoryDetail(int exe_sn, String locale_type) throws Exception;

	List<Map<String, Object>> selectScheduleHistoryWorkDetail(int exe_sn, String locale_type) throws Exception;

	List<Map<String, Object>> selectScheduleDBMSList(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> selectScheduleHistoryNew(Map<String, Object> param) throws Exception;
}
