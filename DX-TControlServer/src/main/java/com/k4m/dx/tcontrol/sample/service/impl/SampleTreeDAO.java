package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.sample.service.SampleTreeVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("sampleTreeDAO")
public class SampleTreeDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<SampleTreeVO> selectSampleTreeList() throws SQLException {
		List<SampleTreeVO> sl = null;
		sl = (List<SampleTreeVO>) list("sampleTreeSQL.selectSampleTreeDBServer", sl);
		return sl;
	}

	public void insertSampleTreeList(SampleTreeVO sampleTreeVo) throws SQLException {
		insert("sampleTreeSQL.insertSampleTreeDBServer", sampleTreeVo);
	}

}
