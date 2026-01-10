/* ===============================
   STUDENT COURSE ENROLLMENT DB
   =============================== */

/* ---------- CREATE DATABASE ---------- */
CREATE DATABASE Student_Course_DB;
USE Student_Course_DB;

/* ---------- STUDENT ---------- */
CREATE TABLE STUDENT (
    regno VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    major VARCHAR(255),
    bdate DATE
);

/* ---------- COURSE ---------- */
CREATE TABLE COURSE (
    course_no INT PRIMARY KEY,
    cname VARCHAR(255),
    dept VARCHAR(255)
);

/* ---------- TEXTBOOK ---------- */
CREATE TABLE TEXTBOOK (
    book_ISBN INT PRIMARY KEY,
    book_title VARCHAR(255),
    publisher VARCHAR(255),
    author VARCHAR(255)
);

/* ---------- ENROLL ---------- */
CREATE TABLE ENROLL (
    regno VARCHAR(50),
    course_no INT,
    sem INT,
    marks INT,
    FOREIGN KEY (regno) REFERENCES STUDENT(regno)
        ON DELETE CASCADE,
    FOREIGN KEY (course_no) REFERENCES COURSE(course_no)
        ON DELETE CASCADE
);

/* ---------- BOOK_ADOPTION ---------- */
CREATE TABLE BOOK_ADOPTION (
    course_no INT,
    sem INT,
    book_ISBN INT,
    PRIMARY KEY (course_no, sem, book_ISBN),
    FOREIGN KEY (course_no) REFERENCES COURSE(course_no)
        ON DELETE CASCADE,
    FOREIGN KEY (book_ISBN) REFERENCES TEXTBOOK(book_ISBN)
        ON DELETE CASCADE
);



/* ---------- INSERT INTO STUDENT ---------- */
INSERT INTO STUDENT VALUES
('S001', 'John Doe', 'Computer Science', '1990-01-01'),
('S002', 'Jane Smith', 'Electrical Engineering', '1992-05-15'),
('S003', 'Bob Johnson', 'Mechanical Engineering', '1991-08-20'),
('S004', 'Alice Brown', 'Computer Science', '1993-03-10'),
('S005', 'Charlie Davis', 'Physics', '1992-11-25');


/* ---------- INSERT INTO COURSE ---------- */
INSERT INTO COURSE VALUES
(1, 'Database Management Systems', 'CS'),
(2, 'Computer Networks', 'CS'),
(3, 'Introduction to Physics', 'Physics'),
(4, 'Mechanics of Materials', 'Mechanical Engineering'),
(5, 'Digital Signal Processing', 'Electrical Engineering');


/* ---------- INSERT INTO ENROLL ---------- */
INSERT INTO ENROLL VALUES
('S001', 1, 1, 85),
('S002', 1, 1, 72),
('S003', 2, 1, 68),
('S004', 1, 1, 90),
('S005', 3, 1, 75);


/* ---------- INSERT INTO TEXTBOOK ---------- */
INSERT INTO TEXTBOOK VALUES
(123456789, 'Database Management Systems', 'Pearson', 'Author1'),
(234567890, 'Computer Networks', 'McGraw Hill', 'Author2'),
(345678901, 'Introduction to Physics', 'Wiley', 'Author3'),
(456789012, 'Mechanics of Materials', 'Springer', 'Author4'),
(567890123, 'Digital Signal Processing', 'Pearson', 'Author5');


/* ---------- INSERT INTO BOOK_ADOPTION ---------- */
INSERT INTO BOOK_ADOPTION VALUES
(1, 1, 123456789),
(1, 2, 234567890),
(3, 8, 345678901),
(4, 4, 123456789),
(5, 3, 234567890);


-- 1.
INSERT INTO TEXTBOOK VALUES
(678901234, 'Advanced Database Systems', 'Pearson', 'Elmasri');

INSERT INTO BOOK_ADOPTION VALUES
(1, 2, 678901234);

-- 2.
SELECT
    C.course_no,
    T.book_ISBN,
    T.book_title
FROM COURSE C
JOIN BOOK_ADOPTION B ON C.course_no = B.course_no
JOIN TEXTBOOK T ON B.book_ISBN = T.book_ISBN
WHERE C.dept = 'CS'
  AND C.course_no IN (
        SELECT course_no
        FROM BOOK_ADOPTION
        GROUP BY course_no
        HAVING COUNT(book_ISBN) > 2
  )
ORDER BY T.book_title;

-- 3.
SELECT DISTINCT c.dept
FROM COURSE c
WHERE c.dept IN (
        SELECT c1.dept
        FROM COURSE c1
        JOIN BOOK_ADOPTION b1 ON c1.course_no = b1.course_no
        JOIN TEXTBOOK t1 ON b1.book_ISBN = t1.book_ISBN
        WHERE t1.publisher = 'Pearson'
)
AND c.dept NOT IN (
        SELECT c2.dept
        FROM COURSE c2
        JOIN BOOK_ADOPTION b2 ON c2.course_no = b2.course_no
        JOIN TEXTBOOK t2 ON b2.book_ISBN = t2.book_ISBN
        WHERE t2.publisher != 'Pearson'
);


/*🧠 How to read this (very simply)

First subquery (IN)
→ departments that use at least one Pearson book

Second subquery (NOT IN)
→ departments that use any non-Pearson book
*/


-- 4.
SELECT s.regno, s.name
FROM COURSE c
JOIN ENROLL e ON c.course_no = e.course_no
JOIN STUDENT s ON s.regno = e.regno
WHERE c.cname = 'Database Management Systems'
  AND e.marks = (
        SELECT MAX(e2.marks)
        FROM ENROLL e2
        JOIN COURSE c2 ON e2.course_no = c2.course_no
        WHERE c2.cname = 'Database Management Systems'
  );


-- 5.
SELECT
    s.regno,
    s.name,
    c.cname,
    e.marks
FROM STUDENT s
JOIN ENROLL e ON s.regno = e.regno
JOIN COURSE c ON e.course_no = c.course_no;


-- 6.
DELIMITER $$

CREATE TRIGGER prevent_low_marks_enrollment
BEFORE INSERT ON ENROLL
FOR EACH ROW
BEGIN
    IF NEW.marks < 40 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Enrollment not allowed: marks less than 40';
    END IF;
END$$

DELIMITER ;
INSERT INTO ENROLL VALUES ('S001', 2, 1, 35);



/* trial*/

delimiter //

create trigger stutrigger
before insert on ENROLL
for each row
begin
 if (new.marks<40) then
        signal sqlstate '45000'
        set message_text="marks less";
 end if;
end;//

delimiter ;
~
~
~
~
~
~
