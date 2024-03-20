package edu.syr.project.trelloclone.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import edu.syr.project.trelloclone.data.models.*;
import edu.syr.project.trelloclone.data.repository.UserTaskRepository;
import edu.syr.project.trelloclone.data.service.UserTaskService;

import java.util.List;

//UserTaskController for executing user based api calls
@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api")
public class UserTaskController
{
    @Autowired
    UserTaskService userTaskService;
    @Autowired
    UserTaskRepository userTaskRepository;


    //Get Operations

    //Get user task details with description for a specific user based on userId.
    @GetMapping("/getAllTasksOfUser/{userId}")
    public ResponseEntity<List<Object>> getUserTaskDetailsWithDescription(@PathVariable(value = "userId") Long userId) {
        List<Object> userTaskDetails = userTaskRepository.getAllTasksOfUser(userId);
        return new ResponseEntity<>(userTaskDetails, HttpStatus.OK);
    }
    // Get users associated with a specific task based on taskId.
    @GetMapping("/getAllUsersOfTask/{taskId}")
    public ResponseEntity<List<Object>> getAllUsersOfTask(@PathVariable(value = "taskId") Long taskId) {
        List<Object> userTaskDetails = userTaskRepository.getAllUsersOfTask(taskId);
        return new ResponseEntity<>(userTaskDetails, HttpStatus.OK);
    }

    //Returns userid,taskid and comments on the task
    @GetMapping("/getCommentsWithUserIdAndTaskId")
    public  ResponseEntity<List<Object>> getCommentsWithUserIdAndTaskId(){
        return new ResponseEntity<>(userTaskRepository.getCommentsWithUserIdAndTaskId(),HttpStatus.OK);
    }
    //Returns user name, user id, task description and taskid
    @GetMapping("/getUserTaskDetailsWithDescription")
    public ResponseEntity<List<Object>> getUserTaskDetailsWithDescription(){
        return new ResponseEntity<>(userTaskRepository.getUserTaskDetailsWithDescription(), HttpStatus.OK);
    }


    @RequestMapping(value="usertask/{userId}/{taskId}", method=RequestMethod.DELETE)
    @ResponseBody
    //@DeleteMapping("/{userId}/{taskId}")
    public ResponseEntity<HttpStatus> deleteUserTask(@PathVariable("userId") Long userId, @PathVariable("taskId") Long taskId) throws Exception {
        userTaskService.deleteUserTask(userId, taskId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //Post operations
    //Insert userId with the corresponding taskId in the userTask table
    @PostMapping("/usertask/{userId}/{taskId}")
    public ResponseEntity<UserTask> assignUserTask(@PathVariable(value = "userId") Long userId,@PathVariable(value="taskId") Long taskId) throws Exception {
        UserTask insertUserTask = userTaskService.assignUserToTask(userId,taskId);
        return (insertUserTask == null) ? new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR) : new ResponseEntity<>(insertUserTask, HttpStatus.CREATED);
    }


}
