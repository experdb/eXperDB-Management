
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

abstract public class SummaryValue implements Value {

	public static int byteLen=29;

	abstract public void addcount();
	
	abstract public SummaryValue add(Number value);

	abstract public SummaryValue add(SummaryValue num);

	abstract public long longSum();

	abstract public long longMin();

	abstract public long longMax();

	abstract public long longAvg();

	abstract public double doubleSum();

	abstract public double doubleMin();

	abstract public double doubleMax();

	abstract public double doubleAvg();

	abstract public int getCount();
}