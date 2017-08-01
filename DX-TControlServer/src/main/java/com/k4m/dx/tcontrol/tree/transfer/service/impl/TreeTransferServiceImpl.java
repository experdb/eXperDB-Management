package com.k4m.dx.tcontrol.tree.transfer.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferRelationVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferTargetVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TreeTransferService;

@Service("TreeTransferServiceImpl")
public class TreeTransferServiceImpl implements TreeTransferService {

	@Resource(name = "TreeTransferDAO")
	private TreeTransferDAO treeTransferDAO;

	@Override
	public void insertTransferTarget(TransferTargetVO transferTargetVO) throws Exception {
		treeTransferDAO.insertTransferTarget(transferTargetVO);
	}

	@Override
	public void deleteTransferTarget(int cnr_id) throws Exception {
		treeTransferDAO.deleteTransferTarget(cnr_id);
	}

	@Override
	public List<TransferDetailVO> selectTransferDetail(TransferDetailVO transferDetailVO) throws Exception {
		return treeTransferDAO.selectTransferDetail(transferDetailVO);
	}

	@Override
	public List<DbIDbServerVO> selectServerDbList(String db_svr_nm) throws Exception {
		return treeTransferDAO.selectServerDbList(db_svr_nm);
	}

	@Override
	public List<DbIDbServerVO> selectServerDb(int db_id) throws Exception {
		return treeTransferDAO.selectServerDb(db_id);
	}

	@Override
	public void insertTransferRelation(TransferRelationVO transferRelationVO) throws Exception {
		treeTransferDAO.insertTransferRelation(transferRelationVO);
	}

	@Override
	public void insertTransferMapping(TransferMappingVO transferMappingVO) throws Exception {
		treeTransferDAO.insertTransferMapping(transferMappingVO);
	}

	@Override
	public List<TransferDetailMappingVO> selectTransferMapping(int trf_trg_id) throws Exception {
		return treeTransferDAO.selectTransferMapping(trf_trg_id);
	}

	@Override
	public void deleteTransferRelation(int trf_trg_id) throws Exception {
		treeTransferDAO.deleteTransferRelation(trf_trg_id);
	}

	@Override
	public void deleteTransferMapping(int trf_trg_mpp_id) throws Exception {
		treeTransferDAO.deleteTransferMapping(trf_trg_mpp_id);
	}

}
