<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
String userId = session.getAttribute("user_id") != null ? (String) session.getAttribute("user_id") : null;
String userType = session.getAttribute("user_type") != null ? (String) session.getAttribute("user_type") : null;

if (userId != null && userType != null) {
	response.sendRedirect(userType + ".jsp");
} else {
	if (request.getServletPath().equals("/checkSession.jsp")) {
		response.sendRedirect("index.jsp");
	}
}
%>