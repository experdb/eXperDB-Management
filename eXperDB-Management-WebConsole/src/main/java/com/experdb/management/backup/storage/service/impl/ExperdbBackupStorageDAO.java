package com.experdb.management.backup.storage.service.impl;

import java.util.*;

import javax.annotation.*;

import org.apache.ibatis.session.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.experdb.management.backup.service.*;

@Repository("ExperdbBackupStorageDAO")
public class ExperdbBackupStorageDAO {

    @Autowired 
	@Resource(name="sqlSessionTemplate") 
	private SqlSession sql; 
	
	@Autowired 
	@Resource(name="backupDB") 
	private SqlSession sql2;

	public void backupStorageInsert(BackupLocationInfoVO locationVO) {
		sql2.insert("backupStorageSql.backupStorageInsert", locationVO);
	}

	public List<BackupLocationInfoVO> backupStorageList() {
		return sql2.selectList("backupStorageSql.backupStorageList");
	}

	public BackupLocationInfoVO backupStorageInfo(BackupLocationInfoVO locationVO) {
		return sql2.selectOne("backupStorageSql.backupStorageInfo", locationVO);
	}

	public void backupStorageUpdate(BackupLocationInfoVO locationVO) {
		sql2.update("backupStorageSql.backupStorageUpdate", locationVO);
	}

	public void backupStorageDelete(BackupLocationInfoVO locationVO) {
		sql2.delete("backupStorageSql.backupStorageDelete", locationVO);
	}
	
}
