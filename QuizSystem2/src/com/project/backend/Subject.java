package com.project.backend;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class Subject {
	protected String id;
	protected String name;
	protected Admin modifiedBy;
	protected Date modifiedOn;

	public Subject() {

	}

	public Subject(ResultSet rs) {
		try {
			this.id = rs.getString("subject_id");
			this.name = rs.getString("subject_name");
			this.modifiedBy = new Admin();
			this.modifiedBy.id = rs.getInt("admin_id");
			this.modifiedBy.name = rs.getString("admin_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("Subject: There is an error: " + e.toString());
		}
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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
}
