-- ============================================================
-- 初始化数据脚本
-- 兼容 H2 / MySQL / PostgreSQL
-- ============================================================

-- 创建管理员账号（密码: admin123, BCrypt 加密）
INSERT INTO users (username, email, password_hash, real_name, status, deleted, created_at, updated_at)
VALUES ('admin', 'admin@example.com', '$2a$10$kiZOJFO1EET9ir79fA8COODqdqYbhPT7fIOA0gjOne9CYpB39225K',
        'Administrator', 1, FALSE, NOW(), NOW());

-- 创建管理员角色
INSERT INTO roles (name, description, created_at, updated_at)
VALUES ('ROLE_ADMIN', 'System Administrator', NOW(), NOW());

-- 创建普通用户角色（供注册功能使用）
INSERT INTO roles (name, description, created_at, updated_at)
VALUES ('ROLE_USER', 'Regular user', NOW(), NOW());

-- 将 admin 用户关联到管理员角色
INSERT INTO user_roles (user_id, role_id, created_at)
VALUES ((SELECT id FROM users WHERE username = 'admin'),
        (SELECT id FROM roles WHERE name = 'ROLE_ADMIN'),
        NOW());
