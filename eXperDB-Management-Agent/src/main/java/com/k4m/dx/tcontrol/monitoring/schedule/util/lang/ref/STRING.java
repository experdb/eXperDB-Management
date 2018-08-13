
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref;

public class STRING {
	public STRING() {
	}

	public STRING(String value) {
		this.value = value;
	}

	public String value;

	@Override
	public int hashCode() {
		return ((value == null) ? 0 : value.hashCode());
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof STRING) {
			STRING other = (STRING) obj;
			if (this.value == other.value)
				return true;
			if (this.value == null)
				return false;
			return this.value.equals(other.value);
		}
		return false;
	}

}
