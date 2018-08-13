
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;

import java.text.DecimalFormat;

public class DoubleSummary extends SummaryValue implements Value {

	public double sum;
	public int count;
	public double min;
	public double max;

	public byte getValueType() {
		return ValueEnum.DOUBLE_SUMMARY;
	}


	public String toString() {
		DecimalFormat fmt = new DecimalFormat("#0.0#################");
		StringBuffer sb = new StringBuffer();
		sb.append("[sum=").append(fmt.format(new Double(sum)));
		sb.append(",count=").append(count);
		sb.append(",min=").append(fmt.format(new Double(min)));
		sb.append(",max=").append(fmt.format(new Double(max)));
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
		if (value == null)
			return this;
		if (this.count == 0) {
			this.sum = value.doubleValue();
			this.count = 1;
			this.max = value.doubleValue();
			this.min = value.doubleValue();
		} else {
			this.sum += value.doubleValue();
			this.count++;
			this.max = Math.max(this.max, value.doubleValue());
			this.min = Math.min(this.min, value.doubleValue());
		}
		return this;
	}

	public SummaryValue add(SummaryValue other) {
		if (other == null || other.getCount() == 0)
			return this;
		this.count += other.getCount();
		this.sum += other.doubleSum();
		this.min = Math.min(this.min, other.doubleMin());
		this.max = Math.max(this.max, other.doubleMax());
		return this;
	}

	public long longSum() {
		return (long) this.sum;
	}

	public long longMin() {
		return (long) this.min;
	}

	public long longMax() {
		return (long) this.max;
	}

	public long longAvg() {
		return (long) (count == 0 ? 0 : sum / count);
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