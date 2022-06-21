package com.project.backend;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Submission {
	protected int id;
	protected Task task;
	protected Student student;
	protected String fileName;
	protected String fileHash;

	public Submission(ResultSet rs) {
		try {
			this.id = rs.getInt("submission_id");
			this.task = new Task();
			this.task.id = rs.getInt("task_id");
			this.student = new Student();
			this.student.id = rs.getString("student_id");
			this.student.name = rs.getString("student_name");
			this.fileName = rs.getString("submission_file_name");
			this.fileHash = rs.getString("submission_file_hash");
		} catch (SQLException e) {
			System.out.println("Submission: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Task getTask() {
		return task;
	}

	public void setTask(Task task) {
		this.task = task;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileHash() {
		return fileHash;
	}

	public void setFileHash(String fileHash) {
		this.fileHash = fileHash;
	}
}
