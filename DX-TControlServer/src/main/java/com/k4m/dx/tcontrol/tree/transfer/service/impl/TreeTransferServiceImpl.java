package com.k4m.dx.tcontrol.tree.transfer.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.tree.transfer.service.TransferDetailVO;
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

}
