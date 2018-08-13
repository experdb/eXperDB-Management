
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

public enum AlertLevelEnum {
	INFO(0),
	WARN(1),
	ERROR(2),
	FATAL(3),
	;

	private int level;

	AlertLevelEnum(int level) {
		this.level = level;
	}

	public int getLevel() {
		return this.level;
	}

	public static AlertLevelEnum of(int b) {
		for (AlertLevelEnum level : AlertLevelEnum.values()) {
			if (level.level == b) {
				return level;
			}
		}
		return INFO;
	}
}
