---
name: review-java

description: Java code review for best practices and potential issues

---

# Java 代码审查

## 审查要点

1. **命名规范**：类名 PascalCase，方法名 camelCase，常量 UPPER_SNAKE

2. **代码简洁**：方法不超过 30 行，避免嵌套超过 3 层

3. **避免 AI 味**：无过度注释、无泛化命名（data/info/manager）、无不必要抽象

4. **安全检查**：无硬编码密码、无敏感信息日志

## 输出格式

- 问题列表（文件:行号 - 问题描述 - 修改建议）

- 整体评价（通过/需修改）
