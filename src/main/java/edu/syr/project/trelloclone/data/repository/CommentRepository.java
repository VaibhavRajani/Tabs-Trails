package edu.syr.project.trelloclone.data.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import edu.syr.project.trelloclone.data.models.Comment;
import edu.syr.project.trelloclone.data.models.Task;
import edu.syr.project.trelloclone.data.models.User;

import javax.transaction.Transactional;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {

    //Returns all comments of a user with the specified task
    List<Comment> findByTask(Task task);

    //Returns all comments of a task with the specified user details
    List<Comment> findByUser(User user);

    //deletes all Comments of a Task specified by taskId
    @Transactional
    void deleteByTask(Task task);

    //deletes all Comments of a User specified by userId
    @Transactional
    void deleteByUser(User user);

}
