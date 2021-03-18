package com.experdb.proxy.db;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.SQLException;

/*
 * DB 쿼리 혹은 파라미터 관련 수행 유틸. 단일 클래스에서만 사용되기 때문에 해당 클래스로 통합되어야 할듯.
 */
public class DatabaseUtil {
	/*
	 * Clob 데이터를 String으로 추출
	 */
	public static String ConvertClobToString(StringBuffer sb, Clob clob) throws SQLException, IOException{
		Reader reader = clob.getCharacterStream();
		char[] buffer = new char[(int)clob.length()];
		while(reader.read(buffer) != -1){
			sb.append(buffer);
		}
		return sb.toString();
	}
	
	/*
	 * ResultSet에서 특정위치 컭럼의 데이터 추출
	 */
	public static Object PreparedStmtSetValue(int columnType, ResultSet rs, int index) throws SQLException, IOException{
		StringBuffer sb = new StringBuffer();
		switch(columnType){
		case 2005:  //CLOB
			Clob clob = rs.getClob(index);
			
			if (clob == null){
				return null;
			}
			
			Reader reader = clob.getCharacterStream();
			char[] buffer = new char[(int)clob.length()];
			while(reader.read(buffer) != -1){
				sb.append(buffer);				
			}
			return sb.toString();
		case 2004:  //BLOB			
			Blob blob = rs.getBlob(index);
			
			if (blob == null){
				return null;
			}
			
			InputStream in = blob.getBinaryStream();
			byte[] Bytebuffer = new byte[(int)blob.length()];
			in.read(Bytebuffer);
			return Bytebuffer;
		case -2:
			return rs.getBytes(index);
		default:
			return rs.getObject(index);
		}	
	}

	/*
	 * WHERE 절의 IN 의 인자값(?)을 count 수 만큼 증식. 단 ?는 단일 값이어야 함. Dynamic 쿼리를 못 사용하기 때문에 사용.
	 */
	public static String QueryIncreateInParam(String query, int count){
		if (count < 1) return query;
		StringBuilder builder = new StringBuilder();
		builder.append("IN(");
		for(int i=0; i<count; i++){
			if (i == count -1){
				builder.append("?");
			}else{
				builder.append("?,");
			}
		}
		builder.append(")");
		query = query.replace("IN(?)", builder.toString());
		return query;
	}
}
