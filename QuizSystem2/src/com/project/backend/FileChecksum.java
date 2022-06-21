package com.project.backend;

import java.io.FileInputStream;
import java.io.IOException;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class FileChecksum {
	public static final String SHA_224 = "SHA-224";
	public static final String SHA_256 = "SHA-256";
	public static final String SHA_384 = "SHA-384";
	public static final String SHA_512 = "SHA-512";

	public static String checksum(String filePath, String algorithm) {
		// file hashing with DigestInputStream

		try {
			MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
			DigestInputStream digestInputStream = new DigestInputStream(new FileInputStream(filePath), messageDigest);
			while (digestInputStream.read() != -1)
				; // empty loop to clear the data
			messageDigest = digestInputStream.getMessageDigest();
			digestInputStream.close();
			byte[] hashBytes = messageDigest.digest();

			// convert bytes to hex string
			StringBuilder hashText = new StringBuilder();

			for (byte b : hashBytes) {
				hashText.append(String.format("%02x", b));
			}

			return hashText.toString();
		} catch (NoSuchAlgorithmException e) {
			System.out.println("FileChecksum: There is an error: " + e.toString());
		} catch (IOException e) {
			System.out.println("FileChecksum: There is an error: " + e.toString());
		}

		return null;
	}
}
