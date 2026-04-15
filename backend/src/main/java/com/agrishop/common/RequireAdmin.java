package com.agrishop.common;

import java.lang.annotation.*;

/**
 * 标注在 Controller 类或方法上，表示该接口仅限管理员角色访问
 */
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RequireAdmin {
}
