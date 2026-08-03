package com.dhakcare.utils;

import java.security.SecureRandom;

public class RandomPassWordUtil {
    
    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    
    public static String generateRandomPassword(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(length);
        
        for (int i = 0; i < length; i++) {
            
            int randomIndex = random.nextInt(CHARACTERS.length());
            
            password.append(CHARACTERS.charAt(randomIndex));
        }
        
        return password.toString();
    }
}