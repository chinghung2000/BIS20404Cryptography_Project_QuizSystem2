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
boolean execute = true;


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
		
		// validate parameter 'type' if exists
		if (d.containsKey("type")) {
			if (((String) d.get("type")).length() > 15) {
				// deny execution
				execute = false;
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'type' length can't be more than 15");
			}
		}
		
		// validate parameter 'limit' if exists
		if (d.containsKey("limit")) {
			if (!(d.get("limit") instanceof Double)) {
				// deny execution
				execute = false;
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'limit' must be an unsigned integer");
			} else if (0 < (int) (double) d.get("limit") && (int) (double) d.get("limit") > 2147483647) {
				// deny execution
				execute = false;
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'limit' is out of range");
			}
		}
	} else {
		rc.put("redirect", "index.jsp");
		rc.put("error_code", 401);
		rc.put("description", "Unauthorized: Session not found or invalid session");
	}
}


// execution
if (execute) {
	ArrayList<String> result = new ArrayList<String>();
	
	Admin adminUser = new Admin();
	ArrayList<Log> logs;
	
	int limit = 50;
	if (d.containsKey("limit")) limit = (int) (double) d.get("limit");
	
	if (!d.containsKey("type") || d.get("type").equals("")) {
		logs = adminUser.getSystemLogs(limit);
	} else {
		logs = adminUser.getSystemLogs((String) d.get("type"), limit);
	}
	
	for (Log log : logs) {
		result.add(log.getDescription());
	}
	
	rc.put("result", result);
	rc.put("ok", true);
}


// check unknown error
if ((boolean) rc.get("ok") == false && rc.get("description") == null) {
	rc.put("error_code", 500);
	rc.put("description", "Internal Server Error: Unknown error found");
}


// echo JSON string of response content ($rc) 
out.println(gson.toJson(rc));
%>