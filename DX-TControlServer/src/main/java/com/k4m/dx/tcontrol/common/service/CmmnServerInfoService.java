package com.k4m.dx.tcontrol.common.service;

import java.util.List;

import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface CmmnServerInfoService {

	List<DbServerVO> selectDbServerList(String db_svr_nm) throws Exception;

}
