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
package com.k4m.dx.tcontrol.cmmn.crypto;

import static java.nio.charset.StandardCharsets.UTF_8;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.UUID;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.joda.time.DateTime;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode.Default;


/**
 * @brief 난수 생성
 * 
 *        난수 및 난수 기반의 값을 생성하는 기능을 담당한다.
 * @date 2014. 11. 28.
 * @author Kim, Sunho
 */

public class Generator {

	private Generator() {

	}

	/**
	 * 난수 기반의 UUID 를 생성한다.
	 * @return String - dash(-)를 포함한 36자리의 UUID 포맷 문자열
	 */
	public static String generateUuid()
	{
		return UUID.randomUUID().toString();
	}

	public static String generateTsUuid() {
		return DateTime.now().toString("yyyyMMddHHmmssSSS") + "_" + UUID.randomUUID().toString();
	}

	/**
	 * 입력된 길이 만큼의 난수를 생성하여 byte 배열로 반환한다.
	 * @param bitLength - bit 단위의 난수 길이 . byte의 길이인 8로 나누어 떨어지지 않으면 올림하여 byte의 길이를 맞춘다.
	 * @return byte[] - 생성된 난수의 byte 배열.
	 */
	public static byte[] generateRandomBits(int bitLength) {
		byte[] retval = new byte[bitLength / Byte.SIZE + (bitLength % 8 == 0 ? 0 : 1)];
		try {
			SecureRandom.getInstance(Default.DEFAULT_RANDOM_BIT_GENERATOR_ALGORITHM).nextBytes(retval);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
		return retval;
	}

	/**
	 * 입력된 길이 만큼의 난수를 생성하여 Base64로 인코딩된 문자열로 반환한다. 난수 생성은 generateRandomBits 메소드를 이용한다.
	 * @param bitLength - bit 단위의 난수 길이 . byte의 길이인 8로 나누어 떨어지지 않으면 올림하여 byte의 길이를 맞춘다.
	 * @return String - Base64 문자열로 인코딩된 난수 배열
	 */
	public static String generateRandomString(int bitLength) {
		return Converter.bytesToBase64(generateRandomBits(bitLength));
	}

	/**
	 * 난수 생성기를 이용해서 32bit형의 양의 정수를 생성한다.
	 * @return int - 반환되는 정수는 부호가 모두 +가 되도록 bit이동을 하기 때문에 실제 정수의 길이는 부호를 제외해서 31bit가 된다.
	 */
	public static int generateRandomInteger(int bitLength) {

		if (bitLength == 0 || bitLength > 31) {
			bitLength = 31;
		}

		int byteMod = bitLength % 8;
		byte[] random = new byte[bitLength / 8 + (byteMod == 0 ? 0 : 1)];
		try {
			SecureRandom.getInstance(SystemCode.Default.DEFAULT_RANDOM_BIT_GENERATOR_ALGORITHM).nextBytes(random);
		} catch (NoSuchAlgorithmException e) {
			return 0;
		}

		if (byteMod > 0) {
			random[0] = (byte) ((random[0] & 0xFF) >>> 8 - byteMod);
		}

		int l = 0;

		if (random == null || random.length == 0) { return 0; }
		int len = random.length;
		l |= random[0] & 0xFF;

		switch (len) {
			case 4:
				l <<= 8;
				l |= random[1] & 0xFF;
				l <<= 8;
				l |= random[2] & 0xFF;
				l <<= 8;
				l |= random[3] & 0xFF;
				break;
			case 3:
				l <<= 8;
				l |= random[1] & 0xFF;
				l <<= 8;
				l |= random[2] & 0xFF;
				break;
			case 2:
				l <<= 8;
				l |= random[1] & 0xFF;
				break;
		}

		return l;
	}
	
	public static String generateKey(String password) throws Exception  {
		//String password = "sOme*ShaREd*SecreT";
		byte[] salt = new byte[32];
		
		SecureRandom random = SecureRandom.getInstance("SHA1PRNG");

		synchronized (random) {
			random.nextBytes(salt);
		}

		System.out.println("key : " + Base64.encodeBase64String(salt));
		
		Mac _hmacSha1;
		_hmacSha1 = Mac.getInstance("HmacSHA1");
		_hmacSha1.init(new SecretKeySpec(password.getBytes(UTF_8), "HmacSHA1"));
		//SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		//SecretKeyFactory factory = SecretKeyFactory.getInstance("HmacSHA1");
		//KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 1024, 128);
		//SecretKey key = factory.generateSecret(spec);
		
		//SecretKeySpec secret = new SecretKeySpec(key.getEncoded(), "AES");

		//System.out.println("Key:" + Base64.encodeBase64(spec.));

		
		return toBase64String(_hmacSha1.doFinal(salt));
	}
	
	/**
     * @description byte 배열을 Base64로 인코딩한다.
     */
    public static String toBase64String(byte[] bytes){
         
        byte[] byteArray = Base64.encodeBase64(bytes);
        return new String(byteArray);
         
    }

}
