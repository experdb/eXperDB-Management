package com.k4m.dx.tcontrol.sample.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.sample.service.SampleDatatableService;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;


@Service("sampleDatatableServiceImpl")
public class SampleDatatableServiceImpl implements SampleDatatableService{

	@Resource(name = "SampleDatatableDAO")
	private SampleDatatableDAO sampleDatatableDAO;
	
	public List<SampleListVO> selectSampleDatatableList() throws Exception {
		return sampleDatatableDAO.selectSampleDatatableList();
	}



}
