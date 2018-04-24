package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.joda.time.DateTime;

/**
* AuditLogSiteStatCondition
* 
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class AuditLogSiteStatCondition extends AbstractJSONAwareModel {

	private String			searchAgentLogDateTime;

	private String			searchAgentLogDateTimeFrom;

	private String			searchAgentLogDateTimeTo;

	private String			categoryColumn;

	private int				seriesStartPosition;

	private int				seriesLength;

	private int				seriesType;

	public static final int	SERIES_HOURLY	= 1;

	public static final int	SERIES_DAILY	= 2;

	public static final int	SERIES_MONTHLY	= 3;

	public static final int	SERIES_YEARLY	= 4;

	private List<String>	seriesList;

	public static AuditLogSiteStatCondition fromString(String jsonString) {
		return fromString(jsonString, AuditLogSiteStatCondition.class);
	}

	public String getCategoryColumn() {
		return categoryColumn;
	}

	public void setCategoryColumn(String categoryColumn) {
		this.categoryColumn = categoryColumn;
	}

	public void initSeriesList(int seriesType, String dateTimeFromString14, String dateTimeToString14) {
		switch (seriesType) {
			case SERIES_HOURLY:
				seriesList = new ArrayList<String>(24);
				for (int i = 0; i < 24; i++) {
					seriesList.add(String.format("%02d", i));
				}
				setSeriesStartPosition(9);
				setSeriesLength(2);
				break;
			case SERIES_DAILY:
				DateTime dateTime = DateTime.parse(getDateTimeFormatted(dateTimeFromString14));
				Calendar c = Calendar.getInstance();
				c.setTime(dateTime.toDate());
				int lastDay = c.getActualMaximum(Calendar.DAY_OF_MONTH);
				seriesList = new ArrayList<String>(lastDay);
				for (int i = 1; i <= lastDay; i++) {
					seriesList.add(String.format("%02d", i));
				}
				setSeriesStartPosition(7);
				setSeriesLength(2);
				break;
			case SERIES_MONTHLY:
				seriesList = new ArrayList<String>(12);
				for (int i = 1; i <= 12; i++) {
					seriesList.add(String.format("%02d", i));
				}
				setSeriesStartPosition(5);
				setSeriesLength(2);
				break;
			case SERIES_YEARLY:
				if (dateTimeToString14 == null) {
					seriesList = new ArrayList<String>(1);
					seriesList.add(dateTimeFromString14.substring(0, 5));
				} else {
					DateTime dateTimeFrom = DateTime.parse(getDateTimeFormatted(dateTimeFromString14));
					DateTime dateTimeTo = DateTime.parse(getDateTimeFormatted(dateTimeToString14));
					for (int i = dateTimeFrom.getYear(); i <= dateTimeTo.getYear(); i++) {
						seriesList.add(String.valueOf(i));
					}
				}
				break;
		}
	}

	public int getSeriesType() {
		return seriesType;
	}

	public void setSeriesDefinition(int seriesType) {
		this.seriesType = seriesType;
	}

	public String getDateTimeFormatted(String dateTimeString14) {
		return String.format("%s-%s-%s %s:%s:%s"
				, dateTimeString14.substring(0, 4)
				, dateTimeString14.substring(4, 6)
				, dateTimeString14.substring(6, 8)
				, dateTimeString14.substring(8, 10)
				, dateTimeString14.substring(10, 12)
				, dateTimeString14.substring(12)
				);
	}

	public String getSearchAgentLogDateTime() {
		return searchAgentLogDateTime;
	}

	public void setSearchAgentLogDateTime(String searchAgentLogDateTime) {
		this.searchAgentLogDateTime = searchAgentLogDateTime;
	}

	public String getSearchAgentLogDateTimeFrom() {
		return searchAgentLogDateTimeFrom;
	}

	public void setSearchAgentLogDateTimeFrom(String searchAgentLogDateTimeFrom) {
		this.searchAgentLogDateTimeFrom = searchAgentLogDateTimeFrom;
	}

	public String getSearchAgentLogDateTimeTo() {
		return searchAgentLogDateTimeTo;
	}

	public void setSearchAgentLogDateTimeTo(String searchAgentLogDateTimeTo) {
		this.searchAgentLogDateTimeTo = searchAgentLogDateTimeTo;
	}

	public int getSeriesStartPosition() {
		return seriesStartPosition;
	}

	public void setSeriesStartPosition(int seriesStartPosition) {
		this.seriesStartPosition = seriesStartPosition;
	}

	public int getSeriesLength() {
		return seriesLength;
	}

	public void setSeriesLength(int seriesLength) {
		this.seriesLength = seriesLength;
	}
}
