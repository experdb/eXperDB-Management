package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;

public interface SystemService {
	/**
	 * 샘플 데이터테이블 리스트 조회
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception;
	
	public DbServerInfoVO selectDbServerInfo() throws Exception;
}
