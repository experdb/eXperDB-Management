
package com.k4m.dx.tcontrol.monitoring.schedule.util;


public class CompareUtil {
	public static int compareTo(byte[] l, byte[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(short[] l, short[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(int[] l, int[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(float[] l, float[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(long[] l, long[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(double[] l, double[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;

		for (int i = 0; i < l.length && i < r.length; i++) {
			if (l[i] > r[i])
				return 1;
			if (l[i] < r[i])
				return -1;
		}
		return l.length - r.length;
	}

	public static int compareTo(Comparable[] l, Comparable[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			int c = compareTo(l[i], r[i]);
			if (c != 0)
				return c;
		}
		return l.length - r.length;
	}
	public static int compareTo(String[] l, String[] r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		for (int i = 0; i < l.length && i < r.length; i++) {
			int c = compareTo(l[i], r[i]);
			if (c != 0)
				return c;
		}
		return l.length - r.length;
	}
	public static boolean equals(byte[] l, byte[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(short[] l, short[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(int[] l, int[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(float[] l, float[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(long[] l, long[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(double[] l, double[] r) {
		return compareTo(l, r) == 0;
	}

	public static boolean equals(String[] l, String[] r) {
		return compareTo(l, r) == 0;
	}

	public static int compareTo(String l, String r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		return l.compareTo(r);
	}
	public static int compareTo(Comparable l, Comparable r) {
		if (l == null && r == null)
			return 0;
		if (l == null)
			return -1;
		if (r == null)
			return 1;
		return l.compareTo(r);
	}

	public static boolean equals(String l, String r) {
		if (l == null)
			return r == null;
		else
			return l.equals(r);
	}
	public static boolean equals(Object l, Object r) {
		if (l == null)
			return r == null;
		else
			return l.equals(r);
	}
	public static boolean equals(long l, long r) {
		return l==r;
	}
	public static boolean equals(int l, int r) {
		return l==r;
	}

}