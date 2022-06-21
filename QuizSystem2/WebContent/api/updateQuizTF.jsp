<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
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


// parameter validation
if (validate) {
	
	// check session for lecturer
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type").equals("lecturer")) {
		
		// validate parameter 'subject_id'
		if (d.containsKey("subject_id")) {
			if (!d.get("subject_id").equals("")) {
				if (((String) d.get("subject_id")).length() <= 8) {
					
					// validate parameter 'quiz_tf_id'
					if (d.containsKey("quiz_tf_id")) {
						if (!d.get("quiz_tf_id").equals("")) {
							boolean parseUnsignedIntError;
							
							// try to parse 'quiz_tf_id' into unsigned integer
							try {
								Integer.parseUnsignedInt((String) d.get("quiz_tf_id"));
								parseUnsignedIntError = false;
							} catch (NumberFormatException e) {
								parseUnsignedIntError = true;
							}
							
							// check whether there are no error in parsing process
							if (!parseUnsignedIntError) {
								if (Integer.parseUnsignedInt((String) d.get("quiz_tf_id")) <= 2147483647) {
									
									// validate parameter 'question'
									if (d.containsKey("question")) {
										if (!d.get("question").equals("")) {
											
											// validate parameter 'answer'
											if (d.containsKey("answer")) {
												if (!d.get("answer").equals("")) {
													if (d.get("answer") instanceof Boolean) {
														// permit execution
														execute = true;
													} else {
														rc.put("error_code", 400);
														rc.put("description", "Bad Request: Invalid value for 'answer'");
													}
												} else {
													rc.put("error_code", 400);
													rc.put("description", "Bad Request: 'answer' can't be empty");
												}
											} else {
												rc.put("error_code", 400);
												rc.put("description", "Bad Request: Parameter 'answer' is required");
											}
										} else {
											rc.put("error_code", 400);
											rc.put("description", "Bad Request: 'question' can't be empty");
										}
									} else {
										rc.put("error_code", 400);
										rc.put("description", "Bad Request: Parameter 'question' is required");
									}
								} else {
									rc.put("error_code", 400);
									rc.put("description", "Bad Request: 'quiz_tf_id' is out of range");
								}
							} else {
								rc.put("error_code", 400);
								rc.put("description", "Bad Request: 'quiz_tf_id' must be an unsigned integer");
							}
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'quiz_tf_id' can't be empty");
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'quiz_tf_id' is required");
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
	SimpleDateFormat sdf = new SimpleDateFormat("d/M/yyyy hh:mm:ss a");
	
	Lecturer lecturerUser = new Lecturer();
	Workload workload = lecturerUser.getWorkload(Integer.parseUnsignedInt((String) session.getAttribute("user_id")), (String) d.get("subject_id"));
	
	if (workload != null) {
		QuizTrueFalse quizTrueFalse = lecturerUser.getQuizTF(Integer.parseUnsignedInt((String) d.get("quiz_tf_id")), workload.getId());
		
		if (quizTrueFalse != null) {
			boolean ok = lecturerUser.updateQuizTF(quizTrueFalse.getId(), (String) d.get("question"), (boolean) d.get("answer"),
					Integer.parseUnsignedInt((String) session.getAttribute("user_id")));
			
			if (ok) {
				lecturerUser.addLogRecord("UPDATE", "[" + sdf.format(new Date()) + "] Lecturer " + (String) session.getAttribute("user_id") +
						" updated quiz true/false question");
				
				rc.put("ok", true);
			} else {
				rc.put("error_code", 500);
				rc.put("description", "Internal Server Error: Database Error");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: The corresponding quiz true/false doesn't exist");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("description", "Bad Request: The corresponding workload doesn't exist");
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