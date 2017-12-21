package com.k4m.dx.tcontrol.db;

import java.util.List;

import com.k4m.dx.tcontrol.db.datastructure.DataTable;
import com.k4m.dx.tcontrol.util.CommonUtil;



public class CommonDbCtl {	
	//일반 Insert 함수
	public static int InsCommonFunc(String XML_PATH, String POOL_NAME, String SQL_ID, DataTable dt) throws Exception{
		if(dt == null || dt.getRows().size() == 0) return 0;
		DataAdapter DA = DataAdapter.getInstance(POOL_NAME);
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.Insert(sql, dt);
		return ret;
	}
	
	//범용으로 SELECT 사용할 수 있는 함
	public static DataTable GetCommonData(String XML_PATH, String POOL_NAME, String SQL_ID, List<Object> binds) throws Exception{
		DataAdapter DA = DataAdapter.getInstance(POOL_NAME);
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		DataTable dt = DA.Fill(sql, binds);
		return dt;
	}
	
	//일반 Execute함수(Delete/Update/Insert)
	public static int ExecuteCommonFunc(String XML_PATH, String POOL_NAME, String SQL_ID, List<Object> binds) throws Exception{
		DataAdapter DA = DataAdapter.getInstance(POOL_NAME);
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.DeleteOrUpdate(sql, binds);
		return ret;
	}
	
	//일반 Insert 함수
	public static int InsCommonFunc( DataAdapter DA, String XML_PATH, String POOL_NAME, String SQL_ID, DataTable dt) throws Exception{	
		if(dt == null || dt.getRows().size() == 0) return 0;
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.Insert(sql, dt);
		return ret;
	}
	
	//범용으로 SELECT 사용할 수 있는 함수
	public static DataTable GetCommonData(DataAdapter DA, String XML_PATH, String POOL_NAME, String SQL_ID, List<Object> binds) throws Exception{
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		DataTable dt = DA.Fill(sql, binds);
		return dt;
	}
	
	//일반 Execute함수
	public static int ExecuteCommonFunc(DataAdapter DA, String XML_PATH, String POOL_NAME, String SQL_ID, List<Object> binds) throws Exception{
		String sql = CommonUtil.GetDataFromXml(XML_PATH, SQL_ID, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_TYPE, DBCPPoolManager.getConfigInfo(POOL_NAME).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.DeleteOrUpdate(sql, binds);
		return ret;
	}
	
	/*
	//일반 Insert 함수
	public static int InsCommonFunc(String SQL_ID, DataTable dt) throws Exception{		
		DataAdapter DA = DataAdapter.getInstance(Constant.POOLNAME.REPOSITORY.name());
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.Insert(sql, dt);
		return ret;
	}
	
	//범용으로 SELECT 사용할 수 있는 함
	public static DataTable GetCommonData(String SQL_ID, List<Object> binds) throws Exception{
		DataAdapter DA = DataAdapter.getInstance(Constant.POOLNAME.REPOSITORY.name());
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		DataTable dt = DA.Fill(sql, binds);
		return dt;
	}
	
	//일반 Execute함수(Delete/Update/Insert)
	public static int ExecuteCommonFunc(String SQL_ID, List<Object> binds) throws Exception{
		DataAdapter DA = DataAdapter.getInstance(Constant.POOLNAME.REPOSITORY.name());
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.DeleteOrUpdate(sql, binds);
		return ret;
	}
	
	//일반 Insert 함수
	public static int InsCommonFunc(DataAdapter DA, String SQL_ID, DataTable dt) throws Exception{		
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.Insert(sql, dt);
		return ret;
	}
	
	//범용으로 SELECT 사용할 수 있는 함
	public static DataTable GetCommonData(DataAdapter DA, String SQL_ID, List<Object> binds) throws Exception{
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		DataTable dt = DA.Fill(sql, binds);
		return dt;
	}
	
	//일반 Execute함수
	public static int ExecuteCommonFunc(DataAdapter DA, String SQL_ID, List<Object> binds) throws Exception{
		String sql = CommonUtil.GetDataFromXml(Constant.REPOSQL_XML_PATH, SQL_ID, Constant.REPOSITORY_DB_TYPE, DBCPPoolManager.getConfigInfo(Constant.POOLNAME.REPOSITORY.name()).DB_VER,  Constant.XML_SQL_ELEMENT);
		
		int ret = DA.DeleteOrUpdate(sql, binds);
		return ret;
	}
	*/
}
