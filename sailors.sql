CREATE TABLE sailors (
    sid INT,
    sname VARCHAR(25),
    rating INT NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY (sid)
);

CREATE TABLE boats (
    bid INT NOT NULL,
    bname VARCHAR(30),
    color VARCHAR(15),
    PRIMARY KEY (bid)
);

CREATE TABLE reserves (
    sid INT NOT NULL,
    bid INT NOT NULL,
    day DATE,
    FOREIGN KEY (sid) REFERENCES sailors(sid) ON DELETE CASCADE,
    FOREIGN KEY (bid) REFERENCES boats(bid) ON DELETE CASCADE
);
INSERT INTO sailors VALUES
(1, 'John', 9, 65),
(2, 'Albert', 8, 55),
(3, 'James', 7, 45),
(4, 'Sandy', 5, 35),
(5, 'Patrick', 4, 37),
(6, 'Dennis', 8, 45);
INSERT INTO boats VALUES
(101, 'blue', 'blue'),
(102, 'red', 'red'),
(103, 'green', 'green'),
(104, 'white', 'white'),
(105, 'horse', 'green');
INSERT INTO reserves VALUES
(1, 101, '2008-01-01'),
(1, 102, '2008-06-09'),
(1, 103, '2008-01-01'),
(2, 104, '2008-03-03'),
(2, 105, '2008-09-08'),
(1, 102, '2008-01-01'),
(6, 101, '2008-01-01'),
(4, 105, '2008-09-09'),
(5, 104, '2008-01-05');
#1. Find colors of boats reserved by Albert
 select b.color from boats as b,sailors as s,reserves as r
 where s.sid=r.sid and b.bid=r.bid
 and s.sname="Albert";

#2.Find all sailor id's of sailors who have a rating of atleast 8 or reserved boat 103
(select distinct s.sid from sailors s where s.sid>=8)
union
(select distinct r.sid from reserves r where r.bid=103);

#3.Find the names of sailors who have not reserved a boat whose name conatins the string "storm".Order the names in ascneding order
 select distinct s.sname
 from sailors s
 left join reserves r on s.sid=r.sid
 where r.sid is null and s.sname like "%storm"
 order by s.sname asc;

 #4.Find the names of sailors who have reserved all boats.
 SELECT s.sname
 FROM sailors s
 WHERE NOT EXISTS (
    SELECT *
    FROM boats b
    WHERE NOT EXISTS (
        SELECT *
        FROM reserves r
        WHERE r.sid = s.sid
        AND r.bid = b.bid
    )
);
#5.Find the name and age of the oldest sailor.
select sname,age from sailors where age in (select max(age) from sailors);

#6.For each boat which was reserved by at least 2 sailors with age>=40,find the boat id and the average age of such sailors.
select b.bid,avg(s.age) as average_age from sailors s,boats b,reserves r 
where r.sid=s.sid and r.bid=b.bid and s.age>=40 group by bid having 2<=count(distinct r.sid);

#7.Create a view that shows the names and colors of all the boats that have been reserved by a sailor with a specific rating.
create view ReservedBoats as select distinct bname,color from sailors s,boats b,reserves r where s.sid=r.sid and b.bid=r.bid and s.rating=5;

select * from ReservedBoats;

#8.A trigger that prevents boats from being deleted if they have active reservations.
DELIMITER //

CREATE TRIGGER check_boat_delete
BEFORE DELETE ON boats
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM reserves WHERE reserves.bid = OLD.bid) THEN
      SIGNAL SQLSTATE '45000'  SET MESSAGE_TEXT = 'Boat is reserved and hence cannot be deleted';
       
    END IF;
END//

DELIMITER ;





