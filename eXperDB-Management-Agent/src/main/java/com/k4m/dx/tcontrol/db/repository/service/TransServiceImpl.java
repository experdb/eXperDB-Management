package com.k4m.dx.tcontrol.db.repository.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db.repository.dao.TransDAO;
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

@Service("TransService")
public class TransServiceImpl implements TransService{

	@Resource(name = "TransDAO")
	private TransDAO transDAO;

	/* trans 기본사항 조회  */
	public TransVO selectTransComSettingInfo(TransVO vo)  throws Exception {
		return (TransVO) transDAO.selectTransComSettingInfo(vo);
	}	

	/* table pk 조회  */
	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception {
		return transDAO.selectTablePkInfo(vo);
	}

	/* 소스테이블 connect 실행 결과 수정  */
	public void updateTransExe(TransVO transVO) throws Exception{
		transDAO.updateTransExe(transVO);
	}

	/* 타겟테이블 connect 실행 결과 수정  */
	public void updateTransTargetExe(TransVO transVO) throws Exception{
		transDAO.updateTransTargetExe(transVO);
	}

	/* 토픽등록  */
	public void insertTransTopic(TransVO transVO)  throws Exception{
		transDAO.insertTransTopic(transVO);
	}

	/* tran id 별 topic 리스트 조회 */
	public List<TransVO> selectTranIdTopicList(TransVO vo) throws Exception {
		return transDAO.selectTranIdTopicList(vo);
	}

	/* topic list 삭제 */
	public void deleteTransTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.deleteTransTopic(vo);
		}
	}

	/* topic 상세 카운트 조회 */
	public List<TransVO> selectTranIdTopicTotCnt(TransVO vo) throws Exception {
		return transDAO.selectTranIdTopicTotCnt(vo);
	}

	/* source topic list 수정 */
	public void updateTransSrcTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTransSrcTopic(vo);
		}
	}

	/* 소스 전송관리 테이블 조회 */
	public List<TransVO> selectTranExrtTrgList(TransVO vo) throws Exception {
		return transDAO.selectTranExrtTrgList(vo);
	}

	/* 소스 전송관리 테이블  수정 */
	public void updateTranExrtTrgInfo(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTranExrtTrgInfo(vo);
		}
	}

	/* source topic list 수정 */
	public void updateTransTopic(TransVO vo)  throws Exception{
		if (vo != null) {
			transDAO.updateTransTopic(vo);
		}
	}
}