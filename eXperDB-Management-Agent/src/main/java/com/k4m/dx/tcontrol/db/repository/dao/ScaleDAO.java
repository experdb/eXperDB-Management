package com.k4m.dx.tcontrol.db.repository.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
* @author
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/

@Repository("ScaleDAO")
public class ScaleDAO {

	@Autowired
    private SqlSession session;

	/**
	 * scale log insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertScaleLog_G(Map<String, Object> param) throws Exception  {
		 session.insert("scale.insertScaleLog_G", param);
	}

	/**
	 * scale log update
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void updateScaleLog_G(Map<String, Object> param) throws Exception  {
		 session.insert("scale.updateScaleLog_G", param);
	}

	/**
	 * scale load log insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertScaleLoadLog_G(Map<String, Object> param) throws Exception  {
		 session.insert("scale.insertScaleLoadLog_G", param);
	}

	/**
	 * scale load log delete
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void deleteScaleLoadLog_G(Map<String, Object> param) throws Exception  {
		 session.insert("scale.deleteScaleLoadLog_G", param);
	}

	/**
	 * scale Auto 설정 count
	 * 
	 * @param param
	 * @throws Exception
	 */
	public int selectScaleITotCnt(Map<String, Object> param) throws SQLException {
		return (int) session.selectOne("scale.selectScaleITotCnt", param);
	}

	/**
	 * scale load table seq 조회
	 * 
	 * @param 
	 * @throws Exception
	 */
	public long selectQ_T_SCALELOADLOG_G_01_SEQ() throws Exception  {
		return (long) session.selectOne("scale.selectQ_T_SCALELOADLOG_G_01_SEQ");
	}

	/**
	 * scale load table 시퀀스 초기화
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void deleteScaleLoadSEQ() throws Exception  {
		 session.insert("scale.deleteScaleLoadSEQ");
	}

	/**
	 * scale Auto 설정 list 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectScaleCngList(Map<String, Object> param) {
		return (List) session.selectList("scale.selectScaleCngList", param);
	}

	/**
	 * scale Auto 설정 list 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectAutoScaleDataChk(Map<String, Object> param) throws SQLException {
		return (Map<String, Object>) session.selectOne("scale.selectAutoScaleDataChk", param);
	}

	/**
	 * scale 공통셋팅 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectAutoScaleComCngInfo(Map<String, Object> param) throws SQLException {
		return (Map<String, Object>) session.selectOne("scale.selectAutoScaleComCngInfo", param);
	}
	

	/**
	 * scale Auto 발생이력 등록
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertScaleOccurLog_G(Map<String, Object> param) throws Exception  {
		 session.insert("scale.insertScaleOccurLog_G", param);
	}

	/**
	 * DB서버 IP주소 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectDbServerIpadrInfo(Map<String, Object> param) throws Exception  {
		return (Map<String, Object>) session.selectOne("scale.selectDbServerIpadrInfo", param);
	}

	/**
	 * monitoring cpu_mem 사용량 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectConnectionFailure(Map<String, Object> param) throws SQLException {
		return (Map<String, Object>) session.selectOne("scale.selectConnectionFailure", param);
	}
	

	/**
	 * scale log insert
	 * 
	 * @param param
	 * @throws Exception
	 */
	public void insertScaleServer(Map<String, Object> param) throws Exception  {
		 session.insert("scale.insertScaleServer", param);
	}

	/**
	 * 에이전트 비정상 연결실패 조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	public Map<String, Object> selectMonitorInfo(Map<String, Object> param) throws SQLException {
		return (Map<String, Object>) session.selectOne("scale.selectMonitorInfo", param);
	}
	

}