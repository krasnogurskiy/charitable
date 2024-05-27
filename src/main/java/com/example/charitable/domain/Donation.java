package com.example.charitable.domain;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "donations")
public class Donation {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    @JoinColumn(name="user_id", nullable=false)
    private User user;

    @ManyToOne
    @JoinColumn(name="request_id", nullable=false)
    private Request request;

    private double donatedSum;
    private Timestamp timestamp;
    private boolean isSuccessful;

    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    @Column(unique = true)
    private String order_id;


    public Donation() {}

    public Donation(double donatedSum, User user, Request request, Timestamp timestamp) {
            this.donatedSum = donatedSum;
            this.timestamp = timestamp;
            this.user = user;
            this.request = request;
        }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Request getRequest() {
        return request;
    }

    public void setRequest(Request request) {
        this.request = request;
    }

    public double getDonatedSum() {
        return donatedSum;
    }

    public void setDonatedSum(double donatedSum) {
        this.donatedSum = donatedSum;
    }

    public boolean isSuccessful() {
        return isSuccessful;
    }

    public void setSuccessful(boolean successful) {
        isSuccessful = successful;
    }
}
