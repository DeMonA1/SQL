#-----------------------------ANY ALL-------------------------------------------
#SELECT * FROM Salespeople WHERE city = ANY(SELECT city FROM Customers);
#SELECT * FROM Salespeople WHERE city IN (SELECT city FROM Customers);
#SELECT * FROM Salespeople WHERE sname < ANY(SELECT cname FROM Customers);
#SELECT * FROM Salespeople s1 WHERE EXISTS (SELECT * FROM Customers c1 WHERE s1.sname < c1.cname);
#SELECT * FROM Orders WHERE amt > ANY (SELECT amt FROM Orders WHERE odate = '10/06/1990');
#SELECT * FROM Orders WHERE amt < ANY (SELECT amt FROM Orders a, Customers b WHERE a.cnum = b.cnum AND b.city = 'San Jose');
#SELECT * FROM Orders WHERE amt < (SELECT MAX(amt) FROM Orders a, Customers b WHERE a.cnum = b.cnum AND b.city = 'San Jose');
#SELECT * FROM Customers WHERE rating > ALL (SELECT rating FROM Customers WHERE city = 'Rome');
#SELECT * FROM Customers c1 WHERE NOT EXISTS (SELECT * FROM Customers c2 WHERE c1.rating <= c2.rating AND c2.city = 'Rome');
#SELECT * FROM Customers WHERE rating <> ALL (SELECT rating FROM Customers WHERE city = 'San Jose');
#SELECT * FROM Customers WHERE rating NOT IN (SELECT rating FROM Customers WHERE city = 'San Jose');
#SELECT * FROM Customers WHERE NOT rating = ANY (SELECT rating FROM Customers WHERE city = 'San Jose');
#SELECT * FROM Customers WHERE rating > ANY (SELECT rating FROM Customers WHERE city = 'Boston');
#SELECT * FROM Customers WHERE rating > ALL (SELECT rating FROM Customers WHERE city = 'Boston');
#SELECT * FROM Customers WHERE rating > ANY (SELECT rating FROM Customers WHERE city = 'Rome');
#SELECT * FROM Customers c1 WHERE EXISTS (SELECT * FROM Customers c2 WHERE c1.rating > c2.rating AND c2.city = 'Rome');
#SELECT * FROM Customers c1 WHERE NOT EXISTS (SELECT * FROM Customers c2 WHERE c1.rating <= c2.rating AND c2.city = 'Rome');
#SELECT * FROM Customers c1 WHERE 1 > (SELECT COUNT(*) FROM Customers c2 WHERE c1.rating <=c2.rating AND c2.city = 'Rome');
#SELECT * FROM Customers WHERE rating > ANY
#(SELECT rating FROM Customers c, Salespeople s WHERE c.snum = s.snum AND s.sname = 'Serres');
#SELECT * FROM Salespeople s WHERE city <> ALL(SELECT city FROM Customers c WHERE s.snum = c.snum AND s.city = c.city);
#SELECT * FROM Customers WHERE amt > ALL
#(SELECT o.amt FROM Customers c, Orders o WHERE city = 'London' AND c.cnum = o.cnum);
#SELECT c1.cname FROM Customers c1, Orders o1 WHERE c1.cnum = o1.cnum AND o1.amt > ALL
#(SELECT o.amt FROM Customers c, Orders o WHERE city = 'London' AND c.cnum = o.cnum);
#SELECT c1.cname FROM Customers c1, Orders o1 WHERE c1.cnum = o1.cnum AND o1.amt > ALL
#(SELECT MAX(o.amt) FROM Customers c, Orders o WHERE city = 'London' AND c.cnum = o.cnum);
#-------------------------UNION------------------------------
#SELECT snum, sname FROM Salespeople WHERE city = 'London' UNION
#SELECT cnum, cname FROM Customers WHERE city = 'London';
#SELECT snum, city FROM Customers UNION
#SELECT snum, city FROM Salespeople;
#SELECT snum, city FROM Customers UNION ALL
#SELECT snum, city FROM Salespeople;
#SELECT a.snum, sname, onum, 'Highest on', odate FROM Salespeople a, Orders b 
#WHERE a.snum = b.snum AND b.amt = (SELECT MAX(amt) FROM Orders c WHERE c.odate = b.odate) UNION
#SELECT a.snum, sname, onum, 'Lowest on', odate FROM Salespeople a, Orders b 
#WHERE a.snum = b.snum AND b.amt = (SELECT MIN(amt) FROM Orders c WHERE c.odate = b.odate);
#SELECT a.snum, sname, onum, 'Highest on', odate FROM Salespeople a, Orders b
#WHERE a.snum = b.snum AND b.amt = (SELECT MAX(amt) FROM Orders c WHERE c.odate = b.odate) UNION
#SELECT a.snum, sname, onum, 'Lowest on', odate FROM Salespeople a, Orders b
#WHERE a.snum = b.snum AND b.amt = (SELECT MIN(amt) FROM Orders c WHERE c.odate = b.odate) ORDER BY 3;
#SELECT Salespeople.snum, sname, cname, comm FROM Salespeople, Customers 
#WHERE Salespeople.city = Customers.city UNION
#SELECT snum, sname, 'NO MATCH ', comm FROM Salespeople
#WHERE NOT city = ANY (SELECT city FROM Customers) ORDER BY 2 DESC;
#SELECT a.snum, sname, a.city, 'MATCHED' FROM Salespeople a, Customers b
#WHERE a.city = b.city UNION
#SELECT snum, sname, city, 'NO MATCH' FROM Salespeople 
#WHERE NOT city = ANY(SELECT city FROM Customers) ORDER BY 2 DESC;
#(SELECT snum, city, 'SALESPERSON - MATCHED' FROM Salespeople WHERE city = ANY(SELECT city FROM Customers) UNION
#SELECT snum, city, 'SALESPERSON - NO MATCH' FROM Salespeople WHERE NOT city = ANY(SELECT city FROM Customers)) UNION
#(SELECT cnum, city, 'CUSTOMER - MATCHED' FROM Customers WHERE city = ANY(SELECT city FROM Salespeople)) ORDER BY 2 DESC;
#SELECT cname, city, rating, 'High Rating' FROM Customers WHERE
#rating >= 200 UNION
#SELECT cname, city, rating, 'Low Rating' FROM Customers WHERE
#rating <= 200;
#SELECT snum as Num, sname as Name FROM Salespeople 
#WHERE snum = ANY(SELECT DISTINCT snum FROM Orders o1 WHERE 1 < 
#(SELECT COUNT(snum) FROM Orders o2 WHERE o1.snum = o2.snum)) UNION
#SELECT cnum, cname FROM Customers 
#WHERE cnum = ANY(SELECT DISTINCT cnum FROM Orders o1 WHERE 1 < 
#(SELECT COUNT(cnum) FROM Orders o2 WHERE o1.cnum = o2.cnum));
#(SELECT snum FROM Salespeople WHERE city = 'San Jose' UNION
#SELECT cnum FROM Customers WHERE city = 'San Jose') UNION
#SELECT onum FROM Orders WHERE odate = '10/03/1990';
#-------------DELETE/FROM, UPDATE/SET, INSERT/INTO/VALUES----------------------------
#INSERT INTO Salespeople (city, sname, comm, snum) VALUES ('San Jose', 'Blanco', NULL, 1100);
#DELETE FROM Salespeople WHERE snum = 1100;
#DELETE FROM Orders WHERE cnum = (SELECT cnum FROM Customers WHERE cname = 'Clemens'); 
#INSERT INTO Orders VALUES (3011, 9891.88, '10/06/1990', 2006, 1001);
#UPDATE Customers SET rating = rating - 100 WHERE city = 'Rome';
#UPDATE Customers SET snum = 1004 WHERE snum = (SELECT snum FROM Salespeople WHERE sname = 'Serres');
#UPDATE Orders SET snum = 1004 WHERE snum = (SELECT snum FROM Salespeople WHERE sname = 'Serres');
#DELETE FROM Salespeople WHERE snum = 1002;
#INSERT INTO Salespeople VALUES (1002, 'Serres', 'San Jose', 0.13);
#UPDATE Customers SET snum = 1002 WHERE cname = 'Liu';
#UPDATE Customers SET snum = 1002 WHERE cname = 'Grass';
#UPDATE Orders SET snum = 1002 WHERE onum = 3005;
#UPDATE Orders SET snum = 1002 WHERE onum = 3007;
#UPDATE Orders SET snum = 1002 WHERE onum = 3010;   
#INSERT INTO Multicast SELECT * FROM Salespeople WHERE 
#snum = ANY(SELECT DISTINCT snum FROM Customers c1 WHERE 1 < (SELECT COUNT(snum) FROM Customers c2 
#WHERE c1.snum = c2.snum));
#DELETE FROM Customers WHERE NOT cnum = ANY(SELECT DISTINCT cnum FROM Orders o1 
#WHERE cnum <> ANY(SELECT DISTINCT cnum FROM Orders));
#UPDATE Salespeople SET comm = comm * 1.2 
#WHERE snum = ANY(SELECT snum FROM Orders o1 WHERE 3000 < (SELECT SUM(amt) FROM Orders o2 WHERE o1.snum = o2.snum));
#---------------CREATE TABLE, DROP TABLE, CREATE INDEX/ON-------------------------------------------------
#CREATE TABLE Cutomers (
#cnum INT,
#cname TEXT,
#city TEXT,
#rating INT,
#snum INT);
#DROP TABLE Cutomers;
#CREATE INDEX date ON Orders(odate);
#CREATE INDEX sales_date ON Orders(snum, odate);
#CREATE UNIQUE INDEX group1 ON Customers(snum, rating);
#-----------------  -//- DEFAULT, CHECK -----------------
#CREATE TABLE Ord
#(onum INT UNIQUE,
#amt DECIMAL,
#odate DATE NOT NULL,
#cnum INT,
#snum INT,
#UNIQUE (cnum, snum));
#DROP TABLE ord;
#DROP TABLE Salespeopl;
#SELECT * FROM Salespeople WHERE city REGEXP '^[A-M]';
#CREATE TABLE Salespeopl
#(snum INT PRIMARY KEY,
#sname TEXT CHECK (sname REGEXP '^[A-M]'),
#city CHAR(75),
#comm REAL NOT NULL DEFAULT 0.1);
#CREATE TABLE Ord
#(onum INT UNIQUE NOT NULL,
#amt REAL,
#odate DATE NOT NULL,
#cnum INT NOT NULL,
#snum INT NOT NULL,
#CHECK (onum < cnum AND
#cnum > snum));
#DROP TABLE salespeopl;
#CREATE TABLE Employees
#(empno INT NOT NULL PRIMARY KEY,
#name CHAR(10) NOT NULL UNIQUE,
#manager INT REFERENCES Employees);
#CREATE TABLE Cityorders (
#onum INT NOT NULL REFERENCES Orders(onum),
#amt FLOAT REFERENCES Orders(amt),
#snum INT NOT NULL REFERENCES Orders(snum),
#cnum INT NOT NULL REFERENCES Customers(cnum),
#city CHAR(75) REFERENCES Customers(city),
#FOREIGN KEY (onum) REFERENCES Orders(onum),
#UNIQUE (onum, city));
#CREATE TABLE Ord
#(onum int PRIMARY KEY,
#amt FLOAT,
#odate DATE,
#cnum INT,
#snum INT,
#previ INT,
#FOREIGN KEY (previ, onum) REFERENCES Ord(cnum, onum));
#----------------------------VIEW------------------------------
#CREATE VIEW Londonstaff AS
#SELECT * FROM Salespeople WHERE city = 'London';
#SELECT * FROM londonstaff;
#CREATE VIEW Salesown AS
#SELECT snum, sname, city FROM Salespeople;
#UPDATE Salespeople SET city = 'London' WHERE snum = 1004;
#SELECT * FROM Londonstaff WHERE comm > 0.12;
#CREATE VIEW Ratingcount (rating, numbers) AS
#SELECT rating, COUNT(*) FROM customers GROUP BY rating;
#SELECT * FROM Ratingcount WHERE numbers = 3;
#SELECT rating, COUNT(*) FROM Customers GROUP BY rating HAVING COUNT(*) = 3;
#REATE VIEW Totalforday AS
#SELECT odate, COUNT(DISTINCT cnum), COUNT(DISTINCT snum), COUNT(onum), AVG(amt), SUM(amt)
#FROM Orders GROUP BY odate;
#CREATE VIEW Nameorders AS
#SELECT onum, amt, a.snum, sname, cname FROM Orders a, Customers b, Salespeople c
#WHERE a.cnum = b.cnum AND a.snum = c.snum;
#SELECT * FROM Nameorders WHERE sname = 'Rifkin';
#SELECT a.sname, cname, amt * comm FROM nameorders a, salespeople b
#WHERE a.sname = 'Axelrod' AND b.snum = a.snum;
#CREATE VIEW Elitesalesforce AS
#SELECT b.odate, a.snum, a.sname FROM Salespeople a, Orders b
#WHERE a.snum = b.snum AND b.amt = (SELECT MAX(amt) FROM Orders c WHERE c.odate = b.odate);
#CREATE VIEW Bonus AS
#SELECT DISTINCT snum, sname FROM elitesalesforce a
#WHERE 10 <= (SELECT COUNT(*) FROM Elitesalesforce b WHERE a.snum = b.snum);
#CREATE VIEW HighRate AS
#SELECT * FROM Customers WHERE rating = (SELECT MAX(rating) FROM Customers);
#CREATE VIEW SalesCity AS
#SELECT city, COUNT(snum) FROM Salespeople GROUP BY city;
#CREATE VIEW SalesOrders AS
#SELECT s.sname, SUM(amt), AVG(amt) FROM Salespeople s, Orders WHERE s.snum = Orders.snum GROUP BY Orders.snum;
#CREATE VIEW SalesCust AS
#SELECT sname s, cname c FROM salespeople s, customers c 
#WHERE s.snum = c.snum;
#CREATE VIEW Citymatch (custcity, salescity) AS
#SELECT DISTINCT a.city, b.city FROM Customers a, Salespeople b WHERE a.snum = b.snum;
#CREATE VIEW Dateorders (odate, ocount) AS SELECT odate, COUNT(*) FROM Orders GROUP BY odate;
#CREATE VIEW Londoncust AS SELECT * FROM Customers WHERE city = 'London';
#CREATE VIEW SJsales (neimes, numbers, percentage) AS
#SELECT sname, snum, comm * 100 FROM Salespeople WHERE city = 'San Jose'; 
#CREATE VIEW Salesonthird AS SELECT * FROM Salespeople WHERE snum IN (SELECT snum FROM Orders WHERE odate = '10/03/1990');
#CREATE VIEW Someorders AS SELECT snum, onum, cnum FROM Orders WHERE odate IN ('10/03/1990', '10/06/1990');
#CREATE VIEW highratings AS SELECT cnum, rating FROM customers WHERE rating = 300;
#CREATE VIEW highratings AS SELECT cnum, rating FROM customers WHERE rating = 300 WITH CHECK OPTION;
#CREATE VIEW Londonstuff AS
#SELECT * FROM Salespeople WHERE city = 'London' WITH CHECK Option;
#SELECT snum, sname, comm FROM londonstuff;
#CREATE VIEW Highrating AS SELECT cnum, rating FROM customers WHERE rating = 300 WITH CHECK OPTION;
#CREATE VIEW Myratings AS SELECT * FROM Highrating;
#UPDATE Myratings SET rating = 200 WHERE cnum = 2004;
#CREATE VIEW Commissions AS
#SELECT snum, comm FROM Salespeople WHERE comm BETWEEN 0.10 AND 0.20;
#CREATE TABLE Ord
#(onum int PRIMARY KEY,
#amt FLOAT,
#odate DATE DEFAULT current_timestamp,
#cnum int NOT NULL,
#snum int NOT NULL);
#CREATE VIEW Entryorders AS
#SELECT Ord
#WITH CHECK option;
#---------------------------------GRANT--------------------------------
#GRANT UPDATE(rating) ON Customers TO Janet;
#GRANT SELECT ON Orders TO Stephen WITH GRANT OPTION;
#REVOKE INSERT ON Salespeople FROM Claire;
#CREATE VIEW Sales1 AS 
#SELECT * FROM Customers WHERE rating BETWEEN 100 AND 500 WITH CHECK OPTION;
#GRANT INSERT, UPDATE ON Sales1 TO Jerry;
#CREATE VIEW Cust AS
#SELECT * FROM Customers WHERE rating > (SELECT MIN(rating) FROM Customers) WITH CHECK OPTION;
#GRANT SELECT ON Cust TO Janet;
#COMMIT WORK;
#ROLLBACK WORK;
#SET AUTOCOMMIT=0;
#UPDATE Orders SET snum = NULL WHERE snum = 1004;
#Update Customers SET snum = 1001 WHERE snum = 1004;
#DELETE FROM Salespeople WHERE snum = 1004;
#INSERT INTO Salespeople VALUES (1004, 'Motika', 'London', 0.11);
#UPDATE Customers SET snum = 1004 WHERE cname = 'Pereira';
#UPDATE Orders SET snum = 1004 WHERE snum IS NULL;
#ROLLBACK WORK;
#COMMIT WORK;
#SET AUTOCOMMIT = 1;
#SELECT tname, tabowner, cname, datatype FROM SYSTEMCATALOG
#WHERE cnumber > 4;
#SELECT COUNT(*), tname FROM SYSTEMSYNONS
#GROUP BY tname
