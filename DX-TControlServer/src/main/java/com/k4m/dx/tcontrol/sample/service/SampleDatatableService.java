package com.k4m.dx.tcontrol.sample.service;

import java.util.List;

public interface SampleDatatableService {
	/**
	 * 샘플 데이터테이블 리스트 조회
	 * @param 
	 * @return
	 * @throws Exception
	 */
	List<SampleListVO> selectSampleDatatableList() throws Exception;
}
