
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class BOOLEAN {
	public BOOLEAN() {
	}

	public BOOLEAN(boolean value) {
		this.value = value;
	}

	public boolean value;

	@Override
	public int hashCode() {
		return value ? 1 : 0;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof BOOLEAN) {
			BOOLEAN other = (BOOLEAN) obj;
			return this.value == other.value;
		}
		return false;
	}
}
