package edu.syr.project.trelloclone.data.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

//Comment table to save user comments on task
@Entity
@Table(name="comment")
public class Comment {

    //Primary key id for each user comment
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    //Saving taskId as a foreign key, with ManytoOne relation as many user can have comments for a task
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "taskId", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Task task;

    //Saving userId as a foreign key, with ManytoOne relation as a single user can have many comments for a task
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "userId", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private User user;

    //Comment field for user comments
    @Lob
    private String Comment;


    //default constructor
    public Comment() {
    }

    //Getter and Setter methods for the fields
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public String getComment() {
        return Comment;
    }

    public void setComment(String comment) {
        Comment = comment;
    }
}
