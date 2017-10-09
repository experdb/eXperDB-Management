package com.k4m.dx.tcontrol.functions.schedule.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.sample.service.PagingVO;

public interface ScheduleHistoryService {

	List<Map<String, Object>> selectScheduleHistory(PagingVO pagingVO, Map<String, Object> param) throws Exception;

	int selectScheduleHistoryTotCnt(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectScheduleHistoryFail() throws Exception;

	List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) throws Exception;
}
