package com.project.backend;

import java.util.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class QuizTrueFalse {
	protected int id;
	protected Workload workload;
	protected String question;
	protected boolean answer;
	protected Lecturer modifiedBy;
	protected Date modifiedOn;

	public QuizTrueFalse(ResultSet rs) {
		try {
			this.id = rs.getInt("quiz_tf_id");
			this.workload = new Workload();
			this.workload.id = rs.getInt("workload_id");
			this.question = rs.getString("question");
			this.answer = rs.getBoolean("answer");
			this.modifiedBy = new Lecturer();
			this.modifiedBy.id = rs.getInt("lecturer_id");
			this.modifiedBy.name = rs.getString("lecturer_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("QuizTrueFalse: There is an error: " + e.toString());
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

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public boolean getAnswer() {
		return answer;
	}

	public void setAnswer(boolean answer) {
		this.answer = answer;
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
