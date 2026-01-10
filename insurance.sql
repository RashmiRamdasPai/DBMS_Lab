DROP DATABASE IF EXISTS insurance;
CREATE DATABASE insurance;
USE insurance;

CREATE TABLE IF NOT EXISTS person (
driver_id VARCHAR(255) NOT NULL,
driver_name TEXT NOT NULL,
address TEXT NOT NULL,
PRIMARY KEY (driver_id)
);

CREATE TABLE IF NOT EXISTS car (
reg_no VARCHAR(255) NOT NULL,
model TEXT NOT NULL,
c_year INTEGER,
PRIMARY KEY (reg_no)
);

CREATE TABLE IF NOT EXISTS accident (
report_no INTEGER NOT NULL,
accident_date DATE,
location TEXT,
PRIMARY KEY (report_no)
);

CREATE TABLE IF NOT EXISTS owns (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS participated (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
report_no INTEGER NOT NULL,
damage_amount FLOAT NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE,
FOREIGN KEY (report_no) REFERENCES accident(report_no)
);

INSERT INTO person VALUES
("D111", "Driver_1", "Kuvempunagar, Mysuru"),
("D222", "Smith", "JP Nagar, Mysuru"),
("D333", "Driver_3", "Udaygiri, Mysuru"),
("D444", "Driver_4", "Rajivnagar, Mysuru"),
("D555", "Driver_5", "Vijayanagar, Mysore");

INSERT INTO car VALUES
("KA-20-AB-4223", "Swift", 2020),
("KA-20-BC-5674", "Mazda", 2017),
("KA-21-AC-5473", "Alto", 2015),
("KA-21-BD-4728", "Triber", 2019),
("KA-09-MA-1234", "Tiago", 2018);

INSERT INTO accident VALUES
(43627, "2020-04-05", "Nazarbad, Mysuru"),
(56345, "2019-12-16", "Gokulam, Mysuru"),
(63744, "2020-05-14", "Vijaynagar, Mysuru"),
(54634, "2019-08-30", "Kuvempunagar, Mysuru"),
(65738, "2021-01-21", "JSS Layout, Mysuru"),
(66666, "2021-01-21", "JSS Layout, Mysuru");

INSERT INTO owns VALUES
("D111", "KA-20-AB-4223"),
("D222", "KA-20-BC-5674"),
("D333", "KA-21-AC-5473"),
("D444", "KA-21-BD-4728"),
("D222", "KA-09-MA-1234");

INSERT INTO participated VALUES
("D111", "KA-20-AB-4223", 43627, 20000),
("D222", "KA-20-BC-5674", 56345, 49500),
("D333", "KA-21-AC-5473", 63744, 15000),
("D444", "KA-21-BD-4728", 54634, 5000),
("D222", "KA-09-MA-1234", 65738, 25000);



-- 1
/*
SELECT COUNT(DISTINCT o.driver_id) AS total_people
FROM participated p
JOIN accident a ON p.report_no = a.report_no
JOIN owns o ON p.reg_no = o.reg_no
WHERE a.accident_date LIKE '2021%';


 or
 select distinct(p.driver_id)  from participated p join accident a on a.report_no=p.report_no where a.accident_date like "2021%";


 */

/*2.
SELECT COUNT(DISTINCT pa.report_no) AS number_of_accidents
FROM person p
JOIN owns o ON p.driver_id = o.driver_id
JOIN participated pa ON o.reg_no = pa.reg_no
WHERE p.driver_name = 'Smith';
*/


/*4.
DELETE FROM owns
WHERE driver_id IN (
    SELECT driver_id
    FROM person
    WHERE driver_name =Smith'
)
AND reg_no IN (
    SELECT reg_no
    FROM car
    WHERE model = 'Mazda'
);
*/

/*5.
UPDATE participated
SET damage_amount = 170000
WHERE reg_no = 'KA-09-MA-1234'
  AND report_no = 65738;
(You can use any valid report number.)

*/

/*6
CREATE VIEW cars_in_accidents AS
SELECT DISTINCT c.model, c.c_year
FROM car c
JOIN participated p ON c.reg_no = p.reg_no;
*/



/* 7
delimiter //

create trigger insutrigger
before insert on participated
for each row
begin
 if 2>=(select count(*) from participated where driver_id=new.driver_id) then
    signal sqlstate '45000'
    set message_text= "cant participate";
 end if;
end;//

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
