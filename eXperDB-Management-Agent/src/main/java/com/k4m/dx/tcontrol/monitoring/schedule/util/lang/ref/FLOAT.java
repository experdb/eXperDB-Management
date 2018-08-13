
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class FLOAT {
	public FLOAT() {
	}

	public FLOAT(float value){
		this.value=value;
	}

	public float value;
	
	@Override
	public int hashCode() {
		return (int)value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof FLOAT) {
			FLOAT other = (FLOAT) obj;
			return this.value == other.value;
		}
		return false;
	}
}
