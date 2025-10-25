package context;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import java.sql.Connection;
import java.sql.DriverManager;
/**
 *
 * @author tungn
 */
public class DBContext {
     public Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance 
                   + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true";

        if (instance == null || instance.trim().isEmpty()) {
            url = "jdbc:sqlserver://" + serverName + ":" + portNumber 
                + ";databaseName=" + dbName + ";encrypt=true;trustServerCertificate=true";
        }

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }

    /* 
     * Change/update information of your database connection, 
     * DO NOT change name of instance variables in this class 
     */
    private final String serverName = "localhost";
    private final String dbName     = "SWP391";
    private final String portNumber = "1433";
    private final String instance   = ""; // LEAVE THIS EMPTY IF YOUR SQL IS A SINGLE INSTANCE
    private final String userID     = "sa";
    private final String password   = "123456";
    


    public static void main(String[] args) {
    try {
        Connection conn = new DBContext().getConnection();
        if (conn != null) {
            System.out.println("Connection successful!");
        } else {
            System.out.println("Connection failed!");
        }
    } catch (Exception e) {
        System.out.println("Connection error: " + e.getMessage());
        e.printStackTrace();
    }
}
}
