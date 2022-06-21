package com.project.backend;

import java.util.ArrayList;

public interface StudentInterface {
	ArrayList<Workload> getAllWorkloads();

	Workload getWorkload(int workloadId);

	ArrayList<RegisteredSubject> getAllRegisteredSubjects(String studentId);

	RegisteredSubject getRegisteredSubject(String studentId, String subjectId);

	boolean addRegisteredSubject(String studentId, int workloadId);

	ArrayList<Task> getAllTasks(int workloadId);

	Task getTask(int taskId, int workloadId);

	Submission getSubmission(int taskId, String studentId);

	int addSubmission(int taskId, String studentId, String fileName);

	boolean insertSubmissionFileHash(int submissionId, String filePath);

	boolean deleteSubmission(int submissionId);

	ArrayList<QuizTrueFalse> getAllQuizTF(int workloadId);

	boolean updateQuizTFMark(int registeredSubjectId, int quizTFMark);

	ArrayList<QuizObjective> getAllQuizObj(int workloadId);

	boolean updateQuizObjMark(int registeredSubjectId, int quizObjMark);
}
