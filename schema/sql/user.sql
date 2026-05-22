-- ============================================================================
-- 用户管理模块 - 数据库表结构
-- 兼容数据库: H2 / MySQL 8.0+ / PostgreSQL 15+
-- ============================================================================
-- 使用说明：根据实际数据库选择对应区域的 DDL 执行，执行前取消对应区域注释
-- ============================================================================

-- ============================================================================
-- 一、H2 Database
-- ============================================================================
-- H2 建表语句（开发环境，无需手动建表，JPA 自动生成）
-- ============================================================================

-- ============================================================================
-- 二、MySQL 8.0+
-- ============================================================================
/*
-- 用户表：存储用户基本信息
CREATE TABLE IF NOT EXISTS `users` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '用户ID，主键自增',
    `username`          VARCHAR(50)     NOT NULL                 COMMENT '用户名，登录使用',
    `email`             VARCHAR(100)    NOT NULL                 COMMENT '邮箱，用于找回密码和通知',
    `phone`             VARCHAR(20)                              COMMENT '手机号',
    `password_hash`     VARCHAR(255)    NOT NULL                 COMMENT '密码哈希值（BCrypt 加密）',
    `real_name`         VARCHAR(50)                              COMMENT '真实姓名',
    `avatar`            VARCHAR(500)                             COMMENT '头像URL',
    `status`            TINYINT         NOT NULL DEFAULT 1       COMMENT '状态：0-禁用 1-启用',
    `last_login_at`     DATETIME                                 COMMENT '最后登录时间',
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`           TINYINT         NOT NULL DEFAULT 0       COMMENT '软删除标记：0-正常 1-已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_email` (`email`),
    KEY `ix_deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 角色表：存储角色定义
CREATE TABLE IF NOT EXISTS `roles` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT  COMMENT '角色ID，主键自增',
    `name`              VARCHAR(50)     NOT NULL                 COMMENT '角色名称（如 ADMIN、USER）',
    `description`       VARCHAR(255)                             COMMENT '角色描述',
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 用户-角色关联表：多对多关系
CREATE TABLE IF NOT EXISTS `user_roles` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID，主键自增',
    `user_id`           BIGINT          NOT NULL                 COMMENT '用户ID，关联 users.id',
    `role_id`           BIGINT          NOT NULL                 COMMENT '角色ID，关联 roles.id',
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
    KEY `ix_role_id` (`role_id`),
    CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户-角色关联表';

-- 登录日志表：记录用户登录历史
CREATE TABLE IF NOT EXISTS `user_login_logs` (
    `id`                BIGINT          NOT NULL AUTO_INCREMENT  COMMENT 'ID，主键自增',
    `user_id`           BIGINT          NOT NULL                 COMMENT '用户ID，关联 users.id',
    `ip_address`        VARCHAR(45)                              COMMENT '登录IP地址（支持IPv6）',
    `user_agent`        TEXT                                     COMMENT '浏览器/客户端 User-Agent',
    `login_result`      TINYINT                                  COMMENT '登录结果：0-失败 1-成功',
    `fail_reason`       VARCHAR(255)                             COMMENT '失败原因',
    `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
    PRIMARY KEY (`id`),
    KEY `ix_user_id` (`user_id`),
    KEY `ix_created_at` (`created_at`),
    CONSTRAINT `fk_login_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志表';

-- 用户偏好表：存储用户个性化配置
CREATE TABLE IF NOT EXISTS `user_preferences` (
    `id`                    BIGINT      NOT NULL AUTO_INCREMENT  COMMENT 'ID，主键自增',
    `user_id`               BIGINT      NOT NULL                 COMMENT '用户ID，关联 users.id',
    `language`              VARCHAR(10) NOT NULL DEFAULT 'zh-CN' COMMENT '语言偏好',
    `timezone`              VARCHAR(50) NOT NULL DEFAULT 'Asia/Shanghai' COMMENT '时区',
    `theme`                 VARCHAR(20) NOT NULL DEFAULT 'light' COMMENT '主题：light-亮色 dark-暗色',
    `notifications_enabled` TINYINT     NOT NULL DEFAULT 1       COMMENT '通知开关：0-关闭 1-开启',
    `created_at`            DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`            DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_id` (`user_id`),
    CONSTRAINT `fk_preferences_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户偏好表';

-- 初始数据：插入默认角色（仅首次初始化时执行）
-- INSERT INTO roles (name, description) VALUES ('ROLE_ADMIN', '管理员'), ('ROLE_USER', '普通用户');
*/

-- ============================================================================
-- 三、PostgreSQL 15+
-- ============================================================================
/*
-- 用户表：存储用户基本信息
CREATE TABLE IF NOT EXISTS users (
    id                  BIGINT          GENERATED BY DEFAULT AS IDENTITY  PRIMARY KEY,
    username            VARCHAR(50)     NOT NULL,
    email               VARCHAR(100)    NOT NULL,
    phone               VARCHAR(20),
    password_hash       VARCHAR(255)    NOT NULL,
    real_name           VARCHAR(50),
    avatar              VARCHAR(500),
    status              SMALLINT        NOT NULL DEFAULT 1,
    last_login_at       TIMESTAMP,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted             SMALLINT        NOT NULL DEFAULT 0
);
COMMENT ON TABLE users IS '用户表';
COMMENT ON COLUMN users.id IS '用户ID，主键自增';
COMMENT ON COLUMN users.username IS '用户名，登录使用';
COMMENT ON COLUMN users.email IS '邮箱，用于找回密码和通知';
COMMENT ON COLUMN users.phone IS '手机号';
COMMENT ON COLUMN users.password_hash IS '密码哈希值（BCrypt 加密）';
COMMENT ON COLUMN users.real_name IS '真实姓名';
COMMENT ON COLUMN users.avatar IS '头像URL';
COMMENT ON COLUMN users.status IS '状态：0-禁用 1-启用';
COMMENT ON COLUMN users.last_login_at IS '最后登录时间';
COMMENT ON COLUMN users.created_at IS '创建时间';
COMMENT ON COLUMN users.updated_at IS '更新时间';
COMMENT ON COLUMN users.deleted IS '软删除标记：0-正常 1-已删除';
CREATE UNIQUE INDEX uk_users_username ON users(username);
CREATE UNIQUE INDEX uk_users_email ON users(email);
CREATE INDEX ix_users_deleted ON users(deleted);

-- 角色表：存储角色定义
CREATE TABLE IF NOT EXISTS roles (
    id                  BIGINT          GENERATED BY DEFAULT AS IDENTITY  PRIMARY KEY,
    name                VARCHAR(50)     NOT NULL,
    description         VARCHAR(255),
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE roles IS '角色表';
COMMENT ON COLUMN roles.id IS '角色ID，主键自增';
COMMENT ON COLUMN roles.name IS '角色名称（如 ADMIN、USER）';
COMMENT ON COLUMN roles.description IS '角色描述';
COMMENT ON COLUMN roles.created_at IS '创建时间';
COMMENT ON COLUMN roles.updated_at IS '更新时间';
CREATE UNIQUE INDEX uk_roles_name ON roles(name);

-- 用户-角色关联表：多对多关系
CREATE TABLE IF NOT EXISTS user_roles (
    id                  BIGINT          GENERATED BY DEFAULT AS IDENTITY  PRIMARY KEY,
    user_id             BIGINT          NOT NULL,
    role_id             BIGINT          NOT NULL,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE user_roles IS '用户-角色关联表';
COMMENT ON COLUMN user_roles.id IS 'ID，主键自增';
COMMENT ON COLUMN user_roles.user_id IS '用户ID，关联 users.id';
COMMENT ON COLUMN user_roles.role_id IS '角色ID，关联 roles.id';
COMMENT ON COLUMN user_roles.created_at IS '创建时间';
CREATE UNIQUE INDEX uk_user_roles ON user_roles(user_id, role_id);
CREATE INDEX ix_user_roles_role_id ON user_roles(role_id);
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE;

-- 登录日志表：记录用户登录历史
CREATE TABLE IF NOT EXISTS user_login_logs (
    id                  BIGINT          GENERATED BY DEFAULT AS IDENTITY  PRIMARY KEY,
    user_id             BIGINT          NOT NULL,
    ip_address          VARCHAR(45),
    user_agent          TEXT,
    login_result        SMALLINT,
    fail_reason         VARCHAR(255),
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE user_login_logs IS '登录日志表';
COMMENT ON COLUMN user_login_logs.id IS 'ID，主键自增';
COMMENT ON COLUMN user_login_logs.user_id IS '用户ID，关联 users.id';
COMMENT ON COLUMN user_login_logs.ip_address IS '登录IP地址（支持IPv6）';
COMMENT ON COLUMN user_login_logs.user_agent IS '浏览器/客户端 User-Agent';
COMMENT ON COLUMN user_login_logs.login_result IS '登录结果：0-失败 1-成功';
COMMENT ON COLUMN user_login_logs.fail_reason IS '失败原因';
COMMENT ON COLUMN user_login_logs.created_at IS '登录时间';
CREATE INDEX ix_login_logs_user_id ON user_login_logs(user_id);
CREATE INDEX ix_login_logs_created_at ON user_login_logs(created_at);
ALTER TABLE user_login_logs ADD CONSTRAINT fk_login_logs_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- 用户偏好表：存储用户个性化配置
CREATE TABLE IF NOT EXISTS user_preferences (
    id                      BIGINT      GENERATED BY DEFAULT AS IDENTITY  PRIMARY KEY,
    user_id                 BIGINT      NOT NULL,
    language                VARCHAR(10) NOT NULL DEFAULT 'zh-CN',
    timezone                VARCHAR(50) NOT NULL DEFAULT 'Asia/Shanghai',
    theme                   VARCHAR(20) NOT NULL DEFAULT 'light',
    notifications_enabled   SMALLINT    NOT NULL DEFAULT 1,
    created_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE user_preferences IS '用户偏好表';
COMMENT ON COLUMN user_preferences.id IS 'ID，主键自增';
COMMENT ON COLUMN user_preferences.user_id IS '用户ID，关联 users.id';
COMMENT ON COLUMN user_preferences.language IS '语言偏好';
COMMENT ON COLUMN user_preferences.timezone IS '时区';
COMMENT ON COLUMN user_preferences.theme IS '主题：light-亮色 dark-暗色';
COMMENT ON COLUMN user_preferences.notifications_enabled IS '通知开关：0-关闭 1-开启';
COMMENT ON COLUMN user_preferences.created_at IS '创建时间';
COMMENT ON COLUMN user_preferences.updated_at IS '更新时间';
CREATE UNIQUE INDEX uk_preferences_user_id ON user_preferences(user_id);
ALTER TABLE user_preferences ADD CONSTRAINT fk_preferences_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
*/
