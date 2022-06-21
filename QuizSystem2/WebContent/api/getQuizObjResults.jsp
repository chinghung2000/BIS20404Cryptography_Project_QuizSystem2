<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.BufferedReader"%>
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
					// permit execution
					execute = true;
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
	ArrayList<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
	HashMap<String, Object> quizTFResultDict;
	
	Lecturer lecturerUser = new Lecturer();
	Workload workload = lecturerUser.getWorkload(Integer.parseUnsignedInt((String) session.getAttribute("user_id")), (String) d.get("subject_id"));
	
	if (workload != null) {
		ArrayList<RegisteredSubject> registeredSubjects = lecturerUser.getAllRegisteredSubject(workload.getId());
		
		for (RegisteredSubject registeredSubject: registeredSubjects) {
			quizTFResultDict = new HashMap<String, Object>();
			quizTFResultDict.put("student_id", registeredSubject.getStudent().getId());
			quizTFResultDict.put("student_name", registeredSubject.getStudent().getName());
			quizTFResultDict.put("mark", registeredSubject.getQuizObjMark());
			result.add(quizTFResultDict);
		}
		
		int quizObjCount = lecturerUser.getQuizObjCount(workload.getId());
		
		if (quizObjCount > 0) {
			int totalMark = quizObjCount * 2;
			int passingMark = totalMark / 2;
			rc.put("passing_mark", passingMark);
		}
		
		rc.put("result", result);
		rc.put("ok", true);
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