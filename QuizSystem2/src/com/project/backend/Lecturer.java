package com.project.backend;

import java.util.ArrayList;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Lecturer extends User implements LecturerInterface {
	protected int id;
	protected String password;
	protected String name;
	protected Admin modifiedBy;
	protected Date modifiedOn;

	public Lecturer() {
		super();
	}

	public Lecturer(ResultSet rs) {
		try {
			this.id = rs.getInt("lecturer_id");
			this.name = rs.getString("lecturer_name");
			this.modifiedBy = new Admin();
			this.modifiedBy.id = rs.getInt("admin_id");
			this.modifiedBy.name = rs.getString("admin_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("Lecturer: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Admin getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(Admin modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public Date getModifiedOn() {
		return modifiedOn;
	}

	public void setModifiedOn(Date modifiedOn) {
		this.modifiedOn = modifiedOn;
	}

	@Override
	public ArrayList<Workload> getAllWorkloads(int lecturerId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, a.admin_id, a.admin_name, w.modified_on FROM workload w INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id INNER JOIN admin a ON w.modified_by = a.admin_id WHERE w.lecturer_id = ?;",
				lecturerId);
		ResultSet rs = db.executeQuery();
		ArrayList<Workload> workloads = new ArrayList<Workload>();

		if (rs != null) {
			try {
				while (rs.next()) {
					workloads.add(new Workload(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return workloads;
	}

	@Override
	public Workload getWorkload(int lecturerId, String subjectId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, a.admin_id, a.admin_name, w.modified_on FROM workload w INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id INNER JOIN admin a ON w.modified_by = a.admin_id WHERE w.lecturer_id = ? AND w.subject_id = ?;",
				lecturerId, subjectId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Workload(rs);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public ArrayList<Task> getAllTasks(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT t.task_id, t.workload_id, t.task_name, t.task_file_name, l.lecturer_id, l.lecturer_name, t.modified_on FROM task t INNER JOIN lecturer l ON t.modified_by = l.lecturer_id WHERE t.workload_id = ?;",
				workloadId);
		ResultSet rs = db.executeQuery();
		ArrayList<Task> tasks = new ArrayList<Task>();

		if (rs != null) {
			try {
				while (rs.next()) {
					tasks.add(new Task(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return tasks;
	}

	@Override
	public Task getTask(int taskId, int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT t.task_id, t.workload_id, t.task_name, t.task_file_name, l.lecturer_id, l.lecturer_name, t.modified_on FROM task t INNER JOIN lecturer l ON t.modified_by = l.lecturer_id WHERE t.task_id = ? AND t.workload_id = ?;",
				taskId, workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Task(rs);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public int addTask(int workloadId, String taskName, String fileName, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepareForGeneratedKey(
				"INSERT INTO task (workload_id, task_name, task_file_name, modified_by, modified_on) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP());",
				workloadId, taskName, fileName, modifiedBy);
		ResultSet rs = db.executeUpdateForGeneratedKey();

		if (rs != null) {
			try {
				if (rs.next()) {
					return rs.getInt(1);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return -1;
	}

	@Override
	public boolean deleteTask(int taskId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM task WHERE task_id = ?;", taskId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<Submission> getAllSubmissions(int taskId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT sn.submission_id, sn.task_id, s.student_id, s.student_name, sn.submission_file_name, sn.submission_file_hash FROM submission sn INNER JOIN student s ON sn.student_id = s.student_id WHERE sn.task_id = ?;",
				taskId);
		ResultSet rs = db.executeQuery();
		ArrayList<Submission> submissions = new ArrayList<Submission>();

		if (rs != null) {
			try {
				while (rs.next()) {
					submissions.add(new Submission(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return submissions;
	}

	@Override
	public Submission getSubmission(int submissionId, int taskId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT sn.submission_id, sn.task_id, s.student_id, s.student_name, sn.submission_file_name, sn.submission_file_hash FROM submission sn INNER JOIN student s ON sn.student_id = s.student_id WHERE sn.submission_id = ? AND sn.task_id = ?;",
				submissionId, taskId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Submission(rs);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public ArrayList<QuizTrueFalse> getAllQuizTF(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT q.quiz_tf_id, q.workload_id, q.question, q.answer, l.lecturer_id, l.lecturer_name, q.modified_on FROM quiz_tf q INNER JOIN lecturer l ON q.modified_by = l.lecturer_id WHERE q.workload_id = ?;",
				workloadId);
		ResultSet rs = db.executeQuery();
		ArrayList<QuizTrueFalse> quizTrueFalse = new ArrayList<QuizTrueFalse>();

		if (rs != null) {
			try {
				while (rs.next()) {
					quizTrueFalse.add(new QuizTrueFalse(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return quizTrueFalse;
	}

	@Override
	public QuizTrueFalse getQuizTF(int quizTFId, int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT q.quiz_tf_id, q.workload_id, q.question, q.answer, l.lecturer_id, l.lecturer_name, q.modified_on FROM quiz_tf q INNER JOIN lecturer l ON q.modified_by = l.lecturer_id WHERE q.quiz_tf_id = ? AND q.workload_id = ?;",
				quizTFId, workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new QuizTrueFalse(rs);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public int getQuizTFCount(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM quiz_tf WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return rs.getInt(1);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return -1;
	}

	@Override
	public boolean addQuizTF(int workloadId, String question, boolean answer, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO quiz_tf (workload_id, question, answer, modified_by, modified_on) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP());",
				workloadId, question, answer, modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateQuizTF(int quizTFId, String question, boolean answer, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE quiz_tf SET question = ?, answer = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE quiz_tf_id = ?;",
				question, answer, modifiedBy, quizTFId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteQuizTF(int quizTFId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM quiz_tf WHERE quiz_tf_id = ?;", quizTFId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<QuizObjective> getAllQuizObj(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT q.quiz_obj_id, q.workload_id, q.question, q.choice_a, q.choice_b, q.choice_c, q.choice_d, q.answer, l.lecturer_id, l.lecturer_name, q.modified_on FROM quiz_obj q INNER JOIN lecturer l ON q.modified_by = l.lecturer_id WHERE q.workload_id = ?;",
				workloadId);
		ResultSet rs = db.executeQuery();
		ArrayList<QuizObjective> quizObjective = new ArrayList<QuizObjective>();

		if (rs != null) {
			try {
				while (rs.next()) {
					quizObjective.add(new QuizObjective(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return quizObjective;
	}

	@Override
	public QuizObjective getQuizObj(int quizObjId, int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT q.quiz_obj_id, q.workload_id, q.question, q.choice_a, q.choice_b, q.choice_c, q.choice_d, q.answer, l.lecturer_id, l.lecturer_name, q.modified_on FROM quiz_obj q INNER JOIN lecturer l ON q.modified_by = l.lecturer_id WHERE q.quiz_obj_id = ?;",
				quizObjId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new QuizObjective(rs);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public int getQuizObjCount(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM quiz_obj WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return rs.getInt(1);
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return -1;
	}

	@Override
	public boolean addQuizObj(int workloadId, String question, String choiceA, String choiceB, String choiceC,
			String choiceD, char answer, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO quiz_obj (workload_id, question, choice_a, choice_b, choice_c, choice_d, answer, modified_by, modified_on) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP());",
				workloadId, question, choiceA, choiceB, choiceC, choiceD, answer, modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateQuizObj(int quizObjId, String question, String choiceA, String choiceB, String choiceC,
			String choiceD, char answer, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE quiz_obj SET question = ?, choice_a = ?, choice_b = ?, choice_c = ?, choice_d = ?, answer = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE quiz_obj_id = ?;",
				question, choiceA, choiceB, choiceC, choiceD, answer, modifiedBy, quizObjId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteQuizObj(int quizObjId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM quiz_obj WHERE quiz_obj_id = ?;", quizObjId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<RegisteredSubject> getAllRegisteredSubject(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT r.reg_subject_id, st.student_id, st.student_name, w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, r.quiz_tf_mark, r.quiz_obj_mark FROM reg_subject r INNER JOIN student st ON r.student_id = st.student_id INNER JOIN workload w ON r.workload_id = w.workload_id INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id WHERE r.workload_id = ?;",
				workloadId);
		ResultSet rs = db.executeQuery();
		ArrayList<RegisteredSubject> registeredSubjects = new ArrayList<RegisteredSubject>();

		if (rs != null) {
			try {
				while (rs.next()) {
					registeredSubjects.add(new RegisteredSubject(rs));
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return registeredSubjects;
	}

	@Override
	public boolean checkSubmissionByTask(int taskId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM submission WHERE task_id = ?;", taskId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Lecturer: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Lecturer: Cannot retrieve result from database");
		}

		return false;
	}
}
