-- 农产品销售系统数据库初始化脚本
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
CREATE DATABASE IF NOT EXISTS agri_shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agri_shop;

-- 管理员表
CREATE TABLE IF NOT EXISTS `admin` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) DEFAULT '' COMMENT '昵称',
    `avatar` VARCHAR(255) DEFAULT '' COMMENT '头像',
    `status` TINYINT DEFAULT 1 COMMENT '状态 1启用 0禁用',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(50) DEFAULT '' COMMENT '昵称',
    `phone` VARCHAR(20) DEFAULT '' COMMENT '手机号',
    `email` VARCHAR(100) DEFAULT '' COMMENT '邮箱',
    `avatar` VARCHAR(255) DEFAULT '' COMMENT '头像',
    `status` TINYINT DEFAULT 1 COMMENT '状态 1启用 0禁用',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 商品分类表
CREATE TABLE IF NOT EXISTS `goods_type` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态 1启用 0禁用',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 商品表
CREATE TABLE IF NOT EXISTS `goods` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `type_id` BIGINT NOT NULL COMMENT '分类ID',
    `name` VARCHAR(100) NOT NULL COMMENT '商品名称',
    `cover_img` VARCHAR(255) DEFAULT '' COMMENT '封面图',
    `description` TEXT COMMENT '商品描述',
    `price` DECIMAL(10,2) NOT NULL COMMENT '价格',
    `stock` INT NOT NULL DEFAULT 0 COMMENT '库存',
    `sales` INT DEFAULT 0 COMMENT '销量',
    `status` TINYINT DEFAULT 1 COMMENT '状态 1上架 0下架',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_type_id` (`type_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_goods_type` FOREIGN KEY (`type_id`) REFERENCES `goods_type` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 购物车表
CREATE TABLE IF NOT EXISTS `cart` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `goods_id` BIGINT NOT NULL COMMENT '商品ID',
    `quantity` INT NOT NULL DEFAULT 1 COMMENT '数量',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_goods` (`user_id`, `goods_id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_cart_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 收货地址表
CREATE TABLE IF NOT EXISTS `address` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `receiver` VARCHAR(50) NOT NULL COMMENT '收货人',
    `phone` VARCHAR(20) NOT NULL COMMENT '联系电话',
    `province` VARCHAR(50) DEFAULT '' COMMENT '省',
    `city` VARCHAR(50) DEFAULT '' COMMENT '市',
    `district` VARCHAR(50) DEFAULT '' COMMENT '区',
    `detail` VARCHAR(255) NOT NULL COMMENT '详细地址',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认 1是 0否',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';

-- 订单表（收货信息使用独立字段而非JSON快照）
CREATE TABLE IF NOT EXISTS `orders` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_no` VARCHAR(32) NOT NULL COMMENT '订单编号',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `receiver_name` VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    `receiver_phone` VARCHAR(20) NOT NULL COMMENT '收货人电话',
    `receiver_address` VARCHAR(500) NOT NULL COMMENT '收货地址',
    `total_amount` DECIMAL(10,2) NOT NULL COMMENT '订单总额',
    `status` TINYINT DEFAULT 0 COMMENT '状态 0待支付 1已支付 2已发货 3已完成 4已取消',
    `pay_method` TINYINT DEFAULT 0 COMMENT '支付方式 0未支付 1在线支付 2货到付款',
    `remark` VARCHAR(255) DEFAULT '' COMMENT '备注',
    `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
    `ship_time` DATETIME DEFAULT NULL COMMENT '发货时间',
    `finish_time` DATETIME DEFAULT NULL COMMENT '完成时间',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_status` (`status`),
    CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单详情表
CREATE TABLE IF NOT EXISTS `order_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL COMMENT '订单ID',
    `goods_id` BIGINT NOT NULL COMMENT '商品ID',
    `goods_name` VARCHAR(100) NOT NULL COMMENT '商品名称快照',
    `goods_img` VARCHAR(255) DEFAULT '' COMMENT '商品图片快照',
    `goods_price` DECIMAL(10,2) NOT NULL COMMENT '商品单价快照',
    `quantity` INT NOT NULL COMMENT '数量',
    `subtotal` DECIMAL(10,2) NOT NULL COMMENT '小计',
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`),
    CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_order_item_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- 操作日志表
CREATE TABLE IF NOT EXISTS `operation_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `operator` VARCHAR(50) DEFAULT '' COMMENT '操作人',
    `module` VARCHAR(50) DEFAULT '' COMMENT '模块',
    `action` VARCHAR(50) DEFAULT '' COMMENT '操作',
    `detail` TEXT COMMENT '详情',
    `ip` VARCHAR(50) DEFAULT '' COMMENT 'IP地址',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- 初始数据（密码为BCrypt加密存储）
INSERT INTO `admin` (`username`, `password`, `nickname`) VALUES ('admin', '$2a$10$AqlajHrY1jxoLU3wWfQfHeNLJDWfYLDZX.KktpOsz0x/OG4uwLiu2', '超级管理员');

INSERT INTO `goods_type` (`name`, `sort_order`) VALUES
('新鲜水果', 1), ('时令蔬菜', 2), ('五谷杂粮', 3), ('禽蛋肉类', 4), ('干货特产', 5);

INSERT INTO `goods` (`type_id`, `name`, `cover_img`, `description`, `price`, `stock`, `sales`) VALUES
(1, '红富士苹果 5斤装', 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop', '山东烟台红富士，脆甜多汁，新鲜采摘', 29.90, 500, 1200),
(1, '赣南脐橙 10斤装', 'https://images.unsplash.com/photo-1547514701-42782101795e?w=400&h=400&fit=crop', '江西赣南脐橙，皮薄肉厚，酸甜可口', 39.90, 300, 800),
(2, '有机西红柿 3斤', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=400&fit=crop', '自然成熟，沙瓤多汁，无农药残留', 15.80, 200, 650),
(2, '新鲜西兰花 2颗', 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400&h=400&fit=crop', '云南高原西兰花，翠绿新鲜，营养丰富', 12.50, 150, 420),
(3, '东北五常大米 10斤', 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop', '正宗五常稻花香，颗粒饱满，米香浓郁', 59.90, 1000, 3500),
(3, '有机黑豆 2斤', 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=400&h=400&fit=crop', '东北有机黑豆，粒大饱满，营养丰富', 18.80, 400, 280),
(4, '散养土鸡蛋 30枚', 'https://images.unsplash.com/photo-1498654077810-12c21d4d6dc3?w=400&h=400&fit=crop', '农家散养土鸡蛋，蛋黄饱满，营养健康', 35.00, 600, 2100),
(4, '新鲜猪肉 五花肉 2斤', 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&h=400&fit=crop', '当日屠宰，新鲜直达，肥瘦相间', 45.00, 100, 560),
(5, '新疆红枣 2斤', 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop', '和田大枣，个大肉厚，甘甜醇香', 28.80, 350, 900),
(5, '云南核桃 3斤', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&h=400&fit=crop', '薄皮核桃，果仁饱满，香脆可口', 42.00, 250, 670);

INSERT INTO `user` (`username`, `password`, `nickname`, `phone`) VALUES ('testuser', '$2a$10$Tlrh9N65Mc5A8SKSdW36Uuj/yqZRcas2DlGtMIZSh2plLvX4a5.kO', '测试用户', '13800000000');
