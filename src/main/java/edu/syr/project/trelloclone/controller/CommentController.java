package edu.syr.project.trelloclone.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import edu.syr.project.trelloclone.data.models.*;
import edu.syr.project.trelloclone.data.repository.CommentRepository;
import edu.syr.project.trelloclone.data.repository.HistoryRepository;
import edu.syr.project.trelloclone.data.repository.TaskRepository;
import edu.syr.project.trelloclone.data.repository.UserRepository;
import edu.syr.project.trelloclone.data.service.CommentService;

import java.time.LocalDateTime;
import java.util.List;

//TaskController for executing comment based api calls
@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api")
public class CommentController {

    @Autowired
    private CommentService commentService;

    //Post operation
    //Insert comment for the given taskId in the comment table
    @PostMapping("/task/{taskId}/comments")
    public ResponseEntity<Comment> createComment(@PathVariable(value = "taskId") Long taskId,
                                                 @RequestBody CommentSchema commentRequest) throws Exception {
        Comment insertComment = commentService.createComment(taskId,commentRequest);
        return (insertComment == null) ? new ResponseEntity<>(insertComment, HttpStatus.INTERNAL_SERVER_ERROR) : new ResponseEntity<>(insertComment, HttpStatus.CREATED);
    }


    //Get Operations
    //Get all task comments for the given taskId from the comment table
    @GetMapping("/task/{taskId}/comments")
    public ResponseEntity<List<Comment>> getAllCommentsByTaskId(@PathVariable(value = "taskId") Long taskId) throws Exception {
        List<Comment> allComments = commentService.getAllCommentsByTaskId(taskId);
        return (allComments == null) ? new ResponseEntity<>(allComments, HttpStatus.NOT_FOUND) : new ResponseEntity<>(allComments, HttpStatus.OK);
    }
    //Get the comment with the given commentId from the comment table
    @GetMapping("/comments/{id}")
    public ResponseEntity<Comment> getCommentsByCommentId(@PathVariable(value = "id") Long id) throws Exception {
        Comment commentsWithId = commentService.getCommentsByCommentId(id);
        return (commentsWithId == null) ? new ResponseEntity<>(commentsWithId, HttpStatus.NOT_FOUND) : new ResponseEntity<>(commentsWithId, HttpStatus.OK);
    }
    //Get all user comments for the given userId from the comment table
    @GetMapping("/user/{userId}/comments")
    public ResponseEntity<List<Comment>> getAllCommentsByUserId(@PathVariable(value = "userId") Long userId) throws Exception {
        List<Comment> commentsWithUserId = commentService.getAllCommentsByUserId(userId);
        return (commentsWithUserId == null) ? new ResponseEntity<>(commentsWithUserId, HttpStatus.NOT_FOUND) : new ResponseEntity<>(commentsWithUserId, HttpStatus.OK);
    }

    //Delete Operations
    //Delete comments for the user with the given userId from the comments table
    @DeleteMapping("/user/{userId}/comments")
    public ResponseEntity<List<Comment>> deleteAllCommentsOfUser(@PathVariable(value = "userId") Long userId) throws Exception {
        commentService.deleteByUser(userId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    //Delete comments for the task with the given taskId from the comments table
    @DeleteMapping("/task/{taskId}/comments")
    public ResponseEntity<List<Comment>> deleteAllCommentsOfTask(@PathVariable(value = "taskId") Long taskId) throws Exception {
        commentService.deleteByTask(taskId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    //Delete the comment with the given commentId from the comments table
    @DeleteMapping("/comments/{id}")
    public ResponseEntity<HttpStatus> deleteComment(@PathVariable("id") long id) throws Exception {
        commentService.deleteComment(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
