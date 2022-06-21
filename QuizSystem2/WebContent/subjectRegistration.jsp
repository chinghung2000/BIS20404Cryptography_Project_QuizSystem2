<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionAdmin.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Subject Registration</title>
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
	
	function loadTable(rc = null) {
		if (rc == null) {
			XHRequest("getAllSubjects", JSON.stringify({}), {callback: "loadTable"});
		} else {
			clearTable();
			
			var r = rc["result"];
			var tBody = $e("list").tBodies[0];
			var row, cell, span, button;
			
			for (var i in r) {
				row = tBody.insertRow();
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["subject_id"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["subject_name"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_by"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_on"];
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Update";
				button.setAttribute("onclick", "edit(this, '" + r[i]["subject_id"] + "');");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Delete";
				button.setAttribute("onclick", "remove('" + r[i]["subject_id"] + "');");
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
	
	function add(subjectId, subjectName) {
		var d = {};
		d["subject_id"] = subjectId;
		d["subject_name"] = subjectName;
		
		if (d["subject_id"] != "") {
			if (d["subject_name"] != "") {
				XHRequest("addSubject", JSON.stringify(d), {async: false});
				loadTable();
				$e("input-subject-id").value = null;
				$e("input-subject-name").value = null;
			} else {
				$e("span-message").innerHTML = "Please enter subject name.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Please enter subject ID.";
			clearMessage();
		}
	}
	
	function update(oldSubjectId, subjectId, subjectName) {
		var d = {};
		d["old_subject_id"] = oldSubjectId;
		d["subject_id"] = subjectId;
		d["subject_name"] = subjectName;
		
		if (d["old_subject_id"] != "") { 
			if (d["subject_id"] != "") {
				if (d["subject_name"] != "") {
					XHRequest("updateSubject", JSON.stringify(d), {async: false});
					loadTable();
				} else {
					$e("span-message").innerHTML = "Please enter subject name.";
					clearMessage();
				}
			} else {
				$e("span-message").innerHTML = "Please enter subject ID.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Missing current subject ID.";
			clearMessage();
		}
	}
	
	function remove(subjectId) {
		var d = {};
		d["subject_id"] = subjectId;
		
		if (confirm("Are you sure to delete subject with ID '" + subjectId + "'?") == true) {
			if (d["subject_id"] != "") {
				XHRequest("deleteSubject", JSON.stringify(d), {async: false});
				loadTable();
			} else {
				$e("span-message").innerHTML = "Missing subject ID.";
				clearMessage();
			}
		}
	}
	
	function edit(element, subjectId) {
		var row = element.parentNode.parentNode;
		var cell, span, input, button;
		
		cell = row.cells[0];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		input.maxLength = 8;
		cell.appendChild(input);
		
		cell = row.cells[1];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		input.maxLength = 30;
		cell.appendChild(input);
		
		cell = row.cells[4];
		button = cell.childNodes[0];
		button.innerHTML = "Done";
		button.setAttribute("onclick", "update('" + subjectId + "', this.parentNode.parentNode.cells[0].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[1].childNodes[1].value);");
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Cancel";
		button.setAttribute("onclick", "cancelEdit(this, '" + subjectId + "');");
	}
	
	function cancelEdit(element, subjectId) {
		var row = element.parentNode.parentNode;
		var cell, button;
		
		cell = row.cells[0];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[1];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[4];
		button = cell.childNodes[0];
		button.innerHTML = "Update";
		button.setAttribute("onclick", "edit(this, '" + subjectId + "');");
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Delete";
		button.setAttribute("onclick", "remove('" + subjectId + "');");
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
<body onload="loadUserInfo(); loadTable();">
	<div class="welcome-text">
		Welcome, <span class="welcome-name" id="span-welcome-name">Guest</span> !
	</div>
	<hr>
	<div class="menu">
		<a href="admin.jsp"><button>Home</button></a>
		<a href="adminRegistration.jsp"><button>Admin Registration</button></a>
		<a href="lecturerRegistration.jsp"><button>Lecturer Registration</button></a>
		<a href="subjectRegistration.jsp"><button>Subject Registration</button></a>
		<a href="workloadRegistration.jsp"><button>Workload Registration</button></a>
		<a href="studentRegistration.jsp"><button>Student Registration</button></a>
		<a href="systemLog.jsp"><button>View Log</button></a>
		<button onclick="logout();">Log Out</button>
	</div>
	<div class="container">
		<div class="title">
			<span class="title">Subject Registration</span>
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="content">
			<table id="list" border="1">
				<thead>
					<tr>
						<th>Subject ID</th>
						<th>Subject Name</th>
						<th>Modified By</th>
						<th>Modified On</th>
						<th>Update</th>
						<th>Delete</th>
					</tr>
				</thead>
				<tbody></tbody>
				<tfoot>
					<tr>
						<td><input type="text" id="input-subject-id" maxlength="8"></td>
						<td><input type="text" id="input-subject-name" style="width: 300px;" maxlength="30"></td>
						<td></td>
						<td></td>
						<td><button onclick="add($e('input-subject-id').value, $e('input-subject-name').value);">ADD</button></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</body>
</html>