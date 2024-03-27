package ACID_probs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

public class EnrollmentSystem {
    public static final String URL = "jdbc:postgresql://localhost:5432/enrollment_system";
    private static final String USER = "postgres";
    private static final String PASSWORD = "12345";

public void enrollStudent (int studentId, int courseId) throws SQLException {

    Connection connection = null;
    PreparedStatement enrollStmt = null;

    try {
        connection = DriverManager.getConnection(URL, USER, PASSWORD);
        connection.setAutoCommit(false);
        // Check course capacity
        if (!isCourseFull(courseId, connection)) {
            // Enroll student
            String enrollQuery = "INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES (3, 2, CURRENT_DATE)";
            enrollStmt = connection.prepareStatement(enrollQuery);
            enrollStmt.setInt(1, studentId);
            enrollStmt.setInt(2, courseId);
            enrollStmt.setDate(3,enrollment_date);
            enrollStmt.executeUpdate();

            connection.commit();
        } else {
            System.out.println("Course is full. Enrollment failed.");
        }
    } catch (SQLException e) {
        if (connection != null) {
            connection.rollback();
        }
        e.printStackTrace();
    } finally {
        if (enrollStmt != null) {
            enrollStmt.close();
        }
        if (connection != null) {
            connection.setAutoCommit(true);
            connection.close();
        }
    }
}

    private boolean isCourseFull(int courseId, Connection connection) throws SQLException {
        // Implement logic to check if course is full
        return false; // Placeholder logic
    }

}

