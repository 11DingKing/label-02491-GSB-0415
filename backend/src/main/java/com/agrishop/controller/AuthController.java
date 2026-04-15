package com.agrishop.controller;

import com.agrishop.common.Log;
import com.agrishop.common.Result;
import com.agrishop.dto.LoginDTO;
import com.agrishop.dto.RegisterDTO;
import com.agrishop.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    @Log(module = "用户认证", action = "用户登录")
    public Result<?> login(@Valid @RequestBody LoginDTO dto) {
        return Result.ok(authService.login(dto.getUsername(), dto.getPassword()));
    }

    @PostMapping("/admin/login")
    @Log(module = "用户认证", action = "管理员登录")
    public Result<?> adminLogin(@Valid @RequestBody LoginDTO dto) {
        return Result.ok(authService.adminLogin(dto.getUsername(), dto.getPassword()));
    }

    @PostMapping("/register")
    @Log(module = "用户认证", action = "用户注册")
    public Result<?> register(@Valid @RequestBody RegisterDTO dto) {
        authService.register(dto.getUsername(), dto.getPassword(),
                dto.getNickname(), dto.getPhone(), dto.getEmail());
        return Result.ok();
    }

    @GetMapping("/info")
    public Result<?> info(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        String role = (String) request.getAttribute("role");
        return Result.ok(authService.getInfo(userId, role));
    }
}
