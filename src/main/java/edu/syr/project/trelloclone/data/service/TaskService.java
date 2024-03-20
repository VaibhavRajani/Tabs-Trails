package edu.syr.project.trelloclone.data.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import edu.syr.project.trelloclone.data.models.History;
import edu.syr.project.trelloclone.data.models.Task;
import edu.syr.project.trelloclone.data.repository.HistoryRepository;
import edu.syr.project.trelloclone.data.repository.TaskRepository;
import edu.syr.project.trelloclone.data.repository.UserRepository;
import edu.syr.project.trelloclone.data.repository.UserTaskRepository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

//TaskService for implementing functions for task based api calls from TaskController
@Service
public class TaskService {
    @Autowired
    TaskRepository taskRepository;
    @Autowired
    HistoryRepository historyRepository;
    // Create a new task
    public Task createTask(Task task){
        Task createTask = taskRepository.save(new Task(task.getState(), task.getDescription()));
        //Creating history object to save the details of currently added task in history table
        History createHistory = new History();
        createHistory.setTask(createTask);
        createHistory.setChange_id(createTask.getTaskId());
        createHistory.setChange_id_type("Task id");
        createHistory.setChange_description("Task Inserted");
        createHistory.setUpdated_on(createTask.getModified_on());
        historyRepository.save(createHistory);
        return  createTask;
    }
    // Delete a task by its ID
    public void deleteTask(long id) throws Exception {
        taskRepository.deleteById(id);
    }

    // Update the state of a task
    public Task updateTaskState(Task task, Long id) throws Exception {
        Task findTask = taskRepository.findById(id).orElseThrow(() -> new Exception("Not found Task with id = " + id));
        //Creating history object to save the details of currently changed task state in history table
        History createHistory = new History();
        createHistory.setTask(findTask);
        createHistory.setChange_id(findTask.getTaskId());
        createHistory.setChange_id_type("Task id");
        createHistory.setChange_description("Task state updated from : " + findTask.getState() +" to : "
                + task.getState());
        findTask.setState(task.getState());
        findTask.setModified_on(LocalDateTime.now());
        createHistory.setUpdated_on(findTask.getModified_on());
        historyRepository.save(createHistory);
        return findTask;
    }
    // Update the description of a task
    public Task updateTaskDescription(Task task, long id) throws Exception {
        Task findTask = taskRepository.findById(id)
                .orElseThrow(() -> new Exception("Not found Task with id = " + id));
        //Creating history object to save the details of currently changed task description in history table
        History creaHistory = new History();
        creaHistory.setTask(findTask);
        creaHistory.setChange_id(findTask.getTaskId());
        creaHistory.setChange_id_type("Task id");
        findTask.setDescription(task.getDescription());
        creaHistory.setChange_description("Task description updated to : "+ findTask.getDescription());
        findTask.setModified_on(LocalDateTime.now());
        creaHistory.setUpdated_on(findTask.getModified_on());
        historyRepository.save(creaHistory);
        taskRepository.save(findTask);
        return findTask;
    }

    // Get a list of all tasks
    public List<Task> getAllTasks(){
        List<Task> allTasks = new ArrayList<Task>();
        taskRepository.findAll().forEach(allTasks::add);
        return  allTasks;
    }
    // Find a task by its ID
    public Task findById(long id) throws Exception {
        return taskRepository.findTaskByTaskId(id);
    }

}
