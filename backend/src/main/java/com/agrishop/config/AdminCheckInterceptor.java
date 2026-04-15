package com.agrishop.config;

import com.agrishop.common.RequireAdmin;
import com.agrishop.common.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 管理员权限拦截器：检查 @RequireAdmin 注解，非 admin 角色返回 403
 */
public class AdminCheckInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (!(handler instanceof HandlerMethod handlerMethod)) {
            return true;
        }
        boolean classLevel = handlerMethod.getBeanType().isAnnotationPresent(RequireAdmin.class);
        boolean methodLevel = handlerMethod.hasMethodAnnotation(RequireAdmin.class);
        if (!classLevel && !methodLevel) {
            return true;
        }
        String role = (String) request.getAttribute("role");
        if ("admin".equals(role)) {
            return true;
        }
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(200);
        new ObjectMapper().writeValue(response.getWriter(), Result.fail(403, "无权限，仅管理员可操作"));
        return false;
    }
}
