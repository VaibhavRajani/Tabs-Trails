package edu.syr.project.trelloclone.data.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import edu.syr.project.trelloclone.data.models.History;
import edu.syr.project.trelloclone.data.models.Task;
import edu.syr.project.trelloclone.data.models.User;
import edu.syr.project.trelloclone.data.models.UserTask;
import edu.syr.project.trelloclone.data.repository.HistoryRepository;
import edu.syr.project.trelloclone.data.repository.TaskRepository;
import edu.syr.project.trelloclone.data.repository.UserRepository;
import edu.syr.project.trelloclone.data.repository.UserTaskRepository;

//UserTaskService for implementing functions for usertask based api calls from UserTaskController

@Service
public class UserTaskService {

    @Autowired
    TaskRepository taskRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    UserTaskRepository userTaskRepository;

    @Autowired
    HistoryRepository historyRepository;


    public UserTask deleteUserTask(long userId, long taskId) throws Exception {
        User user = userRepository.findById(userId).
                orElseThrow(() -> new Exception("Not found Task with id = " + userId));

        Task task = taskRepository.findById(taskId).
                orElseThrow(() -> new Exception("Not found Task with id = " + taskId));

        //Creating history object to save the details of currently unassigned suer from a task in history table
        History history = new History();
        history.setTask(task);
        history.setChange_id(user.getUserId());
        history.setChange_id_type("User id");
        history.setChange_description("User " + userId + " unassigned from the task");
        history.setUpdated_on(task.getModified_on());
        historyRepository.save(history);
        userTaskRepository.deleteByUserAndTask(userId, taskId);
        return null;
    }

    // Assign a user to a task
    public UserTask assignUserToTask(long userId, long taskId) throws Exception {
        User assignUser = userRepository.findById(userId).orElseThrow(() -> new Exception("Not found Task with id = " + userId));
        Task assignTask = taskRepository.findById(taskId).orElseThrow(() -> new Exception("Not found Task with id = " + taskId));
        UserTask ut = new UserTask();

        ut.setTask(assignTask);
        ut.setUser(assignUser);

        //Creating history object to save the details of currently assigned user to a task in history table
        History createHistory = new History();
        createHistory.setTask(assignTask);
        createHistory.setChange_id(assignUser.getUserId());
        createHistory.setChange_id_type("User id");
        createHistory.setChange_description("User : " + assignUser.getName() + " , assigned to the task");
        createHistory.setUpdated_on(assignTask.getModified_on());
        historyRepository.save(createHistory);
        return userTaskRepository.save(ut);
    }


}

