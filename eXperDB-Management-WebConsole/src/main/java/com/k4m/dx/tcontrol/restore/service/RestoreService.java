package com.k4m.dx.tcontrol.restore.service;

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
}
