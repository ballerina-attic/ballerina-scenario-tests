package org.ballerinalang.scenario.test.common.database;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.sql.Statement;
import java.io.InputStream;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {
    /**
     * Create a DB and initialize with given SQL file.
     *
     * @param jdbcUrl  JDBC URL
     * @param username Username for the DB
     * @param password Password to connect to the DB
     * @param sqlFile  SQL statements for initialization.
     */
        public static void executeSqlFile(String jdbcUrl, String username, String password, Path sqlFile)
                throws IOException, SQLException {
            try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
                    Statement st = connection.createStatement()) {
                String sql = readFileToString(sqlFile);
                String[] sqlQuery = sql.trim().split("/");
                for (String query : sqlQuery) {
                    st.executeUpdate(query.trim());
                }
                if (!connection.getAutoCommit()) {
                    connection.commit();
                }
            }
        }

    private static String readFileToString(Path pathToFile) throws IOException {
        try (InputStream is = new FileInputStream(pathToFile.toFile());
                BufferedReader buf = new BufferedReader(new InputStreamReader(is));) {
            String line = buf.readLine();
            StringBuilder sb = new StringBuilder();
            while (line != null) {
                sb.append(line).append(System.lineSeparator());
                line = buf.readLine();
            }
            return sb.toString();
        }
    }
}