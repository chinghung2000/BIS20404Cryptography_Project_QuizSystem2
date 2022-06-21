package com.project.backend;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class QuizObjective {
	protected int id;
	protected Workload workload;
	protected String question;
	protected String choiceA;
	protected String choiceB;
	protected String choiceC;
	protected String choiceD;
	protected char answer;
	protected Lecturer modifiedBy;
	protected Date modifiedOn;

	public QuizObjective(ResultSet rs) {
		try {
			this.id = rs.getInt("quiz_obj_id");
			this.workload = new Workload();
			this.workload.id = rs.getInt("workload_id");
			this.question = rs.getString("question");
			this.choiceA = rs.getString("choice_a");
			this.choiceB = rs.getString("choice_b");
			this.choiceC = rs.getString("choice_c");
			this.choiceD = rs.getString("choice_d");
			this.answer = rs.getString("answer").charAt(0);
			this.modifiedBy = new Lecturer();
			this.modifiedBy.id = rs.getInt("lecturer_id");
			this.modifiedBy.name = rs.getString("lecturer_name");
			this.modifiedOn = new Date(rs.getTimestamp("modified_on").getTime());
		} catch (SQLException e) {
			System.out.println("QuizObjective: There is an error: " + e.toString());
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

	public String getChoiceA() {
		return choiceA;
	}

	public void setChoiceA(String choiceA) {
		this.choiceA = choiceA;
	}

	public String getChoiceB() {
		return choiceB;
	}

	public void setChoiceB(String choiceB) {
		this.choiceB = choiceB;
	}

	public String getChoiceC() {
		return choiceC;
	}

	public void setChoiceC(String choiceC) {
		this.choiceC = choiceC;
	}

	public String getChoiceD() {
		return choiceD;
	}

	public void setChoiceD(String choiceD) {
		this.choiceD = choiceD;
	}

	public char getAnswer() {
		return answer;
	}

	public void setAnswer(char answer) {
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
