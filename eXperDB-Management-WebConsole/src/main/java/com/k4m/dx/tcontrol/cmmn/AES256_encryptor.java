package com.k4m.dx.tcontrol.cmmn;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

import com.k4m.dx.tcontrol.cmmn.crypto.Rfc2898DeriveBytes;
 
/*
Copyright 회사명 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
 
public class AES256_encryptor {
    private String iv;
    private Key keySpec;
    private int AES_KEY_SIZE = 16;
    
    public AES256_encryptor(Rfc2898DeriveBytes key, String iv) throws UnsupportedEncodingException, NoSuchAlgorithmException {
    	
    	//SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
    	//Key secretKey = factory.generateSecret(key.salt);
       // this.iv = key.substring(0, 16);
    	this.iv = iv;
/*        byte[] keyBytes = new byte[16];
        byte[] b = key.getBytes(AES_KEY_SIZE);
        int len = b.length;
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }
        System.arraycopy(b, 0, keyBytes, 0, len);*/
        SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(AES_KEY_SIZE), "AES");
        
        this.keySpec = keySpec;

    }
    
 
    // 암호화
    public String aesEncode(String str) throws java.io.UnsupportedEncodingException, 
                                                    NoSuchAlgorithmException, 
                                                    NoSuchPaddingException, 
                                                    InvalidKeyException, 
                                                    InvalidAlgorithmParameterException, 
                                                    IllegalBlockSizeException, 
                                                    BadPaddingException {
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes()));
 
        byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
        String enStr = new String(Base64.encodeBase64(encrypted));
 
        return enStr;
    }
 
    //복호화
	public String aesDecode(String str) throws NoSuchAlgorithmException,
                                                        NoSuchPaddingException, 
                                                        InvalidKeyException, 
                                                        InvalidAlgorithmParameterException,
                                                        IllegalBlockSizeException, 
                                                        BadPaddingException, IOException {
    	byte[] byteIv = Base64.decodeBase64(iv);
    	//sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
		//byte[] byteIv = decoder.decodeBuffer(iv);
		//
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        //c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
        c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(byteIv));
        
        byte[] byteStr = Base64.decodeBase64(str.getBytes());
 
        return new String(c.doFinal(byteStr),"UTF-8");
    }
 
}


