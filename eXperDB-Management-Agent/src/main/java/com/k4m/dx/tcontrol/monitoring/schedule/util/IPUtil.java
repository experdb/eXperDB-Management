
package com.k4m.dx.tcontrol.monitoring.schedule.util;

import java.io.ByteArrayOutputStream;

public class IPUtil {
	
	
	public static String toString(int ip) {
		return toString(BytesUtil.toBytes(ip));
	}
	public static String toString(byte[] ip) {
		if (ip == null)
			return "0.0.0.0";
		try {
			StringBuffer sb = new StringBuffer();
			sb.append(ip[0] & 0xff);
			sb.append(".");
			sb.append(ip[1] & 0xff);
			sb.append(".");
			sb.append(ip[2] & 0xff);
			sb.append(".");
			sb.append(ip[3] & 0xff);
			return sb.toString();
		} catch (Throwable e) {
			return "0.0.0.0";
		}
	}

	public static byte[] toBytes(String ip) {
		if (ip == null) {
			return empty;
		}
		byte[] result = new byte[4];
		String[] s = StringUtil.split(ip, '.');
		long val;
		try {
			if (s.length != 4)
				return empty;

			for (int i = 0; i < 4; i++) {
				val = Integer.parseInt(s[i]);
				if (val < 0 || val > 0xff)
					return null;
				result[i] = (byte) (val & 0xff);
			}
		} catch (Throwable e) {
			return empty;
		}
		return result;
	}

	public static boolean isOK(byte[] ip){
		return  ip != null && ip.length==4;
	}
	public static boolean isNotLocal(byte[] ip) {
		return isOK(ip) && (ip[0] & 0xff) != 127;
	}

	private static byte[] empty = new byte[] { 0, 0, 0, 0 };


	public static void main(String[] args) {
		String[] s = StringUtil.split("127.0.0.1", '.');
		System.out.println(s[0]);
		System.out.println(s[1]);
		System.out.println(s[2]);
		System.out.println(s[3]);
	}
}