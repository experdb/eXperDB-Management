
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.pack;

import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DecimalValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.DoubleValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.FloatValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.NullValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.TextValue;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.Value;

/**
 * Pack type enum.
 * use less number than 100 as a pack type.(over 100 for extensions)
 */
public abstract class PackEnum {
    private static PackEnum extPackEnum; // extension pack

	public final static byte MAP = 10;
	public final static byte XLOG = 21;
	public final static byte XLOG_PROFILE = 26;
	public final static byte TEXT = 50;
	public final static byte PERF_COUNTER = 60;
	public final static byte PERF_STATUS = 61;
	public final static byte STACK = 62;
	public final static byte SUMMARY = 63;
	public final static byte BATCH = 64;

	public final static byte ALERT = 70;
	public final static byte OBJECT = 80;

    public static Pack create(byte packType) {
        Pack pack = createNonExt(packType);
        if(pack == null) {
            if(extPackEnum != null) {
            	pack = extPackEnum.createExt(packType);
            }
            if(pack == null) {
            	throw new RuntimeException("Unknown pack type= " + packType);
            }
        }
        return pack;
	}

    public static Pack createNonExt(byte packType) {
        switch (packType) {
            case MAP:
                return new MapPack();
            case PERF_COUNTER:
                return new PerfCounterPack();
            case PERF_STATUS:
                return new StatusPack();
            case XLOG_PROFILE:
                return new XLogProfilePack();
            case XLOG:
                return new XLogPack();
            case TEXT:
                return new TextPack();
            case ALERT:
                return new AlertPack();
            case OBJECT:
                return new ObjectPack();
            case STACK:
                return new StackPack();
            case SUMMARY:
                return new SummaryPack();
            case BATCH:
            	return new BatchPack();
            default:
                return null;
        }
    }

    public abstract Pack createExt(byte PackType);

    /**
     * add ext pack
     * @param packEnum
     */
    public static synchronized void registPackEnum(PackEnum packEnum) {
        extPackEnum = packEnum;
    }

	public static Value toValue(Object value) throws Exception {
		if (value == null) {
			return new NullValue();
		} else if (value instanceof String) {
			return new TextValue((String) value);
		} else if (value instanceof Number) {
			if (value instanceof Float)
				return new FloatValue((Float) value);
			else if (value instanceof Double)
				return new DoubleValue((Double) value);
			else
				return new DecimalValue(((Number) value).longValue());
		} else {
			return new TextValue(value.toString());
		}
	}
	// public static byte[] toBytes(Packet p) throws IOException {
	// if (p == null)
	// return null;
	// DataOutputX out = new DataOutputX();
	// out.writePacket(p);
	// return out.toByteArray();
	// }

}