
package com.k4m.dx.tcontrol.monitoring.schedule.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

public class CompressUtil {

	public static byte[] doZip(byte[] data) throws IOException {
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		java.util.zip.GZIPOutputStream gout = new GZIPOutputStream(out);
		gout.write(data);
		gout.close();
		return out.toByteArray();
	}

	public static byte[] unZip(byte[] data) throws IOException {
		ByteArrayInputStream in = new ByteArrayInputStream(data);
		java.util.zip.GZIPInputStream gin = new GZIPInputStream(in);
		data = FileUtil.readAll(gin);
		gin.close();
		return data;
	}
}