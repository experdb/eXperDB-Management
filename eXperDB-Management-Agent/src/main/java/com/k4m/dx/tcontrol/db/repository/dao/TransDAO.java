package com.k4m.dx.tcontrol.db.repository.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.db.repository.vo.AgentInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DbServerInfoVO;
import com.k4m.dx.tcontrol.db.repository.vo.DumpRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.RmanRestoreVO;
import com.k4m.dx.tcontrol.db.repository.vo.TransVO;
import com.k4m.dx.tcontrol.db.repository.vo.TrfTrgCngVO;
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
}