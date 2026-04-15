package com.agrishop.common;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;
import java.util.UUID;

/**
 * 通用工具类 - 提供BCrypt密码加密验证、MD5加密、验证码生成、UUID生成等功能
 */
public class CommonUtil {

    private static final String CAPTCHA_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
    private static final BCryptPasswordEncoder BCRYPT = new BCryptPasswordEncoder();

    /**
     * MD5加密（用于非密码场景的摘要计算）
     */
    public static String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5算法不可用", e);
        }
    }

    /**
     * 生成随机验证码
     */
    public static String generateCaptcha(int length) {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(CAPTCHA_CHARS.charAt(random.nextInt(CAPTCHA_CHARS.length())));
        }
        return sb.toString();
    }

    /**
     * 生成UUID（去除横线）
     */
    public static String generateUUID() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 密码加密（BCrypt，自动生成随机盐值）
     */
    public static String encodePassword(String rawPassword) {
        return BCRYPT.encode(rawPassword);
    }

    /**
     * 密码验证（BCrypt）
     */
    public static boolean matchPassword(String rawPassword, String encodedPassword) {
        return BCRYPT.matches(rawPassword, encodedPassword);
    }
}
