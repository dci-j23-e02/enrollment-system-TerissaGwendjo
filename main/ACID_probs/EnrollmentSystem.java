package ACID_probs;

import java.sql.*;

public class EnrollmentSystem {
    public static final String URL = "jdbc:postgresql://localhost:5432/enrollment_system";
    private static final String USER = "postgres";
    private static final String PASSWORD = "12345";

public static void enrollStudent (int studentId, int courseId, Date enrollmentDate) throws SQLException {
    Connection connection = null;
    PreparedStatement enrollStmt = null;

    try {
        connection = DriverManager.getConnection(URL, USER, PASSWORD);
        connection.setAutoCommit(false);

        // Check course capacity
        if (!isCourseFull(courseId, connection)) {
            // Enroll student
            String enrollQuery = "INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES (?, ?, ?)";
            enrollStmt = connection.prepareStatement(enrollQuery);
            enrollStmt.setInt(1, studentId);
            enrollStmt.setInt(2, courseId);
            enrollStmt.setDate(3, enrollmentDate);
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

    private static boolean isCourseFull(int courseId, Connection connection) throws SQLException {
        boolean isFull = false;
        PreparedStatement countStmt = null;
        ResultSet resultSet = null;

        try {
            String countQuery = "SELECT COUNT(*) AS enrollment_count FROM Enrollment WHERE course_id = ?";
            countStmt = connection.prepareStatement(countQuery);
            countStmt.setInt(1, courseId);
            resultSet = countStmt.executeQuery();

            if (resultSet.next()) {
                int enrollmentCount = resultSet.getInt("enrollment_count");
                // Retrieve course capacity from Courses table
                int capacity = getCourseCapacity(courseId, connection);
                // Check if enrollment count equals or exceeds capacity
                isFull = enrollmentCount >= capacity;
            }
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (countStmt != null) {
                countStmt.close();
            }
        }
        return isFull;
    }

    private static int getCourseCapacity(int courseId, Connection connection) throws SQLException {
        int capacity = 0;
        PreparedStatement capacityStmt = null;
        ResultSet resultSet = null;

        try {
            String capacityQuery = "SELECT capacity FROM Courses WHERE course_id = ?";
            capacityStmt = connection.prepareStatement(capacityQuery);
            capacityStmt.setInt(1, courseId);
            resultSet = capacityStmt.executeQuery();

            if (resultSet.next()) {
                capacity = resultSet.getInt("capacity");
            }
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (capacityStmt != null) {
                capacityStmt.close();
            }
        }
        return capacity;
    }


    public void modifyEnrollment(int studentId, int courseIdToAdd, int courseIdToRemove) throws SQLException {
        Connection connection = null;
        PreparedStatement addStmt = null;
        PreparedStatement removeStmt = null;

        try {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            connection.setAutoCommit(false);

            // Add course
            String addQuery = "INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES (?, ?, CURRENT_DATE)";
            addStmt = connection.prepareStatement(addQuery);
            addStmt.setInt(1, studentId);
            addStmt.setInt(2, courseIdToAdd);
            addStmt.executeUpdate();

            // Remove course
            String removeQuery = "DELETE FROM Enrollment WHERE student_id = ? AND course_id = ?";
            removeStmt = connection.prepareStatement(removeQuery);
            removeStmt.setInt(1, studentId);
            removeStmt.setInt(2, courseIdToRemove);
            removeStmt.executeUpdate();

            connection.commit();
        } catch (SQLException e) {
            if (connection != null) {
                connection.rollback();
            }
            e.printStackTrace();
        } finally {
            if (addStmt != null) {
                addStmt.close();
            }
            if (removeStmt != null) {
                removeStmt.close();
            }
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }


    public static void main(String[] args) {

    try {
        enrollStudent(2,1, Date.valueOf("2024-03-25"));
    } catch (SQLException e) {
        e.printStackTrace();
    }

    }

}



