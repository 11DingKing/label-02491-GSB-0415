package com.agrishop.service;

import com.agrishop.common.BizException;
import com.agrishop.config.JwtUtil;
import com.agrishop.dao.AdminDao;
import com.agrishop.dao.UserDao;
import com.agrishop.entity.Admin;
import com.agrishop.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AuthService {

    @Autowired
    private UserDao userDao;
    @Autowired
    private AdminDao adminDao;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JwtUtil jwtUtil;

    public Map<String, Object> login(String username, String password) {
        User user = userDao.selectByUsername(username);
        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            throw new BizException("用户名或密码错误");
        }
        if (user.getStatus() != 1) {
            throw new BizException("账号已被禁用");
        }
        String token = jwtUtil.generate(user.getId(), user.getUsername(), "user");
        Map<String, Object> map = new HashMap<>();
        map.put("token", token);
        map.put("user", sanitizeUser(user));
        return map;
    }

    public Map<String, Object> adminLogin(String username, String password) {
        Admin admin = adminDao.selectByUsername(username);
        if (admin == null || !passwordEncoder.matches(password, admin.getPassword())) {
            throw new BizException("用户名或密码错误");
        }
        if (admin.getStatus() == null || admin.getStatus() != 1) {
            throw new BizException("账号已被禁用");
        }
        String token = jwtUtil.generate(admin.getId(), admin.getUsername(), "admin");
        Map<String, Object> map = new HashMap<>();
        map.put("token", token);
        admin.setPassword(null);
        map.put("user", admin);
        return map;
    }

    public void register(String username, String password, String nickname, String phone, String email) {
        if (userDao.selectByUsername(username) != null) {
            throw new BizException("用户名已存在");
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setNickname(nickname == null ? username : nickname);
        user.setPhone(phone);
        user.setEmail(email);
        userDao.insert(user);
    }

    public Object getInfo(Long userId, String role) {
        if ("admin".equals(role)) {
            Admin admin = adminDao.selectById(userId);
            if (admin != null) admin.setPassword(null);
            return admin;
        }
        User user = userDao.selectById(userId);
        return sanitizeUser(user);
    }

    private User sanitizeUser(User user) {
        if (user != null) user.setPassword(null);
        return user;
    }
}
