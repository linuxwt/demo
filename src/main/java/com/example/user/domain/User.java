package com.example.user.domain;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import javax.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.Where;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
@Where(clause = "deleted = 0")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", comment = "用户ID")
    private Long id;

    @Column(name = "username", length = 50, nullable = false, unique = true, comment = "用户名")
    private String username;

    @Column(name = "email", length = 100, nullable = false, unique = true, comment = "邮箱")
    private String email;

    @Column(name = "phone", length = 20, comment = "手机号")
    private String phone;

    @Column(name = "password_hash", length = 255, nullable = false, comment = "密码哈希")
    private String passwordHash;

    @Column(name = "status", columnDefinition = "SMALLINT DEFAULT 1", comment = "状态: 0-禁用, 1-启用")
    private Integer status;

    @Column(name = "last_login_at", comment = "最后登录时间")
    private LocalDateTime lastLoginAt;

    @CreatedDate
    @Column(name = "created_at", nullable = false, comment = "创建时间")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false, comment = "更新时间")
    private LocalDateTime updatedAt;

    @Type(type = "org.hibernate.type.NumericBooleanType")
    @Column(name = "deleted", columnDefinition = "SMALLINT DEFAULT 0", comment = "软删除标记: 0-正常, 1-已删除")
    private Boolean deleted = false;
}