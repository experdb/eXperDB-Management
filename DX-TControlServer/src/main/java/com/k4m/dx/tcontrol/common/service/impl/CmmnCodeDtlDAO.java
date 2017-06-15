package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;


@Repository("CmmnCodeDtlDAO")
public class CmmnCodeDtlDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;
	
    /**
	 * 코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<CmmnCodeVO> cmmnCodeDtlList(PageVO pageVO,  CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		try {
			return sl = (List<CmmnCodeVO>) sqlMapClient.queryForList("cmmnCodeSQL.cmmnCodeDtlList", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
    }
    
    
    /**
	 * 코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통코드 총 갯수)
     */
	public int selectCmmnCodeDtlListTotCnt(PageVO pageVO) {
		int TotCnt= 0;
		try {
			TotCnt = (int) sqlMapClient.queryForObject("cmmnCodeSQL.selectCmmnCodeDtlListTotCnt", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return TotCnt;
	}

    
	/**
	 * 코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnDtlCode(CmmnCodeVO cmmnCodeVO) {
		try {
			sqlMapClient.insert("cmmnCodeSQL.insertCmmnDtlCode", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}


	/**
	 * 코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnDtlCode(CmmnCodeVO cmmnCodeVO) {
		try {
			sqlMapClient.delete("cmmnCodeSQL.deleteCmmnDtlCode", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}


    /**
	 * 코드 목록을  검색 조회한다.
     * @param pageVO
     * @return List(코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<CmmnCodeVO> cmmnDtlCodeSearch( PageVO pageVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		try {
			return sl = (List<CmmnCodeVO>) sqlMapClient.queryForList("cmmnCodeSQL.cmmnDtlCodeSearch", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
    }
}
