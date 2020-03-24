package com.k4m.dx.tcontrol.scale.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

import com.k4m.dx.tcontrol.common.service.HistoryVO;

/**
* @author 
* @see aws scale 관련 화면 service
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일                 수정자                   수정내용
*  -------     --------    ---------------------------
*  2020.03.24              최초 생성
*      </pre>
*/
public interface InstanceScaleService {

	/**
	 * scale 로그조회
	 * 
	 * @param param
	 * @throws Exception
	 */
	Map<String, Object> selectScaleLog(Map<String, Object> param) throws Exception;

	/**
	 * scale in out
	 * 
	 * @param historyVO, param
	 * @throws Exception
	 */
	Map<String, Object> scaleInOutSet(HistoryVO historyVO, Map<String, Object> param) throws Exception ;

	/**
	 * scale 완료 log 조회
	 * 
	 * @param loginId, timeId
	 * @throws Exception
	 */
	Map<String, Object> scaleThreadLogSetResult(String loginId, String timeId) throws Exception;
	
	/**
	 * scale 화면 접속 히스토리 등록
	 * 
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	void scaleSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd) throws Exception;

	/**
	 * scale 보안그룹 상세조회
	 * 
	 * @param instanceScaleVO
	 * @throws FileNotFoundException, IOException, ParseException
	 */
	JSONObject instanceSecurityListSetting(InstanceScaleVO instanceScaleVO) throws FileNotFoundException, IOException, ParseException;

	/**
	 * scale 상세 조회
	 * 
	 * @param instanceScaleVO
	 * @throws FileNotFoundException, IOException, ParseException
	 */
	JSONArray instanceInfoListSetting(InstanceScaleVO instanceScaleVO) throws Exception ;

	/**
	 * scale list setting
	 * 
	 * @param instanceScaleVO
	 * @throws FileNotFoundException, IOException, ParseException
	 */
	JSONObject instanceListSetting(InstanceScaleVO instanceScaleVO) throws Exception ;
	
	/**
	 * scale out,in log저장
	 * 
	 * @param timeId, scaleGbn, loginId, logGbn, jParam
	 * @throws Exception
	 */
	void scaleThreadLogSave(String timeId, String scaleGbn, String loginId, String logGbn, Map<String, Object> jParam) throws Exception;
	
	/**
	 * scale load 관련 조회 및 파일다운로드
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	Map<String, Object> scaleSetResult(HttpServletRequest request) throws Exception;

	/**
	 * scale 로그등록
	 * 
	 * @param dataConfigVO
	 * @throws Exception
	 */
	void insertScaleSetLog(Map<String, Object> param) throws Exception;
}
