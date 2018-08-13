
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

import com.k4m.dx.tcontrol.monitoring.schedule.util.StringKeyLinkedMap;

public class Counter implements Comparable<Counter> {
	private String name;
	private String displayName;
	private String unit;
	private String icon;
	private boolean all = true;
	private boolean total = true;
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
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	public boolean isAll() {
		return all;
	}
	public void setAll(boolean all) {
		this.all = all;
	}
	public boolean isTotal() {
		return total;
	}
	public void setTotal(boolean total) {
		this.total = total;
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
		Counter other = (Counter) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	
	public int compareTo(Counter o) {
		return this.name.compareTo(o.getName());
	}
}