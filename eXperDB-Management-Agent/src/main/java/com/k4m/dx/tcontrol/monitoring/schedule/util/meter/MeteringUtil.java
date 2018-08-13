
package com.k4m.dx.tcontrol.monitoring.schedule.util.meter;

public abstract class MeteringUtil<T> {

	
	protected final int BUCKET_SIZE;
	protected final int TIME_UNIT;
	
	public MeteringUtil() {
		this(1000,301);
	}
	public MeteringUtil(int bucketSize) {
		this(1000,bucketSize);
	}
	public MeteringUtil(int timeUnit, int bucketSize) {
		this.TIME_UNIT=timeUnit;
		this.BUCKET_SIZE = bucketSize;
		this._time_ = getTime();
		this._pos_ = (int) (_time_ % BUCKET_SIZE);
		this.table = new Object[bucketSize];
		for (int i = 0; i < bucketSize; i++) {
			this.table[i] = create();
		}
	}

	private final Object[] table;
	private long _time_;
	private int _pos_;

	abstract protected T create();
	abstract protected void clear(T o);

	public synchronized T getCurrentBucket() {
		int pos = getPosition();
		return (T)table[pos];
	}

	public synchronized int getPosition() {
		long curTime = getTime();
		if (curTime != _time_) {
			for (int i = 0; i < (curTime - _time_) && i < BUCKET_SIZE; i++) {
				_pos_ = (_pos_ + 1 > BUCKET_SIZE - 1) ? 0 : _pos_ + 1;
				clear((T)table[_pos_]);
			}
			_time_ = curTime;
			_pos_ = (int) (_time_ % BUCKET_SIZE);
		}
		return _pos_;
	}

	protected int check(int period) {
		if (period >= BUCKET_SIZE)
			period = BUCKET_SIZE - 1;
		return period;
	}

	protected int stepback(int pos) {
		if (pos == 0)
			pos = BUCKET_SIZE - 1;
		else
			pos--;
		return pos;
	}

	
	public static interface Handler<T> {
		public void process(T u);
	}

	public int search(int period, Handler<T> h) {
		period = check(period);
		int pos = getPosition();

		for (int i = 0; i < period; i++, pos = stepback(pos)) {
			h.process((T)table[pos]);
		}
		return period;
	}
	public T[] search(int period) {
		period = check(period);
		int pos = getPosition();

		T[] out = (T[]) new Object[period];
		for (int i = 0; i < period; i++, pos = stepback(pos)) {
			out[i]=((T)table[pos]);
		}
		return out;
	}

	protected long getTime() {
		return System.currentTimeMillis() / TIME_UNIT;
	}

}