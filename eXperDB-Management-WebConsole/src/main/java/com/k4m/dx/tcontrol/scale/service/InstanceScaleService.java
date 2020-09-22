package com.k4m.dx.tcontrol.scale.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

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
	 * aws 서버확인 
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	Map<String, Object> scaleInstallChk(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale Auto 설정 list 조회
	 * @param instanceScaleVO
	 * @return List<Map<String, Object>>
	 * @throws Exception
	 */
	List<Map<String, Object>> selectScaleCngList(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale 설정정보 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	Map<String, Object> selectAutoScaleCngInfo(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale 공통 설정정보 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	Map<String, Object> selectAutoScaleComCngInfo(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale load 관련 조회 및 파일다운로드
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	Map<String, Object> scaleSetResult(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale Auto common setting 등록
	 * @param instanceScaleVO
	 * @return String
	 * @throws Exception
	 */
	String updateAutoScaleCommonSetting(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale 공통 내역 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	Map<String, Object> scaleInstallList(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale Auto setting 삭제
	 * @param instanceScaleVO
	 * @return String
	 * @throws Exception
	 */
	String deleteAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale Auto setting 수정
	 * @param instanceScaleVO
	 * @return String
	 * @throws Exception
	 */
	String updateAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 *  scale log list 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	List<Map<String, Object>> selectScaleHistoryList(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale 실행이력 상세정보조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception 
	 */
	Map<String, Object> selectScaleWrkInfo(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale 실패 이력정보
	 * 
	 * @param scale_wrk_sn
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectScaleWrkErrorMsg(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * scale list setting
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	JSONObject instanceListSetting(InstanceScaleVO instanceScaleVO) throws Exception ;

	/**
	 * scale 상세 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	JSONArray instanceInfoListSetting(InstanceScaleVO instanceScaleVO) throws Exception ;

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
	 * scale 화면 접속 히스토리 등록
	 * 
	 * @param request, historyVO, dtlCd
	 * @throws Exception
	 */
	void scaleSaveHistory(HttpServletRequest request, HistoryVO historyVO, String dtlCd) throws Exception;

	/**
	 * scale Auto setting 등록
	 * @param instanceScaleVO
	 * @return String
	 * @throws Exception
	 */
	String insertAutoScaleSetting(InstanceScaleVO instanceScaleVO) throws Exception;

	/**
	 * 대쉬보드 scale 조회
	 * 
	 * @param instanceScaleVO
	 * @throws Exception
	 */
	int dashboardInstanceScale(int db_svr_id) throws Exception;

	/**
	 * scale Auto 사용여부 setting 수정
	 * @param instanceScaleVO
	 * @return String
	 * @throws Exception
	 */
	String updateAutoScaleUseSetting(InstanceScaleVO instanceScaleVO) throws Exception;
}