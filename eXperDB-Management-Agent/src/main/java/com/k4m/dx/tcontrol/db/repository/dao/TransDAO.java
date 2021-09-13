package com.k4m.dx.tcontrol.db.repository.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db.repository.vo.TransVO;

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

@Repository("TransDAO")
public class TransDAO {

	@Autowired
    private SqlSession session;

	public void updateTransExe(TransVO transVO) throws Exception{
		session.update("trans.updateTransExe", transVO);
	}
	
	public void updateTransTargetExe(TransVO transVO) throws Exception{
		session.update("trans.updateTransTargetExe", transVO);
	}

	//trans 기본사항 조회
	public TransVO selectTransComSettingInfo(TransVO vo) throws Exception  {
		return (TransVO) session.selectOne("trans.selectTransComSettingInfo", vo);
	}

	public List<TransVO> selectTablePkInfo(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTablePkInfo", vo);
	}
	
	//토픽등록
	public void insertTransTopic(TransVO vo) throws Exception  {
		 session.insert("trans.insertTransTopic", vo);
	}

	//tran id 별 topic 리스트 조회
	public List<TransVO> selectTranIdTopicList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTranIdTopicList", vo);
	}

	//topic list 삭제
	public void deleteTransTopic(TransVO vo) throws Exception  {
		 session.insert("trans.deleteTransTopic", vo);
	}

	//topic 상세 count 조회
	public List<TransVO> selectTranIdTopicTotCnt(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTranIdTopicTotCnt", vo);
	}

	//source topic list 수정
	public void updateTransSrcTopic(TransVO vo) throws Exception  {
		 session.insert("trans.updateTransSrcTopic", vo);
	}

	//소스 전송관리 테이블 조회
	public List<TransVO> selectTranExrtTrgList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTranExrtTrgList", vo);
	}

	//소스 전송관리 테이블 수정
	public void updateTranExrtTrgInfo(TransVO vo) throws Exception  {
		 session.insert("trans.updateTranExrtTrgInfo", vo);
	}

	//source topic list 수정
	public void updateTransTopic(TransVO vo) throws Exception  {
		 session.insert("trans.updateTransTopic", vo);
	}

	//kafka connect 리스트 조회
	public List<TransVO> selectTransKafkaConList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTransKafkaConList", vo);
	}

	//kafka connect update
	public void updateTranConInfInfo(TransVO vo) throws Exception  {
		 session.insert("trans.updateTranConInfInfo", vo);
	}

	//소스, 타겟 connect 전체 리스트 조회
	public List<TransVO> selectTransCngTotList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTransCngTotList", vo);
	}

	//전송가능 테이블 조회
	public List<TransVO> selectTransExrttrgMappList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTransExrttrgMappList", vo);
	}

	//trans 리스트 조회
	public List<TransVO> selectTranscngKcList(TransVO vo) throws Exception {
		return (List) session.selectList("trans.selectTranscngKcList", vo);
	}
	
	//소스, 타겟 시스템 활성/ 비활성화 시 로그 등록
	public void insertTransActstateCngInfo(TransVO vo) throws Exception  {
		 session.insert("trans.insertTransActstateCngInfo", vo);
	}
	
	//kafka connect 활성/ 비활성화 시 로그 등록
	public void insertTransKafkaActstateCngInfo(TransVO vo) throws Exception  {
		 session.insert("trans.insertTransKafkaActstateCngInfo", vo);
	}
}