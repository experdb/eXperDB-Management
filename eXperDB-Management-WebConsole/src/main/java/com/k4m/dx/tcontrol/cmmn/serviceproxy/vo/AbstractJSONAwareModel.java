/**
 * <pre>
 * Copyright (c) 2014 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.json.simple.JSONAware;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * @brief JSON 문자열로 변환이 필요한 객체들의 상위 클래스
 * 
 *        JSON 문자열로 변환이 필요한 객체들을 위한 메소드를 포함한다.
 * @date 2014. 11. 28.
 * @author Kim, Sunho
 */

public abstract class AbstractJSONAwareModel implements JSONAware {

	protected static Logger		logger					= LoggerFactory.getLogger(AbstractJSONAwareModel.class);

	//private static final Gson	toJsonStringGson		= new Gson();
	private static final Gson	toJsonStringGson		= new GsonBuilder().serializeNulls().create();

	private static final Gson	fromStringGson			= new GsonBuilder().disableHtmlEscaping().create();

	private static final String	oracleTimestampFormat	= "YYYY-MM-DD HH24:MI:SS.FF";

	private static final String	postgresqlTimestampFormat	= "YYYY-MM-DD HH24:MI:SS.MS";

	/**
	 * Reflection으로 객체를 문자열로 변환한다.
	 * @return String - Reflection으로 변환된 문자열로 로깅 등 참고용으로 사용한다.
	 */
	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}

	/**
	 * 현재 객체를 JSON 문자열로 변환한다.
	 * @return String - JSON 문자열
	 */
	public String toJSONString()
	{
		return toJsonStringGson.toJson(this);
	}

	/**
	 * 
	 * 입력받은 JSON문자열로 입력받은 형식의 클래스의 객체를 만들어 반환한다. 이 클래스를 상속받은 객체에서는 이 메소드를 이용하여 각 클래스에 맞는 fromString 메소드를 구현해야 한다.
	 * @code public static Entity fromString(String jsonString) { return fromString(jsonString, Entity.class); }
	 * @endcode
	 * @param jsonString - 객체로 만들 JSON문자열
	 * @param classofT - 만들고자 하는 객체의 클래스
	 * @return T JSON문자열로 생성된 객체
	 */
	protected static <T> T fromString(String jsonString, Class<T> classofT) {
		T retval = null;
		try {
			retval = (fromStringGson).fromJson(jsonString, classofT);
		} catch (Exception e) {
			logger.debug(e.toString());
		}
		return retval;
	}

	public static String getOracletimestampformat() {
		return oracleTimestampFormat;
	}

}
