
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

public class BooleanValue implements Value, Comparable {

	public boolean value;

	public BooleanValue() {
	}

	public BooleanValue(boolean value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof BooleanValue) {
			boolean thisVal = this.value;
			boolean anotherVal = ((BooleanValue) o).value;
			if (thisVal == anotherVal)
				return 0;
			return thisVal ? 1 : -1;
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof BooleanValue) {
			return this.value == ((BooleanValue) o).value;
		}
		return false;
	}

	public int hashCode() {
		return value ? 1 : 0;
	}

	public byte getValueType() {
		return ValueEnum.BOOLEAN;
	}


	public String toString() {
		return Boolean.toString(value);
	}

	public Object toJavaObject() {
		return this.value;
	}
}