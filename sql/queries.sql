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