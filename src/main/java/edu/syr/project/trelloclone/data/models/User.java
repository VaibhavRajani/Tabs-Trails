package edu.syr.project.trelloclone.data.models;

import javax.persistence.*;

//User table to save user details
@Entity
@Table(name="user")
public class User {

    //userId as primary key to have a id for each user
    @Id
    @Column(name = "userId")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private long userId;

    //name field to save User's name
    @Column(name = "name")
    private String name;

    //Default user constructor
    public User() {
    }

    //Getter and setter methods for the fields
    public User(String name) {
        this.name = name;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long id) {
        this.userId = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
