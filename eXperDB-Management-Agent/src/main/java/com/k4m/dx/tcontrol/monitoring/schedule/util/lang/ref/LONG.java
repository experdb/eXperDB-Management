
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class LONG {
	public LONG() {
	}

	public LONG(long value){
		this.value=value;
	}

	public long value;
	@Override
	public int hashCode() {
		return (int) value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof LONG) {
			LONG other = (LONG) obj;
			return this.value == other.value;
		}
		return false;
	}
}
