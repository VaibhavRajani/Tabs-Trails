package edu.syr.project.trelloclone.data.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import edu.syr.project.trelloclone.data.models.*;

import javax.transaction.Transactional;
import java.util.List;


public interface HistoryRepository extends JpaRepository<History,Long> {

    //Returns the history of a task
    List<History> findByTask(Task task);

    @Transactional
    void deleteByTask(Task task);
}