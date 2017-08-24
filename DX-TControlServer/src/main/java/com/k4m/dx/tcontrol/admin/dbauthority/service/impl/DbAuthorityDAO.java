package com.k4m.dx.tcontrol.admin.dbauthority.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;


@Repository("dbAuthorityDAO")
public class DbAuthorityDAO extends EgovAbstractMapper{

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectSvrList() {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbAuthoritySql.selectSvrList", null);
		return sl;
	}

	public void insertUsrDbSvrAut(Map<String, Object> param) {
		insert("dbAuthoritySql.insertUsrDbSvrAut", param);		
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<Map<String, Object>> selectDBList() {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbAuthoritySql.selectDBList", null);
		return sl;
	}

	public void insertUsrDbAut(Map<String, Object> param) {
		insert("dbAuthoritySql.insertUsrDbAut", param);		
	}

	/**
	 *  사용자삭제시, 디비서버권한 삭제
	 * @param 
	 * @throws Exception
	 */
	public void deleteDbSvrAuthority(String string) {
		delete("dbAuthoritySql.deleteDbSvrAuthority", string);			
	}

	/**
	 *  사용자삭제시, 디비권한 삭제
	 * @param 
	 * @throws Exception
	 */
	public void deleteDbAuthority(String string) {
		delete("dbAuthoritySql.deleteDbAuthority", string);			
	}

	
	public List<Map<String, Object>> selectUsrDBSrvAutInfo(String usr_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbAuthoritySql.selectUsrDBSrvAutInfo", usr_id);
		return sl;
	}

	public void updateUsrDBSrvAutInfo(Object object) {
		update("dbAuthoritySql.updateUsrDBSrvAutInfo", object);		
	}

	public List<Map<String, Object>> selectDBAutInfo() {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbAuthoritySql.selectDBAutInfo", null);
		return sl;
	}

	public List<Map<String, Object>> selectUsrDBAutInfo(String usr_id) {
		List<Map<String, Object>>  sl = null;
		sl = (List<Map<String, Object>>) list("dbAuthoritySql.selectUsrDBAutInfo", usr_id);
		return sl;
	}

	public void updateUsrDBAutInfo(Object object) {
		update("dbAuthoritySql.updateUsrDBAutInfo", object);		
	}

	public int selectUsrDBSrvAutInfoCnt(Object object) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbAuthoritySql.selectUsrDBSrvAutInfoCnt", object);
		return resultSet;
	}

	public void insertUsrDBSrvAutInfo(Object object) {
		insert("dbAuthoritySql.insertUsrDBSrvAutInfo", object);			
	}

	public int selectUsrDBAutInfoCnt(Object object) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("dbAuthoritySql.selectUsrDBAutInfoCnt", object);
		return resultSet;
	}

	public void insertUsrDBAutInfo(Object object) {
		insert("dbAuthoritySql.insertUsrDBAutInfo", object);	
	}

}
