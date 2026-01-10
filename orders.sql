tabase if exists order_processing;
create database order_processing;
use order_processing;




/* =========================
   ORDER PROCESSING DATABASE
   ========================= */

/* ---------- CUSTOMER ---------- */
CREATE TABLE Customer (
    cust_no INT PRIMARY KEY,
    cname VARCHAR(255),
    city VARCHAR(255)
);

/* ---------- ORDERS ---------- */
CREATE TABLE Orders (
    order_no INT PRIMARY KEY,
    odate DATE,
    cust_no INT,
    order_amt INT,
    FOREIGN KEY (cust_no) REFERENCES Customer(cust_no)
    ON DELETE CASCADE
);

/* ---------- ITEM ---------- */
CREATE TABLE Item (
    item INT PRIMARY KEY,
    unitprice INT
);

/* ---------- ORDER_ITEM ---------- */
CREATE TABLE Order_item (
    order_no INT,
    item INT,
    qty INT,
    PRIMARY KEY (order_no, item),
    FOREIGN KEY (order_no) REFERENCES Orders(order_no)
    ON DELETE CASCADE,
    FOREIGN KEY (item) REFERENCES Item(item)
    ON DELETE CASCADE
);

/* ---------- WAREHOUSE ---------- */
CREATE TABLE Warehouse (
    warehouse_no INT PRIMARY KEY,
    city VARCHAR(255)
);

/* ---------- SHIPMENT ---------- */
CREATE TABLE Shipment (
    order_no INT PRIMARY KEY,
    warehouse_no INT,
    ship_date DATE,
    FOREIGN KEY (order_no) REFERENCES Orders(order_no)
    ON DELETE CASCADE,
    FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_no)
    ON DELETE CASCADE
);

/* =========================
   INSERT DATA
   ========================= */

/* ---------- CUSTOMER ---------- */
INSERT INTO Customer VALUES
(1, 'John Doe', 'New York'),
(2, 'Jane Smith', 'Los Angeles'),
(3, 'Kumar', 'Chicago'),
(4, 'Alice Brown', 'Houston'),
(5, 'Charlie White', 'San Francisco');

/* ---------- ORDERS ---------- */
INSERT INTO Orders VALUES
(101, '2023-01-15', 1, 500),
(102, '2023-02-02', 2, 750),
(103, '2023-03-10', 3, 300),
(104, '2023-04-05', 4, 900),
(105, '2023-05-12', 5, 600);

/* ---------- ITEM ---------- */
INSERT INTO Item VALUES
(1, 50),
(2, 30),
(3, 25),
(4, 15),
(5, 40);

/* ---------- ORDER_ITEM ---------- */
INSERT INTO Order_item VALUES
(101, 1, 2),
(101, 2, 3),
(102, 3, 1),
(103, 4, 5),
(104, 5, 2);

/* ---------- WAREHOUSE ---------- */
INSERT INTO Warehouse VALUES
(1, 'C1'),
(2, 'C2'),
(3, 'C3'),
(4, 'C4'),
(5, 'C5');

/* ---------- SHIPMENT ---------- */
INSERT INTO Shipment VALUES
(101, 1, '2023-01-20'),
(102, 2, '2023-02-25'),
(103, 3, '2023-03-15'),
(104, 4, '2023-04-10'),
(105, 5, '2023-05-17');






-- 1.
SELECT order_no, ship_date
FROM Shipment
WHERE warehouse_no = 2;


-- 2 .
SELECT O.order_no, S.warehouse_no
FROM Customer C
JOIN Orders O ON C.cust_no = O.cust_no
JOIN Shipment S ON O.order_no = S.order_no
WHERE C.cname = 'Kumar';


-- 3.
SELECT
    C.cname,
    COUNT(O.order_no) AS No_of_Orders,
    AVG(O.order_amt) AS Avg_Order_Amt
FROM Customer C
JOIN Orders O ON C.cust_no = O.cust_no
GROUP BY C.cname;

-- 4.
DELETE FROM Orders
WHERE cust_no = (
    SELECT cust_no
    FROM Customer
    WHERE cname = 'Kumar'
);


-- 5.
SELECT *
FROM Item
WHERE unitprice = (
    SELECT MAX(unitprice)
    FROM Item
);


-- 6.
DELIMITER $$

CREATE TRIGGER UpdateOrderAmt
AFTER INSERT ON Order_item
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET order_amt =
        NEW.qty * (
            SELECT unitprice
            FROM Item
            WHERE item = NEW.item
        )
    WHERE order_no = NEW.order_no;
END$$

DELIMITER ;

INSERT INTO Orders VALUES
(006, "2020-12-23", 0004, 1200);

INSERT INTO Order_item VALUES
(006, 0001, 5); -- This will automatically update the Orders Table also

select * from Orders;

-- 7.
CREATE VIEW Orders_Warehouse_5 AS
SELECT s.order_no, s.ship_date
FROM Shipment s
WHERE s.warehouse_no = 5;

select * from Orders_Warehouse_5;

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
