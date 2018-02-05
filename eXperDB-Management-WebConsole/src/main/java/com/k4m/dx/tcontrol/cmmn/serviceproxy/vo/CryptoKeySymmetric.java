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
package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.crypto.Converter;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.TypeUtility;


/**
 * @brief
 * 
 *        TODO add description
 * @date 2015. 1. 11.
 * @author Kim, Sunho
 */

public class CryptoKeySymmetric extends CryptoKey {

	@Expose
	private String	binUid;

	@Expose
	private String	binName;

	@Expose
	private long	keySequence;

	@Expose
	private int		keySize;

	private String	keyBinary;						//Not Exposed

	private String	ivBinary;						//Not Exposed

	@Expose
	private String	validStartDateTime;

	@Expose
	private String	validStartDate;

	@Expose
	private String	validEndDateTime;

	@Expose
	private String	validEndDate;

	@Expose
	private String	binStatusCode;

	@Expose
	private String	binStatusName;

	@Expose
	private long	binVersion;

	@Expose
	private int		cryptoKeySymmetricUsedCount;

	public String getBinUid() {
		return binUid;
	}

	public void setBinUid(String binUid) {
		this.binUid = binUid;
	}

	public String getBinName() {
		return binName;
	}

	public void setBinName(String binName) {
		this.binName = binName;
	}

	public static CryptoKeySymmetric fromString(String jsonString) {
		return fromString(jsonString, CryptoKeySymmetric.class);
	}

	public int getKeySize() {
		return keySize;
	}

	public void setKeySize(int keySize) {
		this.keySize = keySize;
	}

	public String getKeyBinary() {
		return keyBinary;
	}

	public void setKeyBinary(String keyBinary) {
		this.keyBinary = keyBinary;
	}

	public void setKeyBinary(byte[] keyBytes) {
		this.keyBinary = Converter.bytesToBase64(keyBytes);
	}

	public String getIvBinary() {
		return ivBinary;
	}

	public void setIvBinary(String ivBinary) {
		this.ivBinary = ivBinary;
	}

	public void setIvBinary(byte[] ivBytes) {
		this.ivBinary = Converter.bytesToBase64(ivBytes);
	}

	public String getValidStartDateTime() {
		return validStartDateTime;
	}

	public void setValidStartDateTime(String validStartDateTime) {
		this.validStartDateTime = validStartDateTime;
	}

	public String getValidEndDateTime() {
		return validEndDateTime;
	}

	public void setValidEndDateTime(String validEndDateTime) {
		this.validEndDateTime = validEndDateTime;
	}

	public String getValidStartDate() {
		return validStartDate;
	}

	public void setValidStartDate(String validStartDate) {
		this.validStartDate = validStartDate;
	}

	public String getValidEndDate() {
		return validEndDate;
	}

	public void setValidEndDate(String validEndDate) {
		this.validEndDate = validEndDate;
	}

	public String getBinStatusCode() {
		return binStatusCode;
	}

	public void setBinStatusCode(String binStatusCode) {
		this.binStatusCode = binStatusCode;
	}

	public String getBinStatusName() {
		return binStatusName;
	}

	public void setBinStatusName(String binStatusName) {
		this.binStatusName = binStatusName;
	}

	public long getKeySequence() {
		return keySequence;
	}

	public void setKeySequence(long keySequence) {
		this.keySequence = keySequence;
	}

	public long getBinVersion() {
		return binVersion;
	}

	public void setBinVersion(long binVersion) {
		this.binVersion = binVersion;
	}

	public int getCryptoKeySymmetricUsedCount() {
		return cryptoKeySymmetricUsedCount;
	}

	public void setCryptoKeySymmetricUsedCount(int cryptoKeySymmetricUsedCount) {
		this.cryptoKeySymmetricUsedCount = cryptoKeySymmetricUsedCount;
	}

	public int getKeyByteSizeFromCipherAlgorithmCode() {
		int retval = 0;
		if (TypeUtility.contains(getCipherAlgorithmCode(), new String[] {
				SystemCode.CipherAlgorithmCode.AES_128,
				SystemCode.CipherAlgorithmCode.ARIA_128,
				SystemCode.CipherAlgorithmCode.SEED_128
		})) {
			retval = 16;
		} else if (TypeUtility.contains(getCipherAlgorithmCode(), new String[] {
				SystemCode.CipherAlgorithmCode.AES_192,
				SystemCode.CipherAlgorithmCode.ARIA_192
		})) {
			retval = 24;
		} else if (TypeUtility.contains(getCipherAlgorithmCode(), new String[] {
				SystemCode.CipherAlgorithmCode.AES_256,
				SystemCode.CipherAlgorithmCode.ARIA_256,
				SystemCode.CipherAlgorithmCode.SEED_256,
				SystemCode.CipherAlgorithmCode.LPE_NUM
		})) {
			retval = 32;
		} else if (TypeUtility.contains(getCipherAlgorithmCode(), new String[] {
				SystemCode.CipherAlgorithmCode.TDES
		})) {
			retval = 21;
		}
		return retval;
	}
}
