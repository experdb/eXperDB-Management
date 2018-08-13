package com.k4m.dx.tcontrol.monitoring.schedule.util;

public class SystemUtil {

	public static final String USER_NAME = System.getProperty("user.name");
	public static final boolean IS_JAVA_1_2 = System.getProperty("java.specification.version").startsWith("1.2");
	public static final boolean IS_JAVA_1_3 = System.getProperty("java.specification.version").startsWith("1.3");
	public static final boolean IS_JAVA_1_4 = System.getProperty("java.specification.version").startsWith("1.4");
	public static final boolean IS_JAVA_1_5 = System.getProperty("java.specification.version").startsWith("1.5");
	public static final boolean IS_JAVA_1_6 = System.getProperty("java.specification.version").startsWith("1.6");
	public static final boolean IS_JAVA_1_7 = System.getProperty("java.specification.version").startsWith("1.7");
	public static final boolean IS_JAVA_1_8 = System.getProperty("java.specification.version").startsWith("1.8");
	public static final String JAVA_VERSION = System.getProperty("java.version");
	public static final String JAVA_SPEC_VERSION = System.getProperty("java.specification.version");

	public static final String JAVA_VENDOR = System.getProperty("java.vendor");
	public static final boolean IS_JAVA_IBM = JAVA_VENDOR.startsWith("IBM");

	public static final String OS_NAME = System.getProperty("os.name");
	public static final boolean IS_AIX = OS_NAME.startsWith("AIX");
	public static final boolean IS_HP_UX = OS_NAME.startsWith("HP-UX");
	public static final boolean IS_LINUX = OS_NAME.toUpperCase().startsWith("LINUX");
	public static final boolean IS_MAC = OS_NAME.startsWith("Mac");
	public static final boolean IS_MAC_OSX = OS_NAME.startsWith("Mac OS X");
	public static final boolean IS_WINDOWS = OS_NAME.indexOf("Windows") >= 0;

	public static void main(String[] args) {
		System.out.println(OS_NAME);
	}
}
