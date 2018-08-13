
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.conf;

public enum ValueType {
	VALUE(1),
	NUM(2),
	BOOL(3),
	COMMA_SEPARATED_VALUE(4),
	;

	int type;
	ValueType(int type) {
		this.type = type;
	}

	public int getType() {
		return type;
	}

	public static ValueType of(int type) {
		ValueType[] values = values();
		for (ValueType value : values) {
			if (value.type == type) {
				return value;
			}
		}
		return VALUE;
	}
}
