package com.k4m.dx.tcontrol.sample.service;

import java.util.List;

public interface SampleListService {

	/**
	 * 샘플 리스트 조회
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public List<SampleListVO> selectSampleList(PagingVO searchVO) throws Exception;
	
	
	/**
	 * 샘플 리스트 등록
	 * @param sampleListVo
	 * @return
	 * @throws Exception
	 */
	public void insertSampleList(SampleListVO sampleListVo) throws Exception;
	
	
	/**
	 * 샘플 리스트 상세정보 조회
	 * @param sampleListVo
	 * @return
	 * @throws Exception
	 */
	public List<SampleListVO> selectDetailSampleList(SampleListVO sampleListVo) throws Exception;
	
	
	/**
	 * 샘플 리스트 수정
	 * @param sampleListVo
	 * @return
	 * @throws Exception
	 */
	public void updateSampleList(SampleListVO sampleListVo) throws Exception;
	
	
	/**
	 * 샘플 리스트 삭제
	 * @param sampleListVo
	 * @return
	 * @throws Exception
	 */
	public void deleteSampleList(SampleListVO sampleListVo) throws Exception;


	/**
	 * 샘플 리스트 총 갯수를 조회한다.
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	public int selectSampleListTotCnt(PagingVO searchVO)throws Exception;


}
