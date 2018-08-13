
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class INT {
	public INT() {
	}

	public INT(int value){
		this.value=value;
	}

	public int value;
	
	@Override
	public int hashCode() {
		return value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof INT) {
			INT other = (INT) obj;
			return this.value == other.value;
		}
		return false;
	}
}
