package com.k4m.dx.tcontrol.tree.transfer.service;

import java.util.List;

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

}
