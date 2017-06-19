package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("cmmnCodeDtlDAO")
public class CmmnCodeDtlDAO extends EgovAbstractMapper{
	

    /**
	 * 코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(코드 목록)
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public List<CmmnCodeVO> cmmnCodeDtlList(PageVO pageVO,  CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		sl = (List<CmmnCodeVO>) list("cmmnCodeSQL.cmmnCodeDtlList", pageVO);	
		return sl;
    }
    
    
    /**
	 * 코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통코드 총 갯수)
     */
	public int selectCmmnCodeDtlListTotCnt(PageVO pageVO) throws SQLException {
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("cmmnCodeSQL.selectCmmnCodeDtlListTotCnt", pageVO);
		return TotCnt;
	}

    
	/**
	 * 코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws SQLException {
		insert("cmmnCodeSQL.insertCmmnDtlCode", cmmnCodeVO);	
	}


	/**
	 * 코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws SQLException {
		delete("cmmnCodeSQL.deleteCmmnDtlCode", cmmnCodeVO);		
	}


    /**
	 * 코드 목록을  검색 조회한다.
     * @param pageVO
     * @return List(코드 목록)
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public List<CmmnCodeVO> cmmnDtlCodeSearch( PageVO pageVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		sl = (List<CmmnCodeVO>) list("cmmnCodeSQL.cmmnDtlCodeSearch", pageVO);	
		return sl;
    }
}
