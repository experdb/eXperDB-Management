
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

public class DecimalValue extends NumberValue implements Value, Comparable {

	public long value;

	public DecimalValue() {
	}

	public DecimalValue(long value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof DecimalValue) {
			long thisVal = this.value;
			long anotherVal = ((DecimalValue) o).value;
			return (thisVal < anotherVal ? -1 : (thisVal == anotherVal ? 0 : 1));
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof DecimalValue) {
			return this.value == ((DecimalValue) o).value;
		}
		return false;
	}

	public int hashCode() {
		return (int) (value ^ (value >>> 32));
	}

	public byte getValueType() {
		return ValueEnum.DECIMAL;
	}



	public String toString() {
		return Long.toString(value);
	}

	// ////////////////////////////////
	public double doubleValue() {
		return value;
	}

	public float floatValue() {
		return (float) value;
	}

	public int intValue() {
		return (int) value;
	}

	public long longValue() {
		return (long) value;
	}

	public Object toJavaObject() {
		return this.value;
	}
}