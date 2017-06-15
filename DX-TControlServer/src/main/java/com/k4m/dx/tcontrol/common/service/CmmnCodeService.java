package com.k4m.dx.tcontrol.common.service;

import java.util.List;



public interface CmmnCodeService {
	
	
	/**
	 * 그룹코드 목록을 조회한다.
	 * @param pageVO
	 * @return List(공통코드 목록)
	 * @throws Exception
	 */
	public List<CmmnCodeVO> selectCmmnCodeList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception;
	
	
    /**
	 * 그룹코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통코드 총 갯수)
     */
	public int selectCmmnCodeListTotCnt(PageVO pageVO)throws Exception;


	/**
	 * 그룹코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnCode(CmmnCodeVO cmmnCodeVO) throws Exception;


	/**
	 * 그룹코드 디테일 목록을 조회한다.
	 * @param cmmnCodeVO
	 * @return List(공통코드 목록)
	 * @throws Exception
	 */
	public List<CmmnCodeVO> selectCmmnCodeDetailList(CmmnCodeVO cmmnCodeVO) throws Exception;


	/**
	 * 그룹코드를 수정한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void updateCmmnCode(CmmnCodeVO cmmnCodeVO)  throws Exception;


	/**
	 * 그룹코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnCode(CmmnCodeVO cmmnCodeVO) throws Exception;

	
	/**
	 * 그룹코드 목록을 검색 조회한다.
	 * @param pageVO
	 * @return List(공통코드 목록)
	 * @throws Exception
	 */
	public List<CmmnCodeVO> cmmnCodeSearch(PageVO pageVO) throws Exception;
	
}
