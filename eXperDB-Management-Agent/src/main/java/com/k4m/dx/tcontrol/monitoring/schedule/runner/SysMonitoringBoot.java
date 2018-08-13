package com.k4m.dx.tcontrol.monitoring.schedule.runner;

public class SysMonitoringBoot implements Runnable {
	
	private static boolean booted = false;
	
	public SysMonitoringBoot() {
	}

	@Override
	public void run() {
		boot();
		
	}
	
	public synchronized static void boot() {
		if (booted)
			return;
		booted = true;
	}
	
	public static void main(String[] args) {
		   boot();
		   
			System.out.println(System.getenv());
			System.out.println(System.getProperties());
	}
}
