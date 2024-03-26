### Assignment Title: Educational Course Enrollment System

#### Objective:
To develop a robust system that allows students to enroll in courses, with a focus on handling concurrent enrollments and maintaining consistent records of available seats and student enrollments. The system should demonstrate the ACID properties (Atomicity, Consistency, Isolation, Durability) and implement lock and rollback mechanisms to ensure data integrity and consistency.

#### Tools and Technologies:
- Java
- PostgreSQL
- JDBC

#### Database Design:

**Tables:**

1. **Students**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | student_id | SERIAL | PRIMARY KEY |
    | name | VARCHAR(255) | NOT NULL |
    | email | VARCHAR(255) | UNIQUE NOT NULL |
  
2. **Courses**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | course_id | SERIAL | PRIMARY KEY |
    | title | VARCHAR(255) | NOT NULL |
    | capacity | INT | NOT NULL |
    
3. **Enrollments**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | enrollment_id | SERIAL | PRIMARY KEY |
    | student_id | INT | FOREIGN KEY REFERENCES Students(student_id) |
    | course_id | INT | FOREIGN KEY REFERENCES Courses(course_id) |
    | enrollment_date | DATE | NOT NULL |

4. **Departments**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | department_id | SERIAL | PRIMARY KEY |
    | name | VARCHAR(255) | NOT NULL |

5. **Instructors**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | instructor_id | SERIAL | PRIMARY KEY |
    | name | VARCHAR(255) | NOT NULL |
    | department_id | INT | FOREIGN KEY REFERENCES Departments(department_id) |

6. **CourseInstructors**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | course_id | INT | FOREIGN KEY REFERENCES Courses(course_id) |
    | instructor_id | INT | FOREIGN KEY REFERENCES Instructors(instructor_id) |
    | PRIMARY KEY (course_id, instructor_id) |

7. **Classrooms**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | classroom_id | SERIAL | PRIMARY KEY |
    | location | VARCHAR(255) | NOT NULL |
    | capacity | INT | NOT NULL |

8. **CourseSchedule**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | course_id | INT | FOREIGN KEY REFERENCES Courses(course_id) |
    | classroom_id | INT | FOREIGN KEY REFERENCES Classrooms(classroom_id) |
    | day_of_week | VARCHAR(10) | NOT NULL |
    | start_time | TIME | NOT NULL |
    | end_time | TIME | NOT NULL |
    | PRIMARY KEY (course_id, day_of_week, start_time) |

9. **Grades**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | enrollment_id | INT | FOREIGN KEY REFERENCES Enrollments(enrollment_id) |
    | grade | VARCHAR(2) | NOT NULL |

10. **Attendance**
    | Column Name | Data Type | Constraints |
    |--|--|--|
    | attendance_id | SERIAL | PRIMARY KEY |
    | enrollment_id | INT | FOREIGN KEY REFERENCES Enrollments(enrollment_id) |
    | date | DATE | NOT NULL |
    | status | VARCHAR(10) | NOT NULL |

**Relationships between tables:**

- **Students** ↔ **Enrollments**: One-to-Many (A student can have multiple enrollments)
- **Courses** ↔ **Enrollments**: One-to-Many (A course can have multiple enrollments)
- **Courses** ↔ **CourseInstructors**: Many-to-Many (A course can have multiple instructors and vice versa)
- **Departments** ↔ **Instructors**: One-to-Many (A department can have multiple instructors)
- **Courses** ↔ **CourseSchedule**: One-to-One (Each course has one schedule)
- **Enrollments** ↔ **Grades**: One-to-One (Each enrollment has one grade)
- **Enrollments** ↔ **Attendance**: One-to-Many (An enrollment can have multiple attendance records)

#### Java Tasks:

1. **Database Connection Utility**: Create a utility class for connecting to the PostgreSQL database using JDBC.

2. **Course Enrollment**: Implement functionality for students to enroll in courses. Use transactions to ensure that enrollments are processed atomically.

3. **Capacity Management**: Implement locking on course capacity during the enrollment process to prevent over-enrollment.

4. **Enrollment Modifications**: Allow students to modify their enrollments (add/drop courses) with rollback capabilities to revert changes in case of errors.

5. **Concurrency Handling**: Implement serialization or other concurrency control mechanisms to manage concurrent enrollments effectively, ensuring isolation.

6. **Consistency Checks**: Implement checks to ensure that enrollments adhere to business rules (e.g., prerequisites met, no schedule conflicts).

7. **Durability Testing**: Simulate system failures to ensure that successful enrollments persist across system restarts.

8. **Instructor Assignment**: Allow departments to assign instructors to courses, ensuring that each course has at least one instructor.

9. **Schedule Management**: Implement functionality for scheduling courses in classrooms, taking into account classroom capacity and availability.

10. **Grade Recording**: Develop functionality for instructors to record grades for students, ensuring that grades are consistently recorded and accessible.

#### SQL Queries:

1. **Enroll a Student in a Course** (Transactional):
    ```sql
    BEGIN;
    UPDATE Courses SET capacity = capacity - 1 WHERE course_id = ? AND capacity > 0;
    INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES (?, ?, CURRENT_DATE);
    COMMIT;
    ```

2. **Drop a Course Enrollment** (With Rollback on Failure):
    ```sql
    BEGIN;
    DELETE FROM Enrollments WHERE enrollment_id = ?;
    UPDATE Courses SET capacity = capacity + 1 WHERE course_id = ?;
    COMMIT;
    ```

3. **Locking a Course for Enrollment**:
    ```sql
    SELECT * FROM Courses WHERE course_id = ? FOR UPDATE;
    ```

#### ACID Tasks:

### Task 1: Atomicity

**Objective**: Ensure that course enrollments and modifications are processed as atomic operations.

**Sub-tasks**:
1. Implement transactional enrollment with rollback on failure.
2. Ensure atomic updates to course capacity during enrollment.
3. Develop atomic operations for adding and dropping courses.
4. Validate atomicity through test cases simulating system failures during enrollment.

### Task 2: Consistency

**Objective**: Maintain consistent records of available seats and student enrollments.

**Sub-tasks**:
1. Implement checks to prevent over-enrollment in courses.
2. Ensure that course assignments do not exceed classroom capacities.
3. Validate prerequisites before allowing enrollment.
4. Maintain consistent instructor assignments for courses.

### Task 3: Isolation

**Objective**: Handle concurrent enrollments without data anomalies.

**Sub-tasks**:
1. Implement locking on course capacity during enrollment.
2. Use serialization or other concurrency control mechanisms for enrollment.
3. Test concurrency handling with simultaneous enrollment requests.
4. Ensure that schedule conflicts are avoided during enrollment.

### Task 4: Durability

**Objective**: Ensure that successful transactions persist across system restarts.

**Sub-tasks**:
1. Test durability by simulating system failures after enrollment.
2. Verify that completed enrollments are not lost after a system restart.
3. Implement logging or other mechanisms to recover from incomplete transactions.

#### Assignment Deliverables:

1. **Database Schema**: SQL scripts for creating tables, constraints, and relationships.
2. **Java Application**: Source code for the enrollment system, including database connection, transaction management, and concurrency control.
3. **Documentation**: Detailed documentation on system architecture, database schema, running the application, and demonstrating ACID properties.
4. **Test Cases**: Test scripts or instructions for validating atomicity, consistency, isolation, and durability, including scenarios for normal operation and edge cases.

This assignment provides a comprehensive learning experience in developing a real-world application that demonstrates the ACID properties, with a focus on transaction management, concurrency control, and data integrity.
