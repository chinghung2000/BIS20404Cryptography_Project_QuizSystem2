/*
JavaScript Helper 1.0.3
~~~~~~~~~~~~~~~~~~~~~~~

JavaScript Helper is written in JavaScript, specially designed for the project.
Handles the elements quickly, in getting one or more elements based on element
id, class name, name and tag name.

Handles AJAX (Asynchronous JavaScript and XML) requests and responses for
server API interaction.
Send XML HTTP requests and supports Content-Type of application/json and Form-Data.
Supports callback to user-defined function to receive and handle response data.
Supports consecutive function-call upon receiving responses.
Provides error handling, safely output the error message when error occurs.


Basic usage:
... get the value of the element with id 'input-user-id':

	> var value = $e("input-user-id").value;

... or get the second element with tag name 'button':

	> var secondButton = $t("button")[1];

and

... send HTTP request to 'api/login.jsp':

	> XHRequest("login", jsonString);

... or send HTTP request to with callback:

	> function handlerFunction(responseContent) {};
	> XHRequest("sampleAPI", jsonString, {callback: "handlerFunction"});

... or send a Form-Data object through HTTP request asynchronously:

	> XHRFormData("upload", formData, {async: false});


Copyright (c) 2022 BotBox Studio. All rights reserved.
Version: 1.0.3
Last updated on 19/05/2022, 04:30:51 UTC
Author: Ching Hung Tan
GitHub: chinghung2000
GitHub repository: BIS20404Cryptography_Project_QuizSystem2
Email: tanchinghung5098.1@gmail.com
*/

function $e(id) {
	return document.getElementById(id);
}


function $c(className) {
	return document.getElementsByClassName(className);
}


function $n(name) {
	return document.getElementsByName(name);
}


function $t(tagName) {
	return document.getElementsByTagName(tagName);
}


function XHRequest(APIMethod, jsonString, { async = true, callback = null, nextCall = null } = {}) {
	var xhttp = new XMLHttpRequest();
	xhttp.open("POST", "api/" + APIMethod + ".jsp", async);
	xhttp.setRequestHeader("Content-Type", "application/json");

	xhttp.onreadystatechange = function() {
		if (this.readyState === 4) {
			switch (this.status) {
				case 200:
					var rc = JSON.parse(this.responseText);

					if (rc["ok"] === true) {
						if ("message" in rc) $e("span-message").innerHTML = rc["message"];
						if (callback != null) window[callback](rc);
					} else {
						if ("redirect" in rc) {
							location.href = rc["redirect"];
						} else if ("message" in rc) {
							$e("span-message").innerHTML = rc["message"];
						} else {
							$e("span-message").innerHTML = "Error " + rc["error_code"] + ": " + rc["description"];
						}
					}

					break;
				case 404:
					alert("Requested server file not found. Error code: " + this.status);
					break;
				default:
					alert("Request failed. " + this.statusText + "Error Code: " + this.status);
			}
		}

		if (nextCall != null) window[nextCall]();
	}

	xhttp.send(jsonString);
}


function XHRFormData(APIHandler, formData, { async = true, callback = null, nextCall = null } = {}) {
	var xhttp = new XMLHttpRequest();
	xhttp.open("POST", "api/" + APIHandler + ".jsp", async);

	xhttp.onreadystatechange = function() {
		if (this.readyState === 4) {
			switch (this.status) {
				case 200:
					var rc = JSON.parse(this.responseText);

					if (rc["ok"] === true) {
						if ("message" in rc) $e("span-message").innerHTML = rc["message"];
						if (callback != null) window[callback](rc);
					} else {
						if ("redirect" in rc) {
							location.href = rc["redirect"];
						} else if ("message" in rc) {
							$e("span-message").innerHTML = rc["message"];
						} else {
							$e("span-message").innerHTML = "Error " + rc["error_code"] + ": " + rc["description"];
						}
					}

					break;
				case 404:
					alert("Requested server file not found. Error code: " + this.status);
					break;
				default:
					alert("Request failed. " + this.statusText + "Error Code: " + this.status);
			}
		}

		if (nextCall != null) window[nextCall]();
	}

	xhttp.send(formData);
}
