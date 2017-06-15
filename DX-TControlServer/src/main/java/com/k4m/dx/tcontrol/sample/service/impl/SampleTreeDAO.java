package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.sample.service.SampleTreeVO;

@Repository("SampleTreeDAO")
public class SampleTreeDAO {

	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<SampleTreeVO> selectSampleTreeList() {
		List<SampleTreeVO> sl = null;
		try {
			sl = (List<SampleTreeVO>) sqlMapClient.queryForList("sampleTreeSQL.selectSampleTreeDBServer");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sl;
	}

	public void insertSampleTreeList(SampleTreeVO sampleTreeVo) {
		try {
			sqlMapClient.insert("sampleTreeSQL.insertSampleTreeDBServer", sampleTreeVo);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
