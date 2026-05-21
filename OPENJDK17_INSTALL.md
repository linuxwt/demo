# OpenJDK 17 安装指南

## 下载链接

### 推荐下载源：Adoptium (Eclipse Temurin)

**Windows x64 版本：**
https://github.com/adoptium/temurin17-binaries/releases/download/refs/tags/17.0.19%2B09/OpenJDK17U-jdk_x64_windows_hotspot_17.0.19_09.msi

**直接下载链接：**
https://download.adoptium.net/images/openjdk17u/17.0.19_09/OpenJDK17U-jdk_x64_windows_hotspot_17.0.19_09.msi

## 安装步骤

### 1. 下载安装包
点击上面的链接下载 `.msi` 安装文件

### 2. 运行安装程序
- 双击下载的 `.msi` 文件
- 按照安装向导进行
- 选择安装路径（默认：`C:\Program Files\Java\jdk-17.0.19`）

### 3. 设置环境变量

#### 设置 JAVA_HOME
1. 右键点击"此电脑" → "属性"
2. 点击"高级系统设置"
3. 点击"环境变量"
4. 在"系统变量"中点击"新建"
   - 变量名：`JAVA_HOME`
   - 变量值：`C:\Program Files\Java\jdk-17.0.19`

#### 添加到 PATH
1. 在"系统变量"中找到`Path`，点击"编辑"
2. 点击"新建"，添加：`%JAVA_HOME%\bin`
3. 点击"确定"保存所有设置

### 4. 验证安装

打开新的命令提示符或PowerShell，运行：

```bash
java -version
```

应该显示：
```
openjdk version "17.0.19" 2024-01-16
OpenJDK Runtime Environment Temurin-17.0.19+09
OpenJDK 64-Bit Server VM Temurin-17.0.19+09
```

```bash
javac -version
```

应该显示：
```
javac 17.0.19
```

## 替代下载源

如果上面的链接不可用，可以尝试：

### Microsoft OpenJDK
https://aka.ms/downloadOpenJDK

### Oracle OpenJDK
https://www.oracle.com/java/technologies/downloads/

## 常见问题解决

### 1. 环境变量不生效
- 重启命令提示符或PowerShell
- 重启电脑

### 2. 版本验证失败
- 检查 `JAVA_HOME` 路径是否正确
- 确认 `PATH` 中包含 `%JAVA_HOME%\bin`

### 3. 权限问题
- 以管理员身份运行安装程序
- 检查安装目录的写入权限

## 与Spring Boot兼容性

✅ OpenJDK 17 完全兼容 Spring Boot 3.2.x
✅ 支持所有现代Java特性
✅ 长期支持（LTS）版本

安装完成后，您的Spring Boot项目就可以正常运行了！