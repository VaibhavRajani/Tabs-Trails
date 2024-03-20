package edu.syr.project.trelloclone.data.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import edu.syr.project.trelloclone.data.models.History;
import edu.syr.project.trelloclone.data.models.Task;
import edu.syr.project.trelloclone.data.repository.HistoryRepository;
import edu.syr.project.trelloclone.data.repository.TaskRepository;

import java.util.List;


@Service
public class HistoryService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private HistoryRepository historyRepository;

    // Retrieve history of a specific task
    public List<History> getHistoryOfTask(long taskId) throws Exception {
        // Check if the Task with provided ID exists
        if (!taskRepository.existsById(taskId)) {
            throw new Exception("could not find any Task with id = " + taskId);
        }
        // Retrieve the Task by ID
        Task findTask = taskRepository.findById(taskId)
                .orElseThrow(() -> new Exception("could not find any task with the id"));
        // Retrieve history associated with the Task
        List<History> taskHistory = historyRepository.findByTask(findTask);
        return taskHistory;
    }
}