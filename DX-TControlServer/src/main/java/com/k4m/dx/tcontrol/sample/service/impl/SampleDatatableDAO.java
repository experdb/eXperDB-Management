package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.sample.service.SampleListVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("sampleDatatableDAO")
public class SampleDatatableDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<SampleListVO> selectSampleDatatableList() throws SQLException {
		List<SampleListVO> sl = null;
		sl = (List<SampleListVO>) list("sampleListSQL.selectSampleDatatableList", sl);
		return sl;
	}


}
