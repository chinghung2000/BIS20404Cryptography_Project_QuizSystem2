<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.reflect.TypeToken"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%@ page import="com.project.backend.*"%>


<%
// create gson object (for JSON)
Gson gson = new Gson();

// create a HashMap of data ($d)
HashMap<String, Object> d = new HashMap<String, Object>();

// create a HashMap of response content ($rc)
HashMap<String, Object> rc = new HashMap<String, Object>();
rc.put("ok", false);

// define logic control variables
boolean validate = false;
boolean execute = false;


// check whether request method is 'POST'
if (request.getMethod().equals("POST")) {
	
	// check existence of Content-Type header
	if (request.getContentType() != null) {
		
		// check whether Content-Type is 'application/json'
		if (request.getContentType().equals("application/json")) {
			
			// read raw data from the request body
			BufferedReader br = request.getReader();
			String reqBody = br.readLine();
			br.close();
			
			// check whether request body is not null
			if (reqBody != null) {
				boolean JSONError;
				
				// try JSON parsing request body and convert into HashMap $d
				try {
					d = gson.fromJson(reqBody, new TypeToken<HashMap<String, Object>>() {}.getType());
					JSONError = false;
				} catch (JsonSyntaxException e) {
					JSONError = true;
				}
				
				// check whether there are no error in JSON parsing
				if (!JSONError) {
					// perform parameter validation
					validate = true;
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: Bad POST Request: Can't parse JSON object");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: Bad POST Request: Content is empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Bad POST Request: Unsupported content-type");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("description", "Bad Request: Bad POST Request: Undefined content-type");
	}
} else {
	rc.put("error_code", 405);
	rc.put("description", "Method Not Allowed: No POST request was received");
}


// create an ArrayList of HashMap of answers
ArrayList<HashMap<String, Object>> answers = null;


// parameter validation
if (validate) {
	
	// check session for student
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type").equals("student")) {
		
		// validate parameter 'subject_id'
		if (d.containsKey("subject_id")) {
			if (!d.get("subject_id").equals("")) {
				if (((String) d.get("subject_id")).length() <= 8) {
					
					// validate parameter 'answers'
					if (d.containsKey("answers")) {
						if (d.get("answers") instanceof ArrayList) {
							answers = gson.fromJson(((ArrayList<HashMap<String, Object>>) d.get("answers")).toString(), new TypeToken<ArrayList<HashMap<String, Object>>>() {}.getType());
							
							// permit execution
							execute = true;
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'answers' must be an array");
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'answers' is required");
					}
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: 'subject_id' length can't be more than 8");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'subject_id' can't be empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Parameter 'subject_id' is required");
		}
	} else {
		rc.put("redirect", "index.jsp");
		rc.put("error_code", 401);
		rc.put("description", "Unauthorized: Session not found or invalid session");
	}
}


// execution
if (execute) {
	SimpleDateFormat sdf = new SimpleDateFormat("d/M/yyyy h:mm:ss a");
	
	Student studentUser = new Student();
	RegisteredSubject registeredSubject = studentUser.getRegisteredSubject((String) session.getAttribute("user_id"), (String) d.get("subject_id"));
	
	if (registeredSubject != null) {
		if (registeredSubject.getQuizObjMark() == 0) {
			ArrayList<QuizObjective> quizObjectives = studentUser.getAllQuizObj(registeredSubject.getWorkload().getId());
			boolean loopError = false;
			int mark = 0;
			
			for (QuizObjective quizObjective: quizObjectives) {
				if (loopError) break;
				
				for (HashMap<String, Object> answer : answers) {
					if (answer.containsKey("quiz_obj_id")) {
						if (answer.get("quiz_obj_id") instanceof Double) {
							if (0 < (int) (double) answer.get("quiz_obj_id") && (int) (double) answer.get("quiz_obj_id") <= 2147483647) {
								ArrayList<String> allowedAnswer = new ArrayList<String>();
								Collections.addAll(allowedAnswer, "A", "B", "C", "D");
								
								if (allowedAnswer.contains(((String) answer.get("answer")).toUpperCase())) {
									if (quizObjective.getId() == (int) (double) answer.get("quiz_obj_id")) {
										if (Character.toString(quizObjective.getAnswer()).equals(answer.get("answer"))) {
											mark += 2;
										} else {
											mark -= 2;
										}
									}
								} else {
									rc.put("error_code", 400);
									rc.put("description", "Bad Request: Invalid value for 'answer'");
									loopError = true;
								}
							} else {
								rc.put("error_code", 400);
								rc.put("description", "Bad Request: 'quiz_obj_id' is out of range");
								loopError = true;
							}
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'quiz_obj_id' must be unsigned integer");
							loopError = true;
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'quiz_obj_id' is required for each member in 'answers'");
						loopError = true;
					}
				}
			}
			
			if (mark < 0) mark = 0;
			
			boolean ok = studentUser.updateQuizObjMark(registeredSubject.getId(), mark);
			
			if (ok) {
				studentUser.addLogRecord("ANSWER QUIZ", "[" + sdf.format(new Date()) + "] Student " + (String) session.getAttribute("user_id") +
						" took the quiz objective");
				
				rc.put("ok", true);
			} else {
				rc.put("error_code", 500);
				rc.put("description", "Internal Server Error: Database Error");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: The quiz is already taken. Cannot retake the quiz");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("description", "Bad Request: The corresponding registered subject doesn't exist");
	}
}


// check unknown error
if ((boolean) rc.get("ok") == false && rc.get("description") == null) {
	rc.put("error_code", 500);
	rc.put("description", "Internal Server Error: Unknown error found");
}


// echo JSON string of response content ($rc) 
out.println(gson.toJson(rc));
%>