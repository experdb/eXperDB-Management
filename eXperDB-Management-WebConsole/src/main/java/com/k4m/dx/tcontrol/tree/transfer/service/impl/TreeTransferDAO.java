package com.k4m.dx.tcontrol.tree.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;
import com.k4m.dx.tcontrol.tree.transfer.service.BottlewaterVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TblKafkaConfigVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferRelationVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferTargetVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TreeTransferDAO")
public class TreeTransferDAO extends EgovAbstractMapper {

	/**
	 * 커넥트명 중복 체크
	 * 
	 * @param transferTargetVO
	 * @throws SQLException
	 */
	public int transferTargetNameCheck(String trf_trg_cnn_nm) throws SQLException {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("treeTransferSql.transferTargetNameCheck", trf_trg_cnn_nm);
		return resultSet;
	}

	/**
	 * 전송대상 등록
	 * 
	 * @param transferTargetVO
	 * @throws SQLException
	 */
	public void insertTransferTarget(TransferTargetVO transferTargetVO) throws SQLException {
		insert("treeTransferSql.insertTransferTarget", transferTargetVO);

	}

	/**
	 * 전송대상 수정
	 * 
	 * @param transferTargetVO
	 * @throws SQLException
	 */
	public void updateTransferTarget(TransferTargetVO transferTargetVO) throws SQLException {
		insert("treeTransferSql.updateTransferTarget", transferTargetVO);

	}

	/**
	 * TRF_TRG_MPP_ID 조회
	 * 
	 * @param transferTargetVO
	 * @throws SQLException
	 */
	public String selectTransfermappid(String name) throws SQLException {
		String result = null;
		result = (String) getSqlSession().selectOne("treeTransferSql.selectTransfermappid", name);
		return result;
	}

	/**
	 * 전송대상 상태
	 * 
	 * @param name
	 * @throws SQLException
	 */
	public int statusTransferTarget(String name) {
		return (int) getSqlSession().selectOne("treeTransferSql.selectStatusTransferTarget", name);
	}

	/**
	 * 전송대상 삭제
	 * 
	 * @param name
	 * @throws SQLException
	 */
	public void deleteTransferTarget(String name) throws SQLException {
		delete("treeTransferSql.deleteTransferTarget", name);
	}

	/**
	 * 전송상세설정 조회
	 * 
	 * @param transferDetailVO
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<TransferDetailVO> selectTransferDetail(TransferDetailVO transferDetailVO) throws SQLException {
		List<TransferDetailVO> result = null;
		result = (List<TransferDetailVO>) list("treeTransferSql.selectTransferDetail", transferDetailVO);
		return result;
	}

	/**
	 * 매핑정보 조회
	 * 
	 * @param name
	 * @throws SQLException
	 */
	public TransferDetailVO selectMappingInfo(String name) throws SQLException {
		return (TransferDetailVO) selectOne("treeTransferSql.selectMappingInfo", name);
	}

	/**
	 * 데이터베이스 조회
	 * 
	 * @param db_svr_nm
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbIDbServerVO> selectServerDbList(DbAutVO dbAutVO) throws SQLException {
		List<DbIDbServerVO> result = null;
		result = (List<DbIDbServerVO>) list("treeTransferSql.selectServerDbList", dbAutVO);
		return result;
	}

	/**
	 * DB,SERVER 조회
	 * 
	 * @param db_id
	 * @throws SQLException
	 */
	public DbIDbServerVO selectServerDb(int db_id) throws SQLException {
		return (DbIDbServerVO) selectOne("treeTransferSql.selectServerDb", db_id);
	}

	/**
	 * 전송대상매핑관계 등록
	 * 
	 * @param transferRelationVO
	 * @throws SQLException
	 */
	public void insertTransferRelation(TransferRelationVO transferRelationVO) throws SQLException {
		insert("treeTransferSql.insertTransferRelation", transferRelationVO);

	}

	/**
	 * 전송매핑테이블내역 등록
	 * 
	 * @param transferMappingVO
	 * @throws SQLException
	 */
	public void insertTransferMapping(TransferMappingVO transferMappingVO) throws SQLException {
		insert("treeTransferSql.insertTransferMapping", transferMappingVO);
	}

	/**
	 * trf_trg_cnn_nm 체크
	 * 
	 * @param trf_trg_cnn_nm
	 * @return
	 */
	public int selectTrftrgidCheck(String trf_trg_cnn_nm) throws SQLException {
		return (int) selectOne("treeTransferSql.selectTrftrgidCheck", trf_trg_cnn_nm);
	}

	/**
	 * trf_trg_id 조회
	 * 
	 * @param trf_trg_cnn_nm
	 * @throws SQLException
	 */
	public int selectTrftrgid(String trf_trg_cnn_nm) throws SQLException {
		return (int) selectOne("treeTransferSql.selectTrftrgid", trf_trg_cnn_nm);
	}

	/**
	 * 전송매핑테이블내역 조회
	 * 
	 * @param trf_trg_id
	 * @throws SQLException
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<TransferDetailMappingVO> selectTransferMapping(int trf_trg_id) throws SQLException {
		List<TransferDetailMappingVO> result = null;
		result = (List<TransferDetailMappingVO>) list("treeTransferSql.selectTransferMapping", trf_trg_id);
		return result;
	}

	/**
	 * 전송대상매핑관계 삭제
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	public void deleteTransferRelation(int trf_trg_mpp_id) throws SQLException {
		delete("treeTransferSql.deleteTransferRelation", trf_trg_mpp_id);
	}

	/**
	 * 전송매핑테이블내역 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @return
	 * @throws Exception
	 */
	public void deleteTransferMapping(int trf_trg_mpp_id) throws SQLException {
		delete("treeTransferSql.deleteTransferMapping", trf_trg_mpp_id);
	}

	/**
	 * Bottlewater DB정보
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<BottlewaterVO> selectBottlewaterinfo(int trf_trg_id) throws SQLException {
		List<BottlewaterVO> result = null;
		result = (List<BottlewaterVO>) list("treeTransferSql.selectBottlewaterinfo", trf_trg_id);
		return result;
	}

	/**
	 * tbl kafaconfig 정보
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<TblKafkaConfigVO> selectTblKafkaConfigInfo(int trf_trg_id) throws SQLException {
		List<TblKafkaConfigVO> result = null;
		result = (List<TblKafkaConfigVO>) list("treeTransferSql.selectTblKafkaConfigInfo", trf_trg_id);
		return result;
	}

	/**
	 * Bottlewater bwpid 업데이트
	 * 
	 * @param transferDetailVO
	 * @return
	 * @throws Exception
	 */
	public void updateBottleWaterBwpid(TransferDetailVO transferDetailVO) throws SQLException {
		update("treeTransferSql.updateBottleWaterBwpid", transferDetailVO);
	}

	/**
	 * DB서버 리스트 조회
	 * 
	 * @param dbServerVO
	 * @return dbServerVO
	 * @throws Exception
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	public List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws SQLException {
		List<DbServerVO> result = null;
		result = (List<DbServerVO>) list("treeTransferSql.selectDbServerList", dbServerVO);
		return result;
	}

}
