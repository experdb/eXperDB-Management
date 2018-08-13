
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ListValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;


public class StatusPack implements Pack {

	public long time;
	public String objType;
	public int objHash;
	public String key;
	public MapValue data = new MapValue();

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Status ");
		sb.append(DateUtil.timestamp(time));
		sb.append(" objType=").append(objType);
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" key=").append(key);
		sb.append(" data=").append(data);
		return sb.toString();
	}

	public byte getPackType() {
		return PackEnum.PERF_STATUS;
	}

/*	public void write(DataOutputX out) throws IOException {
		out.writeDecimal(time);
		out.writeText(objType);
		out.writeDecimal(objHash);
		out.writeText(key);
		out.writeValue(data);
	}*/

/*	public Pack read(DataInputX in) throws IOException {

		this.time = in.readDecimal();
		this.objType = in.readText();
		this.objHash = (int) in.readDecimal();
		this.key = in.readText();
		this.data = (MapValue) in.readValue();

		return this;
	}
	*/
	public ListValue newList(String name) {
		ListValue list = new ListValue();
		data.put(name, list);
		return list;
	}
	
	public MapPack toMapPack() {
		MapPack pack = new MapPack();
		for(String key : data.keySet()) {
			pack.put(key, data.get(key));
		}
		return pack;
	}
}