#!/bin/bash
# 根据环境变量生成db.properties
cat > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/db.properties <<EOF
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://${DB_HOST:-localhost}:${DB_PORT:-3306}/agri_shop?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useSSL=false
db.username=${DB_USER:-root}
db.password=${DB_PASS:-root123}
EOF

catalina.sh run
