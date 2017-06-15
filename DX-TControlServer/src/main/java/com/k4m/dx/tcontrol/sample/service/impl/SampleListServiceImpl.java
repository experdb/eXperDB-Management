package com.k4m.dx.tcontrol.sample.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.sample.service.PagingVO;
import com.k4m.dx.tcontrol.sample.service.SampleListService;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;


@Service("sampleListServiceImpl")
public class SampleListServiceImpl implements SampleListService{

	@Resource(name = "SampleListDAO")
	private SampleListDAO sampleListDAO;
	
	public List<SampleListVO> selectSampleList(PagingVO searchVO) throws Exception {
		return sampleListDAO.selectSampleList(searchVO);		
	}

	public void insertSampleList(SampleListVO sampleListVo) throws Exception {
		sampleListDAO.insertSampleList(sampleListVo);
	}
	
	public List<SampleListVO> selectDetailSampleList(SampleListVO sampleListVo) throws Exception {
		return sampleListDAO.selectDetailSampleList(sampleListVo);
	}

	public void updateSampleList(SampleListVO sampleListVo) throws Exception {
		sampleListDAO.updateSampleList(sampleListVo);
	}

	public void deleteSampleList(SampleListVO sampleListVo) throws Exception {
		sampleListDAO.deleteSampleList(sampleListVo);
		
	}
	
	public int selectSampleListTotCnt(PagingVO searchVO) throws Exception {
		return sampleListDAO.selectSampleListTotCnt(searchVO);
	}



}
