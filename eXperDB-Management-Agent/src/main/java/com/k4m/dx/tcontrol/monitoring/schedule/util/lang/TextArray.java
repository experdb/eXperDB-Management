
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.io.IOException;
import java.util.Arrays;

import com.k4m.dx.tcontrol.monitoring.schedule.util.CompareUtil;

public class TextArray  implements Value, Comparable {

	public String[] value;

	public TextArray() {
	}

	public TextArray(String[] value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof TextArray) {
			return CompareUtil.compareTo(this.value, ((TextArray) o).value);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof TextArray) {
			return Arrays.equals(this.value,((TextArray) o).value);
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
		return ValueEnum.ARRAY_TEXT;
	}



	public String toString() {
		return Arrays.toString(value);
	}

	public Object toJavaObject() {
		return this.value;
	}
}