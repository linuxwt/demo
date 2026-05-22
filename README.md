# User Management

用户管理微服务，提供用户注册、登录等基础身份认证功能。

## 技术栈

| 层级 | 选型 |
|------|------|
| 语言 | Java 17+ |
| 框架 | Spring Boot 3.2.5 |
| 数据库 | H2（开发）/ PostgreSQL 15（生产） |
| 构建工具 | Maven 3.5.4+ |
| ORM | Spring Data JPA (Hibernate) |
| 认证 | JWT (jjwt 0.12.5) + BCrypt |
| 测试 | JUnit 5 + Mockito |

## 快速启动

### 前置条件

- JDK 17+（`JAVA_HOME` 环境变量已配置）
- Maven 3.5.4+

### 启动步骤

```bash
# 1. 编译
mvn clean compile

# 2. 运行（开发模式，H2 内存数据库）
mvn spring-boot:run

# 3. 运行（指定生产配置，PostgreSQL）
mvn spring-boot:run -Dspring-boot.run.profiles=prod
```

启动后访问：

- API: `http://localhost:8080`
- H2 Console: `http://localhost:8080/h2-console`（仅 dev 模式）

### 初始化数据

```bash
# 启动时自动执行（需配置 spring.sql.init.mode=always）
# 或手动执行 scripts/sql/init-data.sql
```

默认管理员账号：

- 用户名: `admin`
- 密码: `admin123`

## 目录结构

```
src/main/java/com/example/user
├── common/               # 统一响应、业务异常、全局异常处理、JWT 工具
│   ├── Result.java           — 统一 API 响应
│   ├── BusinessException.java — 业务异常
│   ├── GlobalExceptionHandler.java — 全局异常处理
│   └── JwtUtil.java          — JWT 生成与校验
├── config/               # Spring 配置类
│   ├── JpaConfig.java        — JPA 审计
│   └── SecurityConfig.java   — BCrypt 密码编码器
├── controller/           # REST 控制器
│   └── AuthController.java   — 注册 / 登录端点
├── dto/                  # 数据传输对象
│   ├── RegisterRequest.java
│   ├── LoginRequest.java
│   └── AuthResponse.java
├── domain/               # JPA 实体
│   ├── BaseEntity.java       — ID 基类
│   ├── AuditableEntity.java  — 审计基类（创建/更新时间）
│   ├── User.java
│   ├── Role.java
│   ├── UserRole.java
│   ├── UserPreference.java
│   └── UserLoginLog.java
├── repository/           # 数据访问层
│   ├── UserRepository.java
│   ├── RoleRepository.java
│   └── UserLoginLogRepository.java
└── service/              # 业务逻辑
    ├── AuthService.java         — 接口
    └── impl/AuthServiceImpl.java — 实现
```

## API 概览

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/auth/register | 用户注册 |
| POST | /api/auth/login | 用户登录（支持用户名或邮箱） |

详细 API 文档见 [docs/API.md](docs/API.md)。

## 配置说明

主配置文件 `application.yml` 包含 dev / prod 双 profile：

- **dev（默认）**: H2 内存数据库，SQL 日志输出，H2 Console 开启
- **prod**: PostgreSQL，关闭 SQL 日志，ddl-validate
