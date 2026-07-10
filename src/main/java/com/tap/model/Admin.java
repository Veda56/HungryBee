package com.tap.model;

public class Admin {

    private int adminId;
    private String adminName;
    private String email;
    private String password;

    public Admin() {
    }

    public Admin(String adminName, String email, String password) {
        this.adminName = adminName;
        this.email = email;
        this.password = password;
    }

    public Admin(int adminId, String adminName, String email, String password) {
        this.adminId = adminId;
        this.adminName = adminName;
        this.email = email;
        this.password = password;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "Admin [adminId=" + adminId + ", adminName=" + adminName + ", email=" + email + "]";
    }
}
