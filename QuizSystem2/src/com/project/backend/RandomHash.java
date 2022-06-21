package com.project.backend;

import java.math.BigInteger;

public class RandomHash {
	private static String sha512(String text) {
		return Hash.generate(text, Hash.SHA_512);
	}

	public static String generate(String key1, String key2, String salt) {
		String hashedKey1 = sha512(key1);
		String hashedKey2 = sha512(key2);
		String hashedSalt = sha512(salt);
		String hashText = sha512(hashedKey1 + hashedKey2 + hashedSalt);
		String iterCountStr = hashText.substring(0, 4);
		BigInteger iterCount = new BigInteger(iterCountStr, 16);

		for (BigInteger i = new BigInteger("0"); i.compareTo(iterCount) == -1; i = i.add(new BigInteger("1"))) {
			String temp = hashedKey1;
			hashedKey1 = hashedKey2;
			hashedKey2 = hashedSalt;
			hashedSalt = hashText;
			hashText = temp;
			hashText = sha512(hashedKey1 + hashedKey2 + hashedSalt + hashText);
		}

		return hashText;
	}
}
