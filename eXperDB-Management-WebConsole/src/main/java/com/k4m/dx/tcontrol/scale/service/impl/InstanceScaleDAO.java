package com.k4m.dx.tcontrol.scale.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.scale.service.InstanceScaleVO;

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

	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectSvrIpadrList(int db_svr_id) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("instanceScaleSql.selectSvrIpadrList", db_svr_id);
		return sl;
	}
	
	/**
	 * scale log list 조회
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectScaleHistoryList(InstanceScaleVO instanceScaleVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("instanceScaleSql.selectScaleHistoryList", instanceScaleVO);		
		return sl;
	}
	
	/**
	 * scale 발생 log list 조회
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<Map<String, Object>> selectScaleOccurHistoryList(InstanceScaleVO instanceScaleVO) {
		List<Map<String, Object>> sl = null;
		sl = (List<Map<String, Object>>) list("instanceScaleSql.selectScaleOccurHistoryList", instanceScaleVO);		
		return sl;
	}
}