
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;
import java.sql.Timestamp;

import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;



/**
 * Object that contains one agent(called object) information
 */
public class ObjectPack implements Pack {

	/**
	 * Object type
	 */
	public String objType;
	/**
	 * Object ID
	 */
	public int objHash;
	/**
	 * Object full name
	 */
	public String objName;
	/**
	 * IP address
	 */
	public String address;
	/**
	 * Version
	 */
	public String version;
	/**
	 * Whether alive
	 */
	public boolean alive = true;
	/**
	 * Last wake up time
	 */
	public long wakeup;
	/**
	 * More info
	 */
	public MapValue tags = new MapValue();
	transient public int updated;

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("OBJECT ");
		sb.append(" objType=").append(objType);
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" objName=").append(objName);
		if (isOk(address))
			sb.append(" addr=").append(address);
		if (isOk(version))
			sb.append(" ").append(version);
		if (alive)
			sb.append(" alive");
		if (wakeup > 0)
			sb.append(" ").append(new Timestamp(wakeup));
		if (tags.size() > 0)
			sb.append(" ").append(tags);
		return sb.toString();
	}

	private boolean isOk(String s) {
		return s != null && s.length() > 0;
	}

	public void wakeup() {
		this.wakeup = System.currentTimeMillis();
		this.alive = true;
	}

	public byte getPackType() {
		return PackEnum.OBJECT;
	}

/*	public void write(DataOutputX dout) throws IOException {
		dout.writeText(objType);
		dout.writeDecimal(objHash);
		dout.writeText(objName);
		dout.writeText(address);
		dout.writeText(version);
		dout.writeBoolean(alive);
		dout.writeDecimal(wakeup);
		dout.writeValue(tags);
	}
*/
/*	public Pack read(DataInputX din) throws IOException {
		this.objType = din.readText();
		this.objHash = (int) din.readDecimal();
		this.objName = din.readText();
		this.address = din.readText();
		this.version = din.readText();
		this.alive = din.readBoolean();
		this.wakeup = din.readDecimal();
		this.tags = (MapValue) din.readValue();
		return this;
	}*/

	public int hashCode() {
		return objHash;
	}

	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		return (objHash == ((ObjectPack) obj).objHash);
	}
}