
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.MapValue;

/**
 * Object that contains one alert information
 */
public class AlertPack implements Pack {

	/**
	 * indicate sign about hash value
	 */
	public static String HASH_FLAG = "_hash_";

	/**
	 * Alert time
	 */
	public long time;
	/**
	 * Object type
	 */
	public String objType;
	/**
	 * Object ID
	 */
	public int objHash;
	/**
	 * Alert level. 0:Info, 1:Warn, 2:Error, 3:Fatal
	 */
	public byte level;
	/**
	 * Alert title
	 */
	public String title;
	/**
	 * Alert message
	 */
	public String message;
	/**
	 * More info
	 */
	public MapValue tags = new MapValue();

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("ALERT ");
		sb.append(DateUtil.timestamp(time));
		sb.append(" objType=").append(objType);
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" level=").append(level);
		sb.append(" title=").append(title);
		sb.append(" message=").append(message);
		sb.append(" tags=").append(tags);

		return sb.toString();
	}

	public byte getPackType() {
		return PackEnum.ALERT;
	}


}
