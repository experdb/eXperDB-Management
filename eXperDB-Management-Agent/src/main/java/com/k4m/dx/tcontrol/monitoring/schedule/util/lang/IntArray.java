
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.util.Arrays;

import com.k4m.dx.tcontrol.monitoring.schedule.util.CompareUtil;



public class IntArray  implements Value, Comparable {

	public int[] value;

	public IntArray() {
	}

	public IntArray(int[] value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof IntArray) {
			return CompareUtil.compareTo(this.value, ((IntArray) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof IntArray) {
			return Arrays.equals(this.value,((IntArray) o).value);
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
		return ValueEnum.ARRAY_INT;
	}



	public String toString() {
		return Arrays.toString(value);
	}

	public Object toJavaObject() {
		return this.value;
	}
}