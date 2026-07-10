package com.tap.dao;

import com.tap.model.Admin;

public interface AdminDAO {
    Admin validateAdmin(String email, String password);
    boolean updatePassword(int adminId, String newHashedPassword);
}
