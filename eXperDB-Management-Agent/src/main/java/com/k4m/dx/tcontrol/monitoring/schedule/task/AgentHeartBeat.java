
package com.k4m.dx.tcontrol.monitoring.schedule.task;


import java.util.Enumeration;

import com.k4m.dx.tcontrol.monitoring.schedule.listener.Configure;
import com.k4m.dx.tcontrol.monitoring.schedule.runner.CounterBasket;
import com.k4m.dx.tcontrol.monitoring.schedule.util.StringKeyLinkedMap;
import com.k4m.dx.tcontrol.monitoring.schedule.util.StringUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Version;
import com.k4m.dx.tcontrol.monitoring.schedule.util.anotation.ExperDB;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack.ObjectPack;

public class AgentHeartBeat {
	public AgentHeartBeat() {
	}

	private static StringKeyLinkedMap<ObjectPack> objects = new StringKeyLinkedMap<ObjectPack>();

	public static void addObject(String objType, int objHash, String objName) {

		ObjectPack old = objects.get(objName);

		if (old != null && objType.equals(old.objType)) {
			return;
		}
		ObjectPack p = new ObjectPack();
		p.objType = objType;
		p.objHash = objHash;
		p.objName = objName;
		objects.put(objName, p);
	}

	@ExperDB
	public void alive(CounterBasket pw) {
		//DataProxy.sendHeartBeat(getMainObject());
		Enumeration<ObjectPack> en = objects.values();
		while (en.hasMoreElements()) {
		//	DataProxy.sendHeartBeat(en.nextElement());
		}
	}

	private ObjectPack getMainObject() {
		Configure conf = Configure.getInstance();
		ObjectPack p = new ObjectPack();
		p.objType = conf.obj_type;
		p.objHash = conf.getObjHash();
		p.objName = conf.getObjName();

		p.version = Version.getAgentFullVersion();
		//p.address = TcpWorker.localAddr;

		if(StringUtil.isNotEmpty(conf.getObjDetectedType())){
			p.tags.put(com.k4m.dx.tcontrol.monitoring.schedule.util.lang.constants.ExperDBConstants.TAG_OBJ_DETECTED_TYPE, conf.getObjDetectedType());
		}

		return p;
	}

	public static void clearSubObjects() {
		objects.clear();
	}
}
