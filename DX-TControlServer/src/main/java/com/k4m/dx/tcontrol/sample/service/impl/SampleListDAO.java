package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.sample.service.PagingVO;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;

@Repository("SampleListDAO")
public class SampleListDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<SampleListVO> selectSampleList(PagingVO searchVO) {
		List<SampleListVO> sl = null;
		try {
			return sl = (List<SampleListVO>) sqlMapClient.queryForList("sampleListSQL.selectSampleList", searchVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return sl;
	}

	public void insertSampleList(SampleListVO sampleListVo) {
		try {
			sqlMapClient.insert("sampleListSQL.insertSampleList", sampleListVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}

	@SuppressWarnings("unchecked")
	public List<SampleListVO> selectDetailSampleList(SampleListVO sampleListVo) {
		List<SampleListVO> sl = null;
		try {
			sl = (List<SampleListVO>) sqlMapClient.queryForList("sampleListSQL.selectDetailSampleList", sampleListVo);	
        } catch(SQLException e){
        	e.printStackTrace();
        }
		return sl;
	}

	public void updateSampleList(SampleListVO sampleListVo) {
		try {
			sqlMapClient.update("sampleListSQL.updateSampleList", sampleListVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}	
	}

	public void deleteSampleList(SampleListVO sampleListVo) {
		try {
			sqlMapClient.update("sampleListSQL.deleteSampleList", sampleListVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}

	public int selectSampleListTotCnt(PagingVO searchVO) {
		int TotCnt= 0;
		try {
			TotCnt = (int) sqlMapClient.queryForObject("sampleListSQL.selectSampleListTotCnt", searchVO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return TotCnt;
	}

	
}
