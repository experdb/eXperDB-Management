/**
 * <pre>
 * Copyright (c) 2015 K4M, Inc.
 * All right reserved.
 *
 * This software is the confidential and proprietary information of K4M, Inc. 
 * You shall not disclose such confidential information and
 * shall use it only in accordance with the terms of the license agreement
 * you entered into with K4M.
 * </pre>
 */
package com.k4m.dx.tcontrol.cmmn.crypto;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;


/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 2. 26.
 * @author Kim, Sunho
 */

public class KeyWrapper {

	public static byte[] unWrap(byte[] kek, byte[] cipherKey) throws InvalidKeyException {
		byte[] retval = null;

		Key keKey = null;
		Key pKey = null;
		Cipher cp = null;

		keKey = new SecretKeySpec(kek, SystemCode.Default.DEFAULT_KEY_SPEC_ALGORITHM);
		try {
			cp = Cipher.getInstance(SystemCode.Default.DEFAULT_KEY_CIPHER_ALGORITHM);
			cp.init(Cipher.UNWRAP_MODE, keKey);

			pKey = cp.unwrap(cipherKey, SystemCode.Default.DEFAULT_KEY_CIPHER_ALGORITHM, Cipher.SECRET_KEY);

		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}

		retval = pKey.getEncoded();

		return retval;
	}

	public static byte[] wrap(byte[] kek, byte[] plainKey) throws InvalidKeyException, IllegalBlockSizeException {

		byte[] retval = null;

		Key keKey = null;
		Key pKey = null;

		Cipher cp = null;
		try {
			keKey = new SecretKeySpec(kek, SystemCode.Default.DEFAULT_KEY_SPEC_ALGORITHM);
			pKey = new SecretKeySpec(plainKey, SystemCode.Default.DEFAULT_KEY_SPEC_ALGORITHM);
			cp = Cipher.getInstance(SystemCode.Default.DEFAULT_KEY_CIPHER_ALGORITHM);
			cp.init(Cipher.WRAP_MODE, keKey);
			retval = cp.wrap(pKey);

		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (NoSuchPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}

		return retval;

	}

	private KeyWrapper() {

	}
}
