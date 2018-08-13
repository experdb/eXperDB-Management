
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

import java.io.IOException;


public class LongSummary extends SummaryValue implements Value {

	public long sum;
	public int count;
	public long min;
	public long max;

	public byte getValueType() {
		return ValueEnum.LONG_SUMMARY;
	}


	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("[sum=").append(sum);
		sb.append(",count=").append(count);
		sb.append(",min=").append(min);
		sb.append(",max=").append(max);
		sb.append("]");
		return sb.toString();
	}

	public Object toJavaObject() {
		return this;
	}
	
	public void addcount() {
		this.count++;
	}	

	public SummaryValue add(Number value) {
		if(value==null)
			return this;
		if (this.count == 0) {
			this.sum = value.longValue();
			this.count = 1;
			this.max = value.longValue();
			this.min = value.longValue();
		} else {
			this.sum += value.doubleValue();
			this.count++;
			this.max = Math.max(this.max, value.longValue());
			this.min = Math.min(this.min, value.longValue());
		}
		return this;
	}

	public SummaryValue add(SummaryValue other) {
		if (other == null || other.getCount() == 0)
			return this;
		
		this.count += other.getCount();
		this.sum += other.longSum();
		this.min = Math.min(this.min, other.longMin());
		this.max = Math.max(this.max, other.longMax());
		return this;
	}

	public long longSum() {
		return this.sum;
	}

	public long longMin() {
		return this.min;
	}

	public long longMax() {
		return this.max;
	}

	public long longAvg() {
		return count == 0 ? 0 : sum / count;
	}

	public double doubleSum() {
		return this.sum;
	}

	public double doubleMin() {
		return this.min;
	}

	public double doubleMax() {
		return this.max;
	}

	public double doubleAvg() {
		return count == 0 ? 0 : sum / count;
	}

	public int getCount() {
		return this.count;
	}
}