package com.agrishop.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

/**
 * 应用启动初始化器（初始数据已在 schema.sql 中以 BCrypt 存储，无需额外处理）
 */
@Component
public class DataInitializer implements InitializingBean {
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Override
    public void afterPropertiesSet() {
        log.info("应用启动完成，初始数据已就绪");
    }
}
