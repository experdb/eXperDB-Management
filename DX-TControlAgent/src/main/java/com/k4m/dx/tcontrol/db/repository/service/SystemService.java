package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;

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
	
	/**
	 * 스케쥴실행 로그 seq 조회
	 * @return
	 * @throws Exception
	 */
	public int selectQ_WRKEXE_G_01_SEQ() throws Exception;
	
	/**
	 * 스캐쥴실행 로그 등록
	 * @param vo
	 * @throws Exception
	 */
	public void insertT_WRKEXE_G(WrkExeVO vo) throws Exception;
	
	/**
	 * 스캐쥴실행 로그 완료
	 * @param vo
	 * @throws Exception
	 */
	public void updateT_WRKEXE_G(WrkExeVO vo) throws Exception;
}
