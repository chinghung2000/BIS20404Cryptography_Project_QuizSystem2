<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionAdmin.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Workload Registration</title>
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
			XHRequest("getAllWorkloads", JSON.stringify({}), {callback: "loadTable"});
		} else {
			clearTable();
			
			var r = rc["result"];
			var tBody = $e("list").tBodies[0];
			var row, cell, span, button;
			
			for (var i in r) {
				row = tBody.insertRow();
				
				cell = row.insertCell();
				cell.innerHTML = Number(i) + 1;
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["lecturer_name"];
				span.setAttribute("style", "display: block;");
				span.setAttribute("data-lecturer-id", r[i]["lecturer_id"]);
				cell.appendChild(span);
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["subject_name"];
				span.setAttribute("style", "display: block;");
				span.setAttribute("data-subject-id", r[i]["subject_id"]);
				cell.appendChild(span);
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_by"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_on"];
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Update";
				button.setAttribute("onclick", "edit(this, '" + r[i]["workload_id"] + "');");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Delete";
				button.setAttribute("onclick", "remove('" + r[i]["workload_id"] + "');");
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
	
	var selectLecturer;
	
	function loadSelectionLecturer(rc = null) {
		if (rc == null) {
			XHRequest("getAllLecturers", JSON.stringify({}), {callback: "loadSelectionLecturer"});
		} else {
			var r = rc["result"];
			var select = $e("select-lecturer");
			var option;
			
			for (var i in r) {
				option = document.createElement("option");
				option.text = r[i]["lecturer_name"];
				option.value = r[i]["lecturer_id"];
				select.add(option);
			}
			
			selectLecturer = select;
		}
	}
	
	var selectSubject;
	
	function loadSelectionSubject(rc = null) {
		if (rc == null) {
			XHRequest("getAllSubjects", JSON.stringify({}), {callback: "loadSelectionSubject"});
		} else {
			var r = rc["result"];
			var select = $e("select-subject");
			var option;
			
			for (var i in r) {
				option = document.createElement("option");
				option.text = r[i]["subject_name"];
				option.value = r[i]["subject_id"];
				select.add(option);
			}
			
			selectSubject = select;
		}
	}
	
	function add(lecturerId, subjectId) {
		var d = {};
		d["lecturer_id"] = lecturerId;
		d["subject_id"] = subjectId;
		
		if (d["lecturer_id"] != "") {
			if (d["subject_id"] != "") {
				XHRequest("addWorkload", JSON.stringify(d), {async: false});
				loadTable();
				$e("select-lecturer").value = null;
				$e("select-subject").value = null;
			} else {
				$e("span-message").innerHTML = "Please choose a subject.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Please choose a lecturer.";
			clearMessage();
		}
	}
	
	function update(workloadId, lecturerId, subjectId) {
		var d = {};
		d["workload_id"] = workloadId;
		d["lecturer_id"] = lecturerId;
		d["subject_id"] = subjectId;
		
		if (d["workload_id"] != "") {
			if (d["lecturer_id"] != "") {
				if (d["subject_id"] != "") {
					XHRequest("updateWorkload", JSON.stringify(d), {async: false});
					loadTable();
				} else {
					$e("span-message").innerHTML = "Please choose a subject.";
					clearMessage();
				}
			} else {
				$e("span-message").innerHTML = "Please choose a lecturer.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Missing workload ID.";
			clearMessage();
		}
	}
	
	function remove(workloadId) {
		var d = {};
		d["workload_id"] = workloadId;
		
		if (confirm("Are you sure to delete the workload?") == true) {
			if (d["workload_id"] != "") {
				XHRequest("deleteWorkload", JSON.stringify(d), {async: false});
				loadTable();
			} else {
				$e("span-message").innerHTML = "Missing workload ID.";
				clearMessage();
			}
		}
	}
	
	function edit(element, workloadId) {
		var row = element.parentNode.parentNode;
		var cell, span, select, button;
		
		cell = row.cells[1];
		span = cell.childNodes[0];
		span.style.display = "none";
 		select = cell.appendChild(selectLecturer.cloneNode(true));
		select.value = span.getAttribute("data-lecturer-id");
		
		cell = row.cells[2];
		span = cell.childNodes[0];
		span.style.display = "none";
 		select = cell.appendChild(selectSubject.cloneNode(true));
		select.value = span.getAttribute("data-subject-id");
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Done";
		button.setAttribute("onclick", "update('" + workloadId + "', "
				+ "this.parentNode.parentNode.cells[1].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[2].childNodes[1].value);");
		
		cell = row.cells[6];
		button = cell.childNodes[0];
		button.innerHTML = "Cancel";
		button.setAttribute("onclick", "cancelEdit(this, '" + workloadId + "');");
	}
	
	function cancelEdit(element, workloadId) {
		var row = element.parentNode.parentNode;
		var cell, button;
		
		cell = row.cells[1];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[2];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[5];
		button = cell.childNodes[0];
		button.innerHTML = "Update";
		button.setAttribute("onclick", "edit(this, '" + workloadId + "');");
		
		cell = row.cells[6];
		button = cell.childNodes[0];
		button.innerHTML = "Delete";
		button.setAttribute("onclick", "remove('" + workloadId + "');");
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

select {
	min-width: 200px;
	font-family: verdana;
	font-size: 16px;
}

select:hover {
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
<body onload="loadUserInfo(); loadTable(); loadSelectionLecturer(); loadSelectionSubject();">
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
			<span class="title">Workload Registration</span>
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="content">
			<table id="list" border="1">
				<thead>
					<tr>
						<th>No</th>
						<th>Lecturer</th>
						<th>Subject</th>
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
						<td>
							<select id="select-lecturer">
								<option value="" selected>Select a lecturer</option>
							</select>
						</td>
						<td>
							<select id="select-subject">
								<option value="" selected>Select a subject</option>
							</select>
						</td>
						<td></td>
						<td></td>
						<td><button onclick="add($e('select-lecturer').value, $e('select-subject').value);">ADD</button></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</body>
</html>