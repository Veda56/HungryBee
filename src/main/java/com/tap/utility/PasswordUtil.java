package com.tap.utility;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for password hashing using SHA-256.
 * Passwords are stored as hex-encoded SHA-256 hashes — never in plain text.
 */
public class PasswordUtil {

    private PasswordUtil() {
        // Utility class — prevent instantiation
    }

    /**
     * Hashes a plain-text password using SHA-256 and returns the hex string.
     *
     * @param plainPassword the raw password from the user
     * @return 64-character hex-encoded SHA-256 hash
     * @throws RuntimeException if SHA-256 algorithm is not available
     */
    public static String hashPassword(String plainPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(plainPassword.getBytes("UTF-8"));

            // Convert byte array to hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        } catch (java.io.UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 encoding not supported", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored SHA-256 hash.
     *
     * @param plainPassword  the raw password entered by the user
     * @param hashedPassword the SHA-256 hash stored in the database
     * @return true if the passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        String hashOfInput = hashPassword(plainPassword);
        return hashOfInput.equals(hashedPassword);
    }
}
