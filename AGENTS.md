# 用户管理微服务项目

## 技术栈

- 语言：Java 17+（优先从系统环境变量 JAVA_HOME 取值，最低 Java 17）

- 框架：Spring Boot 3.2.5

- 数据库：H2（开发）/ PostgreSQL 15（生产）

- 构建工具：Maven 3.5.4

- 测试框架：JUnit 5 + Mockito

- JWT：jjwt 0.12.5

- 加密：Spring Security Crypto (BCrypt)

## 编码规范

- 遵循阿里巴巴 Java 开发规范

- 使用 Lombok 简化代码

- 统一异常处理使用 @RestControllerAdvice + BusinessException

- 日志使用 SLF4J

- 避免过度注释、泛化命名、冗余抽象

## 输出要求

- 每步完成后明确告知"本步骤完成"

- 遇到问题时先说明原因，再给出解决方案

- 代码变更需说明改动点和意图

## 项目结构

```
com.example.user
├── common/          # 统一响应 Result、业务异常、全局异常处理、JWT 工具
├── config/          # Spring 配置类（JPA 审计、Security）
├── controller/      # REST 控制器
├── dto/             # 请求/响应数据传输对象
├── domain/          # JPA 实体
├── repository/      # 数据访问层
└── service/         # 业务逻辑接口 + impl 实现
```

## API 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/register | 用户注册 |
| POST | /api/auth/login | 用户登录（支持用户名或邮箱） |
