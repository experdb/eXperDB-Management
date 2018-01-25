/**
 * <pre>
 * Copyright (c) 2014 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @brief 데이터 형과 관련된 Utility 기능 담당
 * 
 *        데이터 형과 관련된 Utility 기능을 담당한다.
 * @date 2014. 12. 29.
 * @author Kim, Sunho
 */

public class TypeUtility {
	
	private static final String			charSet						= "UTF-8";
	
	public static String makeRequestBody(Map body) throws Exception {
		StringBuffer sbB = new StringBuffer();
		for (Iterator itr = body.entrySet().iterator(); itr.hasNext();) {
			Entry entry = (Entry) itr.next();
			if (!(entry.getValue() instanceof List)) {
				try {
					sbB.append(entry.getKey().toString()).append("=").append(URLEncoder.encode(entry.getValue().toString(), charSet)).append("&");
				} catch (UnsupportedEncodingException e) {
					throw e;
				}
			} else {
				List listBody = (List) entry.getValue();
				for (Iterator itrBody = listBody.iterator(); itrBody.hasNext();) {
					sbB.append(entry.getKey().toString()).append("=").append(URLEncoder.encode((String) itrBody.next(), charSet)).append("&");
				}
			}
		}

		return sbB.toString();
	}
	
	public static String getJustClassName(Class type) {
		return type.getName().substring(type.getName().lastIndexOf(".") + 1);
	}

	/**
	 * 입력된 문자열이 빈 문자열인지 확인한다.
	 * @param input - 빈 문자열인지 확인하고자 하는 문자열
	 * @return boolean - null, 공백 (연속 공백 포함) 일 경우 true, 그 이외의 경우 false 반환
	 */
	public static boolean isEmpty(String input) {
		if (input == null || input.trim().length() == 0) { return true; }
		return false;
	}

	/**
	 * 입력된 Date 형을 yyyy-MM-dd HH:mm:ss.SSS 포맷의 문자열로 반환한다.
	 * @param input - 변환할 Date 형
	 * @return String - 변환된 문자열
	 */
	public static String getDateTimeString(Date input) {
		SimpleDateFormat format = new SimpleDateFormat(SystemCode.DATETIME_FORMAT);
		return format.format(input);
	}

	public static boolean contains(String input, String[] in) {
		if (in == null || in.length < 1) { return false; }
		if (input == null) { return false; }
		for (int i = 0; i < in.length; i++) {
			if (input.equals(in[i])) { return true; }
		}
		return false;
	}

	public static boolean startWith(String input, String[] population) {
		if (population == null || population.length < 1) { return false; }
		if (input == null) { return false; }
		for (int i = 0; i < population.length; i++) {
			if (input.startsWith(population[i])) { return true; }
		}
		return false;
	}

	public static boolean endWith(String input, String[] population) {
		if (population == null || population.length < 1) { return false; }
		if (input == null) { return false; }
		for (int i = 0; i < population.length; i++) {
			if (input.endsWith(population[i])) { return true; }
		}
		return false;
	}

	public static boolean testComplexity(String input) {
		if (TypeUtility.isEmpty(input)) { return false; }

		if (input.length() < 8) { return false; }

		return true;
	}

	public static byte[] mergeBytes(byte[]... bytes) {
		if (bytes == null || bytes.length < 1) { return null; }
		int length = 0;
		for (int i = 0; i < bytes.length; i++) {
			length += bytes[i].length;
		}

		if (length == 0) { return null; }
		byte[] retval = new byte[length];

		int start = 0;
		for (int i = 0; i < bytes.length; i++) {
			System.arraycopy(bytes[i], 0, retval, start, bytes[i].length);
			start += bytes[i].length;
		}

		return retval;
	}

	public static boolean isEqual(String val1, String val2) {
		if (val1 == null && val2 == null) {
			return true;
		}
		else if (val1 != null && val2 != null && val1.equals(val2)) { return true; }
		return false;
	}
}
