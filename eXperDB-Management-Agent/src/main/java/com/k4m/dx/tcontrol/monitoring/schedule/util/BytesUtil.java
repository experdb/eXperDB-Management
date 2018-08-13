
package com.k4m.dx.tcontrol.monitoring.schedule.util;

public class BytesUtil {
	public static byte getByte(byte[] data, int x) {
		if (data == null || data.length <= x)
			return 0;
		else
			return data[x];
	}

	public static int getLength(byte[] data) {
	    return data==null?0:data.length;
    }

	public static byte[] merge(byte[] b1, byte[] b2) {
		byte[] buff = new byte[b1.length + b2.length];
		System.arraycopy(b1, 0, buff, 0, b1.length);
		System.arraycopy(b2, 0, buff,  b1.length,b2.length);
		return buff;
	}
	
	public static byte[] toBytes(short v) {
		byte buf[] = new byte[2];
		buf[0] = (byte) ((v >>> 8) & 0xFF);
		buf[1] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes(byte[] buf, int off, short v) {
		buf[off] = (byte) ((v >>> 8) & 0xFF);
		buf[off + 1] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes(int v) {
		byte buf[] = new byte[4];
		buf[0] = (byte) ((v >>> 24) & 0xFF);
		buf[1] = (byte) ((v >>> 16) & 0xFF);
		buf[2] = (byte) ((v >>> 8) & 0xFF);
		buf[3] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes(byte[] buf, int off, int v) {
		buf[off] = (byte) ((v >>> 24) & 0xFF);
		buf[off + 1] = (byte) ((v >>> 16) & 0xFF);
		buf[off + 2] = (byte) ((v >>> 8) & 0xFF);
		buf[off + 3] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes3(int v) {
		byte buf[] = new byte[3];
		buf[0] = (byte) ((v >>> 16) & 0xFF);
		buf[1] = (byte) ((v >>> 8) & 0xFF);
		buf[2] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes3(byte[] buf, int off, int v) {
		buf[off] = (byte) ((v >>> 16) & 0xFF);
		buf[off + 1] = (byte) ((v >>> 8) & 0xFF);
		buf[off + 2] = (byte) ((v >>> 0) & 0xFF);
		return buf;
	}

	public static byte[] toBytes(long v) {
		byte buf[] = new byte[8];
		buf[0] = (byte) (v >>> 56);
		buf[1] = (byte) (v >>> 48);
		buf[2] = (byte) (v >>> 40);
		buf[3] = (byte) (v >>> 32);
		buf[4] = (byte) (v >>> 24);
		buf[5] = (byte) (v >>> 16);
		buf[6] = (byte) (v >>> 8);
		buf[7] = (byte) (v >>> 0);
		return buf;
	}

	public static byte[] toBytes(byte[] buf, int off, long v) {
		buf[off] = (byte) (v >>> 56);
		buf[off + 1] = (byte) (v >>> 48);
		buf[off + 2] = (byte) (v >>> 40);
		buf[off + 3] = (byte) (v >>> 32);
		buf[off + 4] = (byte) (v >>> 24);
		buf[off + 5] = (byte) (v >>> 16);
		buf[off + 6] = (byte) (v >>> 8);
		buf[off + 7] = (byte) (v >>> 0);
		return buf;
	}

	public static byte[] toBytes5(long v) {
		byte writeBuffer[] = new byte[5];
		writeBuffer[0] = (byte) (v >>> 32);
		writeBuffer[1] = (byte) (v >>> 24);
		writeBuffer[2] = (byte) (v >>> 16);
		writeBuffer[3] = (byte) (v >>> 8);
		writeBuffer[4] = (byte) (v >>> 0);
		return writeBuffer;
	}

	public static byte[] toBytes5(byte[] buf, int off, long v) {
		buf[off] = (byte) (v >>> 32);
		buf[off + 1] = (byte) (v >>> 24);
		buf[off + 2] = (byte) (v >>> 16);
		buf[off + 3] = (byte) (v >>> 8);
		buf[off + 4] = (byte) (v >>> 0);
		return buf;
	}

	public static byte[] toBytes(boolean b) {
		if (b)
			return new byte[] { 1 };
		else
			return new byte[] { 0 };
	}

	public static byte[] toBytes(byte[] buf, int off, boolean b) {
		if (b)
			buf[off] = 1;
		else
			buf[off] = 0;
		return buf;
	}

	public static byte[] toBytes(float v) {
		return toBytes(Float.floatToIntBits(v));
	}

	public static byte[] toBytes(byte[] buf, int off, float v) {
		return toBytes(buf, off, Float.floatToIntBits(v));
	}

	public static byte[] toBytes(double v) {
		return toBytes(Double.doubleToLongBits(v));
	}

	public static byte[] toBytes(byte[] buf, int off, double v) {
		return toBytes(buf, off, Double.doubleToLongBits(v));
	}

	public static byte[] set(byte[] dest, int pos, byte[] src) {
		System.arraycopy(src, 0, dest, pos, src.length);
		return dest;
	}

}