package com.k4m.dx.tcontrol.scale.cmmn;

import org.springframework.context.ApplicationContext;

public class ScaleBeanUtils {
    public static Object getBean(String beanName) {
        ApplicationContext applicationContext = ScaleApplicationContextProvider.getApplicationContext();
        return applicationContext.getBean(beanName);
    }
}