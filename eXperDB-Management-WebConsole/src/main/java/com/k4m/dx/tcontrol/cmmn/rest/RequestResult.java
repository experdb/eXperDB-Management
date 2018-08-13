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
package com.k4m.dx.tcontrol.cmmn.rest;

import java.io.File;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import org.json.simple.JSONAware;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;


/**
 * @brief 서비스 처리 후 반환되는 데이터 객체
 * 
 *        서버의 처리 결과 코드와 반환되는 데이터를 포함하는 객체
 * @date 2014. 11. 17.
 * @author Kim, Sunho
 */

public class RequestResult implements Serializable {

	/** serialVersionUID */
	private static final long	serialVersionUID		= -3368117513048675761L;

	public static final String	SUCCESS					= "0000000000";

	public static final String	FAILURE					= "9999999999";

	public static final String	RESULT_CODE_FIELD		= "resultCode";

	public static final String	RESULT_MESSAGE_FIELD	= "resultMessage";

	public static final String	RESULT_UID_FIELD		= "resultUid";

	public static final String	TOTAL_LIST_COUNT_FIELD	= "totalListCount";

	public static final String	KEY_VALUE_FIELD			= "map";

	public static final String	LIST_FIELD				= "list";

	public static final String	OBJECT_FIELD			= "object";

	//public static final String	OBJECT_TYPE_FILED		= "type";

	public static final String	EMPTY_MESSAGE			= "";

	private String				entityUid;

	private String				nextTokenValue;

	private String				resultCode;

	private String				resultMessage;

	private String				resultUid;

	private long				totalListCount			= -1;

	//Custom Key - Value Data
	private Map<String, Object>	resultMap;

	//List Data
	private List				resultList;

	private JSONAware			resultObject;

	//private String				objectType;

	//private JSONObject			jsonResultValue;

	//private String				xmlStringResult;

	private File				resultFile;

	/**
	 * 생성자. 성공 상태로 결과 초기화
	 */
	public RequestResult() {
		this.setResultCode(RequestResult.SUCCESS, RequestResult.SUCCESS);
	}

	/**
	 * 객체 내부 상태를 초기화한다. 이 때 상태는 객체 생성 상태와 동일해야 한다.
	 * @return void
	 */
	public void Clear() {
		this.setResultCode(RequestResult.SUCCESS, RequestResult.SUCCESS);
		this.setResultMessage(RequestResult.EMPTY_MESSAGE);
		this.totalListCount = -1;
		this.resultList = null;
		this.resultMap = null;
		this.resultObject = null;
		this.resultFile = null;
		//this.xmlStringResult = null;
	}

	public File getResultFile() {
		return resultFile;
	}

	public void setResultFile(File resultFile) {
		this.resultFile = resultFile;
	}

	//	public String getXmlStringResult() {
	//		return xmlStringResult;
	//	}
	//
	//	public void setXmlStringResult(String xmlStringResult) {
	//		this.xmlStringResult = xmlStringResult;
	//	}

	public String getResultCode() {
		return resultCode;
	}

	/**
	 * 입력된 코드와 message.properties파일에서 검색한 메세지로 처리 결과를 구성한다.
	 * @param resultCode - 처리 결과 코드
	 * @return void
	 */
	public void setResultCode(String resultCode, String resultMessage) {
		this.resultCode = resultCode;
		this.resultMessage = resultMessage;
	}

	public String getResultMessage() {
		return resultMessage;
	}

	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}

	public String getResultUid() {
		return resultUid;
	}

	public void setResultUid(String resultUid) {
		this.resultUid = resultUid;
	}

	/**
	 * 입력된 코드와 메세지로 처리 결과를 구성한다.
	 * @param resultCode - 처리 결과 코드
	 * @param resultMessage - 처리 결과 메세지
	 * @return void
	 */
	public void setResultCodeMessage(String resultCode, String resultMessage) {
		this.resultCode = resultCode;
		this.resultMessage = resultMessage;
	}

	/**
	 * 단순 키-값 쌍을 처리 결과에 추가시켜 JSON 문자열로 변환되어 http 출력이 되도록 한다. 동일한 키가 존재하는 경우 입력된 값으로 값이 대체된다.
	 * @param key - 키
	 * @param value - 값
	 * @return void
	 */
	//	public void addResultKeyValue(String key, Object value) {
	//		if (resultMap == null) {
	//			resultMap = new HashMap<String, Object>();
	//		}
	//
	//		resultMap.put(key, value);
	//
	//	}

	/**
	 * 외부에서 구성된 단순 키-값 쌍들을 처리 결과에 포함한다. 이전에 구성된 단순 키-값 쌍들은 사라지고 입력된 쌍들로 대체된다.
	 * 
	 * @param value - 출력에 포함할 키-값 쌍
	 * @return void
	 */
	public void setResultMap(Map<String, Object> resultMap) {
		this.resultMap = resultMap;
	}

	public Map<String, Object> getResultMap() {
		return this.resultMap;
	}

	/**
	 * 객체 목록 형태를 처리 결과에 포함한다. 이전에 구성된 객체 목록은 입력된 값으로 대체된다. 목록의 크기는 입력된 목록의 크기로 설정된다.
	 * 
	 * @param value - JSON 변환이 가능한 객체들의 목록
	 * @return void
	 */
	public void setResultList(List value) {
		this.resultList = value;
		if (value != null) {
			this.totalListCount = value.size();
		} else {
			this.totalListCount = 0;
		}
	}

	/**
	 * 객체 목록 형태를 처리 결과에 포함한다. 이전에 구성된 객체 목록은 입력된 값으로 대체된다. 페이징 처리등 전체 조회되는 데이터의 수와 반환되는 객체 목록의 크기가 다른 경우에 전체 조회된 데이터 수를 별도로 제공하기 위해 사옹한다.
	 * 
	 * @param value - JSON 변환이 가능한 객체들의 목록
	 * @param totalCount - 특정 조건으로 조회되는 전체 데이터 수
	 * @return void
	 */
	public void setResultList(List value, long totalCount) {
		this.resultList = value;
		this.totalListCount = totalCount;
	}

	/**
	 * 객체를 처리 결과에 포함한다. 이전에 입력된 객체는 입력된 값으로 대체된다.
	 * @param value - JSON 변환이 가능한 객체
	 * @return void
	 */
	public void setResultObject(JSONAware value) {
		this.resultObject = value;
		//		if (value.getClass().getName().endsWith("Entity")) {
		//			this.objectType = "Entity";
		//		}

	}

	/**
	 * 처리 결과 내부의 키-쌍 목록으로 부터 입력된 키에 해당되는 값을 검색하여 반환한다.
	 * @param key - 검색할 키
	 * @return Object - 검색된 값. 값이 존재하지 않는 경우 null 이 반환된다.
	 */
	public Object getResultKeyValue(String key) {
		if (this.resultMap != null) { return this.resultMap.get(key); }
		return null;
	}

	public void setResultKeyValue(String key, Object value) {
		if (this.resultMap == null) {
			this.resultMap = new HashMap<String, Object>();
		}

		this.resultMap.put(key, value);
	}

	/**
	 * 처리 결과 내부의 객체 목록을 반환한다.
	 * @return List - 처리 결과 내부에 저장되어 있는 JSON 변환 가능한 객체들의 목록
	 */
	public List getResultList() {
		return this.resultList;
	}

	/**
	 * 객체 내부에 포함하는 값들을 JSON 객체로 변환하는 메소드로 RequestResultMessageBodyWriter.writeTo 메소드에서 처리 결과를 출력하기 위해 JSON 문자열 추출에 사용되된다.
	 * @return JSONObject - JSON 문자열 추출을 위한 JSON 객체
	 */
	public JsonObject getResultJSONValue() {
		//JSONObject obj = new JSONObject();
		JsonObject retval = new JsonObject();
		Gson gson = (new GsonBuilder()).excludeFieldsWithoutExposeAnnotation().create();

		retval.addProperty(RESULT_CODE_FIELD, this.resultCode);
		retval.addProperty(RESULT_MESSAGE_FIELD, this.resultMessage);
		retval.addProperty(RESULT_UID_FIELD, this.resultUid);

		//		obj.put(RESULT_CODE_FIELD, this.resultCode);
		//		obj.put(RESULT_MESSAGE_FIELD, this.resultMessage);
		//		obj.put(RESULT_UID_FIELD, this.resultUid);
		if (this.totalListCount > -1)
		{
			//		obj.put(TOTAL_LIST_COUNT_FIELD, this.totalListCount);
			retval.addProperty(TOTAL_LIST_COUNT_FIELD, this.totalListCount);
		}

		if (this.resultMap != null && !this.resultMap.isEmpty()) {
			retval.add(KEY_VALUE_FIELD, gson.toJsonTree(this.resultMap));
		}

		if (this.resultList != null && this.resultList.size() > 0) {
			retval.add(LIST_FIELD, gson.toJsonTree(this.resultList));
			//				obj.put(LIST_FIELD,
			//						new JSONParser()
			//								.parse(gson.toJson(this.resultList).toString()));
		}

		if (this.resultObject != null) {
			retval.add(OBJECT_FIELD, gson.toJsonTree(this.resultObject));
			//				obj.put(OBJECT_FIELD,
			//						new JSONParser().parse((gson.toJson(this.resultObject))));
		}

		return retval;
	}

	/**
	 * 객체가 저장하고 있는 처리 결과 코드와 메세지를 문자열로 반환한다.
	 * @return String - 처리 결과 코드와 메세지의 JSON 문자열
	 */
	public String toString()
	{
		return new StringBuffer().append("{\"resultCode\" : \"").append(this.resultCode).append("\", \"resultMessage\" :\"")
				.append(this.resultMessage).append("\"}").toString();
	}


	public String getEntityUid() {
		return entityUid;
	}

	public void setEntityUid(String entityUid) {
		this.entityUid = entityUid;

	}

	public String getNextTokenValue() {
		return nextTokenValue;
	}

	public void setNextTokenValue(String nextTokenValue) {
		this.nextTokenValue = nextTokenValue;
	}

	//	public String getObjectType() {
	//		return objectType;
	//	}
}
