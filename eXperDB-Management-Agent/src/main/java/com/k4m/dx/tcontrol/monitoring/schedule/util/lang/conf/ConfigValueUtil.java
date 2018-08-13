
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.conf;



import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import com.k4m.dx.tcontrol.monitoring.schedule.util.ArrayUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.ParamText;
import com.k4m.dx.tcontrol.monitoring.schedule.util.StringKeyLinkedMap;
import com.k4m.dx.tcontrol.monitoring.schedule.util.StringUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.BooleanValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DecimalValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DoubleValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.FloatValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.NullValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.TextValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.Value;

public class ConfigValueUtil {
	public static Properties replaceSysProp(Properties temp) {
		Properties p = new Properties();

		Map<Object, Object> args = new HashMap<Object, Object>();
		args.putAll(System.getenv());
		args.putAll(System.getProperties());

		p.putAll(args);

		Iterator<Object> itr = temp.keySet().iterator();
		while (itr.hasNext()) {
			String key = (String) itr.next();
			String value = (String) temp.get(key);
			p.put(key, new ParamText(StringUtil.trim(value)).getText(args));
		}
		return p;
	}
	
	public static StringKeyLinkedMap<Object> getConfigDefault(Object o) {
		StringKeyLinkedMap<Object> map = new StringKeyLinkedMap<Object>();
		Field[] fields = o.getClass().getFields();
		for (int i = 0; i < fields.length; i++) {
			int mod = fields[i].getModifiers();

			if (Modifier.isStatic(mod) == false && Modifier.isPublic(mod)) {
				try {
					String name = fields[i].getName();
					Object value = fields[i].get(o);
					map.put(name, value);
				} catch (Exception e) {
				}
			}
		}
		return map;
	}
	
	public static StringKeyLinkedMap<String> getConfigDescMap(Object o) {
		StringKeyLinkedMap<String> descMap = new StringKeyLinkedMap<String>();
		Field[] fields = o.getClass().getFields();
		for (int i = 0; i < fields.length; i++) {
			int mod = fields[i].getModifiers();
			if (Modifier.isStatic(mod) == false && Modifier.isPublic(mod)) {
				try {
					ConfigDesc desc = fields[i].getAnnotation(ConfigDesc.class);
					if (desc != null && StringUtil.isNotEmpty(desc.value())) {
						String name = fields[i].getName();
						descMap.put(name, desc.value());
					}
				} catch (Exception e) {
				}
			}
		}
		return descMap;
	}

	public static StringKeyLinkedMap<ValueType> getConfigValueTypeMap(Object o) {
		StringKeyLinkedMap<ValueType> valueTypeMap = new StringKeyLinkedMap<ValueType>();
		Field[] fields = o.getClass().getFields();
		for (int i = 0; i < fields.length; i++) {
			int mod = fields[i].getModifiers();
			if (Modifier.isStatic(mod) == false && Modifier.isPublic(mod)) {
				try {
					ValueType valueType;
					Class type = fields[i].getType();
					if (type == Integer.TYPE || type == Long.TYPE
							|| type.isAssignableFrom(Integer.class) || type.isAssignableFrom(Long.class)) {
						valueType = ValueType.NUM;
					} else if (type == Boolean.TYPE || type == Boolean.class) {
						valueType = ValueType.BOOL;
					} else {
						valueType = ValueType.VALUE;
					}

					ConfigValueType annotation = fields[i].getAnnotation(ConfigValueType.class);
					if (annotation != null) {
						valueType = annotation.value();
					}
					String name = fields[i].getName();
					valueTypeMap.put(name, valueType);
				} catch (Exception e) {
				}
			}
		}
		return valueTypeMap;
	}

	public static Value toValue(Object o) {
		if (o == null)
			return new NullValue();
		if (o instanceof Float) {
			return new FloatValue(((Float) o).floatValue());
		}
		if (o instanceof Double) {
			return new DoubleValue(((Double) o).doubleValue());
		}
		if (o instanceof Number) {
			return new DecimalValue(((Number) o).longValue());
		}
		if (o instanceof Boolean) {
			return new BooleanValue(((Boolean) o).booleanValue());
		}
		if (o.getClass().isArray()) {
			String s = ArrayUtil.toString(o);
			return new TextValue(s.substring(1, s.length() - 1));
		}
		return new TextValue(o.toString());
	}

}
