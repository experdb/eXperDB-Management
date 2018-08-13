
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

public class TextValue implements Value, Comparable {

	public String value;

	public TextValue() {
	}

	public TextValue(String value) {
		this.value = (value == null ? "" : value);
	}

	public int compareTo(Object o) {
		if (o instanceof TextValue) {
			if (this.value == null) {
				return ((TextValue) o).value == null ? 0 : -1;
			}
			return this.value.compareTo(((TextValue) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof TextValue) {
			if (this.value == null) {
				return ((TextValue) o).value == null;
			}
			return this.value.equals(((TextValue) o).value);
		}
		return false;
	}

	public int hashCode() {
		if (this.value == null)
			return 0;
		return this.value.hashCode();
	}

	public byte getValueType() {
		return ValueEnum.TEXT;
	}



	public String toString() {
		return value;
	}


	public Object toJavaObject() {
		return this.value;
	}
}