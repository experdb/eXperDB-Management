package com.k4m.dx.tcontrol.admin.accesshistory.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.login.service.UserVO;
import com.k4m.dx.tcontrol.sample.service.PagingVO;

public interface AccessHistoryService {

	/**
	 * 화면접근 이력 등록
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertHistory(HistoryVO historyVO) throws Exception;

	/**
	 * 화면명 조회
	 * 
	 * @return HistoryVO
	 * @throws Exception
	 */
	List<HistoryVO> selectAccessScreenName() throws Exception;
	List<HistoryVO> selectAccessScreenName(String locale_name) throws Exception;
	/**
	 * 화면접근 이력 조회
	 * 
	 * @param param
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAccessHistory(PagingVO searchVO, Map<String, Object> param) throws Exception;

	/**
	 * 화면접근 이력 조회
	 * 
	 * @param param
	 * @param userVo
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAccessHistoryNew(Map<String, Object> param) throws Exception;

	/**
	 * 화면접근 이력 총 갯수
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	int selectAccessHistoryTotCnt(Map<String, Object> param) throws Exception;

	/**
	 * 엑셀 화면접근 이력 조회
	 * 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<UserVO> selectAccessHistoryExcel(Map<String, Object> param) throws Exception;

}
