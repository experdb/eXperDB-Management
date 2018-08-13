
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

public class FloatValue extends NumberValue  implements Value, Comparable {

	public float value;

	public FloatValue() {
	}

	public FloatValue(float value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof FloatValue) {
			return Float.compare(this.value, ((FloatValue) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof FloatValue) {
			return this.value == ((FloatValue) o).value;
		}
		return false;
	}

	public int hashCode() {
		return Float.floatToIntBits(value);
	}

	public byte getValueType() {
		return ValueEnum.FLOAT;
	}


	public String toString() {
		return Float.toString(value);
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