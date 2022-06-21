<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionUser.jsp"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="com.project.backend.*"%>


<%
// define logic control variables
boolean execute = false;


// check session for all user types
if (session.getAttribute("user_id") != null && session.getAttribute("user_type") != null) {
	
	// validate parameter 'subject_id'
	if (request.getParameter("subject_id") != null) {
		
		// validate parameter 'task_id'
		if (request.getParameter("task_id") != null) {
			boolean parseUnsignedIntError;
			
			// try to parse 'task_id' into unsigned integer
			try {
				Integer.parseUnsignedInt(request.getParameter("task_id"));
				parseUnsignedIntError = false;
			} catch (NumberFormatException e) {
				parseUnsignedIntError = true;
			}
			
			// check whether there are no error in parsing process
			if (!parseUnsignedIntError) {
				if (Integer.parseUnsignedInt(request.getParameter("task_id")) <= 2147483647) {
					
					// validate parameter 'submission_id' if exists
					if (request.getParameter("submission_id") != null) {
						
						// try to parse 'submission_id' into unsigned integer
						try {
							Integer.parseUnsignedInt(request.getParameter("submission_id"));
							parseUnsignedIntError = false;
						} catch (NumberFormatException e) {
							parseUnsignedIntError = true;
						}
						
						// check whether there are no error in parsing process
						if (!parseUnsignedIntError) {
							if (Integer.parseUnsignedInt(request.getParameter("submission_id")) <= 2147483647) {
								// permit execution
								execute = true;
							}
						}
					} else {
						// permit execution
						execute = true;
					}
				}
			}
		}
	}
}


if (execute) {
	String filePath = "C:\\JavaWebUploads\\QuizSystem\\uploads\\";
	
	if (session.getAttribute("user_type").equals("lecturer")) {
		Lecturer lecturerUser = new Lecturer();
		Workload workload = lecturerUser.getWorkload(Integer.parseUnsignedInt((String) session.getAttribute("user_id")), request.getParameter("subject_id"));
		
		if (workload != null) {
			Task task = lecturerUser.getTask(Integer.parseUnsignedInt(request.getParameter("task_id")), workload.getId());
			
			if (task != null) {
				if (request.getParameter("submission_id") != null) {
					Submission submission = lecturerUser.getSubmission(Integer.parseUnsignedInt(request.getParameter("submission_id")), task.getId());
					
					if (submission != null) {
						response.setContentType("application/octet-stream");
						response.setHeader("Content-Disposition", "attachment; filename=\"" + submission.getFileName() + "\"");
						FileInputStream fileInputStream = new FileInputStream(filePath + Integer.toString(workload.getId()) + "\\" + Integer.toString(task.getId()) + "\\" + submission.getStudent().getId() + "\\" + submission.getFileName());
						ServletOutputStream outStream = response.getOutputStream();
						
						byte[] outputByte = new byte[4096];
						
						while (fileInputStream.read(outputByte, 0, 4096) != -1) {
							outStream.write(outputByte, 0, 4096);
						}
						
						fileInputStream.close();
						outStream.flush();
						outStream.close();
					}
				} else {
					response.setContentType("application/octet-stream");
					response.setHeader("Content-Disposition", "attachment; filename=\"" + task.getFileName() + "\"");
					FileInputStream fileInputStream = new FileInputStream(filePath + Integer.toString(workload.getId()) + "\\" + Integer.toString(task.getId()) + "\\" + task.getFileName());
					ServletOutputStream outStream = response.getOutputStream();
					
					byte[] outputByte = new byte[4096];
					
					while (fileInputStream.read(outputByte, 0, 4096) != -1) {
						outStream.write(outputByte, 0, 4096);
					}
					
					fileInputStream.close();
					outStream.flush();
					outStream.close();
				}
			}
		}
	} else if (session.getAttribute("user_type").equals("student")) {
		Student studentUser = new Student();
		RegisteredSubject registeredSubject = studentUser.getRegisteredSubject((String) session.getAttribute("user_id"), request.getParameter("subject_id"));
		
		if (registeredSubject != null) {
			Task task = studentUser.getTask(Integer.parseUnsignedInt(request.getParameter("task_id")), registeredSubject.getWorkload().getId());
			
			if (task != null) {
				if (request.getParameter("submission_id") != null) {
					Submission submission = studentUser.getSubmission(Integer.parseUnsignedInt(request.getParameter("task_id")), (String) session.getAttribute("user_id"));
					
					if (submission != null) {
						if (submission.getId() == Integer.parseUnsignedInt(request.getParameter("submission_id"))) {
							response.setContentType("application/octet-stream");
							response.setHeader("Content-Disposition", "attachment; filename=\"" + submission.getFileName() + "\"");
							FileInputStream fileInputStream = new FileInputStream(filePath + Integer.toString(registeredSubject.getWorkload().getId()) + "\\" + Integer.toString(task.getId()) + "\\" + submission.getStudent().getId() + "\\" + submission.getFileName());
							ServletOutputStream outStream = response.getOutputStream();
							
							byte[] outputByte = new byte[4096];
							
							while (fileInputStream.read(outputByte, 0, 4096) != -1) {
								outStream.write(outputByte, 0, 4096);
							}
							
							fileInputStream.close();
							outStream.flush();
							outStream.close();
						}
					}
				} else {
					response.setContentType("application/octet-stream");
					response.setHeader("Content-Disposition", "attachment; filename=\"" + task.getFileName() + "\"");
					FileInputStream fileInputStream = new FileInputStream(filePath + Integer.toString(registeredSubject.getWorkload().getId()) + "\\" + Integer.toString(task.getId()) + "\\" + task.getFileName());
					ServletOutputStream outputStream = response.getOutputStream();
					
					byte[] outputByte = new byte[4096];
					
					while (fileInputStream.read(outputByte, 0, 4096) != -1) {
						outputStream.write(outputByte, 0, 4096);
					}
					
					fileInputStream.close();
					outputStream.flush();
					outputStream.close();
				}
			}
		}
	}
}
%>