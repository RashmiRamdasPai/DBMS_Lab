/* ===============================
   COMPANY DATABASE
   =============================== */

/* ---------- CREATE DATABASE ---------- */
CREATE DATABASE Company_DB;
USE Company_DB;

/* ---------- DEPARTMENT ---------- */
CREATE TABLE DEPARTMENT (
    DNO INT PRIMARY KEY,
    DName VARCHAR(25),
    MgrSSN INT,
    MgrStartDate DATE
);

/* ---------- EMPLOYEE ---------- */
CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    Name VARCHAR(25),
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary FLOAT,
    SuperSSN INT,
    DNO INT,
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO)
        ON DELETE CASCADE,
    FOREIGN KEY (SuperSSN) REFERENCES EMPLOYEE(SSN)
);

/* ---------- DLOCATION ---------- */
CREATE TABLE DLOCATION (
    DNO INT,
    DLoc VARCHAR(255),
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO)
        ON DELETE CASCADE
);

/* ---------- PROJECT ---------- */
CREATE TABLE PROJECT (
    PNO INT PRIMARY KEY,
    PName VARCHAR(255),
    PLocation VARCHAR(255),
    DNO INT,
    FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO)
        ON DELETE CASCADE
);

/* ---------- WORKS_ON ---------- */
CREATE TABLE WORKS_ON (
    SSN INT,
    PNO INT,
    Hours INT,
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN)
        ON DELETE CASCADE,
    FOREIGN KEY (PNO) REFERENCES PROJECT(PNO)
        ON DELETE CASCADE
);

/* ===============================
   COMPANY DATABASE – INSERT DATA
   =============================== */

/* ---------- DEPARTMENT ---------- */
INSERT INTO DEPARTMENT VALUES
(201, 'Human Resources', 1, '2020-10-21'),
(202, 'Quality Assessment', 4, '2020-10-19'),
(203, 'System Assessment', 5, '2020-10-27'),
(204, 'Accounts', 2, '2020-09-04'),
(205, 'Production', 3, '2020-08-16');


/* ---------- EMPLOYEE ---------- */
/* Supervisors first (SuperSSN = NULL) */
INSERT INTO EMPLOYEE VALUES
(1, 'Chandan_Krishna', 'Siddartha Nagar, Mysuru', 'M', 1500000, NULL, 205),
(2, 'Employee_2', 'Lakshmipuram, Mysuru', 'F', 1200000, 1, 202),
(3, 'Employee_3', 'Pune, Maharashtra', 'M', 1000000, 1, 204),
(4, 'Employee_4', 'Hyderabad, Telangana', 'M', 2500000, 2, 205),
(5, 'Employee_5', 'JP Nagar, Bengaluru', 'F', 1700000, 2, 201);


/* ---------- DLOCATION ---------- */
INSERT INTO DLOCATION VALUES
(201, 'Jaynagar, Bengaluru'),
(202, 'Vijaynagar, Mysuru'),
(203, 'Chennai, Tamil Nadu'),
(204, 'Mumbai, Maharashtra'),
(205, 'Kuvempunagar, Mysuru');


/* ---------- PROJECT ---------- */
INSERT INTO PROJECT VALUES
(241563, 'System Testing', 'Mumbai, Maharashtra', 204),
(532678, 'IoT', 'JP Nagar, Bengaluru', 201),
(453723, 'Product Optimization', 'Hyderabad, Telangana', 205),
(278345, 'Yield Increase', 'Kuvempunagar, Mysuru', 205),
(426784, 'Product Refinement', 'Saraswatipuram, Mysuru', 202);


/* ---------- WORKS_ON ---------- */
INSERT INTO WORKS_ON VALUES
(1, 278345, 5),
(2, 426784, 6),
(5, 532678, 3),
(3, 241563, 3),
(4, 453723, 6);

-- 1.
SELECT w.PNO
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.SSN = w.SSN
WHERE e.Name LIKE '%Scott'

UNION

SELECT p.PNO
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.SSN = d.MgrSSN
JOIN PROJECT p ON d.DNO = p.DNO
WHERE e.Name LIKE '%Scott';


-- 2.
SELECT
    e.Name,
    e.Salary AS Current_Salary,
    e.Salary * 1.10 AS Increased_Salary
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.SSN = w.SSN
JOIN PROJECT p ON w.PNO = p.PNO
WHERE p.PName = 'IoT';


-- 3.
SELECT
    SUM(e.Salary) AS Total_Salary,
    MAX(e.Salary) AS Max_Salary,
    MIN(e.Salary) AS Min_Salary,
    AVG(e.Salary) AS Avg_Salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.DNO = d.DNO
WHERE d.DName = 'Accounts';


-- 4.


SELECT E.Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.PNO
    FROM PROJECT P
    WHERE P.DNO = 5
      AND P.PNO NOT IN (
          SELECT W.PNO
          FROM WORKS_ON W
          WHERE W.SSN = E.SSN
      )
);

/* the WHERE NOT EXISTS BLOCK FINDS :🧠 BIG PICTURE: What is this block trying to find?
This block tries to find:
Projects of department 5 that the current employee does NOT work on
That’s the whole purpose.

THE P.PNO NOT IN BLOCK FINDS THE ALL THE PNO NUMBER OF PROJ THAT EMPLOEE IS WORKING ON !!
*/




-- 5.
SELECT
    E.DNO AS DepartmentNumber,
    COUNT(E.SSN) AS EmployeesAbove600000
FROM EMPLOYEE E
WHERE
    E.Salary > 600000
    AND E.DNO IN (
        SELECT DNO
        FROM EMPLOYEE
        GROUP BY DNO
        HAVING COUNT(*) >5
    )
GROUP BY E.DNO;



-- 6.
CREATE VIEW Employee_Department_Location AS
SELECT
    E.Name AS EmployeeName,
    D.DName AS DepartmentName,
    L.DLoc AS Location
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DNO = D.DNO
JOIN DLOCATION L ON D.DNO = L.DNO;


SELECT * FROM Employee_Department_Location;

-- 7.
DELIMITER //

CREATE TRIGGER PREVENT_DELETE
BEFORE DELETE ON PROJECT
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT *
        FROM WORKS_ON
        WHERE PNo = OLD.PNo
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The project cannot be deleted as it has an assigned employee';
    END IF;
END;
//

DELIMITER ;


DELETE FROM PROJECT WHERE PNo = 278345;

~
