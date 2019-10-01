package com.k4m.dx.tcontrol.db2pg.setting.service;

import java.util.List;

public interface Db2pgSettingService {

	/**
	 * 공통 코드 조회
	 * 
	 * @param String
	 * @return CodeVO
	 * @throws Exception
	 */
	List<CodeVO> selectCode(String grp_cd) throws Exception;



}
