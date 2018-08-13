
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class SHORT {
	public SHORT() {
	}

	public SHORT(short value) {
		this.value = value;
	}

	public short value;

	@Override
	public int hashCode() {
		return (int) value;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof SHORT) {
			SHORT other = (SHORT) obj;
			return this.value == other.value;
		}
		return false;
	}
}
