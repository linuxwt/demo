package com.example.user.domain;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import javax.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_login_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class UserLoginLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", comment = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, comment = "用户ID")
    private User user;

    @Column(name = "ip_address", length = 45, comment = "IP地址")
    private String ipAddress;

    @Column(name = "user_agent", columnDefinition = "TEXT", comment = "用户代理")
    private String userAgent;

    @Column(name = "login_result", comment = "登录结果: 0-失败, 1-成功")
    private Integer loginResult;

    @CreatedDate
    @Column(name = "created_at", nullable = false, comment = "创建时间")
    private LocalDateTime createdAt;
}