package com.agrishop.config;

import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.agrishop.common.Result;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT认证拦截器 - 检查Authorization头，验证JWT令牌
 */
public class JwtInterceptor implements HandlerInterceptor {

    private JwtUtil jwtUtil;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        // 延迟获取JwtUtil bean（避免Spring上下文初始化顺序问题）
        if (jwtUtil == null) {
            WebApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
            jwtUtil = ctx.getBean(JwtUtil.class);
        }
        String auth = request.getHeader("Authorization");
        if (auth == null || !auth.startsWith("Bearer ")) {
            writeError(response, 401, "未登录");
            return false;
        }
        try {
            Claims claims = jwtUtil.parse(auth.substring(7));
            request.setAttribute("userId", Long.parseLong(claims.getSubject()));
            request.setAttribute("username", claims.get("username", String.class));
            request.setAttribute("role", claims.get("role", String.class));
            return true;
        } catch (Exception e) {
            writeError(response, 401, "登录已过期");
            return false;
        }
    }

    private void writeError(HttpServletResponse response, int code, String msg) throws Exception {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(200);
        new ObjectMapper().writeValue(response.getWriter(), Result.fail(code, msg));
    }
}
