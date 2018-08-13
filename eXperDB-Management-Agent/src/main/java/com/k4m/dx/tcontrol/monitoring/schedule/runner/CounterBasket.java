
package com.k4m.dx.tcontrol.monitoring.schedule.runner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.k4m.dx.tcontrol.monitoring.schedule.listener.Configure;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack.PerfCounterPack;


public class CounterBasket {
	private class Key {
		private String objName;
		private byte timeType;

		public Key(String objName, byte timeType) {
			this.objName = objName;
			this.timeType = timeType;
		}

		@Override
		public boolean equals(Object obj) {
			if (obj instanceof Key) {
				Key k = (Key) obj;
				return this.objName.equals(k.objName) && this.timeType==k.timeType;
			}
			return false;
		}

		@Override
		public int hashCode() {

			return objName.hashCode() ^ timeType;
		}
	}

	private Map<Key, PerfCounterPack> table = new HashMap<CounterBasket.Key, PerfCounterPack>();

	public PerfCounterPack getPack(String objName, byte timeType) {
		Key key = new Key(objName, timeType);
		PerfCounterPack p = table.get(key);
		if (p == null) {
			p = new PerfCounterPack();
			p.objName = objName;
			p.timetype = timeType;
			table.put(key, p);
		}
		return p;
	}

	public PerfCounterPack getPack(byte timeType) {
		return getPack(Configure.getInstance().getObjName(), timeType);
	}

	public PerfCounterPack[] getList() {
		ArrayList list =  new ArrayList(table.values());
		return (PerfCounterPack[])list.toArray(new PerfCounterPack[list.size()]);
	}
}