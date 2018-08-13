
package com.k4m.dx.tcontrol.monitoring.schedule.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DecimalValue;


public class FormatUtil {

	public static String print(Object o, String format) {
		if (o == null)
			return "";
		if (format == null)
			return o.toString();
		try {
			if (o instanceof java.util.Date) {
				return new SimpleDateFormat(format).format((Date) o);
			} else if (o instanceof Number || o instanceof BigDecimal) {
				return new DecimalFormat(format).format(o);
			} else if (o instanceof DecimalValue) {
				return new DecimalFormat(format).format(new Long(((DecimalValue) o).value));
			}
		} catch (Throwable e) {
		}
		return o.toString();
	}

	private static String[] unit = { "B", "K", "M", "G", "T", "P" };

	public static String printMem(double mem) {
		int x = 0;
		for (x = 0; mem >= 1024 && x < unit.length; x++) {
			mem /= 1024;
		}
		if (x == 0)
			return mem + unit[0];
		return print(mem, "#,##0.0") + unit[x];
	}
public static void main(String[] args) {
	System.out.println(printMem(1024L*1024*1024L));
}
}
