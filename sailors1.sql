
/*DROP DATABASE IF EXISTS sailors;
CREATE DATABASE sailors;
USE sailors;

CREATE TABLE SAILORS (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    rating INT,
    age INT
);

CREATE TABLE BOAT (
    bid INT PRIMARY KEY,
    bname VARCHAR(50),
    color VARCHAR(50)
);

CREATE TABLE RESERVES (
    sid INT,
    bid INT,
    date DATE,
    FOREIGN KEY (sid) REFERENCES SAILORS(sid),
    FOREIGN KEY (bid) REFERENCES BOAT(bid)
);

INSERT INTO SAILORS VALUES
(1, 'Albert', 8, 41),
(2, 'Bob', 9, 45),
(3, 'Charlie', 9, 49),
(4, 'David', 8, 54),
(5, 'Eve', 7, 59);

INSERT INTO BOAT VALUES
(101, 'Boat1', 'Red'),
(102, 'Boat2', 'Blue'),
(103, 'Boat3', 'Green'),
(104, 'Boat4', 'Yellow'),
(105, 'Boat5', 'White');

INSERT INTO RESERVES VALUES
(1, 101, '2023-01-01'),
(1, 102, '2023-02-01'),
(1, 103, '2023-03-01'),
(1, 104, '2023-04-01'),
(1, 105, '2023-05-01'),
(2, 101, '2023-02-01'),
(3, 101, '2023-03-01'),
(4, 101, '2023-04-01'),
(5, 101, '2023-05-01');
*/
-- 1. Find the colours of boats reserved by Albert

/*"List each boat color only once — even if Albert reserved many boats of same color."this is the reason why distint is used"*/
/*
SELECT DISTINCT b.color
FROM BOAT b
JOIN RESERVES r ON b.bid = r.bid
JOIN SAILORS s ON s.sid = r.sid
WHERE s.sname = 'Albert';
*/
-- or
/*
SELECT b.color
FROM BOAT b
JOIN RESERVES r ON b.bid = r.bid
WHERE r.sid = (
    SELECT s.sid
    FROM SAILORS s
    WHERE s.sname = 'Albert'
);

*/


/* ------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- 2 Find all sailor IDs of sailors who: have a rating of at least 8 OR have reserved boat 103

/*
SELECT sid
FROM SAILORS
WHERE rating >= 8

UNION

SELECT sid
FROM RESERVES
WHERE bid = 103;


-- or


SELECT DISTINCT s.sid -- try without distinct youll get to see the diff
FROM SAILORS s
LEFT JOIN RESERVES r ON s.sid = r.sid
WHERE s.rating >= 8 OR r.bid = 103;
*/

/* ------------------------------------------------------------------------------------------------------------------------------------------------
*/


-- 3. Find the names of sailors who have not reserved a boat whose name contains the string
-- “storm”. Order the names in ascending order.
/*
SELECT s.sname
FROM SAILORS s
WHERE s.sid NOT IN (
    SELECT r.sid
    FROM RESERVES r
    JOIN BOAT b ON r.bid = b.bid
    WHERE b.bname LIKE '%storm%'
)
ORDER BY s.sname ASC;


*/


/*4.Find the names of sailors who have reserved all boats.
--> SELECT s.sname
FROM SAILORS s
JOIN RESERVES r ON s.sid = r.sid
GROUP BY s.sid
HAVING COUNT(DISTINCT r.bid) = (
    SELECT COUNT(*) FROM BOAT
);

*/


/* ------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
✅ Query 5: Find the name and age of the oldest sailor
SELECT sname, age
FROM SAILORS
WHERE age = (SELECT MAX(age) FROM SAILORS);

*/




/* ------------------------------------------------------------------------------------------------------------------------------------------------
*/

/* 6 For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id
and the average age of such sailors.


SELECT r.bid, AVG(s.age)
FROM RESERVES r
JOIN SAILORS s ON r.sid = s.sid
WHERE s.age >= 40          -- row-level condition
GROUP BY r.bid             -- grouping
HAVING COUNT(DISTINCT r.sid) >= 5;  -- group-level condition


*/

/*7 7. Create a view that shows the names and colors of all the boats that have been reserved
by a sailor with a specific rating

CREATE VIEW reservesboats AS
SELECT b.bname, b.color
FROM BOAT b
JOIN RESERVES r ON r.bid = b.bid
JOIN SAILORS s ON s.sid = r.sid
WHERE s.rating = 8;


checking view

SELECT * FROM reservesboats;

*/






/*8.
DELIMITER $$

CREATE TRIGGER prevent_boat_delete
BEFORE DELETE ON BOAT
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM RESERVES
        WHERE bid = OLD.bid
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete boat with active reservations';
    END IF;
END$$

DELIMITER ;
*/






delimiter //

create trigger trial
before delete on BOAT
for each row
begin
    if exists(select * from RESERVES  where bid=old.bid) then
        signal sqlstate '45000'
        set message_text ='cant delete';
    end if;
end//

delimiter ;
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
