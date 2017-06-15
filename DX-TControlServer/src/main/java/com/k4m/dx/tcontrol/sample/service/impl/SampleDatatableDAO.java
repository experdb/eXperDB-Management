package com.k4m.dx.tcontrol.sample.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.k4m.dx.tcontrol.sample.service.SampleListVO;

@Repository("SampleDatatableDAO")
public class SampleDatatableDAO {
	
	@Autowired
	@Qualifier("sqlMapClient")
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	public List<SampleListVO> selectSampleDatatableList() {
		List<SampleListVO> sl = null;
		try {
			sl = (List<SampleListVO>) sqlMapClient.queryForList("sampleListSQL.selectSampleDatatableList");	
		} catch (SQLException e) {
			e.printStackTrace();
        }
		return sl;
	}

	
}
