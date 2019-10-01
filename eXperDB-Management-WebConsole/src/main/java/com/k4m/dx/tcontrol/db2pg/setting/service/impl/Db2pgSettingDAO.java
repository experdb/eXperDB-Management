package com.k4m.dx.tcontrol.db2pg.setting.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("db2pgSettingDAO")
public class Db2pgSettingDAO extends EgovAbstractMapper {
	
	/**
	 * 공통 코드 조회
	 * 
	 * @param String
	 * @return CodeVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<CodeVO> selectCode(String grp_cd) throws SQLException{
		List<CodeVO> result = null;
		result = (List<CodeVO>) list("db2pgSettingSql.selectCode", grp_cd);
		return result;
	}
	
	
}
