<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionLecturer.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz (True/False)</title>
<script type="text/javascript" src="js/helper.js"></script>
<script type="text/javascript">
	function logout() {
		XHRequest("logout", JSON.stringify({}), {async: false});
		location.href = "index.jsp";
	}
	
	function loadUserInfo(rc = null) {
		if (rc == null) {
			XHRequest("getUserInfo", JSON.stringify({}), {callback: "loadUserInfo"});
		} else {
			$e("span-welcome-name").innerHTML = rc["name"];
		}
	}
	
	function loadWorkloadInfo(rc = null) {
		if (rc == null) {
			var d = {};
			d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
			
			XHRequest("getWorkloadInfo", JSON.stringify(d), {callback: "loadWorkloadInfo"});
		} else {
			$e("span-subject-id").innerHTML = rc["subject_id"];
			$e("span-subject-name").innerHTML = rc["subject_name"];
		}
	}
	
	function loadTable(rc = null) {
		if (rc == null) {
			var d = {};
			d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
			
			XHRequest("getAllQuizTF", JSON.stringify(d), {callback: "loadTable"});
		} else {
			clearTable();
			
			var r = rc["result"];
			var tBody = $e("list").tBodies[0];
			var row, cell, span, checkbox, button;
			
			for (var i in r) {
				row = tBody.insertRow();
				
				cell = row.insertCell();
				cell.innerHTML = Number(i) + 1;
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["question"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				checkbox = document.createElement("input");
				checkbox.type = "checkbox";
				checkbox.checked = r[i]["answer"];
				checkbox.disabled = true;
				cell.appendChild(checkbox);
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_by"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_on"];
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Update";
				button.setAttribute("onclick", "edit(this, '" + r[i]["quiz_tf_id"] + "');");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Delete";
				button.setAttribute("onclick", "remove('" + r[i]["quiz_tf_id"] + "');");
				cell.appendChild(button);
			}
		}
	}
	
	function clearTable() {
		var tBody = $e("list").tBodies[0];
		
		for (var i = tBody.rows.length; i > 0; i--) {
			tBody.deleteRow(0);
		}
	}
	
	function add(question, answer) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["question"] = question;
		d["answer"] = answer;
		
		if (d["question"] != "") {
			XHRequest("addQuizTF", JSON.stringify(d), {async: false});
			loadTable();
			$e("input-question").value = null;
			$e("input-answer").checked = false;
		} else {
			$e("span-message").innerHTML = "Please enter question.";
			clearMessage();
		}
	}
	
	function update(quizTFId, question, answer) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["quiz_tf_id"] = quizTFId;
		d["question"] = question;
		d["answer"] = answer;
		
		if (d["quiz_tf_id"] != "") {
			if (d["question"] != "") {
				XHRequest("updateQuizTF", JSON.stringify(d), {async: false});
				loadTable();
			} else {
				$e("span-message").innerHTML = "Please enter question.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Missing quiz true/false ID.";
			clearMessage();
		}
	}
	
	function remove(quizTFId) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["quiz_tf_id"] = quizTFId;
		
		if (confirm("Are you sure to delete the question?") == true) {
			if (d["quiz_tf_id"] != "") {
				XHRequest("deleteQuizTF", JSON.stringify(d), {async: false});
				loadTable();
			} else {
				$e("span-message").innerHTML = "Missing quiz true/false ID.";
				clearMessage();
			}
		}
	}
	
	function edit(element, quizTFId) {
		var row = element.parentNode.parentNode;
		var cell, span, input, checkbox, button;
		
		cell = row.cells[1];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[2];
		checkbox = cell.childNodes[0];
		checkbox.disabled = false;
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Done";
		button.setAttribute("onclick", "update('" + quizTFId + "', "
				+ "this.parentNode.parentNode.cells[1].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[2].childNodes[0].checked);");
		
		cell = row.cells[6];
		button = cell.childNodes[0];
		button.innerHTML = "Cancel";
		button.setAttribute("onclick", "cancelEdit(this, '" + quizTFId + "');");
	}
	
	function cancelEdit(element, quizTFId) {
		var row = element.parentNode.parentNode;
		var cell, checkbox, button;
		
		cell = row.cells[1];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[2];
		checkbox = cell.childNodes[0];
		checkbox.disabled = true;
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Update";
		button.setAttribute("onclick", "edit(this, '" + quizTFId + "');");
		
		cell = row.cells[6];
		button = cell.childNodes[0];
		button.innerHTML = "Delete";
		button.setAttribute("onclick", "remove('" + quizTFId + "');");
	}
	
	var t;
	
	function clearMessage() {
		clearTimeout(t);
		t = setTimeout(function () {
			$e("span-message").innerHTML = null;
		}, 5000);
	}
</script>
<style type="text/css">
body {
	font-family: verdana;
	font-size: 16px;
}

div.welcome-text {
	margin: 30px;
}

span.welcome-name {
	font-weight: bold;
}

div.menu {
	margin: 10px 30px;
	padding: 10px;
}

div.container {
	border: 2px solid;
	border-radius: 10px;
	margin: 0px 30px;
	padding: 10px;
	min-height: 500px;
}

div.title {
	margin: 10px 0px;
	padding: 10px;
}

span.title {
	font-size: 20px;
}

div.info {
	margin: 10px 0px;
	padding: 10px;
}

div.message {
	margin: 10px 0px;
	padding: 10px;
	height: 20px;
}

span.message {
	color: red;
}

div.content {
	margin: 10px 0px;
	padding: 10px;
}

table {
	border: 1px solid #bfbfbf;
	border-collapse: collapse;
}

table tr {
	height: 25px;
}

table th {
	background-color: #efefef;
	text-align: left;
}

table th, table td {
	border: 1px solid #bfbfbf;
	padding: 5px 10px;
	max-width: 400px;
}

input[type=text], [type=password] {
	width: 150px;
	font-family: verdana;
	font-size: 16px;
}

input[type=text]:hover, [type=password]:hover {
	outline: 1px solid;
}

input[type=checkbox] {
	height: 20px;
	width: 20px;
	cursor: pointer;
}

input[type=checkbox]:hover {
	outline: 1px solid;
}

div.button {
	margin: 10px 0px;
	text-align: center;
	display: block;
	position: absolute;
	left: 0px;
	right: 0px;
	bottom: 0px;
}

button {
	border-radius: 5px;
	font-family: verdana;
	font-size: 16px;
	box-shadow: 1px 1px 1px 0px;
	cursor: pointer;
}

button:hover {
	box-shadow: 0px 0px 1px 0px;
}
</style>
</head>
<body onload="loadUserInfo(); loadWorkloadInfo(); loadTable();">
	<div class="welcome-text">
		Welcome, <span class="welcome-name" id="span-welcome-name">Guest</span> !
	</div>
	<hr>
	<div class="menu">
		<a href="lecturer.jsp"><button>Home</button></a>
		<a href="workload.jsp"><button>View Workloads</button></a>
		<button onclick="logout();">Log Out</button>
	</div>
	<div class="container">
		<div class="title">
			<span class="title">Quiz (True/False)</span>
		</div>
		<div class="info">
			Subject ID: <span id="span-subject-id"></span>
			<br>
			Subject Name: <span id="span-subject-name"></span>
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="content">
			<table id="list" border="1">
				<thead>
					<tr>
						<th>No</th>
						<th>Question</th>
						<th>True?</th>
						<th>Modified By</th>
						<th>Modified On</th>
						<th>Update</th>
						<th>Delete</th>
					</tr>
				</thead>
				<tbody></tbody>
				<tfoot>
					<tr>
						<td></td>
						<td><input type="text" id="input-question"></td>
						<td><input type="checkbox" id="input-answer"></td>
						<td></td>
						<td></td>
						<td><button onclick="add($e('input-question').value, $e('input-answer').checked);">ADD</button></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</body>
</html>