package com.experdb.management.backup.service;

public class BackupScheduleVO {
	// 스케줄 day 
	private String year;
	private String month;
	private String day;

	private String repeat;
	private String interval;
	private String intervalUnit;
	
	private String startHour;
	private String startHourOfDay;
	private String startMinute;
	private String startHourType;
	private String endHour;
	private String endHourOfDay;
	private String endMinute;
	private String endHourType;
	
	private String backupType;
	
	private String dayType;

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	public String getRepeat() {
		return repeat;
	}

	public void setRepeat(String repeat) {
		this.repeat = repeat;
	}

	public String getInterval() {
		return interval;
	}

	public void setInterval(String interval) {
		this.interval = interval;
	}

	public String getIntervalUnit() {
		return intervalUnit;
	}

	public void setIntervalUnit(String intervalUnit) {
		this.intervalUnit = intervalUnit;
	}

	public String getStartHour() {
		return startHour;
	}

	public void setStartHour(String startHour) {
		this.startHour = startHour;
	}

	public String getStartMinute() {
		return startMinute;
	}

	public void setStartMinute(String startMinute) {
		this.startMinute = startMinute;
	}

	public String getStartHourType() {
		return startHourType;
	}

	public void setStartHourType(String startHourType) {
		this.startHourType = startHourType;
	}

	public String getEndHour() {
		return endHour;
	}

	public void setEndHour(String endHour) {
		this.endHour = endHour;
	}

	public String getEndMinute() {
		return endMinute;
	}

	public void setEndMinute(String endMinute) {
		this.endMinute = endMinute;
	}

	public String getEndHourType() {
		return endHourType;
	}

	public void setEndHourType(String endHourType) {
		this.endHourType = endHourType;
	}

	public String getDayType() {
		return dayType;
	}

	public void setDayType(String dayType) {
		this.dayType = dayType;
	}

	public String getStartHourOfDay() {
		return startHourOfDay;
	}

	public void setStartHourOfDay(String startHourOfDay) {
		this.startHourOfDay = startHourOfDay;
	}

	public String getEndHourOfDay() {
		return endHourOfDay;
	}

	public void setEndHourOfDay(String endHourOfDay) {
		this.endHourOfDay = endHourOfDay;
	}
	
	public String getBackupType() {
		return backupType;
	}

	public void setBackupType(String backupType) {
		this.backupType = backupType;
	}

	@Override
	public String toString() {
		return "BackupScheduleVO [year=" + year + ", month=" + month + ", day=" + day + ", repeat=" + repeat
				+ ", interval=" + interval + ", intervalUnit=" + intervalUnit + ", startHour=" + startHour
				+ ", startHourOfDay=" + startHourOfDay + ", startMinute=" + startMinute + ", startHourType="
				+ startHourType + ", endHour=" + endHour + ", endHourOfDay=" + endHourOfDay + ", endMinute=" + endMinute
				+ ", endHourType=" + endHourType + ", backupType=" + backupType + ", dayType=" + dayType + "]";
	}

	
	
}
