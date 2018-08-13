
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.CompareUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.IPUtil;

public class IP4Value implements Value, Comparable {

	private final static byte[] empty = new byte[4];
	public byte[] value = empty;

	public IP4Value() {
	}

	public IP4Value(String ip) {
		this.value = IPUtil.toBytes(ip);
	}

	public IP4Value(byte[] value) {
		this.value = value;
	}

	public int compareTo(Object o) {
		if (o instanceof IP4Value) {
			byte[] thisVal = this.value;
			byte[] anotherVal = ((IP4Value) o).value;
			return CompareUtil.compareTo(thisVal, anotherVal);
		}
		return 1;
	}

	public boolean equals(Object o) {
		if (o instanceof IP4Value) {
		
			byte[] thisVal = this.value;
			byte[] anotherVal = ((IP4Value) o).value;
			if(thisVal==null || anotherVal==null)
				return thisVal==anotherVal;
			
			for (int i = 0; i < 4; i++) {
				if (thisVal[i] != anotherVal[i])
					return false;
			}
			return true;
		}
		return false;
	}


	public static void main(String[] args) {
		System.out.println(new IP4Value().hashCode());
	}

	public byte getValueType() {
		return ValueEnum.IP4ADDR;
	}



	public String toString() {
		if (value == null)
			value = empty;
		return IPUtil.toString(value);
	}

	public Object toJavaObject() {
		if (value == null)
			value = empty;
		return IPUtil.toString(value);
	}
}