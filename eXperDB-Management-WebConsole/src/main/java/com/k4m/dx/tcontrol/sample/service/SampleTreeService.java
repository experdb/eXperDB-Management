package com.k4m.dx.tcontrol.sample.service;

import java.util.List;

public interface SampleTreeService {

	/**
	 * 트리 리스트 조회
	 * @return
	 * @throws Exception
	 */
	public List<SampleTreeVO> selectSampleTreeList() throws Exception;

	
	/**
	 * 트리 리스트 등록
	 * @param sampleTreeVo
	 * @return
	 * @throws Exception
	 */	
	public void insertSampleTreeList(SampleTreeVO sampleTreeVo)throws Exception;
	
	

}
