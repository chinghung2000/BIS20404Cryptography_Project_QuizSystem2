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
					validate= true;
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
	
	// check session for all user types
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type") != null) {
		
		// validate parameter 'npassword'
		if (d.containsKey("npassword")) {
			if (!d.get("npassword").equals("")) {
				if (((String) d.get("npassword")).length() <= 16) {
					
					// validate parameter 'cpassword'
					if (d.containsKey("cpassword")) {
						if (!d.get("cpassword").equals("")) {
							if (((String) d.get("cpassword")).length() <= 16) {
								
								// check if 'npassword' == 'cpassword'
								if (d.get("npassword").equals(d.get("cpassword"))) {
									// permit execution
									execute = true;
								} else {
									rc.put("error_code", 400);
									rc.put("message", "Password didn't match.");
									rc.put("description", "Bad Request: 'npassword' and 'cpassword' didn't match");
								}
							} else {
								rc.put("error_code", 400);
								rc.put("description", "Bad Request: 'cpassword' length can't be more than 16");
							}
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'cpassword' can't be empty");
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'cpassword' is required");
					}
				} else {
					rc.put("error_code", 400);
					rc.put("description", "Bad Request: 'npassword' length can't be more than 16");
				}
			} else {
				rc.put("error_code", 400);
				rc.put("description", "Bad Request: 'npassword' can't be empty");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Parameter 'npassword' is required");
		}
	} else {
		rc.put("redirect", "index.jsp");
		rc.put("error_code", 401);
		rc.put("description", "Unauthorized: Session not found");
	}
}


// execution
if (execute) {
	SimpleDateFormat sdf = new SimpleDateFormat("d/M/yyyy hh:mm:ss a");
	
	User user = new User();
	boolean ok = user.updatePassword((String) session.getAttribute("user_type"), (String) session.getAttribute("user_id"), (String) d.get("npassword"));
	
	if (ok) {
		if (session.getAttribute("user_type").equals("admin")) {
			user.addLogRecord("UPDATE PASSWORD", "[" + sdf.format(new Date()) + "] Admin " + (String) session.getAttribute("user_id") +
					" updated the password");
		} else if (session.getAttribute("user_type").equals("lecturer")) {
			user.addLogRecord("UPDATE PASSWORD", "[" + sdf.format(new Date()) + "] Lecturer " + (String) session.getAttribute("user_id") +
					" updated the password");
		} else if (session.getAttribute("user_type").equals("student")) {
			user.addLogRecord("UPDATE PASSWORD", "[" + sdf.format(new Date()) + "] Student " + (String) session.getAttribute("user_id") +
					" updated the password");
		}
		
		session.invalidate();
		rc.put("landing", "index.jsp");
		rc.put("ok", true);
	} else {
		rc.put("error_code", 500);
		rc.put("description", "Internal Server Error: Database Error");
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