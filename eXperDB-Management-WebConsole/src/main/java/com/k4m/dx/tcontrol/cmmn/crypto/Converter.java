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

import java.util.BitSet;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;


/**
 * 포맷 간의 변환을 담당한다.
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
public class Converter {

	//private static final char[]	hexArray	= { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	private Converter() {
	}

	/**
	 * Base64 문자열을 byte 배열로 변환한다.
	 * @param input - byte 배열로 변환할 Base64 문자열
	 * @return byte[] - 변환된 byte 배열
	 */
	public static byte[] base64ToBytes(String input) {
		return Base64.decodeBase64(input);
	}

	/**
	 * byte 배열을 Base64 문자열로 변환한다.
	 * @param input - Base64로 변환할 byte 배열
	 * @return String - 변환된 Base64 문자열
	 */
	public static String bytesToBase64(byte[] input) {
		return Base64.encodeBase64String(input);
	}

	public static byte[] hexToBytes(String hex) throws DecoderException {
		return Hex.decodeHex(hex.toCharArray());
	}

	public static byte[] toBytes(int input) {
		return new byte[] { (byte) (input >>> 24), (byte) (input >>> 16), (byte) (input >>> 8), (byte) input };
	}

	public static byte[] toBytes(BitSet input) {
		byte[] retval = new byte[(input.length() + Byte.SIZE - 1) / Byte.SIZE];
		for (int i = 0; i < input.length(); i++) {
			if (input.get(i)) {
				retval[retval.length - i / 8 - 1] |= 1 << (i % 8);
			}
		}
		return retval;
	}

	public static BitSet toBitSet(byte[] input) {
		BitSet retval = new BitSet();
		for (int i = 0; i < input.length * 8; i++) {
			if ((input[input.length - i / 8 - 1] & (1 << (i % 8))) > 0) {
				retval.set(i);
			}
		}
		return retval;
	}

	public static BitSet toBitSet(int input) {

		return toBitSet(new byte[] { (byte) (input >>> 24), (byte) (input >>> 16), (byte) (input >>> 8), (byte) input });
	}

	public static int toInteger(byte[] input) {
		int l = 0;

		if (input == null || input.length == 0) { return 0; }
		int len = input.length;
		l |= input[0] & 0xFF;

		switch (len) {
			case 4:
				l <<= 8;
				l |= input[1] & 0xFF;
				l <<= 8;
				l |= input[2] & 0xFF;
				l <<= 8;
				l |= input[3] & 0xFF;
				break;
			case 3:
				l <<= 8;
				l |= input[1] & 0xFF;
				l <<= 8;
				l |= input[2] & 0xFF;
				break;
			case 2:
				l <<= 8;
				l |= input[1] & 0xFF;
				break;
		}

		return l;
	}
}
