
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;



/**
 * Object that contains multiple summary information
 */
public class SummaryPack implements Pack {

	/**
	 * Summary time
	 */
	public long time;
	/**
	 * Object ID
	 */
	public int objHash;
	/**
	 * Object type
	 */
	public String objType;
	/**
	 * Summary Type. 1:App, 2:SQL, 3:Alert, 4:Ip, 5:ApiCall, 8:User-Agent....
	 */
	public byte stype;
	/**
	 * Summary data. ref.)scouter.lang.value.MapValue
	 */
	public MapValue table = new MapValue();

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Summary ");
		sb.append(DateUtil.timestamp(time));
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" objType=").append(objType);
		sb.append(" stype=").append(stype);
		sb.append(" " );
		sb.append(table.toString());
		
		return sb.toString();
	}

	public byte getPackType() {
		return PackEnum.SUMMARY;
	}

/*	public void write(DataOutputX o) throws IOException {
		o.writeDecimal(time);
		o.writeInt(objHash);
		o.writeText(objType);
		o.writeByte(stype);
		o.writeValue(table);
	}

	public Pack read(DataInputX n) throws IOException {
		this.time = n.readDecimal();
		this.objHash = n.readInt();
		this.objType = n.readText();
		this.stype = n.readByte();
		this.table=(MapValue)n.readValue();

		return this;
	}*/

}