
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.FloatValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.NumberValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.TimeTypeEnum;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.Value;


/**
 * Object that contains multiple counter information
 */
public class PerfCounterPack implements Pack {

	/**
	 * Counter time
	 */
	public long time;
	/**
	 * Object name
	 */
	public String objName;
	/**
	 * Time type. 1:Real-time, 2:OneMin, 3:FiveMin, 4:TenMin, 5:Hour, 6:Day
	 */
	public byte timetype;
	/**
	 * Multiple counter data. Key is counter name. ref.)scouter.lang.value.MapValue
	 */
	public MapValue data = new MapValue();

	public String toString() {
		StringBuffer buf = new StringBuffer();
		buf.append("PerfCounter ").append(DateUtil.timestamp(time));
		buf.append(" ").append(objName);
		buf.append(" ").append(TimeTypeEnum.getString(timetype));
		buf.append(" ").append(data);
		return buf.toString();
	}

	public byte getPackType() {
		return PackEnum.PERF_COUNTER;
	}


    public void put(String key, Object o) {
	    if (o instanceof Number) {
            this.data.put(key, new FloatValue(((Number) o).floatValue()));
        }
    }

	public void put(String key, Value value) {
		this.data.put(key, value);
	}

	public void add(String key, NumberValue value) {
		Value old = this.data.get(key);
		if (old == null) {
			this.data.put(key, value);
		} else if (old instanceof NumberValue) {
			((NumberValue) old).add(value);
		}
	}
}