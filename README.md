# Demo Spring Boot Project

这是一个标准的 Maven Spring Boot 项目骨架，包含完整的分层架构。

## 项目结构

```
src/
├── main/
│   ├── java/
│   │   └── com/example/demo/
│   │       ├── controller/     # 控制器层
│   │       ├── service/        # 服务层
│   │       ├── repository/     # 数据访问层
│   │       ├── domain/         # 实体类
│   │       └── MainApplication.java  # 主应用类
│   └── resources/
│       └── application.yml     # 应用配置文件
└── test/
    └── java/
        └── com/example/demo/   # 测试类
```

## 技术栈

- Java 17+
- Spring Boot 3.2.0
- Maven
- Spring Data JPA
- H2 内存数据库
- Lombok

## 主要特性

- **分层架构**：Controller、Service、Repository、Domain
- **H2 内存数据库**：自动配置，支持 H2 控制台
- **JPA 实体类**：包含审计字段支持
- **REST API**：完整的 CRUD 操作
- **数据验证**：Spring Validation 支持

## 配置

### H2 数据库配置

项目已配置 H2 内存数据库：
- URL: `jdbc:h2:mem:testdb`
- 用户名: `sa`
- 密码: `password`

### H2 控制台

H2 控制台已启用，访问地址：`http://localhost:8080/h2-console`

连接配置：
- JDBC URL: `jdbc:h2:mem:testdb`
- User Name: `sa`
- Password: `password`

## 运行项目

### Maven 命令

```bash
# 编译项目
mvn clean compile

# 运行测试
mvn test

# 打包项目
mvn clean package

# 运行项目
mvn spring-boot:run
```

### API 端点

项目启动后，可以访问以下 API 端点：

- `POST /api/users` - 创建用户
- `GET /api/users` - 获取所有用户
- `GET /api/users/{id}` - 根据 ID 获取用户
- `PUT /api/users/{id}` - 更新用户
- `DELETE /api/users/{id}` - 删除用户
- `GET /api/users/status/{status}` - 根据状态获取用户
- `GET /api/users/check-username/{username}` - 检查用户名是否存在
- `GET /api/users/check-email/{email}` - 检查邮箱是否存在

## 开发说明

### 添加新的实体类

1. 在 `domain` 包中创建实体类
2. 在 `repository` 包中创建对应的 Repository 接口
3. 在 `service` 包中创建 Service 接口和实现
4. 在 `controller` 包中创建 Controller 类

### 数据库配置

如需使用其他数据库（MySQL、PostgreSQL），请修改 `application.yml` 中的 datasource 配置。

## 许可证

MIT License