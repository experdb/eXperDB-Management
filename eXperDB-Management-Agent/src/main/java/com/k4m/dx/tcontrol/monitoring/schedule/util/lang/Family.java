
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import com.k4m.dx.tcontrol.monitoring.schedule.util.StringKeyLinkedMap;


public class Family {
	private String name;
	private String master;
	private StringKeyLinkedMap<String> attrMap = new StringKeyLinkedMap<String>();
	private StringKeyLinkedMap<Counter> counterMap = new StringKeyLinkedMap<Counter>();
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMaster() {
		return master;
	}
	public void setMaster(String master) {
		this.master = master;
	}
	
	public String setAttribute(String key, String value) {
		return attrMap.put(key, value);
	}
	
	public String getAttribute(String key) {
		return attrMap.get(key);
	}
	
	public boolean isTrueAttribute(String key) {
		String value = attrMap.get(key);
		if (value == null) {
			return false;
		}
		return Boolean.valueOf(value);
	}
	
	public Counter addCounter(Counter counter) {
		return counterMap.put(counter.getName(), counter);
	}
	
	protected Counter getCounter(String counter) {
		return counterMap.get(counter);
	}
	
	public List<Counter> listCounters() {
		List<Counter> list = new ArrayList<Counter>(counterMap.size());
		Enumeration<Counter> en = counterMap.values();
		while (en.hasMoreElements()) {
			list.add(en.nextElement());
		}
		return list;
	}

	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Family other = (Family) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
}