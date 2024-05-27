package com.example.charitable.repos;

import com.example.charitable.domain.Donation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.sql.Timestamp;
import java.util.List;

public interface DonationRepo extends JpaRepository<Donation, Long> {
    Donation findById(long id);
    List<Donation> findByRequestId(long id);
    List<Donation> findAllByUserId(long user_id);
    List<Donation> findAllByUserIdAndTimestampAfter(long user_id, Timestamp timestamp);
    List<Donation> findAllByUserIdAndTimestampAfterAndTimestampBefore(long user_id, Timestamp timestampAfter, Timestamp timestampBefore);
    Donation findTopByOrderByIdDesc();
}
