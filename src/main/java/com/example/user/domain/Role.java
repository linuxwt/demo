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
@Table(name = "roles")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", comment = "角色ID")
    private Long id;

    @Column(name = "name", length = 50, nullable = false, unique = true, comment = "角色名称")
    private String name;

    @Column(name = "description", length = 255, comment = "角色描述")
    private String description;

    @CreatedDate
    @Column(name = "created_at", nullable = false, comment = "创建时间")
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false, comment = "更新时间")
    private LocalDateTime updatedAt;
}