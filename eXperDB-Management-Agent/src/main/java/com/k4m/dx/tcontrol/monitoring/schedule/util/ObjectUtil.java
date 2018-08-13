
package com.k4m.dx.tcontrol.monitoring.schedule.util;

public class ObjectUtil {

	public static String toString(Object o) {
		return o==null?"":o.toString();
	}

	 public static boolean equals(Object o1, Object o2) {
        if (o1 == o2) {
            return true;
        }
        if ((o1 == null) || (o2 == null)) {
            return false;
        }
        return o1.equals(o2);
	 }
}
