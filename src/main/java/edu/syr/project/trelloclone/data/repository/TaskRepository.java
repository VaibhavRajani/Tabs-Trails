package edu.syr.project.trelloclone.data.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.RestController;
import edu.syr.project.trelloclone.data.models.Task;

@RestController
public interface TaskRepository extends JpaRepository<Task, Long> {

    //Returns all task in the specified state
    Task findTaskByTaskId(Long id);
}
