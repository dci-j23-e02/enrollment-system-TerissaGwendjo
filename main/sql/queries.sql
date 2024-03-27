CREATE TABLE Students (
                          student_id SERIAL PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          email VARCHAR(255) UNIQUE NOT NULL
);


-- Create Courses table
CREATE TABLE Courses (
                         course_id SERIAL PRIMARY KEY,
                         title VARCHAR(255) NOT NULL,
                         capacity INT NOT NULL
);

-- Create Enrollments table
CREATE TABLE Enrollment (
                            enrollment_id SERIAL PRIMARY KEY,
                            student_id INT REFERENCES Students(student_id),
                            course_id INT REFERENCES Courses(course_id),
                            enrollment_date DATE NOT NULL
);

-- Create Departments table
CREATE TABLE Departments (
                             department_id SERIAL PRIMARY KEY,
                             name VARCHAR(255) NOT NULL

);

-- Create Instructors table
CREATE TABLE Instructors (
                             instructor_id SERIAL PRIMARY KEY,
                             name VARCHAR(255) NOT NULL,
                             department_id INT REFERENCES Departments(department_id)
);


-- Create CourseInstructors table
CREATE TABLE CourseInstructors (
                                   course_id INT REFERENCES Courses(course_id),
                                   instructor_id INT REFERENCES Instructors(instructor_id),
                                   PRIMARY KEY (course_id, instructor_id)
);
/*PRIMARY KEY (course_id, instructor_id): This line designates a composite primary key for the CourseInstructors table.
  A composite key means that the combination of the course_id and instructor_id must be unique within the table. Together,
  they uniquely identify each record in the CourseInstructors table. This ensures that a course can have multiple
  instructors, but each combination of course and instructor is unique.*/


-- Create Classrooms table
CREATE TABLE Classrooms (
                            classroom_id SERIAL PRIMARY KEY,
                            location VARCHAR(255) NOT NULL,
                            capacity INT NOT NULL
);

-- Create CourseSchedule table
CREATE TABLE CourseSchedule (
                                course_id INT REFERENCES Courses(course_id),
                                classroom_id INT REFERENCES Classrooms(classroom_id),
                                day_of_week VARCHAR(10) NOT NULL,
                                start_time TIME NOT NULL,
                                end_time TIME NOT NULL,
                                PRIMARY KEY (course_id, day_of_week, start_time)
);
/* This line specifies a composite primary key for the table. It consists of three columns: course_id, day_of_week,
   and start_time. Together, these columns uniquely identify each row in the table. This means that a combination of
   course_id, day_of_week, and start_time must be unique within the table, meaning no two rows in the CourseSchedule
   table can have the same values for these three columns simultaneously. */

-- Create Grades table
CREATE TABLE Grades (
                        enrollment_id INT REFERENCES Enrollment(enrollment_id),
                        grade VARCHAR(2) NOT NULL
);

-- Create Attendance table
CREATE TABLE Attendance (
                            attendance_id SERIAL PRIMARY KEY,
                            enrollment_id INT REFERENCES Enrollment(enrollment_id),
                            date DATE NOT NULL,
                            status VARCHAR(10) NOT NULL
);

-- Insert values into Students table
INSERT INTO Students (name, email) VALUES
                                       ('Kwame Asante', 'kwame@example.com'),
                                       ('Fatoumata Diallo', 'fatou@example.com'),
                                       ('Sipho Ndlovu', 'sipho@example.com');

-- Insert values into Courses table
INSERT INTO Courses (title, capacity) VALUES
                                          ('Mathematics', 30),
                                          ('History', 25),
                                          ('Biology', 20);

-- Insert values into Enrollments table
INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES
                                                                     (1, 1, '2024-03-25'),
                                                                     (2, 2, '2024-03-26'),
                                                                     (3, 3, '2024-03-27'),
                                                                     (1, 2, '2024-03-27');

-- Insert values into Departments table
INSERT INTO Departments (name) VALUES
                                   ('Mathematics'),
                                   ('History'),
                                   ('Science');

-- Insert values into Instructors table
INSERT INTO Instructors (name, department_id) VALUES
                                                  ('Obi Eze', 1),
                                                  ('Aminata Camara', 2),
                                                  ('Thabo Mokoena', 3);

-- Insert values into CourseInstructors table (assuming each course has multiple instructors)
INSERT INTO CourseInstructors (course_id, instructor_id) VALUES
                                                             (1, 1),
                                                             (2, 2),
                                                             (3, 3),
                                                             (1, 3); -- Additional instructor for Mathematics course

-- Insert values into Classrooms table
INSERT INTO Classrooms (location, capacity) VALUES
                                                ('Room A', 30),
                                                ('Room B', 25),
                                                ('Room C', 20);

-- Insert values into CourseSchedule table
INSERT INTO CourseSchedule (course_id, classroom_id, day_of_week, start_time, end_time) VALUES
                                                                                            (1, 1, 'Monday', '09:00', '11:00'),
                                                                                            (2, 2, 'Tuesday', '10:00', '12:00'),
                                                                                            (3, 3, 'Wednesday', '11:00', '13:00');

-- Insert values into Grades table
INSERT INTO Grades (enrollment_id, grade) VALUES
                                              (1, 'A'),
                                              (2, 'B'),
                                              (3, 'C');

-- Insert values into Attendance table
INSERT INTO Attendance (enrollment_id, date, status) VALUES
                                                         (1, '2024-03-25', 'Present'),
                                                         (2, '2024-03-26', 'Present'),
                                                         (3, '2024-03-27', 'Absent'),
                                                         (1, '2024-03-27', 'Present');

--Enroll a Student in a Course (Transactional):
BEGIN;
UPDATE Courses SET capacity = capacity - 1 WHERE course_id = 1 AND capacity > 0;
INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES (3, 2, CURRENT_DATE);
COMMIT;


---
INSERT INTO enrollment (student_id, course_id, enrollment_date) VALUES (
                                                                           3,1,CURRENT_DATE
                                                                       );

--Drop a Course Enrollment (With Rollback on Failure):
BEGIN;
DELETE FROM Enrollment WHERE enrollment_id = 6;
UPDATE Courses SET capacity = capacity + 6 WHERE course_id = 1;
COMMIT;



