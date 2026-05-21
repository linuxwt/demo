package com.example.demo.service;

import com.example.demo.domain.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    
    User createUser(User user);
    
    User updateUser(Long id, User user);
    
    User deleteUser(Long id);
    
    User getUserById(Long id);
    
    List<User> getAllUsers();
    
    List<User> getUsersByStatus(Integer status);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
}