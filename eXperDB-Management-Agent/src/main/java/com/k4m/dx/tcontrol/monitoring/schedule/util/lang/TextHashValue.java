
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.HashUtil;



public class TextHashValue implements Value, Comparable {

	public int value;

	public TextHashValue() {
	}

	public TextHashValue(int value) {
		this.value = value;
	}
	public TextHashValue(String str) {
		this.value = HashUtil.hash(str);
	}
	public int compareTo(Object o) {
		if (o instanceof TextHashValue) {
			long thisVal = this.value;
			long anotherVal = ((TextHashValue) o).value;
			return (thisVal < anotherVal ? -1 : (thisVal == anotherVal ? 0 : 1));
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof TextHashValue) {
			return this.value == ((TextHashValue) o).value;
		}
		return false;
	}

	public int hashCode() {
		return value;
	}

	public byte getValueType() {
		return ValueEnum.TEXT_HASH;
	}


	public String toString() {
		return Integer.toString(value,16);
	}

	public Object toJavaObject() {
		return this.value;
	}
}