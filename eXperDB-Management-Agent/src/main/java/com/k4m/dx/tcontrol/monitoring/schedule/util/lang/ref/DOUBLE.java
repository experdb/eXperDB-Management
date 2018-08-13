
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class DOUBLE {
	public DOUBLE() {
	}

	public DOUBLE(double value){
		this.value=value;
	}

	public double value;
	
	@Override
	public int hashCode() {
		return (int)value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof DOUBLE) {
			DOUBLE other = (DOUBLE) obj;
			return this.value == other.value;
		}
		return false;
	}
}
