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
@Table(name = "user_preferences")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class UserPreference {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", comment = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, comment = "用户ID")
    private User user;

    @Column(name = "language", length = 10)
    private String language = "zh-CN";

    @Column(name = "timezone", length = 50)
    private String timezone = "Asia/Shanghai";

    @Column(name = "theme", length = 20)
    private String theme = "light";

    @Column(name = "notifications_enabled", columnDefinition = "SMALLINT DEFAULT 1", comment = "通知启用状态")
    private Boolean notificationsEnabled = true;

    @CreatedDate
    @Column(name = "created_at", nullable = false, comment = "创建时间")
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false, comment = "更新时间")
    private LocalDateTime updatedAt;
}