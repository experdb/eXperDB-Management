package com.k4m.dx.tcontrol.transfer.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.k4m.dx.tcontrol.transfer.service.TransDbmsVO;
import com.k4m.dx.tcontrol.transfer.service.TransMappVO;
import com.k4m.dx.tcontrol.transfer.service.TransRegiVO;
import com.k4m.dx.tcontrol.transfer.service.TransVO;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("TransConDAO")
public class TransConDAO extends EgovAbstractMapper{
	
	/**
	 * trans Schema Registry conmnect 명 체크
	 * 
	 * @param trans_sys_nm
	 * @return int
	 * @throws Exception
	 */
	public int trans_Registry_nmCheck(String regi_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("transSQL.trans_Registry_nmCheck", regi_nm);
		return resultSet;
	}


	/**
	 * trans kafka conmnect 명 체크
	 * 
	 * @param trans_sys_nm
	 * @return int
	 * @throws Exception
	 */
	public int trans_connect_nmCheck(String kc_nm) {
		int resultSet = 0;
		resultSet = (int) getSqlSession().selectOne("transSQL.trans_connect_nmCheck", kc_nm);
		return resultSet;
	}

	/**
	 * trans kafka connecnt 등록
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void insertTransKafkaConnect(TransDbmsVO transDbmsVO) {
		insert("transSQL.insertTransKafkaConnect", transDbmsVO);
	}

	/**
	 * kafka connect log 등록
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void insertTransKafkaConnectLog(TransDbmsVO transDbmsVO) {
		insert("transSQL.insertTransKafkaConnectLog", transDbmsVO);
	}

	/**
	 * Schema Registry log 등록
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void insertTransSchemaRegistryLog(TransRegiVO transRegiVO) {
		insert("transSQL.insertTransSchemaRegistryLog", transRegiVO);
	}

	/**
	 * trans Schema Registry 등록
	 * 
	 * @param transRegiVO
	 * @throws Exception
	 */
	public void insertTransSchemaRegistry(TransRegiVO transRegiVO) {
		insert("transSQL.insertTransSchemaRegistry", transRegiVO);
	}
	
	/**
	 * kafka connect log 삭제
	 * 
	 * @param transVO
	 * @throws Exception
	 */
	public void deleteTransKafkaConnectLog(TransDbmsVO transDbmsVO) {
		delete("transSQL.deleteTransKafkaConnectLog", transDbmsVO);
	}

	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void deleteTransKafkaConnect(TransDbmsVO transDbmsVO) {
		delete("transSQL.deleteTransKafkaConnect", transDbmsVO);
	}
	/**
	 * Schema Registry log 삭제
	 * 
	 * @param transRegiVO
	 * @throws Exception
	 */
	
	public void deleteTransSchemaRegistryLog(TransRegiVO transRegiVO) {
		delete("transSQL.deleteTransSchemaRegistryLog", transRegiVO);
		
	}

	/**
	 * trans kafka connect 설정 삭제
	 * 
	 * @param transRegiVO
	 * @throws Exception
	 */
	public void deleteTransSchemaRegistry(TransRegiVO transRegiVO) {
		delete("transSQL.deleteTransSchemaRegistry", transRegiVO);
	}

	/**
	 * trans kafka connect 조회
	 * 
	 * @param transDbmsVO
	 * @return List<TransDbmsVO>
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public List<TransDbmsVO> selectTransKafkaConList(TransDbmsVO transDbmsVO) {
		List<TransDbmsVO> sl = null;
		sl = (List<TransDbmsVO>) list("transSQL.selectTransKafkaConList", transDbmsVO);
		return sl;
	}

	/**
	 * Schema Registry 정보 
	 * 
	 * @param transRegiVO
	 * @return List<TransRegiVO>
	 * @throws Exception
	 */
	public List<TransRegiVO> selectTransRegiList(TransRegiVO transRegiVO) {
		return (List<TransRegiVO>) list("transSQL.selectTransRegiList", transRegiVO);
	}

	/**
	 * trans Schema Registry 수정
	 * 
	 * @param transRegiVO
	 * @throws Exception
	 */
	public void updateTransSchemaRegistry(TransRegiVO transRegiVO) {
		update("transSQL.updateTransShcemaRegistry", transRegiVO);
	}

	/**
	 * trans Schema Registry 사용여부 확인
	 * 
	 * @param transRegiVOselectTransSchemRegiIngChk
	 * @return String
	 * @throws Exception
	 */
	public Map<String, Object> selectTransSchemRegiIngChk(TransDbmsVO transDbmsVO) throws SQLException {
		return (Map<String, Object>) selectOne("transSQL.selectTransSchemRegiIngChk", transDbmsVO);
	}
	
	/**
	 * trans KAFKA CONNECT 사용여부 확인
	 * 
	 * @param transDbmsVO
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> selectTransKafkaConIngChk(TransDbmsVO transDbmsVO) throws SQLException {
		return (Map<String, Object>) selectOne("transSQL.selectTransKafkaConIngChk", transDbmsVO);
	}
	
	/**
	 * trans connect 수정
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void updateTransKafkaConnect(TransDbmsVO transDbmsVO) {
		update("transSQL.updateTransKafkaConnect", transDbmsVO);
	}

	/**
	 * trans connect faild 수정
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void updateTransKafkaConnectFaild(TransDbmsVO transDbmsVO) {
		update("transSQL.updateTransKafkaConnectFaild", transDbmsVO);
	}

	/**
	 * trans schema Registry faild 수정
	 * 
	 * @param transDbmsVO
	 * @throws Exception
	 */
	public void updateTransSchemaConnectFaild(TransRegiVO transRegiVO) {
		update("transSQL.updateTransSchemaConnectFaild", transRegiVO);
	}

	/**
	 * Schema Registry 등록 정보 리스트 조회
	 * 
	 * @param transRegiVO
	 * @return List<TransRegiVO>
	 * @throws Exception
	 */
	public List<TransRegiVO> selectTargetTransRegiList(HashMap<String , Object> paramMap) {
		return (List<TransRegiVO>) list("transSQL.selectTargetTransRegiList", paramMap);
	}

}