package com.agrishop.common;

import com.agrishop.dao.OperationLogDao;
import com.agrishop.entity.OperationLog;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Aspect
@Component
public class OperationLogAspect {

    @Autowired
    private OperationLogDao operationLogDao;

    @Around("@annotation(com.agrishop.common.Log)")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        Object result = point.proceed();
        try {
            MethodSignature sig = (MethodSignature) point.getSignature();
            Log logAnno = sig.getMethod().getAnnotation(Log.class);
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest req = attrs.getRequest();
                OperationLog log = new OperationLog();
                String username = (String) req.getAttribute("username");
                log.setOperator(username != null ? username : "anonymous");
                log.setModule(logAnno.module());
                log.setAction(logAnno.action());
                log.setDetail(sig.getDeclaringTypeName() + "." + sig.getName());
                log.setIp(getIp(req));
                operationLogDao.insert(log);
            }
        } catch (Exception e) {
            // 日志记录失败不影响业务
        }
        return result;
    }

    private String getIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        return ip;
    }
}
