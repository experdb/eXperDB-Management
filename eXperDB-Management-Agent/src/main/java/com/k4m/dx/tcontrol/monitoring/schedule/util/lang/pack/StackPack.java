
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import com.k4m.dx.tcontrol.monitoring.schedule.util.ArrayUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.CompressUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.DateUtil;
import com.k4m.dx.tcontrol.monitoring.schedule.util.Hexa32;



public class StackPack implements Pack {

	public long time;
	public int objHash;
	public byte[] data;

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Stack ");
		sb.append(DateUtil.timestamp(time));
		sb.append(" objHash=").append(Hexa32.toString32(objHash));
		sb.append(" stack=").append(ArrayUtil.len(data) + "bytes");
		return sb.toString();
	}

	public byte getPackType() {
		return PackEnum.STACK;
	}

/*	public void write(DataOutputX out) throws IOException {
		out.writeDecimal(time);
		out.writeDecimal(objHash);
		out.writeBlob(data);
	}

	public Pack read(DataInputX in) throws IOException {

		this.time = in.readDecimal();
		this.objHash = (int) in.readDecimal();
		this.data = in.readBlob();

		return this;
	}*/

	public void setStack(String stack) {
		if (stack == null) {
			this.data = null;
			return;
		}

		try {
			this.data = CompressUtil.doZip(stack.getBytes());
		} catch (Exception e) {
		}
	}

	public String getStack() {
		if (ArrayUtil.isEmpty(data))
			return "";
		try {
			return new String(CompressUtil.unZip(data));
		} catch (Exception e) {
			return "";
		}
	}
}