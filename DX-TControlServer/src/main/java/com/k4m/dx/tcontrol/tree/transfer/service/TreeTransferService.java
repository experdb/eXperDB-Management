package com.k4m.dx.tcontrol.tree.transfer.service;

import java.util.List;

import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;

public interface TreeTransferService {

	/**
	 * 전송대상 등록
	 * 
	 * @param transferTargetVO
	 * @throws Exception
	 */
	void insertTransferTarget(TransferTargetVO transferTargetVO) throws Exception;

	/**
	 * 전송대상 전체 삭제
	 * 
	 * @param cnr_id
	 * @throws Exception
	 */
	void deleteTransferTarget(int cnr_id) throws Exception;

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
	 * @param db_svr_nm
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectServerDbList(String db_svr_nm) throws Exception;

	/**
	 * DB,SERVER 조회
	 * 
	 * @param db_id
	 * @return
	 * @throws Exception
	 */
	List<DbIDbServerVO> selectServerDb(int db_id) throws Exception;

	/**
	 * 전송대상매핑관계 등록
	 * 
	 * @param transferRelationVO
	 * @return
	 * @throws Exception
	 */
	void insertTransferRelation(TransferRelationVO transferRelationVO) throws Exception;

}
