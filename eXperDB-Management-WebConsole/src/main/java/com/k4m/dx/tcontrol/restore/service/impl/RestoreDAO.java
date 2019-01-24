package com.k4m.dx.tcontrol.restore.service.impl;

import org.springframework.stereotype.Repository;
import com.k4m.dx.tcontrol.restore.service.RestoreRmanVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("restoreDAO")
public class RestoreDAO extends EgovAbstractMapper {

	public void insertRmanRestore(RestoreRmanVO restoreRmanVO) {
		insert("restoreRmanSql.insertRmanRestore", restoreRmanVO);		
	}

	public int restore_nmCheck(String restore_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("restoreRmanSql.restore_nmCheck", restore_nm);
		return resultSet;
	}

}
