package com.experdb.proxy.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.StringTokenizer;

import org.apache.commons.lang3.time.FastDateFormat;

/**
* @author 최정환
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2021.02.24   최정환 	최초 생성
*      </pre>
*/
public class StrUtil {
	/************************************************************
	 * RETURN DATE STRING FORMAT INPUT
	 ************************************************************/
	public static String getCalFormat(Calendar cal, String format) {
		String str = "";
		try {
			str = FastDateFormat.getInstance(format).format(cal);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return str;
	}

	/************************************************************
	 * RETURN DATE STRING FORMAT INPUT
	 ************************************************************/
	public static String getCurTime(String format) {
		String str = "";
		try {
			Calendar cal = Calendar.getInstance();
			str = FastDateFormat.getInstance(format).format(cal);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return str;
	}

	/************************************************************
	 * RETURN DATE STRING FORMAT "HH:mm:ss"
	 ************************************************************/
	public static String getCurTime() {
		Timestamp ts = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			ts = Timestamp.valueOf(d);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return ts.toString().substring(11, 19);
	}

	/************************************************************
	 * RETURN DATE STRING FORMAT "yyyy-MM-dd HH:mm:ss"
	 ************************************************************/
	public static String getCurAllTime() {
		Timestamp ts = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			ts = Timestamp.valueOf(d);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return ts.toString().substring(0, 19);
	}

	/************************************************************
	 * RETURN English Month Name
	 ************************************************************/
	public static String getMonthName() {

		String[] month = { "January", "February", "March", "April", "May", "June", "July", "August", "September",
				"October", "November", "December" };
		String mon = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			Timestamp ts = Timestamp.valueOf(d);
			mon = ts.toString().substring(5, 7);

			if (mon.startsWith("0")) {
				mon = mon.substring(1, 2);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return month[Integer.parseInt(mon) - 1];
	}

	/************************************************************
	 * RETURN YEAR
	 ************************************************************/
	public static String getYear() {
		Timestamp ts = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			ts = Timestamp.valueOf(d);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return ts.toString().substring(0, 4);
	}

	/************************************************************
	 * RETURN DATE
	 ************************************************************/
	public static String getDate() {
		Timestamp ts = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			ts = Timestamp.valueOf(d);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return ts.toString().substring(8, 10);
	}

	/************************************************************
	 * RETURN DATE STRING FORMAT "HH:mm:ss"
	 ************************************************************/
	public static String getCurTime(int startIdx, int endIdx) {
		Timestamp ts = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String d = sdf.format(new java.util.Date());
			ts = Timestamp.valueOf(d);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return ts.toString().substring(startIdx, endIdx);
	}

	/************************************************************
	 * RETURN NAME STARTS WITH UPPER CASE FROM TOKENED NAME
	 ************************************************************/
	public static String getNameStartsWithUpperCase(String sName, String sDelim) {

		String sNewName = new String();
		StringTokenizer tokenizer = new StringTokenizer(sName, sDelim);
		String str = "";
		boolean bFirstToken = true;
		while (tokenizer.hasMoreTokens()) {
			if (bFirstToken) {
				bFirstToken = false;
				tokenizer.nextElement();
				continue;
			}
			str = (String) tokenizer.nextElement();
			str = str.substring(0, 1).toUpperCase() + str.substring(1);
			sNewName += str;
		}
		return sNewName;
	}

	/************************************************************
	 * RETURN "" if NULL
	 ************************************************************/
	public static String nvl(String str) {
		if (str == null) {
			return "";
		}

		return str.trim();
	}

	/************************************************************
	 * Check has null or empty value
	 ************************************************************/
	public static boolean isNvl(String str) {
		if (str == null || str.trim().length() == 0) {
			return true;
		}

		return false;
	}

	public static boolean isStringDouble(String s) {
		try {
			Double.parseDouble(s);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/************************************************************
	 * RETURN "" if NULL
	 ************************************************************/
	public static String nvlChg(String str, String rtn) {
		if (str == null) {
			return rtn;
		}

		return str.trim();
	}

	/************************************************************
	 * RETURN "" if NULL
	 ************************************************************/
	public static int nvlIntChg(Integer str, Integer rtn) {
		if (str == null) {
			return rtn;
		}

		return str;
	}
}
