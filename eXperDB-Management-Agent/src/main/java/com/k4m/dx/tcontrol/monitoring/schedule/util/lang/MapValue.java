
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;


public class MapValue implements Value {

	public static MapValue ofStringValueMap(Map<String, String> map) {
		LinkedHashMap<String, Value> tempTable = new LinkedHashMap<String, Value>();
		for (Map.Entry<String, String> e : map.entrySet()) {
			tempTable.put(e.getKey(), new TextValue(e.getValue()));
		}
		MapValue newMapValue = new MapValue();
		newMapValue.putAll(tempTable);
		return newMapValue;
	}

	protected Hashtable<String, Value> table = new Hashtable<String, Value>();

	public int size() {
		return table.size();
	}

	public boolean isEmpty() {
		return table.isEmpty();
	}

	public boolean containsKey(String key) {
		return table.containsKey(key);
	}

	public Enumeration<String> keys() {
		return table.keys();
	}

	public Set<String> keySet() {
		return table.keySet();
	}

	public Value get(String key) {
		return (Value) table.get(key);
	}

	public boolean getBoolean(String key) {
		Value v = get(key);
		if (v instanceof BooleanValue) {
			return ((BooleanValue) v).value;
		}
		return false;
	}

	public int getInt(String key) {
		Value v = get(key);
		if (v instanceof Number) {
			return (int) ((Number) v).intValue();
		}
		return 0;
	}

	public long getLong(String key) {
		Value v = get(key);
		if (v instanceof Number) {
			return ((Number) v).longValue();
		}
		return 0;
	}

	public float getFloat(String key) {
		Value v = get(key);
		if (v instanceof Number) {
			return (float) ((Number) v).doubleValue();
		}
		return 0;
	}

	public String getText(String key) {
		Value v = get(key);
		if (v instanceof TextValue) {
			return ((TextValue) v).value;
		}
		return null;
	}

	public Value put(String key, Value value) {
		return (Value) table.put(key, value);
	}

	public Value put(String key, String value) {
		return put(key, new TextValue(value));
	}

	public Value put(String key, long value) {
		return put(key, new DecimalValue(value));
	}

	public Value remove(String key) {
		return (Value) table.remove(key);
	}

	public void clear() {
		table.clear();
	}

	public String toString() {
		StringBuffer buf = new StringBuffer();
		Iterator en = table.entrySet().iterator();
		buf.append("{");
		while (en.hasNext()) {
			if (buf.length() > 1) {
				buf.append(",");
			}
			Map.Entry e = (Map.Entry) en.next();
			buf.append(e.getKey() + "=" + e.getValue());
		}
		buf.append("}");
		return buf.toString();
	}

	public byte getValueType() {
		return ValueEnum.MAP;
	}



	public ListValue newList(String name) {
		ListValue list = new ListValue();
		this.put(name, list);
		return list;
	}

	public ListValue getList(String key) {
		return (ListValue) table.get(key);
	}

	public ListValue getListNotNull(String key) {
		ListValue lv = (ListValue) table.get(key);
		return lv == null ? new ListValue() : lv;
	}

	public Object toJavaObject() {
		return this.table;
	}

	public Map<String, Value> toMap() {
		return this.table;
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MapValue other = (MapValue) obj;
		if (table == null) {
			if (other.table != null)
				return false;
		} else if (!table.equals(other.table))
			return false;
		return true;
	}
	public void putAll(Map<String, Value> m){
		this.table.putAll(m);
	}
}