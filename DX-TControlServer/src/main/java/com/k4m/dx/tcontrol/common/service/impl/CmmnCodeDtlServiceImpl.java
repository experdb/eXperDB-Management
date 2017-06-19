package com.k4m.dx.tcontrol.common.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.common.service.CmmnCodeDtlService;
import com.k4m.dx.tcontrol.common.service.CmmnCodeVO;
import com.k4m.dx.tcontrol.common.service.PageVO;


@Service("cmmnCodeDtlServiceImpl")
public class CmmnCodeDtlServiceImpl implements CmmnCodeDtlService {
	
    @Resource(name="cmmnCodeDtlDAO")
    private CmmnCodeDtlDAO cmmnCodeDtlDAO;

	/**
	 * 코드 목록을 조회한다.
	 */
	public List<CmmnCodeVO> cmmnCodeDtlList(PageVO pageVO, CmmnCodeVO cmmnCodeVO) throws Exception {
        return cmmnCodeDtlDAO.cmmnCodeDtlList(pageVO, cmmnCodeVO);
	}
	
	/**
	 * 코드 총 갯수를 조회한다.
	 */
	public int selectCmmnCodeDtlListTotCnt(PageVO pageVO) throws Exception {
		return cmmnCodeDtlDAO.selectCmmnCodeDtlListTotCnt(pageVO);
	}


	/**
	 * 코드를 등록한다.
	 */
	public void insertCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws Exception {
		cmmnCodeDtlDAO.insertCmmnDtlCode(cmmnCodeVO);
	}

	
    /**
	 * 코드를 삭제한다.
	 */
	public void deleteCmmnDtlCode(CmmnCodeVO cmmnCodeVO) throws Exception {
		cmmnCodeDtlDAO.deleteCmmnDtlCode(cmmnCodeVO);
	}

	
	/**
	 * 코드 목록을 검색 조회한다.
	 */
	public List<CmmnCodeVO> cmmnDtlCodeSearch(PageVO pageVO) throws Exception {
        return cmmnCodeDtlDAO.cmmnDtlCodeSearch(pageVO);
	}	
}
