package com.k4m.dx.tcontrol.functions.schedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("ScheduleHistoryDAO")
public class ScheduleHistoryDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectScheduleHistory(PagingVO pagingVO, Map<String, Object> param) {
		List<Map<String, Object>> result = null;
		HashMap<String, Object> params= new HashMap<String, Object>();
		params.put("lgi_dtm_start", param.get("lgi_dtm_start"));
		params.put("lgi_dtm_end", param.get("lgi_dtm_end"));
		params.put("scd_nm", param.get("scd_nm"));
		params.put("db_svr_nm", param.get("db_svr_nm"));
		params.put("exe_result", param.get("exe_result"));
		params.put("wrk_nm", param.get("wrk_nm"));
		params.put("recordCountPerPage", pagingVO.getRecordCountPerPage());
		params.put("firstIndex", pagingVO.getFirstIndex());

		result = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistory",params);

		return result;
	}

	
	public int selectScheduleHistoryTotCnt(Map<String, Object> param) {
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("scheduleHistorySql.selectScheduleHistoryTotCnt",param);
		return TotCnt;
	}


	public List<Map<String, Object>> selectScheduleHistoryFail() {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleHistoryFail", null);		
		return sl;
	}


	public List<Map<String, Object>> selectScheduleNmList(Map<String, Object> param) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("scheduleHistorySql.selectScheduleNmList", param);		
		return sl;
	}

}
