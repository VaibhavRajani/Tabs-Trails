package edu.syr.project.trelloclone.data.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import edu.syr.project.trelloclone.data.models.*;
import edu.syr.project.trelloclone.data.repository.CommentRepository;
import edu.syr.project.trelloclone.data.repository.HistoryRepository;
import edu.syr.project.trelloclone.data.repository.TaskRepository;
import edu.syr.project.trelloclone.data.repository.UserRepository;

import java.time.LocalDateTime;
import java.util.List;

//CommentService for implementing functions for comment based api calls from CommentController
@Service
public class CommentService {
    @Autowired
    private TaskRepository taskRepository;
    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private HistoryRepository historyRepository;

    // Get all comments by a specific user
    public List<Comment> getAllCommentsByUserId(long userId) throws Exception {
        if (!userRepository.existsById(userId)) {
            throw new Exception("Not found User with id = " + userId);
        }
        User findUser = userRepository.findById(userId).orElseThrow(()-> new Exception("Not found"));

        List<Comment> getComments = commentRepository.findByUser(findUser);
        return getComments;
    }
    // Get a comment by its ID
    public Comment getCommentsByCommentId(Long id) throws Exception {
        return commentRepository.findById(id).orElseThrow(() -> new Exception("Not found Comment with id = " + id));
    }
    // Get all comments for a specific task
    public  List<Comment> getAllCommentsByTaskId(long taskId) throws Exception {
        if (!taskRepository.existsById(taskId)) {
            throw new Exception("Not found Task with id = " + taskId);
        }
        Task findTask = taskRepository.findById(taskId)
                .orElseThrow(() -> new Exception("Not found"));

        List<Comment> allComments = commentRepository.findByTask(findTask);
        return allComments;
    }

    // Create a new comment for a specific task
    public Comment createComment(long taskId, CommentSchema commentRequest) throws Exception {
        User user = userRepository.findById(commentRequest.userId).
                orElseThrow(() -> new Exception("Not found User with id = " + commentRequest.userId));
        Comment com = new Comment();
        com.setComment(commentRequest.comment);
        com.setUser(user);
        Comment newComment = taskRepository.findById(taskId).map(task -> {
            com.setTask(task);
            return commentRepository.save(com);
        }).orElseThrow(() -> new Exception("Not found Task with id = " + taskId));
        Task fnd_task = taskRepository.findById(taskId)
                .orElseThrow(() -> new Exception("Not found Task with id = " + taskId));
        //Creating history object to save the details of comment added by user on a task in history table
        History createHistory = new History();
        createHistory.setTask(fnd_task);
        createHistory.setChange_id(com.getId());
        createHistory.setChange_id_type("Comment id");
        createHistory.setChange_description("Comment added by " + user.getName() + " : " + com.getComment());
        createHistory.setUpdated_on(LocalDateTime.now());
        historyRepository.save(createHistory);
        return newComment;
    }

    // Delete all comments associated with a specific task
    public void deleteByTask(Long taskId) throws Exception {
        if (!taskRepository.existsById(taskId)) {
            throw new Exception("Not found Task with id = " + taskId);
        }
        Task getTask = taskRepository.findById(taskId).orElseThrow(() -> new Exception("Not found Task with id = " + taskId));
        commentRepository.deleteByTask(getTask);
    }
    // Delete all comments by a specific user
    public void deleteByUser(Long userId) throws Exception {
        if (!userRepository.existsById(userId)) {
            throw new Exception("Not found User with id = " + userId);
        }
        User findUser = userRepository.findById(userId).orElseThrow(() -> new Exception("Not found Task with id = " + userId));

        commentRepository.deleteByUser(findUser);
    }
    // Delete a specific comment by its ID
    public void deleteComment(long id) throws Exception {
        Comment find_comment = commentRepository.findById(id)
                .orElseThrow(() -> new Exception("Not found comment with id = " + id));

        Task getTask = taskRepository.findById(find_comment.getTask().getTaskId())
                .orElseThrow(() -> new Exception("Not found Task for this comment"));

        //Creating history object to save the details of currently removed comment on a task in history table

        History createHistory = new History();
        createHistory.setTask(getTask);
        createHistory.setChange_id(find_comment.getId());
        createHistory.setChange_id_type("Comment id");
        createHistory.setChange_description("Comment deleted : " + find_comment.getComment() + "by user : " + find_comment.getUser().getName());
        createHistory.setUpdated_on(LocalDateTime.now());
        historyRepository.save(createHistory);
        commentRepository.deleteById(id);
    }
}
