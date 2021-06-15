package com.k4m.dx.tcontrol.db2pg.setting.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.k4m.dx.tcontrol.db2pg.dbms.service.Db2pgSysInfVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.CodeVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DDLConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.DataConfigVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.Db2pgSettingService;
import com.k4m.dx.tcontrol.db2pg.setting.service.QueryVO;
import com.k4m.dx.tcontrol.db2pg.setting.service.SrcTableVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("Db2pgSettingServiceImpl")
public class Db2pgSettingServiceImpl extends EgovAbstractServiceImpl implements Db2pgSettingService {

	@Resource(name = "db2pgSettingDAO")
	private Db2pgSettingDAO db2pgSettingDAO;

	@Override
	public List<CodeVO> selectCode(String grp_cd) throws Exception {
		return db2pgSettingDAO.selectCode(grp_cd);
	}

	@Override
	public List<DDLConfigVO> selectDDLWork(Map<String, Object> param) throws Exception {
		return db2pgSettingDAO.selectDDLWork(param);
	}

	@Override
	public List<DataConfigVO> selectDataWork(Map<String, Object> param) throws Exception {
		return db2pgSettingDAO.selectDataWork(param);
	}

	@Override
	public int selectExrttrgSrctblsSeq() throws Exception {
		return db2pgSettingDAO.selectExrttrgSrctblsSeq();
	}

	@Override
	public int selectExrtexctSrctblsSeq() throws Exception {
		return db2pgSettingDAO.selectExrtexctSrctblsSeq();
	}

	@Override
	public int selectExrtusrQryIdSeq() throws Exception {
		return db2pgSettingDAO.selectExrtusrQryIdSeq();
	}

	@Override
	public void insertExrttrgSrcTb(SrcTableVO srctableVO) throws Exception {
		db2pgSettingDAO.insertExrttrgSrcTb(srctableVO);
	}

	@Override
	public void insertExrtexctSrcTb(SrcTableVO srctableVO) throws Exception {
		db2pgSettingDAO.insertExrtexctSrcTb(srctableVO);
	}

	@Override
	public void insertDDLWork(DDLConfigVO ddlConfigVO) throws Exception {
		db2pgSettingDAO.insertDDLWork(ddlConfigVO);
	}

	@Override
	public void updateDDLWork(DDLConfigVO ddlConfigVO) throws Exception {
		db2pgSettingDAO.updateDDLWork(ddlConfigVO);
	}

	@Override
	public void deleteDDLWork(int db2pg_ddl_wrk_id) throws Exception {
		db2pgSettingDAO.deleteDDLWork(db2pg_ddl_wrk_id);
	}

	@Override
	public void insertUsrQry(QueryVO queryVO) throws Exception {
		db2pgSettingDAO.insertUsrQry(queryVO);
	}

	@Override
	public int insertDataWork(DataConfigVO dataConfigVO) throws Exception {
		return db2pgSettingDAO.insertDataWork(dataConfigVO);
	}

	@Override
	public void updateDataWork(DataConfigVO dataConfigVO) throws Exception {
		db2pgSettingDAO.updateDataWork(dataConfigVO);
	}

	@Override
	public void deleteDataWork(int db2pg_trsf_wrk_id) throws Exception {
		db2pgSettingDAO.deleteDataWork(db2pg_trsf_wrk_id);
	}

	@Override
	public void deleteUsrQry(int db2pg_trsf_wrk_id) throws Exception {
		db2pgSettingDAO.deleteUsrQry(db2pg_trsf_wrk_id);
	}

	@Override
	public DDLConfigVO selectDetailDDLWork(int db2pg_ddl_wrk_id) throws Exception {
		return db2pgSettingDAO.selectDetailDDLWork(db2pg_ddl_wrk_id);
	}

	@Override
	public DataConfigVO selectDetailDataWork(int db2pg_trsf_wrk_id) throws Exception {
		return db2pgSettingDAO.selectDetailDataWork(db2pg_trsf_wrk_id);
	}

	@Override
	public List<QueryVO> selectDetailUsrQry(int db2pg_trsf_wrk_id) throws Exception {
		return db2pgSettingDAO.selectDetailUsrQry(db2pg_trsf_wrk_id);
	}

	@Override
	public Db2pgSysInfVO selectDBMS(int db2pg_sys_id) throws Exception {
		return db2pgSettingDAO.selectDBMS(db2pg_sys_id);
	}

	@Override
	public void insertDb2pgWork(DDLConfigVO ddlConfigVO) throws Exception {
		db2pgSettingDAO.insertDb2pgWork(ddlConfigVO);
	}

	@Override
	public void insertDb2pgWorkData(DataConfigVO dataConfigVO) throws Exception {
		db2pgSettingDAO.insertDb2pgWorkData(dataConfigVO);
	}

	@Override
	public int selectWorkSeq() throws Exception {
		return db2pgSettingDAO.selectWorkSeq();
	}

	@Override
	public void updateDDLSavePth(Map<String, Object> param) throws Exception {
		db2pgSettingDAO.updateDDLSavePth(param);
		
	}

	@Override
	public void updateTransSavePth(Map<String, Object> param) throws Exception {
		db2pgSettingDAO.updateTransSavePth(param);
		
	}



}
