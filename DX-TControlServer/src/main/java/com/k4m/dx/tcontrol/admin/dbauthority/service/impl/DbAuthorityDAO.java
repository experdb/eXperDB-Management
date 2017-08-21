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

}
