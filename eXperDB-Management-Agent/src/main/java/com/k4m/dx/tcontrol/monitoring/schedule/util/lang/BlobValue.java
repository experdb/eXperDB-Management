
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import com.k4m.dx.tcontrol.monitoring.schedule.util.CompareUtil;



public class BlobValue implements Value, Comparable {

	public byte[] value;

	public BlobValue() {
	}

	public BlobValue(byte[] value) {
		this.value = (value == null ? new byte[0] : value);
	}

	public int compareTo(Object o) {
		if (o instanceof BlobValue) {
			if (this.value == null) {
				return ((BlobValue) o).value == null ? 0 : -1;
			}
			return CompareUtil.compareTo(this.value, ((BlobValue) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof BlobValue) {
			if (this.value == null) {
				return ((BlobValue) o).value == null;
			}
			return this.value.equals(((BlobValue) o).value);
		}
		return false;
	}

	public int hashCode() {
		if (this.value == null)
			return 0;
		return this.value.hashCode();
	}

	public byte getValueType() {
		return ValueEnum.BLOB;
	}


	public String toString() {
		if (value == null)
			return null;
		return "byte[" + value.length + "]";
	}

	public Object toJavaObject() {
		return this.value;
	}
}