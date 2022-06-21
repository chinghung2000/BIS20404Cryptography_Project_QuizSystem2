package com.project.backend;

import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisteredSubject {
	protected int id;
	protected Student student;
	protected Workload workload;
	protected int quizTFMark;
	protected int quizObjMark;

	public RegisteredSubject(ResultSet rs) {
		try {
			this.id = rs.getInt("reg_subject_id");
			this.student = new Student();
			this.student.id = rs.getString("student_id");
			this.student.name = rs.getString("student_name");
			this.workload = new Workload();
			this.workload.id = rs.getInt("workload_id");
			this.workload.lecturer = new Lecturer();
			this.workload.lecturer.id = rs.getInt("lecturer_id");
			this.workload.lecturer.name = rs.getString("lecturer_name");
			this.workload.subject = new Subject();
			this.workload.subject.id = rs.getString("subject_id");
			this.workload.subject.name = rs.getString("subject_name");
			this.quizTFMark = rs.getInt("quiz_tf_mark");
			this.quizObjMark = rs.getInt("quiz_obj_mark");
		} catch (SQLException e) {
			System.out.println("RegisteredSubject: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public Workload getWorkload() {
		return workload;
	}

	public void setWorkload(Workload workload) {
		this.workload = workload;
	}

	public int getQuizTFMark() {
		return quizTFMark;
	}

	public void setQuizTFMark(int quizTFMark) {
		this.quizTFMark = quizTFMark;
	}

	public int getQuizObjMark() {
		return quizObjMark;
	}

	public void setQuizObjMark(int quizObjMark) {
		this.quizObjMark = quizObjMark;
	}
}
