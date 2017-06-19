package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("cmmnCodeDAO")
public class CmmnCodeDAO extends EgovAbstractMapper{
	
	
    /**
	 * 그룹코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(그룹코드 목록)
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public List<CmmnCodeVO> selectCmmnCodeList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		sl = (List<CmmnCodeVO>) list("cmmnCodeSQL.selectCmmnCodeList", pageVO);	
		return sl;
    }
    
    
    /**
	 * 그룹코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(그룹코드 총 갯수)
     */
	public int selectCmmnCodeListTotCnt(PageVO pageVO) throws SQLException {
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("cmmnCodeSQL.selectCmmnCodeListTotCnt", pageVO);
		return TotCnt;
	}

    
	/**
	 * 그룹코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnCode(CmmnCodeVO cmmnCodeVO) throws SQLException {
		insert("cmmnCodeSQL.insertCmmnCode", cmmnCodeVO);	
	}


    /**
	 * 그룹코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(공통코드 목록)
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public List<CmmnCodeVO> selectCmmnCodeDetailList(CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		sl = (List<CmmnCodeVO>) list("cmmnCodeSQL.selectCmmnCodeDetailList", cmmnCodeVO);	
		return sl;
    }

	
	/**
	 * 그룹코드를 수정한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void updateCmmnCode(CmmnCodeVO cmmnCodeVO) throws SQLException {
		update("cmmnCodeSQL.updateCmmnCode", cmmnCodeVO);	
	}
    

	/**
	 * 그룹코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnCode(CmmnCodeVO cmmnCodeVO) throws SQLException {
		delete("cmmnCodeSQL.deleteCmmnCode", cmmnCodeVO);		
	}

	
    /**
	 * 그룹코드 목록을  검색 조회한다.
     * @param pageVO
     * @return List(공통코드 목록)
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public List<CmmnCodeVO> cmmnCodeSearch( PageVO pageVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		 sl = (List<CmmnCodeVO>) list("cmmnCodeSQL.cmmnCodeSearch", pageVO);	
		return sl;
    }
}
