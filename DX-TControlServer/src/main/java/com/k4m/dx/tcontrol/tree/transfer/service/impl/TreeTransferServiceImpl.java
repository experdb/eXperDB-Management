package com.k4m.dx.tcontrol.tree.transfer.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.accesscontrol.service.DbAutVO;
import com.k4m.dx.tcontrol.accesscontrol.service.DbIDbServerVO;
import com.k4m.dx.tcontrol.tree.transfer.service.BottlewaterVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TblKafkaConfigVO;
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
	public int transferTargetNameCheck(String trf_trg_cnn_nm) throws Exception {
		return treeTransferDAO.transferTargetNameCheck(trf_trg_cnn_nm);
	}

	@Override
	public void insertTransferTarget(TransferTargetVO transferTargetVO) throws Exception {
		treeTransferDAO.insertTransferTarget(transferTargetVO);
	}

	@Override
	public void updateTransferTarget(TransferTargetVO transferTargetVO) throws Exception {
		treeTransferDAO.updateTransferTarget(transferTargetVO);

	}

	@Override
	public String selectTransfermappid(String name) throws Exception {
		return treeTransferDAO.selectTransfermappid(name);
	}

	@Override
	public void deleteTransferTarget(String name) throws Exception {
		treeTransferDAO.deleteTransferTarget(name);
	}

	@Override
	public List<TransferDetailVO> selectTransferDetail(TransferDetailVO transferDetailVO) throws Exception {
		return treeTransferDAO.selectTransferDetail(transferDetailVO);
	}

	@Override
	public List<DbIDbServerVO> selectServerDbList(DbAutVO dbAutVO) throws Exception {
		return treeTransferDAO.selectServerDbList(dbAutVO);
	}

	@Override
	public DbIDbServerVO selectServerDb(int db_id) throws Exception {
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
	public void deleteTransferRelation(int trf_trg_mpp_id) throws Exception {
		treeTransferDAO.deleteTransferRelation(trf_trg_mpp_id);
	}

	@Override
	public void deleteTransferMapping(int trf_trg_mpp_id) throws Exception {
		treeTransferDAO.deleteTransferMapping(trf_trg_mpp_id);
	}

	@Override
	public List<BottlewaterVO> selectBottlewaterinfo(int trf_trg_id) throws Exception {
		return treeTransferDAO.selectBottlewaterinfo(trf_trg_id);
	}

	@Override
	public List<TblKafkaConfigVO> selectTblKafkaConfigInfo(int trf_trg_id) throws Exception {
		return treeTransferDAO.selectTblKafkaConfigInfo(trf_trg_id);
	}
	
	@Override
	public void updateBottleWaterBwpid(TransferDetailVO transferDetailVO) throws Exception {
		treeTransferDAO.updateBottleWaterBwpid(transferDetailVO);
	}
}
