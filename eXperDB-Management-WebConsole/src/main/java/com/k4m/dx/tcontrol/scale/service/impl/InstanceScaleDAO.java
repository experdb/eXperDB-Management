package com.k4m.dx.tcontrol.scale.service.impl;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

/**
* @author 
* @see aws scale 관련 화면 dao
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
@Repository("instanceScaleDAO")
public class InstanceScaleDAO extends EgovAbstractMapper{
	
	/**
	 * scale log 조회
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	public Map<String, Object> selectScaleLog(Map<String, Object> param) throws SQLException {
		return (Map<String, Object>) selectOne("instanceScaleSql.selectScaleLog", param);
	}

	/**
	 * scale log 등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	public void insertScaleLog(Map<String, Object> param) throws SQLException {
		insert("instanceScaleSql.insertScaleLog", param);
	}

	/**
	 * scale log 수정
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	public void updateScaleLog(Map<String, Object> param) throws SQLException {
		insert("instanceScaleSql.updateScaleLog", param);
	}
}