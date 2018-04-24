package com.k4m.dx.tcontrol.cmmn.serviceproxy.vo;

import com.google.gson.annotations.Expose;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;

/**
* CryptoKey
* 
* 
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

public class CryptoKey extends Resource {

	@Expose
	private String	keyUid;

	@Expose
	private String	keyTypeCode;

	@Expose
	private String	keyTypeName;

	@Expose
	private String	keyStatusCode;

	@Expose
	private String	keyStatusName;

	@Expose
	private String	cipherAlgorithmCode;

	@Expose
	private String	cipherAlgorithmName;

	private boolean	renew;

	private boolean	copyBin;

	@Expose
	private int		cryptoKeyUsedCount;

	public static CryptoKey fromString(String jsonString) {
		return fromString(jsonString, CryptoKey.class);
	}

	public String getKeyUid() {
		return keyUid;
	}

	public void setKeyUid(String keyUid) {
		this.keyUid = keyUid;
	}

	public String getKeyTypeCode() {
		return keyTypeCode;
	}

	public void setKeyTypeCode(String keyTypeCode) {
		this.keyTypeCode = keyTypeCode;
	}

	public String getKeyTypeName() {
		return keyTypeName;
	}

	public void setKeyTypeName(String keyTypeName) {
		this.keyTypeName = keyTypeName;
	}

	public String getKeyStatusCode() {
		return keyStatusCode;
	}

	public void setKeyStatusCode(String keyStatusCode) {
		this.keyStatusCode = keyStatusCode;
	}

	public String getResourceStatusCodeFromKeyStatusCode() {
		if (SystemCode.KeyStatusCode.ACTIVE.equals(getKeyStatusCode())) {
			return SystemCode.ResourceStatusCode.ACTIVE;
		} else if (SystemCode.KeyStatusCode.DEACTIVE.equals(getKeyStatusCode())) {
			return SystemCode.ResourceStatusCode.DEACTIVE;
		} else if (SystemCode.KeyStatusCode.DESTROYED.equals(getKeyStatusCode())
				|| SystemCode.KeyStatusCode.DESTROYED_COMPROMISED.equals(getKeyStatusCode())) {
			return SystemCode.ResourceStatusCode.DESTROYED;
		} else if (SystemCode.KeyStatusCode.PREACTIVE.equals(getKeyStatusCode())) {
			return SystemCode.ResourceStatusCode.PREACTIVE;
		} else {
			return getResourceStatusCode();
		}
	}

	public String getKeyStatusName() {
		return keyStatusName;
	}

	public void setKeyStatusName(String keyStatusName) {
		this.keyStatusName = keyStatusName;
	}

	public String getCipherAlgorithmCode() {
		return cipherAlgorithmCode;
	}

	public void setCipherAlgorithmCode(String cipherAlgorithmCode) {
		this.cipherAlgorithmCode = cipherAlgorithmCode;
	}

	public String getCipherAlgorithmName() {
		return cipherAlgorithmName;
	}

	public void setCipherAlgorithmName(String cipherAlgorithmName) {
		this.cipherAlgorithmName = cipherAlgorithmName;
	}

	public boolean isRenew() {
		return renew;
	}

	public void setRenew(boolean renew) {
		this.renew = renew;
	}

	public boolean isCopyBin() {
		return copyBin;
	}

	public void setCopyBin(boolean copyBin) {
		this.copyBin = copyBin;
	}

	public int getCryptoKeyUsedCount() {
		return cryptoKeyUsedCount;
	}

	public void setCryptoKeyUsedCount(int cryptoKeyUsedCount) {
		this.cryptoKeyUsedCount = cryptoKeyUsedCount;
	}
}
