package com.k4m.dx.tcontrol.monitoring.schedule.listener;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.k4m.dx.tcontrol.monitoring.schedule.runner.CounterBasket;
import com.k4m.dx.tcontrol.monitoring.schedule.util.ThreadUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.anotation.ExperDB;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack.PerfCounterPack;
import com.k4m.dx.tcontrol.monitoring.schedule.util.scan.Scanner;

public class TaskExecuteListener extends Thread {
	
	private static TaskExecuteListener instance;
	
	public final static synchronized TaskExecuteListener getInstance() {
		try {
			if (instance == null) {
				instance = new TaskExecuteListener();
				instance.setDaemon(true);
				instance.setName(ThreadUtil.getName(instance));
				instance.start();
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return instance;
	}
	
	Configure conf = Configure.getInstance();
	public void run() {
		while (true) {
			ThreadUtil.sleep(1000);
			if (conf.counter_enabled == false) {
				continue;
			}
			long now = System.currentTimeMillis();
			CounterBasket pw = new CounterBasket();
			for (int i = 0; i < taskSec.size(); i++) {
				CountStat r = taskSec.get(i);
				try {
					if (r.counter.interval() <= now - r.xtime) {
						r.xtime = now;
						r.counter.process(pw);
					}
				} catch (Throwable t) {
					t.printStackTrace();
				}
			}
			//
			PerfCounterPack[] pks = pw.getList();
			//DataProxy.sendCounter(pks);
		}
	}
	private TaskExecuteListener() {
	}
	private List<CountStat> taskSec = new ArrayList<CountStat>();
	static class CountStat {
		Invocation counter;
		long xtime;
		CountStat(Invocation counter) {
			this.counter = counter;
		}
	}
	public void put(Invocation counter) {
		taskSec.add(new CountStat(counter));
	}
	protected static class Invocation {
		Object object;
		Method method;
		long time;
		public Invocation(Object object, Method method, long interval) {
			this.object = object;
			this.method = method;
			this.time=interval;
		}
		public void process(CounterBasket pw) throws Throwable {
			try {
				method.invoke(object, pw);
			} catch (Exception e) {
				//Logger.println("A111", object.getClass() + " " + method + " " + e);
			}
		}
		public long interval() {
			return this.time;
		}
	}
	
	public static void load() {
		Set<String> defaultTasks = new Scanner("com.k4m.dx.tcontrol.monitoring.schedule.task").process();
		//Set<String> customTasks = new Scanner(System.getProperty("scouter.task")).process();
		//defaultTasks.addAll(customTasks);
		
		int n = 0;
		Iterator<String> itr = defaultTasks.iterator();
		while (itr.hasNext()) {
			try {
				String strClassName = itr.next();
				System.out.println(strClassName);
				Class c = Class.forName(strClassName);
				if (Modifier.isPublic(c.getModifiers()) == false)
					continue;
				
				System.out.println("--" + strClassName);
				
				Method[] m = c.getDeclaredMethods();
				for (int i = 0; i < m.length; i++) {
					ExperDB mapAn = (ExperDB) m[i].getAnnotation(ExperDB.class);
					if (mapAn == null)
						continue;
					int interval=mapAn.interval();
					TaskExecuteListener.getInstance().put(new Invocation(c.newInstance(), m[i], interval));
					n++;
				}
			} catch (Throwable t) {
				System.out.println(ThreadUtil.getStackTrace(t));
				//scouter.agent.Logger.println("A112", ThreadUtil.getStackTrace(t));
			}
		}
		//scouter.agent.Logger.println("A113", "Counter Collector Started (#" + n + ")");
	}
	public static void main(String[] args) {
		load();
	}

}
