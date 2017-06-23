package com.k4m.dx.tcontrol.sample.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.sample.service.SampleTreeService;
import com.k4m.dx.tcontrol.sample.service.SampleTreeVO;


@Service("sampleTreeServiceImpl")
public class SampleTreeServiceImpl implements SampleTreeService{
	
	@Resource(name = "sampleTreeDAO")
	private SampleTreeDAO sampleTreeDAO;

	public List<SampleTreeVO> selectSampleTreeList() throws Exception {
		return sampleTreeDAO.selectSampleTreeList();	
	}

	public void insertSampleTreeList(SampleTreeVO sampleTreeVo) throws Exception {
		sampleTreeDAO.insertSampleTreeList(sampleTreeVo);	
	}


	

}
