package com.example.charitable.repos;

import com.example.charitable.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepo extends JpaRepository<User, Long> {
    User findByUsername(String username);
    User findById(long id);
    List<User> findAllByCity(String city);

}
