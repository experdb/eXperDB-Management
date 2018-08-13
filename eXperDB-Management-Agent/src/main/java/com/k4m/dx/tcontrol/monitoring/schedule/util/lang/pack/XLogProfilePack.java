
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import java.io.IOException;

import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;



/**
 * Object that contains a part of full profile
 */
public class XLogProfilePack implements Pack {

	/**
	 * Profile time
	 */
	public long time;
	/**
	 * Object ID
	 */
	public int objHash;
	/**
	 * Related transaction name hash
	 */
	public int service;
	/**
	 * Related transaction ID
	 */
	public long txid;
	/**
	 * Elapsed time until this step(ms)
	 */
	public int elapsed;
	/**
	 * Byte array of profile steps
	 */
	public byte[] profile;

	public byte getPackType() {
		return PackEnum.XLOG_PROFILE;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Profile ");
		sb.append(DateUtil.timestamp(time));
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" txid=").append(Hexa32.toString32(txid));
		sb.append(" profile=").append(profile == null ? null : profile.length);
		return sb.toString();
	}

/*	public void write(DataOutputX dout) throws IOException {
		dout.writeDecimal(time);
		dout.writeDecimal(objHash);
		dout.writeDecimal(service);
		dout.writeLong(txid);
		dout.writeBlob(profile);
	}

	public Pack read(DataInputX din) throws IOException {
		this.time = din.readDecimal();
		this.objHash = (int) din.readDecimal();
		this.service= (int) din.readDecimal();
		this.txid = din.readLong();
		this.profile = din.readBlob();
		return this;
	}*/

}