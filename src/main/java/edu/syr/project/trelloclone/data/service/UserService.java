package edu.syr.project.trelloclone.data.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import edu.syr.project.trelloclone.data.models.User;
import edu.syr.project.trelloclone.data.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;

//UserService for implementing functions for user based api calls from UserController
@Service
public class UserService {
    @Autowired
    UserRepository userRepository;

    // Get a user by their ID
    public User getUserById(long id) throws Exception {
        return userRepository.findById(id).orElseThrow(() -> new Exception("There's no user with id = " + id));
    }
    // Get a list of users with a specified user name, or all users if userName is null
    public List<User> getAllUsers(String userName){
        List<User> userNames = new ArrayList<User>();
        if (userName == null)
            userRepository.findAll().forEach(userNames::add);
        else
            userRepository.findByName(userName).forEach(userNames::add);
        return userNames;
    }

    // Delete a user by their ID
    public void deleteById(long id) {
        userRepository.deleteById(id);
    }

    // Update user information for a given user ID
    public User updateUser(long id, User user) throws Exception {
        User updateUser = userRepository.findById(id)
                .orElseThrow(() -> new Exception("There's no user with id = " + id));

        updateUser.setName(user.getName());
        return userRepository.save(updateUser);
    }
}
