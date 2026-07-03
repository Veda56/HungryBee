package com.tap.model;

import java.sql.Timestamp;

public class User {

    private int userId;
    private String name;
    private String password;
    private String email;
    private String address;
    private String role;
    private Timestamp createdDate;
    private Timestamp lastLoginDate;

    public User() {
    }

    // Constructor without userId
    public User(String name, String password, String email,
                String address, String role,
                Timestamp createdDate, Timestamp lastLoginDate) {

        this.name = name;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
    }

    // Constructor with userId
    public User(int userId, String name, String password,
                String email, String address, String role,
                Timestamp createdDate, Timestamp lastLoginDate) {

        this.userId = userId;
        this.name = name;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Timestamp lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    @Override
    public String toString() {
        return "User [userId=" + userId +
                ", name=" + name +
                ", email=" + email +
                ", role=" + role + "]";
    }
}