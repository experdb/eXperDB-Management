package com.k4m.dx.tcontrol.tree.transfer.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferTargetVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TreeTransferDAO")
public class TreeTransferDAO extends EgovAbstractMapper {

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
	 * 전송대상 전체 삭제
	 * 
	 * @param cnr_id
	 * @throws SQLException
	 */
	public void deleteTransferTarget(int cnr_id) throws SQLException {
		delete("treeTransferSql.deleteTransferTarget", cnr_id);
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

}
