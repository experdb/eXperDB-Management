package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;

public interface SystemService {
	/**
	 * 샘플 데이터테이블 리스트 조회
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public List<DbServerInfoVO> selectDbServerInfoList() throws Exception;
	
	/**
	 * 서버 등록 정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public DbServerInfoVO selectDbServerInfo(DbServerInfoVO vo) throws Exception;
	
	/**
	 * Agent 설치 정보 등록
	 * @param vo
	 * @throws Exception
	 */
	public void insertAgentInfo(AgentInfoVO vo) throws Exception ;
	
	/**
	 * Agent 설치 정보 수정
	 * @param vo
	 * @throws Exception
	 */
	public void updateAgentInfo(AgentInfoVO vo) throws Exception ;
	
	/**
	 * Agent 설치정보 조회
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	public AgentInfoVO selectAgentInfo(AgentInfoVO vo) throws Exception;
	
	/**
	 * Agent 실행
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStartMng(DbServerInfoVO dbServerInfo) throws Exception ;
	
	/**
	 * Agent 종료
	 * @param dbServerInfo
	 * @throws Exception
	 */
	public void agentInfoStopMng(DbServerInfoVO dbServerInfo) throws Exception ;
}
