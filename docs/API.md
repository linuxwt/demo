# API 文档

Base URL: `http://localhost:8080`

---

## 1. 用户注册

注册新用户。

- **路径**: `/api/auth/register`
- **方法**: `POST`
- **Content-Type**: `application/json`

### 请求参数

| 字段 | 类型 | 必填 | 说明 | 校验规则 |
|------|------|------|------|----------|
| `username` | String | 是 | 用户名 | 3~50 个字符 |
| `email` | String | 是 | 邮箱 | 合法邮箱格式，最长 100 字符 |
| `password` | String | 是 | 密码 | 6~100 个字符 |
| `phone` | String | 否 | 手机号 | — |
| `realName` | String | 否 | 真实姓名 | — |

### 请求示例

```json
{
  "username": "alice",
  "email": "alice@example.com",
  "password": "pass123",
  "phone": "13800138000",
  "realName": "Alice"
}
```

### 响应示例 (200)

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzM4NCJ9...",
    "userId": 1,
    "username": "alice",
    "email": "alice@example.com"
  }
}
```

### 错误码

| HTTP 状态码 | code | message | 说明 |
|-------------|------|---------|------|
| 400 | 400 | username already exists | 用户名已被占用 |
| 400 | 400 | email already exists | 邮箱已被占用 |
| 400 | — | 校验失败信息 | 请求参数不合法 |

---

## 2. 用户登录

支持用户名或邮箱登录。

- **路径**: `/api/auth/login`
- **方法**: `POST`
- **Content-Type**: `application/json`

### 请求参数

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `username` | String | 是 | 用户名或邮箱 |
| `password` | String | 是 | 密码 |

### 请求示例

```json
{
  "username": "alice",
  "password": "pass123"
}
```

### 响应示例 (200)

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzM4NCJ9...",
    "userId": 1,
    "username": "alice",
    "email": "alice@example.com"
  }
}
```

### 错误码

| HTTP 状态码 | code | message | 说明 |
|-------------|------|---------|------|
| 400 | 400 | invalid username or password | 用户名/邮箱或密码错误 |
| 400 | 400 | account has been disabled | 账号已被禁用 |

---

## 通用说明

### 统一响应格式

```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

### 全局错误码

| HTTP 状态码 | code | message | 说明 |
|-------------|------|---------|------|
| 400 | 400 | 业务异常信息 | 业务校验不通过 |
| 500 | 500 | Internal server error | 服务器内部错误 |
