package com.project.backend;

import java.sql.ResultSet;
import java.sql.SQLException;

public class Log {
	protected int id;
	protected String type;
	protected String description;

	public Log(ResultSet rs) {
		try {
			this.id = rs.getInt("log_id");
			this.type = rs.getString("type");
			this.description = rs.getString("description");
		} catch (SQLException e) {
			System.out.println("Log: There is an error: " + e.toString());
		}
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}
