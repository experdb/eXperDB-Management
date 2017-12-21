package com.k4m.dx.tcontrol.db.datastructure;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
 * DB에서 추출된 DATA를 저장 및 관리하는 클래스
 */
public class DataTable implements java.io.Serializable{
	private static final long serialVersionUID = 1L;
	private List<Map<String, Object>> rows= null;
	private List<String> columns = null;
	private String tableName = "";
	public DataTable(){
		rows = new ArrayList <Map<String, Object>>();
		columns = new ArrayList <String>();
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : DataTable 이름 설정
	 * @param tableName
	 */
	public void SetTableName(String tableName) {
		this.tableName = tableName;
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : DataTable 이름 얻기
	 * @return
	 */
	public String GetTableName() {
		return tableName;
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 컬럼 추가하기
	 * @param columnName
	 * @throws Exception
	 */
	public void AddColumns(String columnName) throws Exception{
		if (columns.contains(columnName)) {
			throw new Exception("컬럼정보가 기 존재합니다.");
		}
		columns.add(columnName);
		
		for (Map<String, Object> map: rows) {
			map.put(columnName, null);
		}
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 특정 위치에 컬럼 추가하기.
	 * @param idx
	 * @param columnName
	 * @throws Exception
	 */
	public void AddColumns(int idx, String columnName) throws Exception{
		if (columns.contains(columnName)) {
			throw new Exception("컬럼정보가 기 존재합니다.");
		}
		columns.add(idx, columnName);
		
		for (Map<String, Object> map: rows) {
			map.put(columnName, null);
		}
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 데이터 로우 추가하기.
	 * @param objs
	 * @throws Exception
	 */
	public void AddRow(List<Object> objs) throws Exception{
		if (columns.size() == 0) {
			throw new Exception("등록된 컬럼정보가 없습니다.");
		}
		if (columns.size() != objs.size()) {
			throw new Exception("컬럼 갯수와 로우컬럼 갯수가 동일하지 않습니다.");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		for (int i=0; i<objs.size(); i++) {
			map.put(columns.get(i), objs.get(i));
		}
		rows.add(map);
	}
	
	public void AddRow(Object[] objs) throws Exception{
		if (columns.size() == 0) {
			throw new Exception("등록된 컬럼정보가 없습니다.");
		}
		if (columns.size() != objs.length) {
			throw new Exception("컬럼 갯수와 로우컬럼 갯수가 동일하지 않습니다.");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		for (int i=0; i<objs.length; i++) {
			map.put(columns.get(i), objs[i]);
		}
		rows.add(map);
	}
	
	public void RenameColumn(String SrcColNm, String RepColNm) throws Exception{
		if (columns.size() == 0) {
			throw new Exception("등록된 컬럼정보가 없습니다.");
		}
		
		columns.set(columns.indexOf(SrcColNm), RepColNm);
		
		for(Map<String, Object> map: rows){
			Object obj = map.get(SrcColNm);
			map.remove(SrcColNm);
			map.put(RepColNm, obj);			
		}
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 입력받은 위치의 데이터 로우 삭제
	 * @param index
	 * @throws Exception
	 */
	public void DeleteRow(int index)  throws Exception{
		rows.remove(index);
	}
	
	public void ClearRows() throws Exception{
		rows.clear();
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 입력받은 위치의 컬럼 삭제
	 * @param colIdx
	 * @throws Exception
	 */
	public void DeleteColumn(int colIdx) throws Exception{
		columns.remove(colIdx);
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 입력받은 컬럼명을 가진 컬럼 삭제
	 * @param columnName
	 * @throws Exception
	 */
	public void DeleteColumn(String columnName) throws Exception{
		columns.remove(columnName);
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 데이터 로우 추출. 
	 * @return
	 */
	public List<Map<String, Object>> getRows() {
		return rows;
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 컬럼 리스트 추출
	 * @return
	 */
	public List<String> getColumns() {
		return columns;
	}
	
	/**
	 * 
	 * @Author : SangHae Seo
	 * @Date   :2015. 1. 16.
	 * @Description : 현제 데이터 테이블명 동일한 내용의 클론객체 생성
	 * @return
	 */
	public DataTable Clone() {
		DataTable dt = new DataTable();
		dt.SetTableName(this.tableName);
		dt.columns.addAll(this.columns);
		dt.rows.addAll(this.rows);
		
		return dt;
	}
	
	/*
	public DataTable Select(String condition) throws Exception{
		DataTable resultDt = Clone();
		condition = condition.toUpperCase();
		String[] cond_attr = condition.split("AND");			
		
		Map<String, Object> tMap = new HashMap<String, Object>();	
		for(String attr: cond_attr){
			String[] attr2 = attr.split("=");
			
			if (attr2.length != 2){
				throw new Exception("missing expression");
			}
			
			String key = attr2[0].trim();
			String value = attr2[1].trim();
			
			if (!columns.contains(key)){
				throw new Exception("조건에 입력된 컬럼이 존재하지 않습니다.");
			}
			
			if (tMap.size() == 0){
				for(Map<String, Object> map : this.rows){
					if (map.get(key).equals(value)){								
						tMap.putAll(map);
						
					}
				}
			}else{
				for(int i = tMap.size() - 1; i >= 0; i--){
					
				}
				for(Map<String, Object> map : tMap){					
					String tValue = (String)map.get(key); 
					
					if (tValue == null){
						tMap.remove(tMap);
					}
					if (map.get(key).equals(value)){								
						tMap.putAll(map);
					}
				}
			}

		}
		return resultDt;
	}
	*/
}
