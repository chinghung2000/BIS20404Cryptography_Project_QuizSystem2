package com.project.backend;

import java.util.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Workload {
	protected int id;
	protected Lecturer lecturer;
	protected Subject subject;
	protected Admin modifiedBy;
	protected Date modifiedOn;

	public Workload() {
		super();
	}

	public Workload(ResultSet rs) {
		try {
			this.id = rs.getInt("workload_id");
			this.lecturer = new Lecturer();
			this.lecturer.id = rs.getInt("lecturer_id");
			this.lecturer.name = rs.getString("lecturer_name");
			this.subject = new Subject();
			this.subject.id = rs.getString("subject_id");
			this.subject.name = rs.getString("subject_name");
			this.modifiedBy = new Admin();
			this.modifiedBy.id = rs.getInt("admin_id");
			this.modifiedBy.name = rs.getString("admin_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("Workload: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Lecturer getLecturer() {
		return lecturer;
	}

	public void setLecturer(Lecturer lecturer) {
		this.lecturer = lecturer;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
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
}
