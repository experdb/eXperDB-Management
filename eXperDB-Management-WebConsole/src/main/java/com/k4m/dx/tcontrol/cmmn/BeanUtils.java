package com.k4m.dx.tcontrol.cmmn;

import org.springframework.context.ApplicationContext;

public class BeanUtils {
		public static <T> Object getBean(String string) {
			ApplicationContext applicationContext = ApplicationContextProvider.getContext();
			return applicationContext.getBean(string);
		}
}
