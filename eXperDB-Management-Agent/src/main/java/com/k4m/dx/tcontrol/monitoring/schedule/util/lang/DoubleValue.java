
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.text.DecimalFormat;


public class DoubleValue extends NumberValue implements Value , Comparable {

	public double value;

	public DoubleValue() {
	}

	public DoubleValue(double value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof DoubleValue) {
			return Double.compare(this.value, ((DoubleValue) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof DoubleValue) {
			return this.value == ((DoubleValue) o).value;
		}
		return false;
	}

	public int hashCode() {
		long v = Double.doubleToLongBits(value);
		return (int) (v ^ (v >>> 32));
	}

	public byte getValueType() {
		return ValueEnum.DOUBLE;
	}


	public String toString() {
		return new DecimalFormat("#0.0#################").format(new Double(value));
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