<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
String userId = session.getAttribute("user_id") != null ? (String) session.getAttribute("user_id") : null;
String userType = session.getAttribute("user_type") != null ? (String) session.getAttribute("user_type") : null;

if (userId == null || userType == null) {
	response.sendRedirect("index.jsp");
} else {
	if (request.getServletPath().equals("/checkSessionUser.jsp")) {
		response.sendRedirect("index.jsp");
	}
}
%>