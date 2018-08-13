
package com.k4m.dx.tcontrol.monitoring.schedule.util.meter;

import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref.DOUBLE;
import com.k4m.dx.tcontrol.monitoring.schedule.util.lang.ref.INT;
import com.k4m.dx.tcontrol.monitoring.schedule.util.meter.MeteringUtil.Handler;

public class MeterResource  {

	static class Bucket {
		double value;
		int count;
	}
	private MeteringUtil<Bucket> meter = new MeteringUtil<Bucket>() {
		protected Bucket create() {
			return new Bucket();
		};

		protected void clear(Bucket o) {
			o.value=0;
			o.count = 0;
		}
	};
	
	public synchronized void add(double value) {
		Bucket b = meter.getCurrentBucket();
		b.value += value;
		b.count++;
	}

	public double getAvg(int period) {
		final INT count = new INT();
		final DOUBLE sum = new DOUBLE();
		meter.search(period, new Handler<MeterResource.Bucket>() {
			public void process(Bucket u) {
				sum.value += u.value;
				count.value += u.count;
			}
		});
		return count.value == 0 ? 0 : sum.value / count.value;
	}

	public double getSum(int period) {
		final DOUBLE sum = new DOUBLE();
		meter.search(period, new Handler<MeterResource.Bucket>() {
			public void process(Bucket u) {
				sum.value += u.value;
			}
		});
		return sum.value;
	}

}