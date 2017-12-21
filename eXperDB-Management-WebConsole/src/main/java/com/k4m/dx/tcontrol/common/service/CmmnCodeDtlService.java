package com.k4m.dx.tcontrol.common.service;

import java.util.List;



public interface CmmnCodeDtlService {
	
	
	/**
	 * 코드 목록을 조회한다.
	 * @param pageVO
	 * @return List(공통코드 목록)
	 * @throws Exception
	 */
	public List<CmmnCodeVO> cmmnCodeDtlList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception;
	
	
    /**
	 * 코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통코드 총 갯수)
     */
	public int selectCmmnCodeDtlListTotCnt(PageVO pageVO)throws Exception;


	/**
	 * 코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws Exception;


	/**
	 * 코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws Exception;

	
	/**
	 * 코드 목록을 검색 조회한다.
	 * @param pageVO
	 * @return List(코드 목록)
	 * @throws Exception
	 */
	public List<CmmnCodeVO> cmmnDtlCodeSearch(PageVO pageVO) throws Exception;
	
}
