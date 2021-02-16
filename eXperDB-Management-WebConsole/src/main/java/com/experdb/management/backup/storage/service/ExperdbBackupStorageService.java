package com.experdb.management.backup.storage.service;

import java.util.*;

import javax.servlet.http.*;

import org.json.simple.*;

import com.experdb.management.backup.service.*;


public interface ExperdbBackupStorageService {
	
	void backupStorageInsert(HttpServletRequest request);
	
	List<Map<String, Object>> backupStorageList();

	BackupLocationInfoVO backupStorageInfo(HttpServletRequest request);

	void backupStorageUpdate(HttpServletRequest request);

	void backupStorageDelete(HttpServletRequest request);

	boolean checkStoragePath(HttpServletRequest request);
	
}
