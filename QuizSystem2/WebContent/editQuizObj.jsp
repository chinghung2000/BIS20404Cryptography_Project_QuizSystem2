<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="checkSessionLecturer.jsp"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz (Objective)</title>
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
	
	var selectAnswer = document.createElement("select");
	var option = document.createElement("option");
	var options = ["A", "B", "C", "D"];
	selectAnswer.disabled = true;
	
	for (var i = 0; i < options.length; i++) {
		option.text = options[i];
		option.value = options[i];
		selectAnswer.add(option.cloneNode(true));
	}
	
	function loadTable(rc = null) {
		if (rc == null) {
			var d = {};
			d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
			
			XHRequest("getAllQuizObj", JSON.stringify(d), {callback: "loadTable"});
		} else {
			clearTable();
			
			var r = rc["result"];
			var tBody = $e("list").tBodies[0];
			var row, cell, span, select, button;
			
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
				span = document.createElement("span");
				span.innerHTML = r[i]["choice_a"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["choice_b"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["choice_c"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				span = document.createElement("span");
				span.innerHTML = r[i]["choice_d"];
				span.setAttribute("style", "display: block;");
				cell.appendChild(span);
				
				cell = row.insertCell();
				select = cell.appendChild(selectAnswer.cloneNode(true));
				select.value = r[i]["answer"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_by"];
				
				cell = row.insertCell();
				cell.innerHTML = r[i]["modified_on"];
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Update";
				button.setAttribute("onclick", "edit(this, '" + r[i]["quiz_obj_id"] + "');");
				cell.appendChild(button);
				
				cell = row.insertCell();
				button = document.createElement("button");
				button.innerHTML = "Delete";
				button.setAttribute("onclick", "remove('" + r[i]["quiz_obj_id"] + "');");
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
	
	function add(question, choiceA, choiceB, choiceC, choiceD, answer) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["question"] = question;
		d["choice_a"] = choiceA;
		d["choice_b"] = choiceB;
		d["choice_c"] = choiceC;
		d["choice_d"] = choiceD;
		d["answer"] = answer;
		
		if (d["question"] != "") {
			if (d["choice_a"] != "") {
				if (d["choice_b"] != "") {
					if (d["answer"] != "") {
						XHRequest("addQuizObj", JSON.stringify(d), {async: false});
						loadTable();
						$e("input-question").value = null;
						$e("input-choice-a").value = null;
						$e("input-choice-b").value = null;
						$e("input-choice-c").value = null;
						$e("input-choice-d").value = null;
						$e("select-answer").value = "A";
					} else {
						$e("span-message").innerHTML = "Please choose an answer.";
						clearMessage();
					}
				} else {
					$e("span-message").innerHTML = "Please enter choice B.";
					clearMessage();
				}
			} else {
				$e("span-message").innerHTML = "Please enter choice A.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Please enter question.";
			clearMessage();
		}
	}
	
	function update(quizObjId, question, choiceA, choiceB, choiceC, choiceD, answer) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["quiz_obj_id"] = quizObjId;
		d["question"] = question;
		d["choice_a"] = choiceA;
		d["choice_b"] = choiceB;
		d["choice_c"] = choiceC;
		d["choice_d"] = choiceD;
		d["answer"] = answer;
		
		if (d["quiz_obj_id"] != "") {
			if (d["question"] != "") {
				if (d["choice_a"] != "") {
					if (d["choice_b"] != "") {
						if (d["answer"] != "") {
							XHRequest("updateQuizObj", JSON.stringify(d), {async: false});
							loadTable();
						} else {
							$e("span-message").innerHTML = "Please enter answer.";
							clearMessage();
						}
					} else {
						$e("span-message").innerHTML = "Please enter choice B.";
						clearMessage();
					}
				} else {
					$e("span-message").innerHTML = "Please enter choice A.";
					clearMessage();
				}
			} else {
				$e("span-message").innerHTML = "Please enter question.";
				clearMessage();
			}
		} else {
			$e("span-message").innerHTML = "Missing quiz objective ID.";
			clearMessage();
		}
	}
	
	function remove(quizObjId) {
		var d = {};
		d["subject_id"] = "<% out.print(request.getParameter("subject_id")); %>";
		d["quiz_obj_id"] = quizObjId;
		
		if (confirm("Are you sure to delete the question?") == true) {
			if (d["quiz_obj_id"] != "") {
				XHRequest("deleteQuizObj", JSON.stringify(d), {async: false});
				loadTable();
			} else {
				$e("span-message").innerHTML = "Missing quiz objective ID.";
				clearMessage();
			}
		}
	}
	
	function edit(element, quizObjId) {
		var row = element.parentNode.parentNode;
		var cell, span, input, select, button;
		
		cell = row.cells[1];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[2];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[3];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[4];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[5];
		span = cell.childNodes[0];
		span.style.display = "none";
		input = document.createElement("input");
		input.type = "text";
		input.value = span.innerHTML;
		cell.appendChild(input);
		
		cell = row.cells[6];
		select = cell.childNodes[0];
		select.disabled = false;
		
		cell = row.cells[9];
		button = cell.childNodes[0];
		button.innerHTML = "Done";
		button.setAttribute("onclick", "update('" + quizObjId + "', "
				+ "this.parentNode.parentNode.cells[1].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[2].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[3].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[4].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[5].childNodes[1].value, "
				+ "this.parentNode.parentNode.cells[6].childNodes[0].value);");
		
		cell = row.cells[10];
		button = cell.childNodes[0];
		button.innerHTML = "Cancel";
		button.setAttribute("onclick", "cancelEdit(this, '" + quizObjId + "');");
	}
	
	function cancelEdit(element, quizObjId) {
		var row = element.parentNode.parentNode;
		var cell, select, button;
		
		cell = row.cells[1];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[2];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[3];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[4];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[5];
		cell.childNodes[0].style.display = "block";
		cell.removeChild(cell.childNodes[1]);
		
		cell = row.cells[6];
		select = cell.childNodes[0];
		select.disabled = true;
		
		cell = row.cells[9];
		button = cell.childNodes[0];
		button.innerHTML = "Update";
		button.setAttribute("onclick", "edit(this, '" + quizObjId + "');");
		
		cell = row.cells[10];
		button = cell.childNodes[0];
		button.innerHTML = "Delete";
		button.setAttribute("onclick", "remove('" + quizObjId + "');");
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
	max-width: 120px;
}

input[type=text], [type=password] {
	width: 100px;
	font-family: verdana;
	font-size: 16px;
}

input[type=text]:hover, [type=password]:hover {
	outline: 1px solid;
}

select {
	min-width: 50px;
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
			<span class="title">Quiz (Objective)</span>
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
						<th>Choice A</th>
						<th>Choice B</th>
						<th>Choice C</th>
						<th>Choice D</th>
						<th>Answer</th>
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
						<td><input type="text" id="input-choice-a"></td>
						<td><input type="text" id="input-choice-b"></td>
						<td><input type="text" id="input-choice-c"></td>
						<td><input type="text" id="input-choice-d"></td>
						<td>
							<select id="select-answer">
								<option value="A">A</option>
								<option value="B">B</option>
								<option value="C">C</option>
								<option value="D">D</option>
							</select>
						</td>
						<td></td>
						<td></td>
						<td><button onclick="add($e('input-question').value, $e('input-choice-a').value, $e('input-choice-b').value, $e('input-choice-c').value, $e('input-choice-d').value, $e('select-answer').value);">ADD</button></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</body>
</html>