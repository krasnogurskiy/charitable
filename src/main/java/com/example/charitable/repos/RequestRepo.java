package com.example.charitable.repos;

import com.example.charitable.domain.Request;
import org.springframework.data.jpa.repository.JpaRepository;

import java.sql.Timestamp;
import java.util.List;

public interface RequestRepo extends JpaRepository<Request, Long> {
    Request findById(long id);
    List<Request> findAllByUserId(long user_id);
    List<Request> findAllByUserIdAndTimestampAfter(long user_id, Timestamp timestamp);
    List<Request> findAllByUserIdAndTimestampAfterAndTimestampBefore(long user_id, Timestamp timestampAfter, Timestamp timestampBefore);
}
