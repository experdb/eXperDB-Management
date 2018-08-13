
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;



import java.util.Enumeration;
import java.util.List;

import com.k4m.dx.tcontrol.monitoring.schedule.util.StringKeyLinkedMap;

public class ObjectType {
	private String name;
	private String displayName;
	private Family family;
	private String icon;
	private boolean subObject;
	private StringKeyLinkedMap<Counter> counterMap = new StringKeyLinkedMap<Counter>();
	private StringKeyLinkedMap<String> attrMap = new StringKeyLinkedMap<String>();
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public Family getFamily() {
		return family;
	}
	public void setFamily(Family family) {
		this.family = family;
	}
	
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	
	public boolean isSubObject() {
		return this.subObject;
	}
	
	public void setSubObject(boolean isSubObject) {
		this.subObject = isSubObject;
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
	
	public Counter[] listCounters() {
		if(family == null) return null;
		List<Counter> list = family.listCounters();
		Enumeration<Counter> en = counterMap.values();
		while (en.hasMoreElements()) {
			list.add(en.nextElement());
		}
		return list.toArray(new Counter[list.size()]);
	}
	
	public Counter[] listObjectTypeCounters() {
		Counter[] counters = new Counter[counterMap.size()];
		Enumeration<Counter> en = counterMap.values();
		int i = 0;
		while (en.hasMoreElements()) {
			counters[i] = en.nextElement();
			i++;
		}
		return counters;
	}
	
	public Counter getCounter(String name) {
		Counter c = counterMap.get(name);
		if (c == null) {
			c = family.getCounter(name);
		}
		return c;
	}
	
	public void addCounter(Counter c) {
		this.counterMap.put(c.getName(), c);
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
		ObjectType other = (ObjectType) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
}
