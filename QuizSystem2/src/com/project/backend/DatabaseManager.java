/*
 * Database Manager v2.3.2
 * ~~~~~~~~~~~~~~~~~~~~~~~
 * 
 * Database Manager is written in Java, to shorten the code in programming.
 * Provides better database implementation when coding with Java.
 * 
 * Database Manager can handle SQL statement preparation with flexible
 * parameter binding. Say bye to manually preparing SQL statements and bind
 * parameters to SQL statements one by one with corresponding data types.
 * Provides error handling, as well as event logging to make debugging easier.
 * 
 * 
 * Basic usage:
 * ... create DatabaseManager object:
 * 
 *     +----------------------------------------------------------------------------------------+
 *     |                                                                                        |
 *     |    Connection databaseConnection = null;                                               |
 *     |                                                                                        |
 *     |    try {                                                                               |
 *     |        databaseConnection = DriverManager.getConnection(url, username, password);      |
 *     |    } catch (SQLException e) {                                                          |
 *     |        e.printStackTrace();                                                            |
 *     |    }                                                                                   |
 *     |                                                                                        |
 *     |    DatabaseManager db = new DatabaseManager(databaseConnection);                       |
 *     |                                                                                        |
 *     +----------------------------------------------------------------------------------------+
 * 
 * ... or prepare a statement:
 * 
 *     +----------------------------------------------------------------------------------------+
 *     |                                                                                        |
 *     |    int adminId = 1;                                                                    |
 *     |    db.prepare("SELECT * FROM admin WHERE admin_id = ?;", adminId);                     |
 *     |                                                                                        |
 *     +----------------------------------------------------------------------------------------+
 * 
 * ... or execute a query with returning results:
 * 
 *     +----------------------------------------------------------------------------------------+
 *     |                                                                                        |
 *     |    ResultSet rs = db.executeQuery();                                                   |
 *     |    String adminName = rs.getString("admin_name");                                      |
 *     |                                                                                        |
 *     +----------------------------------------------------------------------------------------+
 * 
 * 
 * 
 * Copyright (c) 2022 Botbox Studio. All rights reserved.
 * Version: 2.3.2
 * Last updated on 19/05/2022, 10:04:08 UTC
 * Author: Ching Hung Tan
 * GitHub: chinghung2000
 * Email: tanchinghung5098.1@gmail.com
 */

package com.project.backend;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.SQLException;

public class DatabaseManager {
	private Connection connection;
	private PreparedStatement pstmt;

	// constructor to receive database connection
	public DatabaseManager(Connection connection) {
		this.connection = connection;
	}

	// to prepare a SQL statement and bind respective parameters
	public boolean prepare(String statement, Object... parameters) {
		if (this.connection != null) {
			try {
				this.pstmt = this.connection.prepareStatement(statement, ResultSet.TYPE_SCROLL_INSENSITIVE,
						ResultSet.CONCUR_READ_ONLY);
				System.out.println("DatabaseManager.prepare: Preparing SQL statement: \"" + statement + "\"...");
				int i = 1;

				for (Object parameter : parameters) {
					if (parameter instanceof Boolean) {
						this.pstmt.setBoolean(i, (boolean) parameter);
					} else if (parameter instanceof Integer) {
						this.pstmt.setInt(i, (int) parameter);
					} else if (parameter instanceof Long) {
						this.pstmt.setLong(i, (long) parameter);
					} else if (parameter instanceof Float) {
						this.pstmt.setFloat(i, (float) parameter);
					} else if (parameter instanceof Double) {
						this.pstmt.setDouble(i, (double) parameter);
					} else if (parameter instanceof String) {
						this.pstmt.setString(i, (String) parameter);
					} else if (parameter instanceof Character) {
						this.pstmt.setString(i, Character.toString((char) parameter));
					} else if (parameter instanceof Date) {
						this.pstmt.setDate(i, (Date) parameter);
					} else {
						this.pstmt.setNull(i, java.sql.Types.NULL);
					}

					i++;
				}

				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.prepare: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.prepare: No database connection");
		}

		return false;
	}

	// to prepare a SQL statement and bind respective parameters for returning
	// generated keys
	public boolean prepareForGeneratedKey(String statement, Object... parameters) {
		if (this.connection != null) {
			try {
				this.pstmt = this.connection.prepareStatement(statement, PreparedStatement.RETURN_GENERATED_KEYS);
				System.out.println(
						"DatabaseManager.prepareForGeneratedKey: Preparing SQL statement: \"" + statement + "\"...");
				int i = 1;

				for (Object parameter : parameters) {
					if (parameter instanceof Boolean) {
						this.pstmt.setBoolean(i, (boolean) parameter);
					} else if (parameter instanceof Integer) {
						this.pstmt.setInt(i, (int) parameter);
					} else if (parameter instanceof Long) {
						this.pstmt.setLong(i, (long) parameter);
					} else if (parameter instanceof Float) {
						this.pstmt.setFloat(i, (float) parameter);
					} else if (parameter instanceof Double) {
						this.pstmt.setDouble(i, (double) parameter);
					} else if (parameter instanceof Character || parameter instanceof String) {
						this.pstmt.setString(i, (String) parameter);
					} else if (parameter instanceof Date) {
						this.pstmt.setDate(i, (Date) parameter);
					} else {
						this.pstmt.setNull(i, java.sql.Types.NULL);
					}

					i++;
				}

				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.prepareForGeneratedKey: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.prepareForGeneratedKey: No database connection");
		}

		return false;
	}

	// to execute SQL statement with returning results
	public ResultSet executeQuery() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeQuery: Executing prepared SQL statement...");
				ResultSet rs = this.pstmt.executeQuery();
				int rowCount = rs.last() ? rs.getRow() : 0;
				rs.beforeFirst();
				System.out.println("DatabaseManager.executeQuery: " + rowCount + " row(s) found.");
				return rs;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeQuery: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeQuery: No database connection");
		}

		return null;
	}

	// to execute SQL statement without returning result
	public boolean executeUpdate() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeUpdate: Executing prepared SQL statement...");
				int affectedRowCount = this.pstmt.executeUpdate();
				System.out.println("DatabaseManager.executeUpdate: " + affectedRowCount + " row(s) affected.");
				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeUpdate: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeUpdate: No database connection");
		}

		return false;
	}

	// to execute SQL statement without returning result for returning generated
	// keys
	public ResultSet executeUpdateForGeneratedKey() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeUpdateForGeneratedKey: Executing prepared SQL statement...");
				int affectedRowCount = this.pstmt.executeUpdate();
				System.out.println(
						"DatabaseManager.executeUpdateForGeneratedKey: " + affectedRowCount + " row(s) affected.");
				return this.pstmt.getGeneratedKeys();
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeUpdateForGeneratedKey: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeUpdateForGeneratedKey: No database connection");
		}

		return null;
	}

	// to close the database connection
	public boolean close() {
		if (this.connection != null) {
			try {
				this.connection.close();
				System.out.println("DatabaseManager.close: Database connection closed.");
				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.close: There is an error: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.close: No database connection");
		}

		return false;
	}
}
