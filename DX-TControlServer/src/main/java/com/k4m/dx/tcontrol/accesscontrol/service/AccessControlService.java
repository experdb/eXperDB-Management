package com.k4m.dx.tcontrol.accesscontrol.service;

import java.util.List;

import com.k4m.dx.tcontrol.backup.service.DbVO;

public interface AccessControlService {

	List<DbVO> selectDatabaseList(int db_svr_id) throws Exception;


	
}
