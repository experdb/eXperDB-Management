package com.k4m.dx.tcontrol.db2pg.setting.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DDLConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DataConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.QueryVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.SrcTableVO;

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
	
	/**
	 * DDL WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DDLConfigVO> selectDDLWork(Map<String, Object> param) throws SQLException{
		List<DDLConfigVO> result = null;
		result = (List<DDLConfigVO>) list("db2pgSettingSql.selectDDLWork", param);
		return result;
	}
	
	/**
	 * Data WORK 리스트 조회
	 * 
	 * @param Map
	 * @return DDLConfigVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DataConfigVO> selectDataWork(Map<String, Object> param) throws SQLException{
		List<DataConfigVO> result = null;
		result = (List<DataConfigVO>) list("db2pgSettingSql.selectDataWork", param);
		return result;
	}
	
	/**
	 * 추출 대상 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	public int selectExrttrgSrctblsSeq() throws SQLException{
		return (int) getSqlSession().selectOne("db2pgSettingSql.selectExrttrgSrctblsSeq");
	}

	/**
	 * 추출 제외 테이블 작업 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	public int selectExrtexctSrctblsSeq() throws SQLException{
		return (int) getSqlSession().selectOne("db2pgSettingSql.selectExrtexctSrctblsSeq");
	}
	
	/**
	 * 사용자 쿼리 내역 ID SEQ 조회
	 * 
	 * @return int
	 * @throws Exception
	 */
	public int selectExrtusrQryIdSeq() throws SQLException{
		return (int) getSqlSession().selectOne("db2pgSettingSql.selectExrtusrQryIdSeq");
	}

	/**
	 * 추출 대상 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	public void insertExrttrgSrcTb(SrcTableVO srctableVO) throws SQLException{
		insert("db2pgSettingSql.insertExrttrgSrcTb", srctableVO);
	}
	
	/**
	 * 추출 제외 테이블 등록
	 * 
	 * @param srctableVO
	 * @throws Exception
	 */
	public void insertExrtexctSrcTb(SrcTableVO srctableVO) throws SQLException{
		insert("db2pgSettingSql.insertExrtexctSrcTb", srctableVO);
	}
	
	/**
	 * DDL WORK 등록
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	public void insertDDLWork(DDLConfigVO ddlConfigVO) throws SQLException{
		insert("db2pgSettingSql.insertDDLWork", ddlConfigVO);
		
	}

	/**
	 * DDL WORK 수정
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	public void updateDDLWork(DDLConfigVO ddlConfigVO) throws SQLException{
		update("db2pgSettingSql.updateWork", ddlConfigVO);	
		update("db2pgSettingSql.updateDDLWork", ddlConfigVO);	
	}
	
	/**
	 * DDL WORK 삭제
	 * 
	 * @param db2pg_ddl_wrk_id
	 * @throws Exception
	 */
	public void deleteDDLWork(int db2pg_ddl_wrk_id) throws SQLException{
		delete("db2pgSettingSql.deleteDDLWork", db2pg_ddl_wrk_id);
	}
	
	/**
	 * 사용자 쿼리 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	public void insertUsrQry(QueryVO queryVO) throws SQLException{
		insert("db2pgSettingSql.insertUsrQry", queryVO);
	}
	
	/**
	 * Data WORK 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	public void insertDataWork(DataConfigVO dataConfigVO) throws SQLException{
		insert("db2pgSettingSql.insertDataWork", dataConfigVO);
	}

	/**
	 * DDL WORK 상세정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	public DDLConfigVO selectDetailDDLWork(int db2pg_ddl_wrk_id) throws SQLException{
		return (DDLConfigVO) selectOne("db2pgSettingSql.selectDetailDDLWork", db2pg_ddl_wrk_id);
	}

	/**
	 * 소스DBMS 접속정보
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	public Db2pgSysInfVO selectSoruceDBMS(int db2pg_sys_id) throws SQLException{
		return (Db2pgSysInfVO) selectOne("db2pgSettingSql.selectSoruceDBMS", db2pg_sys_id);
	}

	/**
	 * DB2PG WORK 등록
	 * 
	 * @param ddlConfigVO
	 * @throws Exception
	 */
	public void insertDb2pgWork(DDLConfigVO ddlConfigVO) throws SQLException{
		insert("db2pgSettingSql.insertDb2pgWork", ddlConfigVO);
		
	}

	public int selectWorkSeq() throws SQLException{
		return (int) getSqlSession().selectOne("db2pgSettingSql.selectWorkSeq");
	}

}
