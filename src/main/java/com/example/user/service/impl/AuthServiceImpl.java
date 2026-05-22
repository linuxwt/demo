package com.example.user.service.impl;

import com.example.user.common.BusinessException;
import com.example.user.common.JwtUtil;
import com.example.user.domain.Role;
import com.example.user.domain.User;
import com.example.user.domain.UserLoginLog;
import com.example.user.domain.UserRole;
import com.example.user.dto.AuthResponse;
import com.example.user.dto.LoginRequest;
import com.example.user.dto.RegisterRequest;
import com.example.user.repository.RoleRepository;
import com.example.user.repository.UserLoginLogRepository;
import com.example.user.repository.UserRepository;
import com.example.user.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private static final int STATUS_ACTIVE = 1;
    private static final int LOGIN_RESULT_SUCCESS = 1;

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserLoginLogRepository loginLogRepository;
    private final JwtUtil jwtUtil;
    private final BCryptPasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new BusinessException("username already exists");
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BusinessException("email already exists");
        }

        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseGet(() -> roleRepository.save(
                        Role.builder().name("ROLE_USER").description("Regular user").build()));

        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .phone(request.getPhone())
                .realName(request.getRealName())
                .status(STATUS_ACTIVE)
                .build();

        user = userRepository.save(user);

        UserRole userRoleEntity = UserRole.builder()
                .user(user)
                .role(userRole)
                .build();
        user.getRoles().add(userRoleEntity);

        return buildAuthResponse(user);
    }

    @Override
    @Transactional
    public AuthResponse login(LoginRequest request) {
        Optional<User> userOpt = request.getUsername().contains("@")
                ? userRepository.findByEmail(request.getUsername())
                : userRepository.findByUsername(request.getUsername());

        User user = userOpt.orElseThrow(() -> new BusinessException("invalid username or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BusinessException("invalid username or password");
        }

        if (user.getStatus() != STATUS_ACTIVE) {
            throw new BusinessException("account has been disabled");
        }

        user.setLastLoginAt(LocalDateTime.now());

        UserLoginLog loginLog = UserLoginLog.builder()
                .user(user)
                .loginResult(LOGIN_RESULT_SUCCESS)
                .build();
        loginLogRepository.save(loginLog);

        return buildAuthResponse(user);
    }

    private AuthResponse buildAuthResponse(User user) {
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        return AuthResponse.builder()
                .token(token)
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .build();
    }

}
