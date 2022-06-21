package com.project.backend;

import java.util.ArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Admin extends User implements AdminInterface {
	protected int id;
	protected String password;
	protected String name;

	public Admin() {
		super();
	}

	public Admin(ResultSet rs) {
		try {
			this.id = rs.getInt("admin_id");
			this.name = rs.getString("admin_name");
		} catch (SQLException e) {
			System.out.println("Admin: There is an error: " + e.toString());
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

	@Override
	public ArrayList<Admin> getAllAdmins() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT admin_id, admin_name FROM admin;");
		ResultSet rs = db.executeQuery();
		ArrayList<Admin> admins = new ArrayList<Admin>();

		if (rs != null) {
			try {
				while (rs.next()) {
					admins.add(new Admin(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return admins;
	}

	@Override
	public Admin getAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT admin_id, admin_name FROM admin WHERE admin_id = ?;", adminId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Admin(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public boolean addAdmin(int adminId, String adminName) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("INSERT INTO admin (admin_id, password, admin_name) VALUES (?, ?, ?);", adminId,
				RandomHash.generate(Integer.toString(adminId), Integer.toString(adminId), "password"), adminName);
		return db.executeUpdate();
	}

	@Override
	public boolean updateAdmin(int oldAdminId, int adminId, String adminName) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("UPDATE admin SET admin_id = ?, password = ?, admin_name = ? WHERE admin_id = ?;", adminId,
				RandomHash.generate(Integer.toString(adminId), Integer.toString(adminId), "password"), adminName,
				oldAdminId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM admin WHERE admin_id = ?;", adminId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<Lecturer> getAllLecturers() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT l.lecturer_id, l.lecturer_name, a.admin_id, a.admin_name, l.modified_on FROM lecturer l INNER JOIN admin a ON l.modified_by = a.admin_id;");
		ResultSet rs = db.executeQuery();
		ArrayList<Lecturer> lecturers = new ArrayList<Lecturer>();

		if (rs != null) {
			try {
				while (rs.next()) {
					lecturers.add(new Lecturer(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return lecturers;
	}

	@Override
	public Lecturer getLecturer(int lecturerId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT l.lecturer_id, l.lecturer_name, a.admin_id, a.admin_name, l.modified_on FROM lecturer l INNER JOIN admin a ON l.modified_by = a.admin_id WHERE l.lecturer_id = ?;",
				lecturerId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Lecturer(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public boolean addLecturer(int lecturerId, String lecturerName, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO lecturer (lecturer_id, password, lecturer_name, modified_by, modified_on) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP());",
				lecturerId, RandomHash.generate(Integer.toString(lecturerId), Integer.toString(lecturerId), "password"),
				lecturerName, modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateLecturer(int oldLecturerId, int lecturerId, String lecturerName, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE lecturer SET lecturer_id = ?, password = ?, lecturer_name = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE lecturer_id = ?;",
				lecturerId, RandomHash.generate(Integer.toString(lecturerId), Integer.toString(lecturerId), "password"),
				lecturerName, modifiedBy, oldLecturerId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteLecturer(int lecturerId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM lecturer WHERE lecturer_id = ?;", lecturerId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<Subject> getAllSubjects() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT s.subject_id, s.subject_name, a.admin_id, a.admin_name, s.modified_on FROM subject s INNER JOIN admin a ON s.modified_by = a.admin_id;");
		ResultSet rs = db.executeQuery();
		ArrayList<Subject> subjects = new ArrayList<Subject>();

		if (rs != null) {
			try {
				while (rs.next()) {
					subjects.add(new Subject(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return subjects;
	}

	@Override
	public Subject getSubject(String subjectId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT s.subject_id, s.subject_name, a.admin_id, a.admin_name, s.modified_on FROM subject s INNER JOIN admin a ON s.modified_by = a.admin_id WHERE s.subject_id = ?;",
				subjectId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Subject(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public boolean addSubject(String subjectId, String subjectName, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO subject (subject_id, subject_name, modified_by, modified_on) VALUES (?, ?, ?, CURRENT_TIMESTAMP());",
				subjectId, subjectName, modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateSubject(String oldSubjectId, String subjectId, String subjectName, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE subject SET subject_id = ?, subject_name = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE subject_id = ?;",
				subjectId, subjectName, modifiedBy, oldSubjectId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteSubject(String subjectId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM subject WHERE subject_id = ?;", subjectId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<Workload> getAllWorkloads() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, a.admin_id, a.admin_name, w.modified_on FROM workload w INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id INNER JOIN admin a ON w.modified_by = a.admin_id;");
		ResultSet rs = db.executeQuery();
		ArrayList<Workload> workloads = new ArrayList<Workload>();

		if (rs != null) {
			try {
				while (rs.next()) {
					workloads.add(new Workload(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return workloads;
	}

	@Override
	public Workload getWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, a.admin_id, a.admin_name, w.modified_on FROM workload w INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id INNER JOIN admin a ON w.modified_by = a.admin_id WHERE w.workload_id = ?;",
				workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Workload(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
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
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public Workload getWorkload(int lecturerId, String subjectId, int exceptWorkloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT w.workload_id, l.lecturer_id, l.lecturer_name, s.subject_id, s.subject_name, a.admin_id, a.admin_name, w.modified_on FROM workload w INNER JOIN lecturer l ON w.lecturer_id = l.lecturer_id INNER JOIN subject s ON w.subject_id = s.subject_id INNER JOIN admin a ON w.modified_by = a.admin_id WHERE w.lecturer_id = ? AND w.subject_id = ? AND w.workload_id != ?;",
				lecturerId, subjectId, exceptWorkloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Workload(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public boolean addWorkload(int lecturerId, String subjectId, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO workload (lecturer_id, subject_id, modified_by, modified_on) VALUES (?, ?, ?, CURRENT_TIMESTAMP());",
				lecturerId, subjectId, modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateWorkload(int workloadId, int lecturerId, String subjectId, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE workload SET lecturer_id = ?, subject_id = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE workload_id = ?;",
				lecturerId, subjectId, modifiedBy, workloadId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM workload WHERE workload_id = ?;", workloadId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<Student> getAllStudents() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT s.student_id, s.student_name, s.student_email, a.admin_id, a.admin_name, s.modified_on FROM student s INNER JOIN admin a ON s.modified_by = a.admin_id;");
		ResultSet rs = db.executeQuery();
		ArrayList<Student> students = new ArrayList<Student>();

		if (rs != null) {
			try {
				while (rs.next()) {
					students.add(new Student(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return students;
	}

	@Override
	public Student getStudent(String studentId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"SELECT s.student_id, s.student_name, s.student_email, a.admin_id, a.admin_name, s.modified_on FROM student s INNER JOIN admin a ON s.modified_by = a.admin_id WHERE s.student_id = ?;",
				studentId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					return new Student(rs);
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return null;
	}

	@Override
	public boolean addStudent(String studentId, String studentName, String studentEmail, int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"INSERT INTO student (student_id, password, student_name, student_email, modified_by, modified_on) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP());",
				studentId, RandomHash.generate(studentId, studentId, "password"), studentName, studentEmail,
				modifiedBy);
		return db.executeUpdate();
	}

	@Override
	public boolean updateStudent(String oldStudentId, String studentId, String studentName, String studentEmail,
			int modifiedBy) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare(
				"UPDATE student SET student_id = ?, password = ?, student_name = ?, student_email = ?, modified_by = ?, modified_on = CURRENT_TIMESTAMP() WHERE student_id = ?;",
				studentId, RandomHash.generate(studentId, studentId, "password"), studentName, studentEmail, modifiedBy,
				oldStudentId);
		return db.executeUpdate();
	}

	@Override
	public boolean deleteStudent(String studentId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("DELETE FROM student WHERE student_id = ?;", studentId);
		return db.executeUpdate();
	}

	@Override
	public ArrayList<String> getSystemLogTypes() {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT DISTINCT type FROM log;");
		ResultSet rs = db.executeQuery();
		ArrayList<String> logTypes = new ArrayList<String>();

		if (rs != null) {
			try {
				while (rs.next()) {
					logTypes.add(rs.getString("type"));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return logTypes;
	}

	@Override
	public ArrayList<Log> getSystemLogs(int limit) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT log_id, type, description FROM log ORDER BY log_id DESC LIMIT ?;", limit);
		ResultSet rs = db.executeQuery();
		ArrayList<Log> logs = new ArrayList<Log>();

		if (rs != null) {
			try {
				while (rs.next()) {
					logs.add(new Log(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return logs;
	}

	@Override
	public ArrayList<Log> getSystemLogs(String type, int limit) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT log_id, type, description FROM log WHERE type = ? ORDER BY log_id DESC LIMIT ?;", type,
				limit);
		ResultSet rs = db.executeQuery();
		ArrayList<Log> logs = new ArrayList<Log>();

		if (rs != null) {
			try {
				while (rs.next()) {
					logs.add(new Log(rs));
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return logs;
	}

	@Override
	public boolean checkLecturerByAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM lecturer WHERE modified_by = ?;", adminId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkSubjectByAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM subject WHERE modified_by = ?;", adminId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkStudentByAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM student WHERE modified_by = ?;", adminId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkWorkloadByAdmin(int adminId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM workload WHERE modified_by = ?;", adminId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkWorkloadByLecturer(int lecturerId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM workload WHERE lecturer_id = ?;", lecturerId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkWorkloadBySubject(String subjectId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM workload WHERE subject_id = ?;", subjectId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkRegisteredSubjectByStudent(String studentId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM reg_subject WHERE student_id = ?;", studentId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkTaskByWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM task WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkQuizTFByWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM quiz_tf WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkQuizObjByWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM quiz_obj WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}

	@Override
	public boolean checkRegisteredSubjectByWorkload(int workloadId) {
		DatabaseManager db = new DatabaseManager(new MySQL().connect());

		db.prepare("SELECT COUNT(*) FROM reg_subject WHERE workload_id = ?;", workloadId);
		ResultSet rs = db.executeQuery();

		if (rs != null) {
			try {
				if (rs.next()) {
					if (rs.getInt(1) == 0)
						return true;
				}
			} catch (SQLException e) {
				System.out.println("Admin: There is an error: " + e.toString());
			}
		} else {
			System.out.println("Admin: Cannot retrieve result from database");
		}

		return false;
	}
}
