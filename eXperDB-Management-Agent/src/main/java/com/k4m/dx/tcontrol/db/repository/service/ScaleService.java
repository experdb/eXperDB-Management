package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;
import java.util.Map;

/**
* @author 박태혁
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
public interface ScaleService {	

	/**
	 * auto scale load log insert
	 * @param  param
	 * @return 
	 * @throws Exception
	 */
	public void insertScaleLoadLog_G(Map<String, Object> param) throws Exception ;

	/**
	 * auto scale load log delete
	 * @param  param
	 * @return 
	 * @throws Exception
	 */
	public void deleteScaleLoadLog_G(Map<String, Object> param) throws Exception ;

	/**
	 * scale Auto 설정 count
	 * @param  param
	 * @return int
	 * @throws Exception
	 */
	public int selectScaleITotCnt(Map<String, Object> param) throws Exception;

	/**
	 * auto scale load table 시퀀스 초기화
	 * @param 
	 * @return long
	 * @throws Exception
	 */
	public long selectQ_T_SCALELOADLOG_G_01_SEQ() throws Exception;

	/**
	 * auto scale load table 시퀀스 초기화
	 * @param 
	 * @return 
	 * @throws Exception
	 */
	public void deleteScaleLoadSEQ() throws Exception ;

	/**
	 * scale auto 실행
	 * @param param
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	public List<Map<String, Object>> autoScaleExecute(Map<String, Object> param) throws Exception;

	/**
	 * monitoring cpu_mem 사용량 조회록
	 * @param  param
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectMonitorInfo(Map<String, Object> param)  throws Exception;

	/**
	 * 에이전트 비정상 연결실패 조회
	 * @param  param
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectConnectionFailure(Map<String, Object> param)  throws Exception;
	
	/**
	 * auto scale load log insert
	 * @param  param
	 * @return 
	 * @throws Exception
	 */
	public void insertScaleServer() throws Exception ;

	/**
	 * scale 기본사항 조회
	 * @param  param
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectAutoScaleComCngInfo(Map<String, Object> param)  throws Exception;
}
