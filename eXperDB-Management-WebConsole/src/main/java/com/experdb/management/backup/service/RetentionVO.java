package com.experdb.management.backup.service;

import java.io.Serializable;

public class RetentionVO implements Serializable {

	private static final long serialVersionUID = -1540233930663347878L;
	/*    */ public static final int LAST_DAY = 32;
	/*    */ public static final int LAST_SUNDAY = 33;
	/*    */ public static final int LAST_MONDAY = 34;
	/*    */ public static final int LAST_TUESDAY = 35;
	/*    */ public static final int LAST_WEDNESDAY = 36;
	/*    */ public static final int LAST_THURSDAY = 37;
	/*    */ public static final int LAST_FRIDAY = 38;
	/*    */ public static final int LAST_SATURDAY = 39;
	private int backupSetCount;
	private int dayOfMonth;
	private int dayOfWeek;
	private String useWeekly;

	public int getBackupSetCount() {
		return backupSetCount;
	}

	public void setBackupSetCount(int backupSetCount) {
		this.backupSetCount = backupSetCount;
	}

	public int getDayOfMonth() {
		return dayOfMonth;
	}

	public void setDayOfMonth(int dayOfMonth) {
		this.dayOfMonth = dayOfMonth;
	}

	public int getDayOfWeek() {
		return dayOfWeek;
	}

	public void setDayOfWeek(int dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	public String getUseWeekly() {
		return useWeekly;
	}

	public void setUseWeekly(String useWeekly) {
		this.useWeekly = useWeekly;
	}

	@Override
	public String toString() {
		return "RetentionVO [backupSetCount=" + backupSetCount + ", dayOfMonth=" + dayOfMonth + ", dayOfWeek="
				+ dayOfWeek + ", useWeekly=" + useWeekly + "]";
	}
	
	

}
