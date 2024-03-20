package edu.syr.project.trelloclone.data.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import edu.syr.project.trelloclone.data.models.Comment;
import edu.syr.project.trelloclone.data.models.Task;
import edu.syr.project.trelloclone.data.models.User;
import edu.syr.project.trelloclone.data.models.UserTask;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.repository.query.Param;

import javax.transaction.Transactional;
import java.util.List;

public interface UserTaskRepository extends JpaRepository<UserTask, Long> {

    //Returns  taskId and userId with the specified task details
    List<Comment> findByTask(Task task);

    //Returns  taskId and userId with the specified user details
    List<Comment> findByUser(User user);


    //Returns user name, taskid, task description
    @Query(value = "SELECT DISTINCT team10.user.name, team10.usertask.task_id AS user_task_id, team10.task.description " +
            "FROM team10.usertask " +
            "INNER JOIN team10.user ON team10.user.user_id = team10.usertask.user_id " +
            "INNER JOIN team10.task ON team10.task.task_id = team10.usertask.task_id " +
            "WHERE team10.usertask.user_id = ?1",
            nativeQuery = true)
    List<Object> getAllTasksOfUser(Long userId);

    //Returns user id,user name
    @Query(value = "SELECT DISTINCT team10.usertask.user_id AS user_user_id, team10.user.name " +
            "FROM team10.usertask " +
            "INNER JOIN team10.user ON team10.user.user_id = team10.usertask.user_id " +
            "INNER JOIN team10.task ON team10.task.task_id = team10.usertask.task_id " +
            "WHERE team10.usertask.task_id = ?1",
            nativeQuery = true)
    List<Object> getAllUsersOfTask(Long taskId);


    //Deletes taskId and userId with the specified task details
    @Transactional
    UserTask deleteByTask(Task task);

    //Deletes taskId and userId with the specified user details
    @Transactional
    void deleteByUser(User user);

    @Transactional
    @Modifying
    @Query(value ="DELETE FROM team10.usertask ut WHERE ut.user_id = ?1 AND ut.task_id = ?2",
            nativeQuery = true)
    void deleteByUserAndTask(Long userId, Long taskId);

    //Returns user name, user id, task description and taskid
    @Query(value = "SELECT DISTINCT team10.user.name,team10.usertask.user_id,team10.task.description," +
            "team10.usertask.task_id FROM team10.usertask \n" +
            "INNER JOIN team10.user On \n" +
            "team10.user.user_id = team10.usertask.user_id \n" +
            "INNER JOIN team10.task ON\n" +
            " team10.task.task_id = team10.usertask.task_id;",
            nativeQuery = true)
    List<Object> getUserTaskDetailsWithDescription();

    //Returns userid,taskid and comments on the task
    @Query(value = "SELECT DISTINCT team10.usertask.user_id,\n" +
            "            team10.usertask.task_id,team10.comment.comment FROM team10.usertask\n" +
            "            INNER JOIN team10.comment On \n" +
            "\t\tteam10.usertask.user_id = team10.comment.user_id \n" +
            "            INNER JOIN team10.task ON\n" +
            "\t\tteam10.usertask.task_id = team10.comment.task_id;",nativeQuery = true)
    List<Object> getCommentsWithUserIdAndTaskId();


}
