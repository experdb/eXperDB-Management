package com.k4m.dx.tcontrol.db2pg.setting.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;

public interface Db2pgSettingService {

	/**
	 * 공통 코드 조회
	 * 
	 * @param String
	 * @return CodeVO
	 * @throws Exception
	 */
	List<CodeVO> selectCode(String grp_cd) throws Exception;

	/**
	 * DDL WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	List<DDLConfigVO> selectDDLWork(Map<String, Object> param) throws Exception;

	/**
	 * Data WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	List<DataConfigVO> selectDataWork(Map<String, Object> param) throws Exception;
	
	/**
	 * 추출 대상 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrttrgSrctblsSeq() throws Exception;

	/**
	 * 추출 제외 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrtexctSrctblsSeq() throws Exception;
	
	/**
	 * 사용자 쿼리 내역 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	int selectExrtusrQryIdSeq() throws Exception;

	/**
	 * 추출 대상 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	void insertExrttrgSrcTb(SrcTableVO srctableVO) throws Exception;

	/**
	 * 추출 제외 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	void insertExrtexctSrcTb(SrcTableVO srctableVO) throws Exception;
	
	/**
	 * DDL WORK 등록
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	void insertDDLWork(DDLConfigVO ddlConfigVO) throws Exception;
	
	/**
	 * DDL WORK 수정
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	void updateDDLWork(DDLConfigVO ddlConfigVO) throws Exception;
	
	/**
	 * DDL WORK 삭제
	 * 
	 * @param db2pg_ddl_wrk_id
	 * @throws Exception
	 */
	void deleteDDLWork(int db2pg_ddl_wrk_id) throws Exception;
	
	/**
	 * 사용자 쿼리 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void insertUsrQry(QueryVO queryVO) throws Exception;
	
	/**
	 * Data WORK 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void insertDataWork(DataConfigVO dataConfigVO) throws Exception;
	
	/**
	 * DDL WORK 상세정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	DDLConfigVO selectDetailDDLWork(int db2pg_ddl_wrk_id) throws Exception;

	/**
	 * 소스DBMS 접속정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	Db2pgSysInfVO selectSoruceDBMS(int db2pg_sys_id) throws Exception;


}
