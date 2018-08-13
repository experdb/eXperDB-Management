
package com.k4m.dx.tcontrol.monitoring.schedule.util.lang.conf;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface ParamDesc {
  String value();
}
