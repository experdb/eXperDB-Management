
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.io.IOException;

public class NullValue implements Value {
	public static NullValue value = new NullValue();

	public int compareTo(Object o) {
		if (o instanceof NullValue) {
			return 0;
		}
		return 1;
	}

	public boolean equals(Object o) {
		return (o instanceof NullValue);
	}

	public int hashCode() {
		return 0;
	}

	public byte getValueType() {
		return ValueEnum.NULL;
	}


	public String toString() {
		return null;
	}

	public Object toJavaObject() {
		return null;
	}

}