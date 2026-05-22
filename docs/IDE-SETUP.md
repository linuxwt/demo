# VSCode 开发环境配置

## 前提条件

| 工具 | 版本 | 路径 |
|---|---|---|
| JDK | 17+ | `%JAVA_HOME%` → `C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot` |
| Maven | 3.5.x | `%MAVEN_HOME%` → `D:\soft_install\maven\maven3.5.4` |

验证安装：

```bash
java -version
mvn --version
```

> 如果环境变量未设置，替换为实际安装路径。

## 1. 安装 VSCode 扩展

按下 `Ctrl+Shift+X` 搜索并安装以下扩展：

| 扩展 | 用途 |
|---|---|
| **Extension Pack for Java** (`vscjava.vscode-java-pack`) | Java 语言支持、Maven 集成、调试、测试 |
| **Spring Boot Extension Pack** (`vmware.vscode-boot-dev-pack`) | Spring Boot 仪表盘、自动补全、配置提示 |
| **REST Client** (`humao.rest-client`) | 直接在 VSCode 中发送 HTTP 请求测试 API |

## 2. 项目配置

`.vscode/settings.json` 已预配置 JDK 和 Maven 路径。

如需修改路径，编辑该文件中对应字段：

```json
{
  "java.configuration.runtimes": [
    { "name": "JavaSE-17", "path": "<你的JDK路径>" }
  ],
  "maven.executable.path": "<你的mvn.cmd路径>"
}
```

## 3. 运行项目

### 方式一：Spring Boot Dashboard

1. 点击左侧栏 Spring Boot 图标（❒ 叶子）
2. 找到 `user-management` → 点击 ▶ 启动

### 方式二：Maven 命令行

```bash
mvn spring-boot:run
```

### 方式三：调试模式

1. 按 `F5` 或点击左侧栏调试图标
2. 选择 `UserApplication` 启动配置
3. 设置断点后即可调试

## 4. 打包部署

```bash
mvn clean package -DskipTests
java -jar target/user-management-0.0.1-SNAPSHOT.jar
```

## 5. 测试 API

安装 REST Client 扩展后，打开 `.vscode/test-api.http` 文件，点击每个请求上方的 `Send Request`。

```http
### 注册
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
  "username": "admin",
  "email": "admin@example.com",
  "password": "123456"
}

### 登录
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "123456"
}
```

## 6. H2 数据库控制台

启动项目后访问：http://localhost:8080/h2-console

- JDBC URL: `jdbc:h2:mem:userdb`
- 用户名: `sa`
- 密码: （空）

## 7. 常见问题

**Q: 启动报错 "Java 17 required"**
确保 `settings.json` 中 `java.configuration.runtimes` 指向 JDK 17+ 路径。

**Q: Maven 命令找不到**
确认 `mvn --version` 能正常输出，或在 `settings.json` 中手动设置 `maven.executable.path`。

**Q: 端口被占用**
修改 `application.yml` 中 `server.port` 或使用 `--server.port=8081` 启动。
