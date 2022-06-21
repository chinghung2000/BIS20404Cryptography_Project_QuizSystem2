<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
String userId = session.getAttribute("user_id") != null ? (String) session.getAttribute("user_id") : null;
String userType = session.getAttribute("user_type") != null ? (String) session.getAttribute("user_type") : null;

if (userId == null || userType == null || !userType.equals("student")) {
	response.sendRedirect("index.jsp");
} else {
	if (request.getServletPath().equals("/checkSessionStudent.jsp")) {
		response.sendRedirect("index.jsp");
	} else if (request.getServletPath().equals("/task.jsp")) {
		if (request.getParameter("subject_id") == null) {
			response.sendRedirect("subject.jsp");
		}
	} else if (request.getServletPath().equals("/submission.jsp")) {
		if (request.getParameter("subject_id") == null || request.getParameter("task_id") == null) {
			response.sendRedirect("subject.jsp");
		}
	} else if (request.getServletPath().equals("/quizTF.jsp")) {
		if (request.getParameter("subject_id") == null) {
			response.sendRedirect("subject.jsp");
		}
	} else if (request.getServletPath().equals("/quizObj.jsp")) {
		if (request.getParameter("subject_id") == null) {
			response.sendRedirect("subject.jsp");
		}
	}
}
%>