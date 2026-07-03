package com.tap.dao;

import java.util.List;

import com.tap.model.User;

public interface UserDAO {

    int addUser(User user);

    User getUserById(int userId);

    List<User> getAllUsers();

    boolean updateUser(User user);

    boolean deleteUser(int userId);

    User getUserByEmail(String email);

    User validateUser(String email, String password);
}