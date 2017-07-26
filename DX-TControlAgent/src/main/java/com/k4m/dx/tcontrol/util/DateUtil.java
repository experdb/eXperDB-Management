package com.k4m.dx.tcontrol.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Date Utils
 * @author thpark
 *
 */
public class DateUtil {
	
	/**
	 * 현재 년월일을 구한다.
	 * @return
	 * @throws Exception
	 */
	public static String getYMD() throws Exception {
		Calendar c = Calendar.getInstance();
		String strYmd = "";
		String strMonth = "";
		String strDay = "";
		
		strYmd = String.valueOf(c.get(Calendar.YEAR));
		strMonth = ("0" + String.valueOf(c.get(Calendar.MONTH) + 1));
		
		strYmd += strMonth.substring(strMonth.length()-2);
		
		strDay = "0" + String.valueOf(c.get(Calendar.DATE));
		strDay = strDay.substring(strDay.length()-2);
		strYmd += strDay;
		
		return strYmd;
	}
	
	/**
	 * 현재 년,월,일 을 구한다.
	 * YYYY : 년도 리턴
	 * MM : 월 리턴
	 * DD : 일자 리턴
	 * @param strDateGbn
	 * @return
	 * @throws Exception
	 */
	public String getDate(String strDateGbn) throws Exception {
		Calendar c = Calendar.getInstance();
		String strReturnDate = "";
		String strYmd = "";
		String strMonth = "";
		String strDay = "";
		
		strYmd = String.valueOf(c.get(Calendar.YEAR));
		strMonth = ("0" + String.valueOf(c.get(Calendar.MONTH) + 1));
		strMonth = strMonth.substring(strMonth.length()-2);
		
		strDay = "0" + String.valueOf(c.get(Calendar.DATE));
		strDay = strDay.substring(strDay.length()-2);
		
		if(strDateGbn.equals("YYYY")) {
			strReturnDate = strYmd;
		} else if(strDateGbn.equals("MM")) {
			strReturnDate = strMonth;
		} else if(strDateGbn.equals("DD")) {
			strReturnDate = strDay;
		}
		
		return strReturnDate;
	}
	
	/**
	 * 현재 시각을 구한다.
	 * @return
	 * @throws Exception
	 */
	public String getTime() throws Exception {
		String strReturnTime = "";
		
		Date dt = new Date();
		//System.out.println(dt.toString());
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm"); 
		//System.out.println(sdf.format(dt).toString()); 
		strReturnTime = sdf.format(dt).toString();
		return strReturnTime;
	}
	
	/**
	 * 현재 요일을 구한다.
	 * @return
	 */
	public String getDayOfWeek() {
	   Calendar oCalendar = Calendar.getInstance( );  // 현재 날짜/시간 등의 각종 정보 얻기
	   final String[] week = { "일", "월", "화", "수", "목", "금", "토" };

	   return week[oCalendar.get(Calendar.DAY_OF_WEEK) - 1];
	}
	
	/**
	 * String YYYYMMDD 를 날짜로 변환
	 * @param strDateYMD
	 * @return
	 * @throws Exception
	 */
	public static Date getDateToString(String strDateYMD) throws Exception {
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date transDate = transFormat.parse(strDateYMD);
		
		return transDate;
	}
	
	public static void main(String args[]) throws Exception{
		DateUtil dt = new DateUtil();
		
		//System.out.println(dt.getYMD());
		/**
		System.out.println("YYYY : " + dt.getDate("YYYY"));
		System.out.println("MM : " + dt.getDate("MM"));
		System.out.println("DD : " + dt.getDate("DD"));
		
		System.out.println("time : " + dt.getTime());
		
		System.out.println("week : " + dt.getDayOfWeek());
		**/
		
		Date a = getDateToString("2017-07-25 09:51:14");
		Date b = getDateToString("2017-07-26");
		Date c = getDateToString("2017-07-22");
		
		
		System.out.println(a.compareTo(b));
		System.out.println(a.compareTo(c));
		System.out.println(a.compareTo(a));
		
	}

}
