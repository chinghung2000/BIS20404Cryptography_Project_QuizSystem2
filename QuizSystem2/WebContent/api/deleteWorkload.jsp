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
	
	// check session for admin
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type").equals("admin")) {
		
		// validate parameter 'workload_id'
		if (d.containsKey("workload_id")) {
			if (!d.get("workload_id").equals("")) {
				boolean parseUnsignedIntError;
				
				// try to parse 'workload_id' into unsigned integer
				try {
					Integer.parseUnsignedInt((String) d.get("workload_id"));
					parseUnsignedIntError = false;
				} catch (NumberFormatException e) {
					parseUnsignedIntError = true;
				}
				
				// check whether there are no error in parsing process
				if (!parseUnsignedIntError) {
					if (Integer.parseUnsignedInt((String) d.get("workload_id")) <= 2147483647) {
						// permit execution
						execute = true;
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: 'workload_id' is out of range");
					}
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: 'workload_id' must be an unsigned integer");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'workload_id' can't be empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Parameter 'workload_id' is required");
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
	
	Admin adminUser = new Admin();
	Workload workload = adminUser.getWorkload(Integer.parseUnsignedInt((String) d.get("workload_id")));
	
	if (workload != null) {
		boolean checkTask = adminUser.checkTaskByWorkload(workload.getId());
		boolean checkQuizTF = adminUser.checkQuizTFByWorkload(workload.getId());
		boolean checkQuizObj = adminUser.checkQuizObjByWorkload(workload.getId());
		boolean checkRegisteredSubject = adminUser.checkRegisteredSubjectByWorkload(workload.getId());
		
		if (checkTask && checkQuizTF && checkQuizObj && checkRegisteredSubject) {
			boolean ok = adminUser.deleteWorkload(Integer.parseUnsignedInt((String) d.get("workload_id")));
			
			if (ok) {
				adminUser.addLogRecord("DELETE", "[" + sdf.format(new Date()) + "] Admin " + (String) session.getAttribute("user_id") +
						" deleted workload (ID: \"" + Integer.toString(workload.getId()) + "\", Lecturer ID: \"" +
						Integer.toString(workload.getLecturer().getId()) + "\", Subject ID: \"" + workload.getSubject().getId() + "\")");
				
				rc.put("ok", true);
			} else {
				rc.put("error_code", 500);
				rc.put("description", "Internal Server Error: Database Error");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("message", "Cannot delete workload which has been used in tasks, quizzes and being registered by any student.");
			rc.put("description", "Bad Request: Cannot delete workload which has been used in tasks, quizzes and being registered by any student");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("message", "The workload doesn't exist.");
		rc.put("description", "Bad Request: The workload doesn't exist");
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