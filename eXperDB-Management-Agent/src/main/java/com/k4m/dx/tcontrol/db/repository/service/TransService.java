package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;

import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.db.repository.vo.WrkExeVO;

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

public interface TransService {

	/**
	 * trans 기본사항 조회
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public TransVO selectTransComSettingInfo(TransVO vo) throws Exception;

	/**
	 * table pk 조회
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception;

	/**
	 * 소스테이블 connect 실행 결과 수정
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public void updateTransExe(TransVO transVO) throws Exception;
	
	/**
	 * 타겟테이블 connect 실행 결과 수정
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public void updateTransTargetExe(TransVO transVO) throws Exception;
	
	/**
	 * 토픽등록
	 * @param 
	 * @return
	 * @throws Exception
	 */
	public void insertTransTopic(TransVO transVO)  throws Exception;
}