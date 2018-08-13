
package com.k4m.dx.tcontrol.monitoring.schedule.util;

public class Hexa32 {

	private static final char PLUS = 'x';
	private static final char MINUS = 'z';

	public static String toString32(long num) {
		boolean minus = num < 0;
		if (minus) {
			if (num == Long.MIN_VALUE)
				return min;
			return MINUS + Long.toString(-num, 32);
		} else {
			if (num < 10)
				return Long.toString(num);
			else
				return PLUS + Long.toString(num, 32);
		}
	}

	private final static String min = "z8000000000000";

	public static long toLong32(String str) {
		if (str == null || str.length() == 0)
			return 0;

		switch (str.charAt(0)) {
		case MINUS:
			if (min.equals(str))
				return Long.MIN_VALUE;
			else
				return -1 * Long.parseLong(str.substring(1), 32);
		case PLUS:
			return Long.parseLong(str.substring(1), 32);
		default:
			return Long.parseLong(str);
		}
	}

	public static void main(String[] args) {
		System.out.println(Hexa32.toLong32("z6eq8mqkdkpt7c"));
		System.out.println(Hexa32.toString32(100000001L));
	}
}
