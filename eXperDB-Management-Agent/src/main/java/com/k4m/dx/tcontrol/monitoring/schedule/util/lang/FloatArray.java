
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.util.Arrays;

import com.k4m.dx.tcontrol.monitoring.schedule.util.CompareUtil;


public class FloatArray  implements Value, Comparable {

	public float[] value;

	public FloatArray() {
	}

	public FloatArray(float[] value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof FloatArray) {
			return CompareUtil.compareTo(this.value, ((FloatArray) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof FloatArray) {
			return Arrays.equals(this.value,((FloatArray) o).value);
		}
		return false;
	}

	private int _hash;
	public int hashCode() {
		if(_hash==0){
			_hash= Arrays.hashCode(this.value);
		}
		return _hash;
	}

	public byte getValueType() {
		return ValueEnum.ARRAY_FLOAT;
	}


	public String toString() {
		return Arrays.toString(value);
	}

	public Object toJavaObject() {
		return this.value;
	}
}