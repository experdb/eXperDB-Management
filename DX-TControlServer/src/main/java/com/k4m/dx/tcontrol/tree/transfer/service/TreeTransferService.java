package com.k4m.dx.tcontrol.tree.transfer.service;

import java.util.List;

import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.admin.dbserverManager.service.DbServerVO;

public interface TreeTransferService {

	/**
	 * 커넥트명 중복 체크
	 * 
	 * @param transferTargetVO
	 * @throws Exception
	 */
	int transferTargetNameCheck(String trf_trg_cnn_nm) throws Exception;

	/**
	 * 전송대상 등록
	 * 
	 * @param transferTargetVO
	 * @throws Exception
	 */
	void insertTransferTarget(TransferTargetVO transferTargetVO) throws Exception;

	/**
	 * 전송대상 수정
	 * 
	 * @param transferTargetVO
	 * @throws Exception
	 */
	void updateTransferTarget(TransferTargetVO transferTargetVO) throws Exception;

	/**
	 * TRF_TRG_MPP_ID 조회
	 * 
	 * @param name
	 * @throws Exception
	 */
	String selectTransfermappid(String name) throws Exception;

	/**
	 * 전송대상 삭제
	 * 
	 * @param name
	 * @throws Exception
	 */
	void deleteTransferTarget(String name) throws Exception;

	/**
	 * 전송상세설정 조회
	 * 
	 * @param transferDetailVO
	 * @throws Exception
	 */
	List<TransferDetailVO> selectTransferDetail(TransferDetailVO transferDetailVO) throws Exception;

	/**
	 * 데이터베이스 조회
	 * 
	 * @param dbAutVO
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectServerDbList(DbAutVO dbAutVO) throws Exception;

	/**
	 * DB,SERVER 조회
	 * 
	 * @param db_id
	 * @return
	 * @throws Exception
	 */
	DbIDbServerVO selectServerDb(int db_id) throws Exception;

	/**
	 * 전송대상매핑관계 등록
	 * 
	 * @param transferRelationVO
	 * @return
	 * @throws Exception
	 */
	void insertTransferRelation(TransferRelationVO transferRelationVO) throws Exception;

	/**
	 * 전송매핑테이블내역 등록
	 * 
	 * @param transferMappingVO
	 * @return
	 * @throws Exception
	 */
	void insertTransferMapping(TransferMappingVO transferMappingVO) throws Exception;

	/**
	 * 전송매핑테이블내역 조회
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	List<TransferDetailMappingVO> selectTransferMapping(int trf_trg_id) throws Exception;

	/**
	 * 전송대상매핑관계 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @return
	 * @throws Exception
	 */
	void deleteTransferRelation(int trf_trg_mpp_id) throws Exception;

	/**
	 * 전송매핑테이블내역 삭제
	 * 
	 * @param trf_trg_mpp_id
	 * @return
	 * @throws Exception
	 */
	void deleteTransferMapping(int trf_trg_mpp_id) throws Exception;

	/**
	 * Bottlewater DB정보
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	List<BottlewaterVO> selectBottlewaterinfo(int trf_trg_id) throws Exception;

	/**
	 * tbl kafaconfig 정보
	 * 
	 * @param trf_trg_id
	 * @return
	 * @throws Exception
	 */
	List<TblKafkaConfigVO> selectTblKafkaConfigInfo(int trf_trg_id) throws Exception;

	/**
	 * Bottlewater bwpid 업데이트
	 * 
	 * @param transferDetailVO
	 * @return
	 * @throws Exception
	 */
	void updateBottleWaterBwpid(TransferDetailVO transferDetailVO) throws Exception;

	/**
	 * DB서버 리스트 조회
	 * 
	 * @param dbServerVO
	 * @return dbServerVO
	 * @throws Exception
	 */
	List<DbServerVO> selectDbServerList(DbServerVO dbServerVO) throws Exception;
}
