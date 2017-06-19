package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;
import org.springframework.stereotype.Repository;
import com.k4m.dx.tcontrol.sample.service.PagingVO;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("sampleListDAO")
public class SampleListDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<SampleListVO> selectSampleList(PagingVO searchVO) throws SQLException {
		List<SampleListVO> sl = null;
		sl = (List<SampleListVO>) list("sampleListSQL.selectSampleList", searchVO);	
		return sl;
	}

	public void insertSampleList(SampleListVO sampleListVo) throws SQLException {
		insert("sampleListSQL.insertSampleList", sampleListVo);	
	}

	
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<SampleListVO> selectDetailSampleList(SampleListVO sampleListVo) throws SQLException {
		List<SampleListVO> sl = null;
		sl = (List<SampleListVO>) list("sampleListSQL.selectDetailSampleList", sampleListVo);
		return sl;
	}

	public void updateSampleList(SampleListVO sampleListVo) throws SQLException {
		update("sampleListSQL.updateSampleList", sampleListVo);	
	}

	public void deleteSampleList(SampleListVO sampleListVo) throws SQLException {
		update("sampleListSQL.deleteSampleList", sampleListVo);		
	}

	public int selectSampleListTotCnt(PagingVO searchVO) throws SQLException {
		int TotCnt= 0;
		TotCnt = (int) getSqlSession().selectOne("sampleListSQL.selectSampleListTotCnt", searchVO);
		return TotCnt;
	}

	
}
