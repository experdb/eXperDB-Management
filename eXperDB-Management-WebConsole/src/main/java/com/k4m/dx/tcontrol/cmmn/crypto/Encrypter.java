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

import java.security.Key;
import java.security.MessageDigest;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode.Default;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;

/**
 * 관리 기능에서 필요로 하는 암호화를 담당한다.
* @author 박태혁
* @see
* 
*      <pre>
* == 개정이력(Modification Information) ==
*
*   수정일       수정자           수정내용
*  -------     --------    ---------------------------
*  2018.04.23   박태혁 최초 생성
*      </pre>
*/
public class Encrypter {

	private Encrypter() {
	}

	/**
	 * 입력된 문자열을 SystemCode에 정의된 알고리즘으로 해싱처리한 후 Base64로 인코딩하여 반환한다.
	 * @param input - 해싱 처리할 문자열
	 * @return String - 해싱 처리 결과의 Base64로 인코딩된 문자열
	 */
	public static String digestToBase64(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance(Default.DEFAULT_HASH_ALGORITHM);
			md.update(input.getBytes(Default.DEFAULT_CHARACTER_SET));
			return Converter.bytesToBase64(md.digest());
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private static byte[] hmac(byte[] input, byte[] dek, String algorithm) throws Exception {
		Key key = new SecretKeySpec(dek, algorithm);
		Mac mac = Mac.getInstance(algorithm);
		mac.init(key);
		return mac.doFinal(input);
	}

	public static String hmac(String input, String dek) throws Exception {
		return Converter.bytesToBase64(hmac(input.getBytes(Default.DEFAULT_CHARACTER_SET), dek.getBytes(Default.DEFAULT_CHARACTER_SET),
				Default.DEFAULT_PSUEDO_RANDOM_FUNCTION));
	}

	public static byte[] hmacToBytes(String input, String dek) throws Exception {
		return hmac(input.getBytes(Default.DEFAULT_CHARACTER_SET), dek.getBytes(Default.DEFAULT_CHARACTER_SET),
				Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);
	}

	private static byte[] encrypt(byte[] input, byte[] dek, String keyAlgorithm, String cipherAlgorithm) throws Exception {
		Key key = new SecretKeySpec(dek, keyAlgorithm);
		byte[] iv = Generator.generateRandomBits(Default.DEFAULT_IV_BYTE_LENGTH * Byte.SIZE);

		Cipher cipher = Cipher.getInstance(cipherAlgorithm);
		cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));

		byte[] enc = cipher.doFinal(input);

		byte[] retval = new byte[iv.length + enc.length];

		System.arraycopy(iv, 0, retval, 0, iv.length);
		System.arraycopy(enc, 0, retval, iv.length, enc.length);

		return retval;

	}

	public static byte[] encryptThenMac(byte[] input, byte[] key) throws Exception {
		byte[] ivenc = encrypt(input, key, Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM);
		byte[] hmac = hmac(ivenc, key, Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);
		return TypeUtility.mergeBytes(hmac, ivenc);
	}

	public static byte[] encryptOnly(byte[] input, byte[] key) throws Exception {
		return encrypt(input, key, Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM);
	}

	public static byte[] validateMacThenDecrypt(byte[] input, byte[] key) throws Exception {
		byte[] hmac = Arrays.copyOf(input, Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH);
		byte[] ivenc = Arrays.copyOfRange(input, hmac.length, input.length);
		if (Arrays.equals(hmac, hmac(ivenc, key, Default.DEFAULT_PSUEDO_RANDOM_FUNCTION))) {
			return decrypt(ivenc, key, Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM);
		} else {
			throw new Exception("The integrity of encrypted data is undermined.");
		}
	}

	public static byte[] decryptOnly(byte[] input, byte[] key) throws Exception {
		return decrypt(input, key, Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM);
	}

	public static String encrypt(String input, String dek) throws Exception {
		return Converter.bytesToBase64(encrypt(input.getBytes(Default.DEFAULT_CHARACTER_SET), dek.getBytes(Default.DEFAULT_CHARACTER_SET),
				Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM));
	}

	private static byte[] decrypt(byte[] input, byte[] dek, String keyAlgorithm, String cipherAlgorithm) throws Exception {
		Key key = new SecretKeySpec(dek, keyAlgorithm);
		byte[] iv = new byte[Default.DEFAULT_IV_BYTE_LENGTH];
		byte[] enc = new byte[input.length - iv.length];
		System.arraycopy(input, 0, iv, 0, iv.length);
		System.arraycopy(input, iv.length, enc, 0, enc.length);
		Cipher cipher = Cipher.getInstance(cipherAlgorithm);
		cipher.init(Cipher.DECRYPT_MODE, key, new IvParameterSpec(iv));
		return cipher.doFinal(enc);
	}

	public static String decrypt(String input, String dek) throws Exception {
		return new String(decrypt(Converter.base64ToBytes(input), dek.getBytes(Default.DEFAULT_CHARACTER_SET),
				Default.DEFAULT_KEY_SPEC_ALGORITHM, Default.DEFAULT_DATA_CIPHER_ALGORITHM), Default.DEFAULT_CHARACTER_SET);
	}

}
