package edu.syr.project.trelloclone.data.models;

import javax.persistence.*;
import java.time.LocalDateTime;

// Define an enum for task states
enum TaskState {
    TODO, DOING, DONE;
}

@Entity
@Table(name = "task")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "taskId")
    private long taskId;

    // Use the TaskState enum for the state field
    @Enumerated(EnumType.STRING)
    @Column(name = "state")
    private TaskState state;

    @Column(name = "description")
    private String description;

    @Column(name = "toc")
    private LocalDateTime toc;

    @Column(name = "modified_on")
    private LocalDateTime modified_on;

    public Task() {
    }

    public Task(TaskState state, String description) {
        this.state = state;
        this.description = description;
        this.toc = LocalDateTime.now();
        this.modified_on = LocalDateTime.now();
    }

    public long getTaskId() {
        return taskId;
    }

    public void setTaskId(long id) {
        this.taskId = id;
    }

    public TaskState getState() {
        return state;
    }

    public void setState(TaskState state) {
        this.state = state;
    }

    public LocalDateTime getModified_on() {
        return modified_on;
    }

    public void setModified_on(LocalDateTime modified_on) {
        this.modified_on = modified_on;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getToc() {
        return toc;
    }

    public void setToc(LocalDateTime toc) {
        this.toc = toc;
    }
}
