package com.k4m.dx.tcontrol.cmmn.crypto;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.BitSet;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import com.k4m.dx.tcontrol.cmmn.serviceproxy.SystemCode;

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
public class KeyDeriver {
	//private static final String	algoPrf				= "HmacSHA256";

	//private static final int	prfOutputBitLength	= 256;

	//private static final int	prfOutputByteLength	= prfOutputBitLength / 8;

	//private static final String	stringEncode	= "utf-8";

	//	public static byte[] deriveServerKey(String password, String bootstrapKey, String databaseKey){
	//		String mergedKey = mergeKey(password, bootstrapKey, databaseKey);
	//		pbkdf2(mergedKey, Generator.generateRandomBits(bitLength), 0, SystemCode.Default.DEFAULT_KEY_BIT_LENGTH/Byte.SIZE)
	//	}

	/**
	 * Desc : KDF in Counter Mode defined in NIST SP 800-108 using Pseudorandom Function (Hmac)
	 * @Method Name : derive
	 * @param masterKey
	 * @param purpose
	 * @param context
	 * @param keyBitLength
	 * @return
	 * @throws InvalidKeyException
	 */
	public static byte[] derive(byte[] masterKey, String purpose, String context, int keyBitLength)
			throws InvalidKeyException {
		byte[] derivedKey = null;
		Mac prf = null;

		int n = keyBitLength / SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH
				+ (keyBitLength % SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH != 0 ? 1 : 0);

		int i = 1;
		if (n > Math.pow(2, Integer.SIZE) - 1) { return null; }

		Key mk = new SecretKeySpec(masterKey, SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);

		try {
			prf = Mac.getInstance(SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);
			prf.init(mk);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}

		byte[] output = new byte[SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH * n];
		byte[] prfOutput = new byte[SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH];
		// String input = null;
		byte[] fixedInputB = null;
		try {
			fixedInputB = (purpose + Byte.toString((byte) 0x00) + context + Integer.toBinaryString(keyBitLength))
					.getBytes(SystemCode.Default.DEFAULT_CHARACTER_SET);
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return null;
		}
		byte[] inputB = new byte[fixedInputB.length + 4];

		System.arraycopy(fixedInputB, 0, inputB, 4, fixedInputB.length);
		for (i = 1; i <= n; i++) {
			// input = Integer.toBinaryString(i) + purpose +
			// Byte.toString((byte) 0x00) + context
			// + Integer.toBinaryString(keyBitLength);

			inputB[0] = (byte) (i >> 24 & 0xff);
			inputB[1] = (byte) (i >> 16 & 0xff);
			inputB[2] = (byte) (i >> 8 & 0xff);
			inputB[3] = (byte) (i >> 0 & 0xff);

			try {
				prfOutput = prf.doFinal(inputB);
				System.arraycopy(prfOutput, 0, output, SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH * (i - 1),
						SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH);
			} catch (IllegalStateException e) {

				e.printStackTrace();
				return null;
			}
		}

		int byteLength = keyBitLength / 8;
		derivedKey = new byte[byteLength];
		System.arraycopy(output, 0, derivedKey, 0, byteLength);
		return derivedKey;
	}

	/**
	 * Desc : Password based KDF defined in NIST SP 800-132 using Pseudorandom Function (Hmac)
	 * @Method Name : derive
	 * @param password
	 * @param salt
	 * @param count
	 * @param keyBitLength
	 * @return
	 * @throws InvalidKeyException
	 */
	public static byte[] derive(String password, byte[] salt, int count, int keyBitLength) throws InvalidKeyException {
		byte[] derivedKey = null;
		Mac prf = null;

		int n = keyBitLength / SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH
				+ (keyBitLength % SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BIT_LENGTH != 0 ? 1 : 0);

		int i = 1;
		if (n > Math.pow(2, Integer.SIZE) - 1) { return null; }

		Key mk = new SecretKeySpec(password.getBytes(), SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);

		try {
			prf = Mac.getInstance(SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);
			prf.init(mk);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}

		byte[] output = new byte[SystemCode.Default.DEFAULT_PSUEDO_RANDOM_OUTPUT_BYTE_LENGTH * n];

		BitSet ui = null;
		BitSet ti = null;
		int intByteSize = Integer.SIZE / Byte.SIZE;
		byte[] t = null;

		int sByteSize = salt.length;
		byte[] u0 = new byte[salt.length + intByteSize];

		System.arraycopy(salt, 0, u0, 0, salt.length);

		for (i = 1; i <= n; i++) {
			ti = new BitSet();
			System.arraycopy(Converter.toBytes(i), 0, u0, sByteSize, intByteSize);
			ui = Converter.toBitSet(u0);
			//ui = BitSet.valueOf(u0);
			for (int j = 1; j <= count; j++) {
				//ui = BitSet.valueOf(prf.doFinal(ui.toByteArray()));
				ui = Converter.toBitSet(prf.doFinal(Converter.toBytes(ui)));
				ti.xor(ui);
			}
			//t = ti.toByteArray();
			t = Converter.toBytes(ti);
			System.arraycopy(t, 0, output, t.length * (i - 1), t.length);
		}

		derivedKey = new byte[(keyBitLength + Byte.SIZE - 1) / Byte.SIZE];
		System.arraycopy(output, 0, derivedKey, 0, derivedKey.length);

		// System.out.println("derivedKey len:" + derivedKey.length);
		return derivedKey;
	}

	/**
	 * Implementation of PBKDF2 (RFC2898).
	 * 
	 * @param mac Pre-initialized {@link Mac} instance to use.
	 * @param salt Salt.
	 * @param count Iteration count.
	 * @param DK Byte array that derived key will be placed in.
	 * @param dkByteLength Intended length, in octets, of the derived key.
	 * 
	 * @throws GeneralSecurityException
	 */
	private static byte[] pbkdf2(Mac mac, byte[] salt, int count, int dkByteLength) throws GeneralSecurityException {
		int hByteLength = mac.getMacLength();

		if (dkByteLength > (Math.pow(2, 32) - 1) * hByteLength) { throw new GeneralSecurityException("Requested key length too long"); }

		byte[] U = new byte[hByteLength];
		byte[] T = new byte[hByteLength];
		byte[] block1 = new byte[salt.length + 4];

		int l = (int) Math.ceil((double) dkByteLength / hByteLength);
		int r = dkByteLength - (l - 1) * hByteLength;

		System.arraycopy(salt, 0, block1, 0, salt.length);

		byte[] DK = new byte[dkByteLength];

		for (int i = 1; i <= l; i++) {
			block1[salt.length + 0] = (byte) (i >> 24 & 0xff);
			block1[salt.length + 1] = (byte) (i >> 16 & 0xff);
			block1[salt.length + 2] = (byte) (i >> 8 & 0xff);
			block1[salt.length + 3] = (byte) (i >> 0 & 0xff);

			mac.update(block1);
			mac.doFinal(U, 0);
			System.arraycopy(U, 0, T, 0, hByteLength);

			for (int j = 1; j < count; j++) {
				mac.update(U);
				mac.doFinal(U, 0);

				for (int k = 0; k < hByteLength; k++) {
					T[k] ^= U[k];
				}
			}

			System.arraycopy(T, 0, DK, (i - 1) * hByteLength, i == l ? r : hByteLength);
		}

		return DK;

	}

	/**
	 * Implementation of PBKDF2 (RFC2898).
	 * 
	 * @param alg HMAC algorithm to use.
	 * @param password Password.
	 * @param salt Salt.
	 * @param count Iteration count.
	 * @param dkByteLength Intended length, in octets, of the derived key.
	 * 
	 * @return The derived key.
	 * 
	 * @throws GeneralSecurityException
	 */
	public static byte[] pbkdf2(String password, byte[] salt, int count, int dkByteLength)
			throws GeneralSecurityException {
		Mac mac = Mac.getInstance(SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION);
		try {
			mac.init(new SecretKeySpec(password.getBytes(SystemCode.Default.DEFAULT_CHARACTER_SET), SystemCode.Default.DEFAULT_PSUEDO_RANDOM_FUNCTION));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}

		return pbkdf2(mac, salt, count, dkByteLength);
	}

	private KeyDeriver() {
	}
}
