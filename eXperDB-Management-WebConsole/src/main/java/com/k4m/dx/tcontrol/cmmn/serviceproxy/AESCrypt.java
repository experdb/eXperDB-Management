package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.k4m.dx.tcontrol.cmmn.crypto.Rfc2898DeriveBytes;

public class AESCrypt {
	private final Cipher cipher;
	private final SecretKeySpec key;
	private String encryptedText, decryptedText;

	public AESCrypt(String password, byte[] keyBytes) throws Exception {
		// hash password with SHA-256 and crop the output to 128-bit for key
		//MessageDigest digest = MessageDigest.getInstance("SHA-256");
		//digest.update(password.getBytes("UTF-8"));
		//byte[] keyBytes = new byte[16];
		//System.arraycopy(digest.digest(), 0, keyBytes, 0, keyBytes.length);

		cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		key = new SecretKeySpec(keyBytes, "AES");
	}

	public byte[] encrypt(String plainText) throws Exception {
		byte[] iv = new byte[cipher.getBlockSize()];
		AlgorithmParameterSpec spec = new IvParameterSpec(iv);
		cipher.init(Cipher.ENCRYPT_MODE, key, spec);
		return cipher.doFinal(plainText.getBytes());
	}

	public String decrypt(byte[] cryptedText, byte[] iv) throws Exception {
		//byte[] iv = new byte[cipher.getBlockSize()];
		AlgorithmParameterSpec spec = new IvParameterSpec(iv);
		cipher.init(Cipher.DECRYPT_MODE, key, spec);
		// decrypt the message
		byte[] decrypted = cipher.doFinal(cryptedText);
		decryptedText = Base64.encodeBase64String(decrypted);
		
		//decryptedText = Base64.decodeBase64(decrypted);
		//decryptedText = new String(decrypted, "UTF-8");
		return decryptedText;
	}

	public static String asHex(byte buf[]) {
		StringBuilder strbuf = new StringBuilder(buf.length * 2);
		int i;
		for (i = 0; i < buf.length; i++) {
			if (((int) buf[i] & 0xff) < 0x10) {
				strbuf.append("0");
			}
			strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
		}
		return strbuf.toString();
	}

	public static void main(String[] args) throws Exception {

		int myIteration = 200000;
		int AES_KEY_SIZE = 16;
		int MASTER_KEY_SIZE = 32;
				
				
				
		String loadStr = "{\"mas\":\"uMbslqhNKDQrvs/RcPluZcenWtOrYLmZ8Wc+6Zs4xk1npKFX50HgPvlKSi9+CPIP\",\"ter\":\"kWlRZF2SkyTRXDL7eqDdIQ==\",\"key\":\"UW0IxVLs9S7e1vFdIWSTcpXwU4EuZvHmegHYZv59dpg=\"}";
		
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(loadStr);
		
		//Rfc2898DeriveBytes key = new Rfc2898DeriveBytes("password", Base64.encodeBase64(json.get("key")))
		
		String masterStrEnc = json.get("mas").toString();
		String iv = json.get("ter").toString();
		String salt = json.get("key").toString();
		
		byte[] byteIv = Base64.decodeBase64(iv);
		//byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);
		
		String password = "1234qwer";

		
		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, Base64.decodeBase64(salt), myIteration);
		//key.getBytes(AES_KEY_SIZE);

		byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);
		//byte[] bySalt = Base64.decodeBase64(salt.getBytes());
		AESCrypt aes = new AESCrypt(password, key.getBytes(AES_KEY_SIZE));
		
		//byte[] strEnc = aes.encrypt(strTxt);
		//String decryptedText = aes.decrypt(strEnc).toString(); 
		//System.out.println(strEnc);
		
		String decryptedText = aes.decrypt(byMasterStrEnc, byteIv).toString(); 
		System.out.println(decryptedText);
	}
	

}