package com.project.backend;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Hash {
	public static final String SHA_224 = "SHA-224";
	public static final String SHA_256 = "SHA-256";
	public static final String SHA_384 = "SHA-384";
	public static final String SHA_512 = "SHA-512";

	public static String generate(String text, String algorithm) {
		try {
			MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
			byte[] hashBytes = messageDigest.digest(text.getBytes());
			StringBuilder hashText = new StringBuilder();

			for (byte b : hashBytes) {
				hashText.append(String.format("%02x", b));
			}

			return hashText.toString();
		} catch (NoSuchAlgorithmException e) {
			System.out.println("Hash: There is an error: " + e.toString());
		}

		return null;
	}
}
