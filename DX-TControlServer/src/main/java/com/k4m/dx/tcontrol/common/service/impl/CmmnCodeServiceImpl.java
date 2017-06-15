package com.k4m.dx.tcontrol.common.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.common.service.CmmnCodeService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;


@Service("cmmnCodeServiceImpl")
public class CmmnCodeServiceImpl implements CmmnCodeService {
	
    @Resource(name="CmmnCodeDAO")
    private CmmnCodeDAO cmmnCodeDAO;

	/**
	 * 그룹코드 목록을 조회한다.
	 */
	public List<CmmnCodeVO> selectCmmnCodeList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception {
        return cmmnCodeDAO.selectCmmnCodeList(pageVO, cmmnCodeVO);
	}
	
	/**
	 * 그룹코드 총 갯수를 조회한다.
	 */
	public int selectCmmnCodeListTotCnt(PageVO pageVO) throws Exception {
		return cmmnCodeDAO.selectCmmnCodeListTotCnt(pageVO);
	}


	/**
	 * 그룹코드를 등록한다.
	 */
	public void insertCmmnCode(CmmnCodeVO cmmnCodeVO) throws Exception {
		cmmnCodeDAO.insertCmmnCode(cmmnCodeVO);
	}
	
	
	/**
	 * 그룹코드 상세 목록을 조회한다.
	 */
	public List<CmmnCodeVO> selectCmmnCodeDetailList(CmmnCodeVO cmmnCodeVO) throws Exception {
        return cmmnCodeDAO.selectCmmnCodeDetailList(cmmnCodeVO);
	}
	
	
	/**
	 * 그룹코드를 수정한다.
	 */
	
	public void updateCmmnCode(CmmnCodeVO cmmnCodeVO) throws Exception {
		cmmnCodeDAO.updateCmmnCode(cmmnCodeVO);
	}
	
    /**
	 * 그룹코드를 삭제한다.
	 */
	public void deleteCmmnCode(CmmnCodeVO cmmnCodeVO) throws Exception {
		cmmnCodeDAO.deleteCmmnCode(cmmnCodeVO);
	}
	
	/**
	 * 그룹코드 목록을 검색 조회한다.
	 */
	public List<CmmnCodeVO> cmmnCodeSearch(PageVO pageVO) throws Exception {
        return cmmnCodeDAO.cmmnCodeSearch(pageVO);
	}	

}
