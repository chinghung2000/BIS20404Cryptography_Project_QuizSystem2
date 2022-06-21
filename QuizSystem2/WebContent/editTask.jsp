<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionLecturer.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Assignments / Tutorials / Labs</title>
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
			
			XHRequest("getAllTasks", JSON.stringify(d), {callback: "loadTable"});
		} else {
			clearTable();
			
			var r = rc["result"];
			var tBody = $e("list").tBodies[0];
			var row, cell, button;
			
			for (var i in r) {
				row = tBody.insertRow();
				
				cell = row.insertCell();
				cell.innerHTML = Number(i) + 1;
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["task_name"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["file_name"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_by"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_on"];
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Download";
				button.setAttribute("onclick", "location.href = 'download.jsp?subject_id=" + "<% out.print(request.getParameter("subject_id")); %>" + "&task_id=" + r[i]["task_id"] + "';");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "View";
				button.setAttribute("onclick", "location.href = 'viewSubmission.jsp?subject_id=" + "<% out.print(request.getParameter("subject_id")); %>" + "&task_id=" + r[i]["task_id"] + "';");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Delete";
				button.setAttribute("onclick", "remove('" + r[i]["task_id"] + "');");
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
	
	function add(taskName, files) {
		if (taskName != "") {
			if (files.length > 0) {
				var formData = new FormData();
				formData.append("subject_id", "<% out.print(request.getParameter("subject_id")); %>");
				formData.append("task_name", taskName);
				formData.append("task_file", files[0], files[0].name);
				
				$e("button-upload").innerHTML = "Uploading...";
				$e("button-upload").disabled = true;
				XHRFormData("addTask", formData, {async: false});
				$e("button-upload").innerHTML = "Upload";
				$e("button-upload").disabled = false;
				loadTable();
				$e("input-task-name").value = null;
				$e("input-upload-file").value = null;
			} else {
				$e("span-message").innerHTML = "Please select a file.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Please enter task name.";
			clearMessage();
		}
	}
	
	function remove(taskId) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["task_id"] = taskId;
		
		if (confirm("Are you sure to delete the task?") == true) {
			if (d["subject_id"] != "") {
				if (d["task_id"] != "") {
					XHRequest("deleteTask", JSON.stringify(d), {async: false});
					loadTable();
				} else {
					$e("span-message").innerHTML = "Missing task ID.";
					clearMessage();
				}
			} else {
				$e("span-message").innerHTML = "Missing subject ID.";
				clearMessage();
			}
		}
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

div.upload-area {
	margin: 10px 0px;
	padding: 10px;
}

label.upload-field {
	width: 240px;
	text-align: right;
	display: inline-block;
}

input[type=file] {
	border-radius: 5px;
	font-family: verdana;
	font-size: 16px;
	box-shadow: 0px 0px 2px 0px;
	cursor: pointer;
}

input[type=file]:hover {
	box-shadow: 0px 0px 0px 1px;
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
			<span class="title">Assignments / Tutorials / Labs</span>
		</div>
		<div class="info">
			Subject ID: <span id="span-subject-id"></span>
			<br>
			Subject Name: <span id="span-subject-name"></span>
		</div>
		<div class="message">
			<span class="message" id="span-message"></span>
		</div>
		<div class="upload-area">
			<label class="upload-field" for="input-task-name">Assignment / Tutorial / Lab:</label>
			<input type="text" id="input-task-name" style="width: 330px;">
			<br>
			<label class="upload-field" for="input-upload-file">Document:</label>
			<input type="file" id="input-upload-file">
			<button id="button-upload" onclick="add($e('input-task-name').value, $e('input-upload-file').files);">Upload</button>
		</div>
		<div class="content">
			<table id="list" border="1">
				<thead>
					<tr>
						<th>No</th>
						<th>Assignments / Tutorials / Labs</th>
						<th>File Name</th>
						<th>Modified By</th>
						<th>Modified On</th>
						<th>Content</th>
						<th>Submission</th>
						<th>Delete</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</body>
</html>