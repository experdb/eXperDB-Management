package com.k4m.dx.tcontrol.cmmn.serviceproxy;

import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.k4m.dx.tcontrol.cmmn.crypto.Converter;
import com.k4m.dx.tcontrol.cmmn.crypto.Encrypter;
import com.k4m.dx.tcontrol.cmmn.crypto.Rfc2898DeriveBytes;
import com.k4m.dx.tcontrol.cmmn.serviceproxy.vo.MasterKeyFile;


/**
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
public class AESCrypt {

	public AESCrypt() throws Exception {}

	public byte[] encrypt(String password, Rfc2898DeriveBytes key, AlgorithmParameterSpec spec) throws Exception {
		int AES_KEY_SIZE = 16;

		SecretKey secureKey = new SecretKeySpec(key.getBytes(AES_KEY_SIZE), "AES");
		
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, secureKey, spec);

		return cipher.doFinal(key.getSalt());
	}

	public String decrypt(byte[] cryptedText, byte[] iv, byte[] byteKey) throws Exception {
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		SecretKeySpec key = new SecretKeySpec(byteKey, "AES");

		AlgorithmParameterSpec spec = new IvParameterSpec(iv);
		cipher.init(Cipher.DECRYPT_MODE, key, spec);

		byte[] decrypted = cipher.doFinal(cryptedText);
		String decryptedText = Base64.encodeBase64String(decrypted);

		return decryptedText;
	}

	private static byte[] getRandomIvParameterSpec() {
		byte[] iv = new byte[16];
		new SecureRandom().nextBytes(iv);
		
		return iv;
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

	private static void encryptTest(String password) throws Exception {
		int AES_KEY_SIZE = 16;
		int MASTER_KEY_SIZE = 32;
		int myIteration = 200000;

		MasterKeyFile m = new MasterKeyFile();
		
		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, MASTER_KEY_SIZE, myIteration);
		
		//System.out.println("key : " + Base64.encodeBase64String(key.getSalt()));
		
		byte[] btSpecIV = getRandomIvParameterSpec();
				
		AlgorithmParameterSpec spec = new IvParameterSpec(btSpecIV);

		AESCrypt aes = new AESCrypt();

		byte[] btEncode = aes.encrypt(password, key, spec);
				

		//System.out.println("masterStr : " + Base64.encodeBase64String(btEncode));
	

		// Base64.encode(btEncode);

	}


	private static void decodeTest(String password) throws Exception {
		int myIteration = 200000;
		int AES_KEY_SIZE = 16;
		int MASTER_KEY_SIZE = 32;

		String loadStr = "{\"mas\":\"uMbslqhNKDQrvs/RcPluZcenWtOrYLmZ8Wc+6Zs4xk1npKFX50HgPvlKSi9+CPIP\",\"ter\":\"kWlRZF2SkyTRXDL7eqDdIQ==\",\"key\":\"UW0IxVLs9S7e1vFdIWSTcpXwU4EuZvHmegHYZv59dpg=\"}";

		//loadStr = "{\"mas\":\"GZg9MW2J1dlGgFAnuT45J7O4HMDjOpoAQxU+qtQtkCnE6T97yJGPlIndtfqUw+qA\",\"ter\":\"sXc23MW3SgVwAGDKqky3Hw==\",\"key\":\"bp1qqmZrRRreM/+60qZ5bSA/O/5ST9S9z4pYMNM/HBs=\"}";
		//loadStr = "{\"mas\":\"0FAA1aYQSg1v3UVjQB899wO0YuRSluWa/pCpAxNSQP/lGkeA04PRI3iGXRbQVkew\",\"ter\":\"Xn2fkw+MYu59LedBAEy39w==\",\"key\":\"U+b6GuSe3oY9X/W+WHs2Y4NQGlUTi9+iYYNd9oChFgI=\"}";
		//loadStr = "{\"mas\":\"xuZJVm6pJE3fl7ngM37Hp4Jv3xNXY0Gso+wmrlVk7lZ8zGi6pUUUsLUn3Tj6owrm\",\"ter\":\"yi+6/3VhSyFetuUDYl5low==\",\"key\":\"9fpKoj4UFqCzGMkbV/8K4AnWNggni3ULIisJx8AvLSE=\"}";
		loadStr = "{\"mas\":\"ScfypwlI+yt1j4XxuMPEKYeLj3BTLoEoBmy5vC3wWGl+M/a0/WK39s/8BudpUXNU\",\"ter\":\"5Os7QRcWTNBCprpra2/Xkg==\",\"key\":\"pQcdT8XmWoOIZQyELMR8A1nZ6jr72Kq/kD93799x1UE=\"}";
		
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(loadStr);

		String masterStrEnc = json.get("mas").toString();
		String iv = json.get("ter").toString();
		String salt = json.get("key").toString();
		byte[] byteIv = Base64.decodeBase64(iv);

		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, Base64.decodeBase64(salt), myIteration);
		byte[] byteKey = key.getBytes(AES_KEY_SIZE);

		byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);

		AESCrypt aes = new AESCrypt();

		String decryptedText = aes.decrypt(byMasterStrEnc, byteIv, byteKey).toString();
		System.out.println(decryptedText);
	}
	
	/**
	 * experDB-Encrypt Admin 키 복호화
	 * @param password
	 * @param loadStr
	 * @return
	 * @throws Exception
	 */
	public String GetMasterStr(String password, String loadStr) throws Exception {
		
		int myIteration = 200000;
		int AES_KEY_SIZE = 16;
		
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(loadStr);

		String masterStrEnc = json.get("mas").toString();
		String iv = json.get("ter").toString();
		String salt = json.get("key").toString();
		byte[] byteIv = Base64.decodeBase64(iv);

		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, Base64.decodeBase64(salt), myIteration);
		byte[] byteKey = key.getBytes(AES_KEY_SIZE);

		byte[] byMasterStrEnc = Base64.decodeBase64(masterStrEnc);

		AESCrypt aes = new AESCrypt();

		String decryptedText = aes.decrypt(byMasterStrEnc, byteIv, byteKey).toString();
		
		return decryptedText;
	}
	
	/**
	 * experDB-Encrypt Admin 키 암호화
	 * @param password
	 * @return
	 * @throws Exception
	 */
	public MasterKeyFile GenerateMasterStr(String password) throws Exception {
		int MASTER_KEY_SIZE = 32;
		int myIteration = 200000;
		
		MasterKeyFile m = new MasterKeyFile();
		
		Rfc2898DeriveBytes key = new Rfc2898DeriveBytes(password, MASTER_KEY_SIZE, myIteration);

		byte[] btSpecIV = getRandomIvParameterSpec();

		AlgorithmParameterSpec spec = new IvParameterSpec(btSpecIV);
		
		AESCrypt aes = new AESCrypt();
		byte[] btEncode = aes.encrypt(password, key, spec);
		
		m.setMas(Base64.encodeBase64String(btEncode));
		m.setTer(Base64.encodeBase64String(btSpecIV));
		m.setKey(Base64.encodeBase64String(key.getSalt()));

		System.out.println("mas : " + Base64.encodeBase64String(btEncode));
		System.out.println("ter : " + Base64.encodeBase64String(btSpecIV));
		System.out.println("key : " + Base64.encodeBase64String(key.getSalt()));
		
		return m;
	}


	public static void main(String[] args) throws Exception {
		AESCrypt aes = new AESCrypt();
		
		//암호화
		//aes.GenerateMasterStr("1234qwer");
		byte[] hmacBytes = Converter.base64ToBytes("LEmO3rril0yJn3761IxVPgAABI9QfE21gxFjC9+k7V1LilYsovQzcOA6PfQRs3hKgFaB9w==");
		
		if (!Arrays.equals(Arrays.copyOfRange(hmacBytes, 16 + Integer.SIZE / Byte.SIZE, hmacBytes.length),
				Encrypter.hmacToBytes("password", "password"))) { 
			
			System.out.println("111111");
		 } else {
			 System.out.println("222222222");
		 }
		
		
		System.out.println(Encrypter.hmacToBytes("pQcdT8XmWoOIZQyELMR8A1nZ6jr72Kq/kD93799x1UE=", "pQcdT8XmWoOIZQyELMR8A1nZ6jr72Kq/kD93799x1UE="));
		
		String loadStr = "{\"mas\":\"ScfypwlI+yt1j4XxuMPEKYeLj3BTLoEoBmy5vC3wWGl+M/a0/WK39s/8BudpUXNU\",\"ter\":\"5Os7QRcWTNBCprpra2/Xkg==\",\"key\":\"pQcdT8XmWoOIZQyELMR8A1nZ6jr72Kq/kD93799x1UE=\"}";
		//복호화
		String encText = aes.GetMasterStr("1234qwer", loadStr);
		System.out.println(encText);
	}
	
}