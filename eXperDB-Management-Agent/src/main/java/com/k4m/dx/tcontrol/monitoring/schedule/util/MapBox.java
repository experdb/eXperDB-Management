
package com.k4m.dx.tcontrol.monitoring.schedule.util;



import java.io.IOException;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.BooleanValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DecimalValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ListValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.TextValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.Value;

public class MapBox{

	protected Map<String, Value> table;

	public MapBox() {
		this.table = new LinkedHashMap<String, Value>();
	}

	public MapBox(Map<String, ? extends Value> table) {
		this.table = new LinkedHashMap<String, Value>(table);
	}

	public static MapBox ofStringValueMap(Map<String, String> map) {
		LinkedHashMap<String, Value> tempTable = new LinkedHashMap<String, Value>();
		for (Map.Entry<String, String> e : map.entrySet()) {
			tempTable.put(e.getKey(), new TextValue(e.getValue()));
		}
		return new MapBox(tempTable);
	}

	public int size() {
		return table.size();
	}

	public boolean isEmpty() {
		return table.isEmpty();
	}

	public boolean containsKey(String key) {
		return table.containsKey(key);
	}

	public Iterator<String> keys() {
		return table.keySet().iterator();
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

	public long getLongDefault(String key, long d) {
		Value v = get(key);
		if (v instanceof Number) {
			return ((Number) v).longValue();
		}
		return d;
	}

	public float getFloat(String key) {
		Value v = get(key);
		if (v instanceof Number) {
			return (float) ((Number) v).floatValue();
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
	
	public Value put(String key, boolean value) {
		return put(key, new BooleanValue(value));
	}

	public Value remove(String key) {
		return (Value) table.remove(key);
	}

	public void clear() {
		table.clear();
	}

	public String toString() {
		StringBuffer buf = new StringBuffer();
		buf.append("MapPack ");
		buf.append(table);
		return buf.toString();
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

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MapBox other = (MapBox) obj;
		if (size() != other.size())
			return false;
		Set<String> keySet = keySet();
		for (String key : keySet) {
			Value v1 = get(key);
			Value v2 = other.get(key);
			if (v2 == null) {
				return false;
			}
			if (v1.toJavaObject().equals(v2.toJavaObject()) == false) {
				return false;
			}
		}
		return true;
	}

	public Object toJavaObject() {
		return this.table;
	}

	public Map<String, Value> toMap() {
		return this.table;
	}

	public MapValue toMapValue() {
		MapValue map = new MapValue();
		map.putAll(this.table);
		return map;
	}

	public MapBox setMapValue(MapValue mapValue) {
		if(mapValue==null)
			return this;
		Enumeration<String> keys = mapValue.keys();	
		while(keys.hasMoreElements()){
			String key = keys.nextElement();
			Value value=mapValue.get(key);
			this.table.put(key, value);
		}
		return this;
	}
}
