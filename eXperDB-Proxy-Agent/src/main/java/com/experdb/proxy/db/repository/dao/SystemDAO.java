package com.experdb.proxy.db.repository.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.experdb.proxy.db.repository.vo.AgentInfoVO;
import com.experdb.proxy.db.repository.vo.DbServerInfoVO;
import com.experdb.proxy.db.repository.vo.ProxyServerVO;

/**
* @author 
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   		최초 생성
*      </pre>
*/
@Repository("SystemDAO")
public class SystemDAO {
	
	//private SqlSessionFactory sqlSessionFactory = SqlSessionManager.getInstance();

	@Autowired
    private SqlSession session;

	/**
	 * Agent 설치정보 조회
	 * 
	 * @param AgentInfoVO
	 * @return AgentInfoVO
	 * @throws Exception
	 */
	public AgentInfoVO selectPryAgtInfo(AgentInfoVO vo) throws Exception  {
		return (AgentInfoVO) session.selectOne("system.selectPryAgtInfo", vo);
	}

	/**
	 * Agent 설치 정보 등록
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void insertPryAgtInfo(AgentInfoVO vo) throws Exception  {
		 session.insert("system.insertPryAgtInfo", vo);
	}

	/**
	 * Agent 설치 정보 수정
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updatePryAgtInfo", vo);
	}
	
	/**
	 * Agent 종료 정보 변경
	 * 
	 * @param AgentInfoVO
	 * @throws Exception
	 */
	public void updatePryAgtStopInfo(AgentInfoVO vo) throws Exception {
		session.update("system.updatePryAgtStopInfo", vo);
	}
	
	/**
	 * db리스트 조회
	 * @param DbServerInfoVO
	 * @return List<DbServerInfoVO>
	 * @throws Exception
	 */
	public List<DbServerInfoVO> selectDbsvripadrMstGbnInfo(DbServerInfoVO vo) throws Exception {
		List<DbServerInfoVO> selectList = session.selectList("system.selectDbsvripadrMstGbnInfo");
		return selectList;
	}
	
	/**
	 * db리스트 내부ip 조회
	 * @param DbServerInfoVO
	 * @return List<DbServerInfoVO>
	 * @throws Exception
	 */
	public DbServerInfoVO selectDbsvripadrMstGbnIntlInfo(DbServerInfoVO vo) throws Exception {
		DbServerInfoVO selectList = session.selectOne("system.selectDbsvripadrMstGbnIntlInfo", vo);
		return selectList;
	}



	/**
	 * Proxy 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectPrySvrMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectPrySvrMaxNmInfo", vo);
	}

	/**
	 * Proxy DBMS 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectDBMSSvrMaxNmInfo", vo);
	}

	/**
	 * Proxy DBMS 별 마스터 별 최종 서버명 조회
	 * 
	 * @param ProxyServerVO
	 * @return ProxyServerVO
	 * @throws Exception
	 */
	public ProxyServerVO selectDBMSSvrEtcMaxNmInfo(ProxyServerVO vo) throws Exception  {
		return (ProxyServerVO) session.selectOne("system.selectDBMSSvrEtcMaxNmInfo", vo);
	}
	
	/**
	 * Agent 사용여부 변경
	 * 
	 * @param AgentInfoVO
	 * @return integer
	 * @throws Exception
	 */
	public int updatePryAgtUseYnLInfo(AgentInfoVO vo) throws Exception  {
		return session.update("system.updatePryAgtUseYnLInfo", vo);
	}
}