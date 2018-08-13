
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class BYTE {
	public BYTE() {
	}

	public BYTE(byte value){
		this.value=value;
	}

	public byte value;
	
	@Override
	public int hashCode() {
		return (int)value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof BYTE) {
			BYTE other = (BYTE) obj;
			return this.value == other.value;
		}
		return false;
	}
}
