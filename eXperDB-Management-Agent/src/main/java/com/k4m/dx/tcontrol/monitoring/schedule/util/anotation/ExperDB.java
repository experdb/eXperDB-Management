
package com.k4m.dx.tcontrol.monitoring.schedule.util.anotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface ExperDB {
  int interval() default 2000; //default interval 2000 ms
}