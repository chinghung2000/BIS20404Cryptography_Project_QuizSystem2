/*
 * MySQL Connector v2.1.1
 * ~~~~~~~~~~~~~~~~~~~~~~
 * 
 * MySQL Connector is written in Java, for easy MySQL implementation.
 * Create database connection to MySQL database server by using the
 * MySQL Connector/J driver. 
 * 
 * 
 * Basic usage:
 * ... create MySQL database connection:
 * 
 *     +----------------------------------------------------------------------------------------+
 *     |                                                                                        |
 *     |    Connection databaseConnection = null;                                               |
 *     |                                                                                        |
 *     |    try {                                                                               |
 *     |        databaseConnection = new MySQL().connect();                                     |
 *     |    } catch (SQLException e) {                                                          |
 *     |        e.printStackTrace();                                                            |
 *     |    }                                                                                   |
 *     |                                                                                        |
 *     +----------------------------------------------------------------------------------------+
 * 
 * ... or use along with Database Manager:
 * 
 *     +----------------------------------------------------------------------------------------+
 *     |                                                                                        |
 *     |    DatabaseManager db = new DatabaseManager(new MySQL().connect());                    |
 *     |                                                                                        |
 *     |    int adminId = 1;                                                                    |
 *     |    db.prepare("SELECT * FROM admin WHERE admin_id = ?;", adminId);                     |
 *     |    ResultSet rs = db.executeQuery();                                                   |
 *     |    String adminName = rs.getString("admin_name");                                      |
 *     |                                                                                        |
 *     +----------------------------------------------------------------------------------------+
 * 
 * 
 * 
 * Copyright (c) 2022 Botbox Studio. All rights reserved.
 * Version: 2.1.1
 * Last updated on 27/05/2022, 16:33:03 UTC
 * Author: Ching Hung Tan
 * GitHub: chinghung2000
 * Email: tanchinghung5098.1@gmail.com
 */

package com.project.backend;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;

public class MySQL {
	private String serverName = "localhost";
	private String portNumber = "3306";
	private String database = "app2";
	private String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + database;
	private String username = "appuser";
	private String password = "1234";

	// to create MySQL database connection
	public Connection connect() {

		// check the existence of MySQL JDBC driver (MySQL Connector Java JAR)
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("MySQL: Error occured when adding JDBC: " + e.toString());
			return null;
		}

		// try connecting to the MySQL database
		try {
			Connection connection = DriverManager.getConnection(this.url, this.username, this.password);
			System.out.println("MySQL: Connection successful.");
			return connection;
		} catch (SQLException e) {
			System.out.println("MySQL: Connection failed! There are some errors: " + e.toString());
			return null;
		}
	}
}
