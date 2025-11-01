package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for password hashing and verification
 * Uses SHA-256 with salt for password security
 */
public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16; // 16 bytes salt
    
    /**
     * Hash a password with a randomly generated salt
     * @param password Plain text password
     * @return Hashed password with salt in format: salt$hash
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash password with salt
            String hash = hashWithSalt(password, salt);
            
            // Combine salt and hash: salt$hash
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            return saltBase64 + "$" + hash;
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verify if a plain text password matches the stored hash
     * @param plainPassword Plain text password to verify
     * @param storedHash Stored hash in format: salt$hash
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) {
            return false;
        }
        
        try {
            // Split salt and hash
            String[] parts = storedHash.split("\\$");
            if (parts.length != 2) {
                // Old format without salt - support backward compatibility
                // Try direct hash comparison for existing plain text passwords
                return storedHash.equals(plainPassword) || 
                       hashPassword(plainPassword).split("\\$")[1].equals(storedHash);
            }
            
            String saltBase64 = parts[0];
            String storedHashValue = parts[1];
            
            // Decode salt
            byte[] salt = Base64.getDecoder().decode(saltBase64);
            
            // Hash the plain password with the same salt
            String computedHash = hashWithSalt(plainPassword, salt);
            
            // Compare hashes
            return computedHash.equals(storedHashValue);
            
        } catch (Exception e) {
            // If any error occurs, return false
            return false;
        }
    }
    
    /**
     * Hash password with provided salt
     * @param password Plain text password
     * @param salt Salt bytes
     * @return Base64 encoded hash
     */
    private static String hashWithSalt(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);
        
        // Add salt to password
        md.update(salt);
        
        // Hash password
        byte[] hashBytes = md.digest(password.getBytes());
        
        // Convert to Base64 string
        return Base64.getEncoder().encodeToString(hashBytes);
    }
    
    /**
     * Check if a stored hash is in the new format (with salt)
     * @param storedHash Stored hash to check
     * @return true if hash is in new format (contains $), false otherwise
     */
    public static boolean isHashed(String storedHash) {
        if (storedHash == null || storedHash.isEmpty()) {
            return false;
        }
        return storedHash.contains("$");
    }
}

