
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang;


@SuppressWarnings("serial")
abstract public class NumberValue extends Number implements Value {
	public NumberValue add(NumberValue num) {
		if (num == null)
			return this;
		switch (this.getValueType()) {
		case ValueEnum.DECIMAL:
			((DecimalValue) this).value += num.longValue();
			return this;
		case ValueEnum.FLOAT:
			((FloatValue) this).value += num.floatValue();
			return this;
		case ValueEnum.DOUBLE:
			((DecimalValue) this).value += num.doubleValue();
			return this;
		default:
			return new DoubleValue(this.doubleValue() + num.doubleValue());
		}
	}
	
	abstract public double doubleValue();
	abstract public float floatValue();
	abstract public int intValue();
	abstract public long longValue();

}