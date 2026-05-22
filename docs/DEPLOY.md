# 部署文档

## 环境依赖

| 组件 | 版本要求 | 说明 |
|------|----------|------|
| JDK | 17+ | 必须配置 `JAVA_HOME` 环境变量 |
| Maven | 3.5.4+ | 可选，缺失时自动使用 `mvnw` 包装器 |
| Docker | 24+ | 仅 Docker 部署需要 |
| Docker Compose | 2.20+ | 仅 Docker 部署需要 |

## 本地部署

### Windows

```bat
# 使用默认配置（dev profile, 8080 端口）
scripts\start.bat

# 指定 profile 和端口
scripts\start.bat --profile prod --port 8080
```

### Linux / macOS

```bash
# 使用默认配置
chmod +x scripts/start.sh
./scripts/start.sh

# 指定 profile 和端口
./scripts/start.sh --profile prod --port 8080
```

### 手动启动

```bash
# 1. 编译
mvn clean package -DskipTests

# 2. 运行（开发模式）
java -jar target/user-management-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=dev

# 3. 运行（生产模式，需已启动 PostgreSQL）
java -jar target/user-management-0.0.1-SNAPSHOT.jar \
  --server.port=8080 \
  --spring.profiles.active=prod
```

启动后访问 `http://localhost:8080`。

### 初始化数据

首次启动后，手动执行初始化 SQL 以创建管理员账号：

```bash
# 通过 H2 Console（dev 模式）或 psql（prod 模式）执行
scripts/sql/init-data.sql
```

默认管理员：`admin` / `admin123`

## Docker 部署

### 前置准备

确保已安装 Docker 和 Docker Compose。

### 构建并启动

```bash
# 在项目根目录执行
docker compose up -d
```

### 环境变量配置

通过 `.env` 文件或系统环境变量配置：

```bash
# .env 文件示例
DB_USERNAME=postgres
DB_PASSWORD=your_secure_password
JWT_SECRET=your_base64_encoded_secret_key
```

### 验证部署

```bash
# 查看应用日志
docker compose logs -f app

# 查看数据库日志
docker compose logs -f db

# 健康检查
curl http://localhost:8080/actuator/health
```

### 常用命令

```bash
# 启动所有服务
docker compose up -d

# 停止所有服务
docker compose down

# 停止并删除数据卷（清除数据库）
docker compose down -v

# 重新构建并启动
docker compose up -d --build

# 查看运行状态
docker compose ps
```

## 配置说明

### Profile

| Profile | 数据库 | 说明 |
|---------|--------|------|
| `dev`（默认） | H2 内存 | 开发调试，自动建表，SQL 日志 |
| `prod` | PostgreSQL | 生产运行，ddl-validate |

### 关键环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `DB_HOST` | `localhost` | 数据库主机地址 |
| `DB_USERNAME` | `postgres` | 数据库用户名 |
| `DB_PASSWORD` | `postgres` | 数据库密码 |
| `JWT_SECRET` | — | JWT 签名密钥（Base64，prod 必填） |
| `SERVER_PORT` | `8080` | 服务端口 |

## 常见问题

### 1. 启动报 "Java 17+ required"

确认 `JAVA_HOME` 已正确指向 JDK 17+：

```bash
# 验证版本
java -version
echo %JAVA_HOME%   # Windows
echo $JAVA_HOME    # Linux / macOS
```

### 2. Maven 构建失败

```bash
# 清理缓存后重试
mvn clean compile -B
```

### 3. Docker 部署数据库连接失败

检查数据库服务是否就绪：

```bash
docker compose logs db
```

确认环境变量 `DB_HOST` 已设置为 `db`（Docker Compose 中自动配置）。

### 4. 生产环境 JWT 密钥生成

```bash
# Linux / macOS
echo -n "your-secret-key-min-256-bits" | base64

# Windows PowerShell
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("your-secret-key-min-256-bits"))
```

将输出值设为 `JWT_SECRET` 环境变量。

### 5. 端口被占用

```bash
# 查找占用程序
netstat -ano | findstr :8080   # Windows
lsof -i :8080                  # Linux / macOS
```

修改端口：`--port 8081`（启动脚本）或 `--server.port=8081`（java -jar）。
