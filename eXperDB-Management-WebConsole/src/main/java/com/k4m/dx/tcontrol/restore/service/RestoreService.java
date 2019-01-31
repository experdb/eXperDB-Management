package com.k4m.dx.tcontrol.restore.service;

import java.util.List;

import com.k4m.dx.tcontrol.backup.service.WorkVO;

public interface RestoreService {
	
	
	/**
	 * RMAN Restore 정보 등록
	 * @param restoreRmanVO 
	 * 
	 * @param historyVO
	 * @throws Exception
	 */
	void insertRmanRestore(RestoreRmanVO restoreRmanVO) throws Exception;

	
	/**
	 * 복구명 중복검사
	 * @param restore_nm
	 * @throws Exception
	 */
	public int restore_nmCheck(String restore_nm) throws Exception;


	/**
	 * get sn MAX value
	 * @return RestoreRmanVO
	 * @throws Exception
	 */
	public RestoreRmanVO latestRestoreSN() throws Exception;


	/**
	 * RMAN 복구 이력 조회
	 * @return RestoreRmanVO
	 * @throws Exception
	 */
	List<RestoreRmanVO> rmanRestoreHistory(RestoreRmanVO restoreRmanVO) throws Exception;
}
