package com.project.backend;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Task {
	protected int id;
	protected Workload workload;
	protected String name;
	protected String fileName;
	protected Lecturer modifiedBy;
	protected Date modifiedOn;

	public Task() {

	}

	public Task(ResultSet rs) {
		try {
			this.id = rs.getInt("task_id");
			this.workload = new Workload();
			this.workload.id = rs.getInt("workload_id");
			this.name = rs.getString("task_name");
			this.fileName = rs.getString("task_file_name");
			this.modifiedBy = new Lecturer();
			this.modifiedBy.id = rs.getInt("lecturer_id");
			this.modifiedBy.name = rs.getString("lecturer_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("Task: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Workload getWorkload() {
		return workload;
	}

	public void setWorkload(Workload workload) {
		this.workload = workload;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Lecturer getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(Lecturer modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public Date getModifiedOn() {
		return modifiedOn;
	}

	public void setModifiedOn(Date modifiedOn) {
		this.modifiedOn = modifiedOn;
	}
}
