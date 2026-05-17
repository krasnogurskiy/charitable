package com.example.charitable.repos;

import com.example.charitable.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface UserRepo extends JpaRepository<User, Long> {
    User findByUsername(String username);
    User findById(long id);
    List<User> findAllByCity(String city);

    // НАШ НОВИЙ ЗАТВЕРДЖЕНИЙ МЕТОД ДЛЯ ЗАПИСУ РОЛІ
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM user_role WHERE user_id = :userId", nativeQuery = true)
    void clearUserRoles(@Param("userId") Long userId);

    @Modifying
    @Transactional
    @Query(value = "INSERT INTO user_role (user_id, roles) VALUES (:userId, 'HELP_SEEKER')", nativeQuery = true)
    void insertHelpSeekerRole(@Param("userId") Long userId);
}