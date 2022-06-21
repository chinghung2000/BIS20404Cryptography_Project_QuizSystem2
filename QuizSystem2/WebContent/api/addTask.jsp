<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.io.File"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.reflect.TypeToken"%>
<%@ page import="com.google.gson.JsonSyntaxException"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException"%>
<%@ page import="com.project.backend.*"%>


<%
// create gson object (for JSON)
Gson gson = new Gson();

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
		
		// check whether Content-Type is 'multipart/form-data'
		if (request.getContentType().indexOf("multipart/form-data") == 0) {
			// perform parameter validation
			validate = true;
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Bad POST Request: Unsupported content-type: Content-type must be multipart/form-data");
		}
	} else {
		rc.put("error_code", 400);
		rc.put("description", "Bad Request: Bad POST Request: Undefined content-type");
	}
} else {
	rc.put("error_code", 405);
	rc.put("description", "Method Not Allowed: No POST request was received");
}


// create a HashMap of parameters
HashMap<String, Object> parameters = new HashMap<String, Object>();

// create a List of file items
List<FileItem> fileItems = null;


// parameter validation
if (validate) {
	
	// check session for lecturer
	if (session.getAttribute("user_id") != null && session.getAttribute("user_type").equals("lecturer")) {
		
		// definitions of DiskFileItemFactory, ServletFileUpload objects and variables
		int maxMemorySize = 100 * 1024 * 1024 ;	// 100 MB
		int maxFileSize = 100 * 1024 * 1024;	// 100 MB
		
		DiskFileItemFactory dfif = new DiskFileItemFactory();
		dfif.setSizeThreshold(maxMemorySize);
		dfif.setRepository(new File("C:\\JavaWebUploads\\QuizSystem\\temp\\"));
		ServletFileUpload upload = new ServletFileUpload(dfif);
		upload.setFileSizeMax(maxFileSize);
		
		// try parsing form-data into FileItems
		try {
			fileItems = upload.parseRequest(request);
		} catch (FileSizeLimitExceededException e) {
			System.out.println(e);
			rc.put("error_code", 400);
			rc.put("message", "File size can't be more than 100 MB");
			rc.put("description", "Bad Request: Bad POST Request: File size exceeds limit (100 MB)");
		} catch (Exception e) {
			System.out.println(e);
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: Bad POST Request: Unknown error");
		}
		
		// check whether fileItems is null or not
		if (fileItems != null) {
			
			// iteration to collect parameters
			Iterator<FileItem> i = fileItems.iterator();
			
			while (i.hasNext()) {
				FileItem fileItem = i.next();
				
				if (fileItem.isFormField()) {
					parameters.put(fileItem.getFieldName(), fileItem.getString());
				} else {
					parameters.put(fileItem.getFieldName(), fileItem.getName());
				}
			}
		}
		
		// validate parameter 'subject_id'
		if (parameters.containsKey("subject_id")) {
			if (!parameters.get("subject_id").equals("")) {
				if (((String) parameters.get("subject_id")).length() <= 8) {
					
					// validate parameter 'task_name'
					if (parameters.containsKey("task_name")) {
						if (!parameters.get("task_name").equals("")) {
							if (((String) parameters.get("task_name")).length() <= 50) {
								
								// validate parameter 'task_file'
								if (parameters.containsKey("task_file")) {
									// permit execution
									execute = true;
								} else {
									rc.put("error_code", 400);
									rc.put("description", "Bad Request: Parameter 'task_file' is required");
								}
							} else {
								rc.put("error_code", 400);
								rc.put("description", "Bad Request: 'task_name' length can't be more than 50");
							}
						} else {
							rc.put("error_code", 400);
							rc.put("description", "Bad Request: 'task_name' can't be empty");
						}
					} else {
						rc.put("error_code", 400);
						rc.put("description", "Bad Request: Parameter 'task_name' is required");
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
	Workload workload = lecturerUser.getWorkload(Integer.parseUnsignedInt((String) session.getAttribute("user_id")), (String) parameters.get("subject_id"));
	
	if (workload != null) {
		if (!parameters.get("task_file").equals("")) {
			int taskId = lecturerUser.addTask(workload.getId(), (String) parameters.get("task_name"), (String) parameters.get("task_file"),
					Integer.parseUnsignedInt((String) session.getAttribute("user_id")));
			
			if (taskId != -1) {
				String filePath = "C:\\JavaWebUploads\\QuizSystem\\uploads\\";
				
				// iteration to write files
				Iterator<FileItem> i = fileItems.iterator();
				
				while (i.hasNext()) {
					FileItem fileItem = i.next();
					
					if (!fileItem.isFormField()) {
						
						// check whether the field name is 'task_file'
						if (fileItem.getFieldName().equals("task_file")) {
							
							// check whether the file name is not empty string
							if (!fileItem.getName().equals("")) {
								
								// create workload folder if not exist
								File workloadFolder = new File(filePath + Integer.toString(workload.getId()) + "\\");
								if (!workloadFolder.exists()) workloadFolder.mkdir();
								
								// create task folder if not exist
								File taskFolder = new File(filePath + Integer.toString(workload.getId()) + "\\" + Integer.toString(taskId) + "\\");
								if (!taskFolder.exists()) taskFolder.mkdir();
								
								// create and write uploaded file into folder
								File file = new File(filePath + Integer.toString(workload.getId()) + "\\" + Integer.toString(taskId) + "\\" + fileItem.getName());
								fileItem.write(file);
							}
						}
					}
				}
				
				lecturerUser.addLogRecord("INSERT", "[" + sdf.format(new Date()) + "] Lecturer " + (String) session.getAttribute("user_id") +
						" added new task (Name: \"" + (String) parameters.get("task_name") + "\", File: \"" + (String) parameters.get("task_file") + "\")");
				
				rc.put("ok", true);
			} else {
				rc.put("error_code", 500);
				rc.put("description", "Internal Server Error: Database Error");
			}
		} else {
			rc.put("error_code", 400);
			rc.put("description", "Bad Request: File name can't be empty");
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