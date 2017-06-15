package com.k4m.dx.tcontrol.common.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;


@Repository("CmmnCodeDAO")
public class CmmnCodeDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;
	
    /**
	 * 그룹코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(그룹코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<CmmnCodeVO> selectCmmnCodeList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		try {
			return sl = (List<CmmnCodeVO>) sqlMapClient.queryForList("cmmnCodeSQL.selectCmmnCodeList", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
    }
    
    
    /**
	 * 그룹코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(그룹코드 총 갯수)
     */
	public int selectCmmnCodeListTotCnt(PageVO pageVO) {
		int TotCnt= 0;
		try {
			TotCnt = (int) sqlMapClient.queryForObject("cmmnCodeSQL.selectCmmnCodeListTotCnt", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return TotCnt;
	}

    
	/**
	 * 그룹코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnCode(CmmnCodeVO cmmnCodeVO) {
		try {
			sqlMapClient.insert("cmmnCodeSQL.insertCmmnCode", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}


    /**
	 * 그룹코드 목록을 조회한다.
     * @param pageVO, cmmnCodeVO
     * @return List(공통코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<CmmnCodeVO> selectCmmnCodeDetailList(CmmnCodeVO cmmnCodeVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		try {
			return sl = (List<CmmnCodeVO>) sqlMapClient.queryForList("cmmnCodeSQL.selectCmmnCodeDetailList", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
    }

	
	/**
	 * 그룹코드를 수정한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void updateCmmnCode(CmmnCodeVO cmmnCodeVO) {
		try {
			sqlMapClient.update("cmmnCodeSQL.updateCmmnCode", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}
    

	/**
	 * 그룹코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnCode(CmmnCodeVO cmmnCodeVO) {
		try {
			sqlMapClient.delete("cmmnCodeSQL.deleteCmmnCode", cmmnCodeVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}

	
    /**
	 * 그룹코드 목록을  검색 조회한다.
     * @param pageVO
     * @return List(공통코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<CmmnCodeVO> cmmnCodeSearch( PageVO pageVO) throws Exception {
		List<CmmnCodeVO> sl = null;
		try {
			return sl = (List<CmmnCodeVO>) sqlMapClient.queryForList("cmmnCodeSQL.cmmnCodeSearch", pageVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
    }
}
