
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL,
    name TEXT NOT NULL,
    doc_ser NUMERIC(4),
    doc_num NUMERIC(6),
    PRIMARY KEY (record_book)
);
CREATE TABLE progress (
    record_book NUMERIC(5) NOT NULL,
    subject TEXT NOT NULL,
    acad_year TEXT NOT NULL,
    term NUMERIC(1) NOT NULL CHECK (term = 1 OR term = 2),
    mark NUMERIC(1) NOT NULL CHECK (mark >= 3 AND mark <= 5) DEFAULT 5,
    FOREIGN KEY (record_book) REFERENCES students(record_book)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
ALTER TABLE students ADD COLUMN
    who_adds_row TEXT DEFAULT current_user;
INSERT INTo students (record_book, name, doc_ser, doc_num)
    VALUES (12300, 'Hi Hey Ho', 0402, 543281);
ALTER TABLE students ADD COLUMN 
    when_it_added TIMESTAMP DEFAULT current_timestamp;
INSERT INTO students (record_book, name, doc_ser, doc_num)
    VALUES (11000, 'Hu', 1332, 121311);
ALTER TABLE progress ADD COLUMN test_form VARCHAR(10);
ALTER TABLE progress ADD CHECK (test_form in ('examine', 'test'));
ALTER TABLE progress
ADD CHECK (
    (test_form = 'examine' AND mark IN (3,4,5))
    OR
    (test_form = 'test' AND mark IN (0, 1))
);
INSERT INTO progress 
VALUES ('12300', 'math', 'spring', '1', '4', 'examine');
ALTER TABLE progress DROP CONSTRAINT progress_mark_check;
INSERT INTO progress 
VALUES ('12300', 'math', 'spring', '1', '1', 'test');
ALTER TABLE progress ALTER COLUMN mark DROP NOT NULL;
INSERT INTO progress (record_book, subject, acad_year, term, test_form)
VALUES ('12300', 'physics', '2016/2017', 1, 'test');

ALTER TABLE students ADD UNIQUE(doc_ser, doc_num);
INSERT INTO students VALUES ('23000', 'HUSE', 444, 555);
INSERT INTO students VALUES ('2300', 'HUSE', 44, 555);
INSERT INTO students(record_book, name, doc_ser) VALUES ('23', 'HUSE', 444);
INSERT INTO students(record_book, name) VALUES ('2233', 'HUSE');
SELECT (null=null);
DROP TABLE students2;
CREATE TABLE students2 (
    record_book NUMERIC(5) NOT NULL UNIQUE,
    name TEXT NOT NULL,
    doc_ser NUMERIC(4),
    doc_num NUMERIC(6),
    PRIMARY KEY (doc_ser, doc_num)
);
CREATE TABLE progress2 (
    doc_ser NUMERIC(4) DEFAULT 1,
    doc_num NUMERIC(6) DEFAULT 2,
    subject TEXT NOT NULL,
    acad_year TEXT NOT NULL,
    term NUMERIC(1) NOT NULL CHECK (term = 1 OR term = 2),
    mark NUMERIC(1) NOT NULL CHECK (mark >= 3 AND mark <= 5) DEFAULT 5,
    FOREIGN KEY (doc_ser, doc_num) REFERENCES students2 (doc_ser, doc_num)
    ON DELETE CASCADE ON UPDATE SET DEFAULT
);
INSERT INTO students2 VALUES (12345, 'Pole', 1234, 123456);
INSERT INTO students2 VALUES (09871, 'Rosy', 1234, 124561);
INSERT INTO students2 VALUES (91211, 'Amerigo', 1, 2);
INSERT INTO progress2 VALUES (1234, 123456, 'math', '1233/1234', 1);
INSERT INTO progress2 VALUES (1234, 124561, 'physics', '1233/1234',1);

UPDATE progress2 SET doc_ser = 1324 WHERE subject = 'physics';
UPDATE students2 SET doc_ser = 1324 WHERE name = 'Pole';
DELETE FROM students2 WHERE doc_num=123456;

CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY,
    subject TEXT UNIQUE
);
INSERT INTO subjects VALUES (1, 'math');
INSERT INTO subjects VALUES (2, 'physics');
INSERT INTO subjects VALUES (3, 'history');
ALTER TABLE progress RENAME COLUMN subject TO subject_id;
ALTER TABLE progress 
ALTER COLUMN subject_id SET DATA TYPE integer
    USING (CASE WHEN subject_id = 'math' THEN 1
                WHEN subject_id = 'physics' THEN 2
                WHEN subject_id = 'history' THEN 3 END);
ALTER TABLE progress 
ADD FOREIGN KEY (subject_id) REFERENCES subjects;
INSERT INTO progress VALUES (23, 2, 'winter', 1, 1, 'test');
INSERT INTO progress VALUES (23, 1, 'winter', 1, 0, 'test');
INSERT INTO students (record_book, name, doc_ser, doc_num)
VALUES (1230, '', 1402, 543281);
ALTER TABLE students ADD CHECK (name <> '');
INSERT INTO students VALUES (12346, ' ', 0406, 112233);
INSERT INTO students VALUES (12347, '  ', 0407, 112234);
SELECT *, length(name) FROM students;
ALTER TABLE students ADD CHECK ('' <> trim(both ' ' from name));
ALTER TABLE students ALTER COLUMN doc_ser 
SET DATA TYPE CHAR(10);
-- Active: 1727185462921@@127.0.0.1@5432@demo@bookings

--CREATE TABLE aircrafts1 (
--    aircraft_code char(3) NOT NULL,
--    model text NOT NULL,
--    range INTEGER NOT NULL,
--    CHECK (range > 0),
--    PRIMARY KEY (aircraft_code)
--);


--INSERT INTO aircrafts1 (aircraft_code, model, range)
--VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);

--SELECT * FROM aircrafts1;

--INSERT INTO aircrafts1 (aircraft_code, model, range)
--VALUES ('773', 'Boeing 777-300', 11100),
--        ('764', 'Boeing 767-300', 7900),
  --      ('733', 'Boeing 737-300', 4200),
    --    ('320', 'Airbus A320-200', 5700),
      --  ('321', 'Airbus A321-200', 5600),
        --('319', 'Airbus A319-100', 6700),
--        ('CN1', 'Cessna 208 Caravan', 1200),
  --      ('CR2', 'Bombardier CRJ-200', 2700);

--SELECT * FROM aircrafts1;

--SELECT model, aircraft_code, range FROM aircrafts1 ORDER BY model;

--SELECT model, aircraft_code, range FROM aircrafts1 WHERE range >= 4000 AND range <= 6000;

--UPDATE aircrafts1 SET range = 3500 WHERE aircraft_code = 'SU9';

--SELECT * FROM aircrafts1 WHERE aircraft_code = 'SU9';

--DELETE FROM aircrafts1 WHERE aircraft_code = 'CN1';

--DELETE FROM aircrafts1 WHERE range > 10000 OR range < 3000;

--DELETE FROM aircrafts1;

--CREATE TABLE seats (
--    aircraft_code char(3) NOT NULL,
  --  seat_no VARCHAR(4) NOT NULL,
    --fare_conditions VARCHAR(10) NOT NULL,
   -- CHECK (fare_conditions IN ('Economy', 'Comfort', 'Business')),
    --PRIMARY KEY (aircraft_code, seat_no),
    --FOREIGN KEY (aircraft_code) 
     --   REFERENCES aircrafts1 (aircraft_code) ON DELETE CASCADE
--);

--INSERT INTO seats1 VALUES ('123', '1A', 'Business');

--INSERT INTO seats1 VALUES
  --  ('319', '1A', 'Business'),
--    ('319', '1B', 'Business'),
--    ('319', '10A', 'Economy'),
--    ('319', '10B', 'Economy'),
--    ('319', '10F', 'Economy'),
--    ('319', '20F', 'Economy');

--SELECT aircraft_code, count(*) FROM seats
--GROUP BY aircraft_code ORDER BY count;

--SELECT aircraft_code, fare_conditions, count(*) FROM seats
--GROUP BY aircraft_code, fare_conditions
--ORDER BY aircraft_code, fare_conditions;

--SELECT * FROM aircrafts1 ORDER BY range DESC;

--UPDATE aircrafts1 SET range=range * 2 WHERE aircraft_code='SU9';

--DELETE FROM aircrafts1 WHERE range <= 1;


-----------TYPE OF DATA------------------------------

--SELECT 0.1::REAL * 10 = 1.0::REAL; --FALSE

--SELECT 'PostgreSQL';
--SELECT 'PGDAY''17';

--SELECT $$PGDAY'1709/$$;

--SELECT E'PGDAY\'17';
-----------------------TIME--------------------------
SELECT '2016-09-12'::date;
SELECT 'Sep 12, 2016'::date;
SELECT CURRENT_DATE;
SELECT to_char(CURRENT_DATE, 'dd-mm-yyyy');
SELECT '21:15'::time;
SELECT '21:15:26'::time;
SELECT '10:15:16 am'::time;
SELECT '10:15:16 pm'::time;
SELECT current_time;
SELECT timestamp with time zone '2016-09-21 22:15:12';
SELECT TIMESTAMP '2016-09-21 22:25:35';
SELECT current_timestamp;

SELECT '1 year 2 months ago'::interval;
SELECT 'P0001-02-03T04:05:06'::interval;
SELECT ('2016-09-16'::timestamp - '2016-09-01'::timestamp)::INTERVAL;
SELECT (date_trunc('hour', current_timestamp));
SELECT extract('mon' FROM timestamp '1999-11-27 12:34:56.123459');

CREATE TABLE databases (is_open_source boolean, dbms_name text);

INSERT INTo databases VALUES (TRUE, 'PostgreSQL');
INSERT INTo databases VALUES (FALSE, 'Oracle');
INSERT INTo databases VALUES (TRUE, 'MySQL');
INSERT INTo databases VALUES (FALSE, 'MS SQL Server');
SELECT * FROM databases;
SELECT * FROM databases WHERE is_open_source;

----------------ARRAY--------------------------
CREATE TABLE pilots (
  pilot_name text,
  schedule INTEGER[]
);
INSERT INTO pilots
VALUES ('Ivan', '{1,2,3,5,6,7}'::INTEGER[]),
        ('Petr', '{1,2,5,7}'::INTEGER[]),
        ('Pavel','{2,5}'::INTEGER[]),
        ('Boris', '{3,5,6}'::INTEGER[]);
SELECT * FROM pilots;
UPDATE pilots SET schedule = schedule || 7
WHERE pilot_name = 'Boris';
UPDATE pilots SET schedule = array_append(schedule, 6)
WHERE pilot_name = 'Pavel';
UPDATE pilots SET schedule = array_prepend(1, schedule)
WHERE pilot_name = 'Pavel';
UPDATE pilots SET schedule = array_remove(schedule, 5)
WHERE pilot_name = 'Ivan';
UPDATE pilots SET schedule[1] = 2, schedule[2] = 3
WHERE pilot_name = 'Petr';
--or like that
UPDATE pilots SET schedule[1:2] = array[2,3]
WHERE pilot_name = 'Petr';
UPDATE pilots SET schedule = array_remove(schedule, 2)
WHERE pilot_name = 'Ivan';
SELECT * FROM pilots;

SELECT * FROM pilots
WHERE array_position(schedule, 3) IS NOT NULL;
SELECT * FROM pilots
WHERE schedule @> '{1, 7}'::INTEGER[];
SELECT * FROM pilots
WHERE schedule && ARRAY[2, 5];
SELECT * FROM pilots
WHERE NOT (schedule && array[2, 5]);
SELECT unnest(schedule) AS days_of_week FROM pilots
WHERE pilot_name = 'Ivan';

-------------------JSON---------------------
CREATE TABLE pilot_hobbies (
  pilot_name TEXT,
  hobbies JSONB
);
INSERT INTO pilot_hobbies
VALUES  ('Ivan',
        '{"sports": ["football", "swimming"],
          "home_lib": true, "trips": 3}'::jsonb),
        ('Petr',
        '{"sports":["tennis", "swimming"],
        "home_lib": true, "trips": 2}'::jsonb),
        ('Pavel',
        '{"sports":["swimming"],
        "home_lib": false, "trips": 4}'::jsonb),
        ('Boris',
        '{"sports":["football", "swimming", "tennis"],
        "home_lib": true, "trips": 0}'::jsonb);
SELECT * FROM pilot_hobbies;

SELECT * FROM pilot_hobbies
WHERE hobbies @> '{"sports": ["football"]}'::jsonb;
SELECT pilot_name, hobbies->'sports' AS sports FROM pilot_hobbies
WHERE hobbies->'sports' @> '["football"]'::jsonb;
SELECT count(*) FROM pilot_hobbies
WHERE hobbies ? 'sport';
SELECT count(*) FROM pilot_hobbies
WHERE hobbies ? 'sports';
UPDATE pilot_hobbies SET hobbies = hobbies || '{"sports": ["hockey"]}'
WHERE pilot_name = 'Boris';
SELECT pilot_name, hobbies FROM pilot_hobbies
WHERE pilot_name = 'Boris';
UPDATE pilot_hobbies SET hobbies = jsonb_set(hobbies, '{sports, 1}', '"football"')
WHERE pilot_name = 'Boris';
SELECT pilot_name, hobbies FROM pilot_hobbies
WHERE pilot_name = 'Boris'; 


---------------------------------------------------
CREATE TABLE test_numeric (
  measurment NUMERIC(5, 2),
  descrtiption TEXT
);
INSERT INTO test_numeric
VALUES (999.9999, 'Some kind of measurment ');
INSERT INTO test_numeric
VALUES (999.9009, 'One more measurment ');
INSERT INTO test_numeric
VALUES (999.1111, 'And one more measurment ');
INSERT INTO test_numeric
VALUES (998.9999, 'And one more ');

DROP TABLE test_numeric;

CREATE TABLE test_numeric (
  measurement NUMERIC,
  description TEXT
);
INSERT INTO test_numeric
VALUES (1234567890.0987654321, 'Precision of 20 characters, scale of 10 characters');
INSERT INTO test_numeric
VALUES (1.5, 'Precision of 2 characters, scale of 1 character');
INSERT INTO test_numeric
VALUES (0.12345678901234567890, 'Precision of 21 characters, scale of 20 characters');
INSERT INTO test_numeric
VALUES (1234567890, 'Precision of 20 characters, scale of 0 characters (integer)');
INSERT INTO test_numeric
VALUES (1234567890.0987654321, 'Precision of 20 characters, scale of 10 characters');
INSERT INTO test_numeric
VALUES (1.5, 'Precision of 2 characters, scale of 1 character');
INSERT INTO test_numeric
VALUES (0.12345678901234567890, 'Precision of 21 characters, scale of 20 characters');
INSERT INTO test_numeric
VALUES (1234567890, 'Precision of 20 characters, scale of 0 characters (integer)');
SELECT * FROM test_numeric;

SELECT 'NaN'::NUMERIC > 10000; --true

SELECT '5e-324'::double PRECISION > '4e-324'::double PRECISION;
SELECT '4e-324'::double PRECISION;
SELECT '4e307'::double PRECISION >= '4e307'::double PRECISION; -- true
SELECT '1e-37'::REAL >= '1e-37'::REAL; --true
SELECT '1e37'::REAL <= '1e37'::REAL; -- true
SELECT '-Infinity'::double PRECISION <= 1e-308; -- true
SELECT 0.0 * 'Inf'::REAL;
SELECT 'NaN'::REAL > 'Inf'::REAL; --true

CREATE TABLE test_serial (
  id SERIAL,
  name TEXT
);
INSERT INTO test_serial (name) VALUES ('Cherry');
INSERT INTO test_serial (name) VALUES ('Pear');
INSERT INTO test_serial (name) VALUES ('Green');
SELECT * FROM test_serial;
INSERT INTO test_serial (id, name) VALUES (10, 'Cool');
INSERT INTO test_serial (name) VALUES ('Meadow');
DROP TABLE test_serial;
CREATE TABLE test_serial (
  id SERIAL PRIMARY KEY,
  name TEXT
);

INSERT INTO test_serial (name) VALUES ('Cherry');
INSERT INTO test_serial (id, name) VALUES (2, 'Cool');
INSERT INTO test_serial (name) VALUES ('Pear');
INSERT INTO test_serial (name) VALUES ('Green');
DELETE FROM test_serial WHERE id=4;
INSERT INTO test_serial (name) VALUES ('Meadow');
SELECT * FROM test_serial;

SELECT current_time, current_timestamp, '22:11:11.222'::interval;
SELECT current_time::time(0), current_timestamp::time(0), '22:11:11.222'::interval(0);
SELECT current_time::time(3), current_timestamp::time(3), '22:11:11.222'::interval(3);
SHOW datesty-- Active: 1727185462921@@127.0.0.1@5432@demo@bookings

--CREATE TABLE aircrafts1 (
--    aircraft_code char(3) NOT NULL,
--    model text NOT NULL,
--    range INTEGER NOT NULL,
--    CHECK (range > 0),
--    PRIMARY KEY (aircraft_code)
--);


--INSERT INTO aircrafts1 (aircraft_code, model, range)
--VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);

--SELECT * FROM aircrafts1;

--INSERT INTO aircrafts1 (aircraft_code, model, range)
--VALUES ('773', 'Boeing 777-300', 11100),
--        ('764', 'Boeing 767-300', 7900),
  --      ('733', 'Boeing 737-300', 4200),
    --    ('320', 'Airbus A320-200', 5700),
      --  ('321', 'Airbus A321-200', 5600),
        --('319', 'Airbus A319-100', 6700),
--        ('CN1', 'Cessna 208 Caravan', 1200),
  --      ('CR2', 'Bombardier CRJ-200', 2700);

--SELECT * FROM aircrafts1;

--SELECT model, aircraft_code, range FROM aircrafts1 ORDER BY model;

--SELECT model, aircraft_code, range FROM aircrafts1 WHERE range >= 4000 AND range <= 6000;

--UPDATE aircrafts1 SET range = 3500 WHERE aircraft_code = 'SU9';

--SELECT * FROM aircrafts1 WHERE aircraft_code = 'SU9';

--DELETE FROM aircrafts1 WHERE aircraft_code = 'CN1';

--DELETE FROM aircrafts1 WHERE range > 10000 OR range < 3000;

--DELETE FROM aircrafts1;

--CREATE TABLE seats (
--    aircraft_code char(3) NOT NULL,
  --  seat_no VARCHAR(4) NOT NULL,
    --fare_conditions VARCHAR(10) NOT NULL,
   -- CHECK (fare_conditions IN ('Economy', 'Comfort', 'Business')),
    --PRIMARY KEY (aircraft_code, seat_no),
    --FOREIGN KEY (aircraft_code) 
     --   REFERENCES aircrafts1 (aircraft_code) ON DELETE CASCADE
--);

--INSERT INTO seats1 VALUES ('123', '1A', 'Business');

--INSERT INTO seats1 VALUES
  --  ('319', '1A', 'Business'),
--    ('319', '1B', 'Business'),
--    ('319', '10A', 'Economy'),
--    ('319', '10B', 'Economy'),
--    ('319', '10F', 'Economy'),
--    ('319', '20F', 'Economy');

--SELECT aircraft_code, count(*) FROM seats
--GROUP BY aircraft_code ORDER BY count;

--SELECT aircraft_code, fare_conditions, count(*) FROM seats
--GROUP BY aircraft_code, fare_conditions
--ORDER BY aircraft_code, fare_conditions;

--SELECT * FROM aircrafts1 ORDER BY range DESC;

--UPDATE aircrafts1 SET range=range * 2 WHERE aircraft_code='SU9';

--DELETE FROM aircrafts1 WHERE range <= 1;


-----------TYPE OF DATA------------------------------

--SELECT 0.1::REAL * 10 = 1.0::REAL; --FALSE

--SELECT 'PostgreSQL';
--SELECT 'PGDAY''17';

--SELECT $$PGDAY'1709/$$;

--SELECT E'PGDAY\'17';
-----------------------TIME--------------------------
SELECT '2016-09-12'::date;
SELECT 'Sep 12, 2016'::date;
SELECT CURRENT_DATE;
SELECT to_char(CURRENT_DATE, 'dd-mm-yyyy');
SELECT '21:15'::time;
SELECT '21:15:26'::time;
SELECT '10:15:16 am'::time;
SELECT '10:15:16 pm'::time;
SELECT current_time;
SELECT timestamp with time zone '2016-09-21 22:15:12';
SELECT TIMESTAMP '2016-09-21 22:25:35';
SELECT current_timestamp;

SELECT '1 year 2 months ago'::interval;
SELECT 'P0001-02-03T04:05:06'::interval;
SELECT ('2016-09-16'::timestamp - '2016-09-01'::timestamp)::INTERVAL;
SELECT (date_trunc('hour', current_timestamp));
SELECT extract('mon' FROM timestamp '1999-11-27 12:34:56.123459');

CREATE TABLE databases (is_open_source boolean, dbms_name text);

INSERT INTo databases VALUES (TRUE, 'PostgreSQL');
INSERT INTo databases VALUES (FALSE, 'Oracle');
INSERT INTo databases VALUES (TRUE, 'MySQL');
INSERT INTo databases VALUES (FALSE, 'MS SQL Server');
SELECT * FROM databases;
SELECT * FROM databases WHERE is_open_source;

----------------ARRAY--------------------------
CREATE TABLE pilots (
  pilot_name text,
  schedule INTEGER[]
);
INSERT INTO pilots
VALUES ('Ivan', '{1,2,3,5,6,7}'::INTEGER[]),
        ('Petr', '{1,2,5,7}'::INTEGER[]),
        ('Pavel','{2,5}'::INTEGER[]),
        ('Boris', '{3,5,6}'::INTEGER[]);
SELECT * FROM pilots;
UPDATE pilots SET schedule = schedule || 7
WHERE pilot_name = 'Boris';
UPDATE pilots SET schedule = array_append(schedule, 6)
WHERE pilot_name = 'Pavel';
UPDATE pilots SET schedule = array_prepend(1, schedule)
WHERE pilot_name = 'Pavel';
UPDATE pilots SET schedule = array_remove(schedule, 5)
WHERE pilot_name = 'Ivan';
UPDATE pilots SET schedule[1] = 2, schedule[2] = 3
WHERE pilot_name = 'Petr';
--or like that
UPDATE pilots SET schedule[1:2] = array[2,3]
WHERE pilot_name = 'Petr';
UPDATE pilots SET schedule = array_remove(schedule, 2)
WHERE pilot_name = 'Ivan';
SELECT * FROM pilots;

SELECT * FROM pilots
WHERE array_position(schedule, 3) IS NOT NULL;
SELECT * FROM pilots
WHERE schedule @> '{1, 7}'::INTEGER[];
SELECT * FROM pilots
WHERE schedule && ARRAY[2, 5];
SELECT * FROM pilots
WHERE NOT (schedule && array[2, 5]);
SELECT unnest(schedule) AS days_of_week FROM pilots
WHERE pilot_name = 'Ivan';

-------------------JSON---------------------
CREATE TABLE pilot_hobbies (
  pilot_name TEXT,
  hobbies JSONB
);
INSERT INTO pilot_hobbies
VALUES  ('Ivan',
        '{"sports": ["football", "swimming"],
          "home_lib": true, "trips": 3}'::jsonb),
        ('Petr',
        '{"sports":["tennis", "swimming"],
        "home_lib": true, "trips": 2}'::jsonb),
        ('Pavel',
        '{"sports":["swimming"],
        "home_lib": false, "trips": 4}'::jsonb),
        ('Boris',
        '{"sports":["football", "swimming", "tennis"],
        "home_lib": true, "trips": 0}'::jsonb);
SELECT * FROM pilot_hobbies;

SELECT * FROM pilot_hobbies
WHERE hobbies @> '{"sports": ["football"]}'::jsonb;
SELECT pilot_name, hobbies->'sports' AS sports FROM pilot_hobbies
WHERE hobbies->'sports' @> '["football"]'::jsonb;
SELECT count(*) FROM pilot_hobbies
WHERE hobbies ? 'sport';
SELECT count(*) FROM pilot_hobbies
WHERE hobbies ? 'sports';
UPDATE pilot_hobbies SET hobbies = hobbies || '{"sports": ["hockey"]}'
WHERE pilot_name = 'Boris';
SELECT pilot_name, hobbies FROM pilot_hobbies
WHERE pilot_name = 'Boris';
UPDATE pilot_hobbies SET hobbies = jsonb_set(hobbies, '{sports, 1}', '"football"')
WHERE pilot_name = 'Boris';
SELECT pilot_name, hobbies FROM pilot_hobbies
WHERE pilot_name = 'Boris'; 


---------------------------------------------------
CREATE TABLE test_numeric (
  measurment NUMERIC(5, 2),
  descrtiption TEXT
);
INSERT INTO test_numeric
VALUES (999.9999, 'Some kind of measurment ');
INSERT INTO test_numeric
VALUES (999.9009, 'One more measurment ');
INSERT INTO test_numeric
VALUES (999.1111, 'And one more measurment ');
INSERT INTO test_numeric
VALUES (998.9999, 'And one more ');

DROP TABLE test_numeric;

CREATE TABLE test_numeric (
  measurement NUMERIC,
  description TEXT
);
INSERT INTO test_numeric
VALUES (1234567890.0987654321, 'Precision of 20 characters, scale of 10 characters');
INSERT INTO test_numeric
VALUES (1.5, 'Precision of 2 characters, scale of 1 character');
INSERT INTO test_numeric
VALUES (0.12345678901234567890, 'Precision of 21 characters, scale of 20 characters');
INSERT INTO test_numeric
VALUES (1234567890, 'Precision of 20 characters, scale of 0 characters (integer)');
INSERT INTO test_numeric
VALUES (1234567890.0987654321, 'Precision of 20 characters, scale of 10 characters');
INSERT INTO test_numeric
VALUES (1.5, 'Precision of 2 characters, scale of 1 character');
INSERT INTO test_numeric
VALUES (0.12345678901234567890, 'Precision of 21 characters, scale of 20 characters');
INSERT INTO test_numeric
VALUES (1234567890, 'Precision of 20 characters, scale of 0 characters (integer)');
SELECT * FROM test_numeric;

SELECT 'NaN'::NUMERIC > 10000; --true

SELECT '5e-324'::double PRECISION > '4e-324'::double PRECISION;
SELECT '4e-324'::double PRECISION;
SELECT '4e307'::double PRECISION >= '4e307'::double PRECISION; -- true
SELECT '1e-37'::REAL >= '1e-37'::REAL; --true
SELECT '1e37'::REAL <= '1e37'::REAL; -- true
SELECT '-Infinity'::double PRECISION <= 1e-308; -- true
SELECT 0.0 * 'Inf'::REAL;
SELECT 'NaN'::REAL > 'Inf'::REAL; --true

CREATE TABLE test_serial (
  id SERIAL,
  name TEXT
);
INSERT INTO test_serial (name) VALUES ('Cherry');
INSERT INTO test_serial (name) VALUES ('Pear');
INSERT INTO test_serial (name) VALUES ('Green');
SELECT * FROM test_serial;
INSERT INTO test_serial (id, name) VALUES (10, 'Cool');
INSERT INTO test_serial (name) VALUES ('Meadow');
DROP TABLE test_serial;
CREATE TABLE test_serial (
  id SERIAL PRIMARY KEY,
  name TEXT
);

INSERT INTO test_serial (name) VALUES ('Cherry');
INSERT INTO test_serial (id, name) VALUES (2, 'Cool');
INSERT INTO test_serial (name) VALUES ('Pear');
INSERT INTO test_serial (name) VALUES ('Green');
DELETE FROM test_serial WHERE id=4;
INSERT INTO test_serial (name) VALUES ('Meadow');
SELECT * FROM test_serial;

SELECT current_time, current_timestamp, '22:11:11.222'::interval;
SELECT current_time::time(0), current_timestamp::time(0), '22:11:11.222'::interval(0);
SELECT current_time::time(3), current_timestamp::time(3), '22:11:11.222'::interval(3);
SHOW datestyle;
SELECT '2016-05-19'::date;
SELECT '05-23-2019'::date;
SELECT '18-05-2019'::date;
SET datestyle TO 'DMY';
SET datestyle TO DEFAULT;
SELECT '2016-05-19'::timestamp;
SELECT '05-23-2019'::timestamp;
SELECT '18-05-2019'::timestamp;
SET datestyle TO 'Postgres, DMY';
SET datestyle TO 'German';
SET datestyle TO 'SQL';
SELECT current_timestamp;le;
SELECT '2016-05-19'::date;
SELECT '05-23-2019'::date;
SELECT '18-05-2019'::date;
SET datestyle TO 'DMY';
SET datestyle TO DEFAULT;
SELECT '2016-05-19'::timestamp;
SELECT '05-23-2019'::timestamp;
SELECT '18-05-2019'::timestamp;
SET datestyle TO 'Postgres, DMY';
SET datestyle TO 'German';
SET datestyle TO 'SQL';
SELECT to_char(current_timestamp, 'mi:ss');
SELECT to_char(current_timestamp, 'dd');
SELECT to_char(current_timestamp, 'yyyy-mm-mi-dd');
SELECT 'Feb 29, 2015'::date; -- error
SELECT '21:15:16:22'::time; -- error
SELECT ('2016-09-16'::date - '2016-09-01'::date);ELECT current_timestamp;
SELECT ('20:34:35'::time - '19:44:45'::time);
SELECT (current_timestamp - '2016-01-01'::timestamp) AS new_date;
SELECT (current_timestamp + '1 mon'::interval);
SELECT ('2016-01-31'::date + '1 mon'::interval) as new_date;
SELECT ('2016-02-29'::date + '1 mon'::interval) as new_date;
SET intervalstyle TO 'postgres_verbose';
SET intervalstyle to DEFAULT;
SET intervalstyle to 'iso_8601';
SELECT '2 years 15 months 100 weeks 99 hours 123456789 milliseconds'::interval;
SELECT ('2016-09-16'::date - '2015-09-01'::date);
SELECT ('2016-09-16'::timestamp - '2015-09-01'::timestamp);
SELECT ('20:34:35'::time - '1 minutes'::interval); --error
SELECT('2016-09-16'::date - 1);
SELECT (date_trunc('mil', TIMESTAMP '1999-11-27 12:34:56.987654'));
SELECT extract('mil' from timestamp '1999-11-27 12:34:56.123455');
SELECT extract(CENTURY FROM INTERVAL '2091 year');
SELECT * FROM databases WHERE is_open_source <> 't';
CREATE TABLE test_bool (
  a BOOLEAN,
  b TEXT
);
INSERT INTO test_bool VALUES (TRUE, 'yes');
INSERT INTO test_bool VALUES (yes, 'yes'); -- error
INSERT INTO test_bool VALUES ('yes', true);
INSERT INTO test_bool VALUES ('yes', TRUE);
INSERT INTO test_bool VALUES ('1', 'true');
INSERT INTO test_bool VALUES (1, 'true'); --error
INSERT INTO test_bool VALUES ('t', 'true');
INSERT INTO test_bool VALUES ('t', truth); --error
INSERT INTO test_bool VALUES (true, true);
INSERT INTO test_bool VALUES (1::BOOLEAN, 'true');
INSERT INTO test_bool VALUES (111::BOOLEAN, 'true');

CREATE TABLE birthdays (
  person TEXT NOT NULL,
  birthday date NOT NULL
);
INSERT INTO birthdays VALUES ('Ken Thompson', '1955-03-23');
INSERT INTO birthdays VALUES ('Ben Johnson', '1971-03-19');
INSERT INTO birthdays VALUES ('Andy Gibson', '1987-08-12');
SELECT * FROM birthdays WHERE extract('mon' from birthday) = 3;
SELECT *, birthday + '40 years'::interval FROM birthdays
WHERE birthday + '40 years'::interval < current_timestamp;
SELECT *, birthday + '40 years'::interval FROM birthdays
WHERE birthday + '40 years'::interval < CURRENT_DATE;
SELECT *, (current_date::TIMESTAMP - birthday::TIMESTAMP)::INTERVAL
FROM birthdays;
SELECT *, age( current_timestamp, birthday) FROM birthdays;

-----------ARRAY------------------------
SELECT array_cat(array[1,2,3], array[3,5]);
SELECT array_remove(array[1,2,3], 3);

CREATE TABLE pilots (
  pilot_name TEXT,
  schedule INTEGER[],
  meal TEXT[]
);
INSERT INTO pilots
VALUES ('Ivan', '{1,3,5,6,7}'::integer[],
        '{"sausage", "macarons", "cofe"}'::text[]),
        ('Petr', '{1,2,5,7}'::integer[],
        '{"cutlet", "porridge", "cofe"}'::text[]),
        ('Pavel', '{2,5}'::integer[],
        '{"sausage", "porridge", "cofe"}'::text[]),
        ('Boris', '{3,5,6}'::integer[],
        '{"cutlet", "porridge", "tea"}'::text[]);
SELECT * FROM pilots;
SELECT * FROM pilots WHERE meal[1] = 'sausage';
UPDATE pilots SET meal = '{{"sausage", "macarons", "cofe"},
                            {"cutlet", "porridge", "cofe"},
                            {"sausage", "porridge", "cofe"},
                            {"cutlet", "porridge", "tea"}}'::text[][]
WHERE pilot_name = 'Ivan';
UPDATE pilots SET meal = array_prepend('soup', meal)
WHERE pilot_name = 'Petr';

SELECT * FROM pilots WHERE meal[2][2] = 'porridge';

------------JSON-------------------
UPDATE pilot_hobbies SET hobbies = jsonb_set(hobbies, '{trips}', '10')
WHERE pilot_name = 'Pavel';
SELECT pilot_name, hobbies -> 'trips' AS trips FROM pilot_hobbies;
UPDATE pilot_hobbies SET hobbies = jsonb_set(hobbies, '{home_lib}', 'false')
WHERE pilot_name = 'Boris';
SELECT '{"sports": "hockey"}'::jsonb || '{"trips": 5}'::jsonb;
UPDATE pilot_hobbies SET hobbies = hobbies || '{"exp" : 5}'
WHERE pilot_name = 'Boris';
UPDATE pilot_hobbies SET hobbies = hobbies - 'exp'
WHERE pilot_name = 'Boris';


---------------TRANSACTIONS------------------------
SHOW default_transaction_isolation;
DROP TABLE aircrafts_tmp;
CREATE TABLE aircrafts_tmp AS SELECT * FROM aircrafts;
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SHOW transaction_isolation;
UPDATE aircrafts_tmp
SET range = range + 100 WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts_tmp WHERE aircraft_code = 'SU9';
ROLLBACK;


BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;
UPDATE aircrafts_tmp
SET range = range + 100 WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts_tmp WHERE aircraft_code = 'SU9';
COMMIT;

BEGIN;
SELECT * FROM aircrafts_tmp;
END;


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM aircrafts_tmp;
END;
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE aircrafts_tmp SET range = range + 100 WHERE aircraft_code = '320';
END;
SELECT * FROM aircrafts_tmp WHERE aircraft_code = '320';


CREATE TABLE modes(
    num INTEGER,
    mode TEXT
);
INSERT INTO modes VALUES (1, 'LOW'), (2, 'HIGH');
SELECT * FROM modes;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes SET mode = 'HIGH' WHERE mode = 'LOW' RETURNING *;
COMMIT;
END;


BEGIN;
INSERT INTO bookings (book_ref, book_date, total_amount)
VALUES ('ABC123', bookings.now(), 0);
INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name)
VALUES ('9991234567890', 'ABC123', '1234 123456', 'IVAN PETROV');
INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name)
VALUES ('9991234567891', 'ABC123', '4321 654321', 'PETR IVANOV');
INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
VALUES ('9991234567890', 5572, 'Business', 12500),
        ('9991234567890', 13881, 'Economy', 8500);
INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
VALUES ('9991234567891', 5572, 'Business', 12500),
        ('9991234567891', 13881, 'Economy', 8500);

UPDATE bookings SET total_amount = (
    SELECT sum(amount) FROM ticket_flights
    WHERE ticket_no IN (
        SELECT ticket_no FROM tickets WHERE book_ref = 'ABC123'))
WHERE book_ref = 'ABC123';

SELECT * FROM bookings WHERE book_ref = 'ABC123';
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM aircrafts_tmp WHERE model ~ '^Аэро' FOR UPDATE;
UPDATE aircrafts_tmp SET range = 5800 WHERE aircraft_code = '320';
END;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
LOCK TABLE aircrafts_tmp IN ACCESS EXCLUSIVE MODE;
ROLLBACK;


BEGIN;
SELECT * FROM aircrafts_tmp WHERE range < 3000;
UPDATE aircrafts_tmp SET range = 2100 WHERE aircraft_code = 'CN1';
UPDATE aircrafts_tmp SET range = 1900 WHERE aircraft_code = 'CR2';
COMMIT;
ROLLBACK;
SELECT * FROM aircrafts_tmp;


BEGIN;
SELECT * FROM aircrafts_tmp WHERE range > 6000;
END;


BEGIN;
SELECT * FROM aircrafts_tmp WHERE aircraft_code IN ('773', '763', 'SU9') FOR UPDATE;

BEGIN;
SELECT * FROM aircrafts_tmp WHERE aircraft_code IN ('773', '763', 'SU9') FOR SHARE;

CREATE TABLE modes AS
SELECT num::INTEGER, 'LOW' || num::text AS mode
    FROM generate_series(1, 100000) AS gen_ser(num)
UNION ALL
SELECT num::integer, 'HIGH' || (num - 100000)::text AS mode
    FROM generate_series (100001, 200000) AS gen_ser(num);

CREATE INDEX modes_ind ON modes (num);

SELECT * FROM modes WHERE mode IN ('LOW1', 'HIGH1');
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE modes SET mode = 'HIGH1' WHERE num = 1;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM ticket_flights WHERE flight_id = 5572;
INSERT INTO bookings(book_ref, book_date, total_amount)
VALUES('ABC126', bookings.now(), 0);
INSERT INTO tickets(ticket_no, book_ref, passenger_id, passenger_name)
VALUES('7891234567890', 'ABC126', '1234 123456', 'IVAN PETROV');
INSERT INTO ticket_flights(ticket_no, flight_id, fare_conditions, amount)
VALUES('7891234567890', 13881, 'Business', 12500);

UPDATE bookings SET total_amount = 12500
WHERE book_ref = 'ABC126';
COMMIT;


EXPLAIN SELECT * FROM aircrafts;
EXPLAIN (COSTS OFF) SELECT * FROM aircrafts;
EXPLAIN SELECT * FROM aircrafts WHERE model ~ 'Аэр'; 
EXPLAIN SELECT * FROM aircrafts ORDER BY aircraft_code;
EXPLAIN SELECT * FROM bookings ORDER BY book_ref;
EXPLAIN SELECT * FROM bookings WHERE book_ref > '0000FF' AND
    book_ref < '000FFF' ORDER BY book_ref;

EXPLAIN SELECT * FROM seats WHERE aircraft_code = 'SU9';
EXPLAIN SELECT book_ref FROM bookings WHERE book_ref < '000FFF'
ORDER BY book_ref;
EXPLAIN SELECT count(*) FROM seats WHERE aircraft_code = 'SU9';
EXPLAIN SELECT avg(total_amount) FROM bookings;



EXPLAIN SELECT a.aircraft_code, a.model,
                s.seat_no, s.fare_conditions
FROM seats s
JOIN aircrafts a ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Аэро' ORDER BY s.seat_no;

EXPLAIN SELECT r.flight_no, r.departure_airport_name,
                r.arrival_airport_name, a.model
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
ORDER BY flight_no;

EXPLAIN SELECT t.ticket_no, t.passenger_name,
                tf.flight_id, tf.amount
FROM tickets t
JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
ORDER BY t.ticket_no;

SET enable_hashjoin = on;
SET enable_mergejoin = ON;
SET enable_nestloop = on;

EXPLAIN ANALYZE
SELECT t.ticket_no, t.passenger_name,
                tf.flight_id, tf.amount
FROM tickets t
JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
ORDER BY t.ticket_no;


EXPLAIN ANALYZE
SELECT b.book_ref, sum(tf.amount)
FROM bookings b, tickets t, ticket_flights tf
WHERE b.book_ref = t.book_ref AND t.ticket_no = tf.ticket_no
GROUP BY 1
ORDER BY 1;

EXPLAIN ANALYZE
SELECT book_ref, total_amount FROM bookings
ORDER BY 1;

EXPLAIN ANALYZE
SELECT EXTRACT(month FROM book_date) AS month,
    avg(total_amount) AS avg
FROM bookings
GROUP BY (EXTRACT(month FROM book_date));

EXPLAIN ANALYZE
SELECt * FROM average;



CREATE TEMP TABLE flights_tt AS
SELECT * FROM flights_v;

EXPLAIN ANALYZE
SELECT count(*) FROM flights_v GROUP BY date_trunc('month',scheduled_departure);

EXPLAIN ANALYZE
SELECT count(*) FROM flights_tt GROUP BY date_trunc('month',scheduled_departure);

CREATE TEMP TABLE aircrafts_tt
AS
( SELECT aircraft_code,
    (model ->> lang()) AS model,
    range
   FROM aircrafts_data ml);

EXPLAIN ANALYZE
SELECT * FROM aircrafts_tt;
EXPLAIN ANALYZE
SELECT * FROM aircrafts;


EXPLAIN ANALYZE
SELECT count(*) FROM tickets
WHERE passenger_name = 'IVAN IVANOV';

DROP INDEX tickets_book_ref_key;
CREATE INDEX tickets_book_ref_key ON bookings.tickets USING btree ("book_ref");

EXPLAIN ANALYZE
SELECT * FROM tickets WHERE book_ref = '0C3A72';



EXPLAIN ANALYZE
SELECT num_tickets, count(*) AS num_bookings
FROM (SELECT b.book_ref, count(*) FROM tickets t, bookings b
        WHERE t.book_ref = b.book_ref
        AND date_trunc('mon', book_date) = '2016-09-01'
        GROUP BY b.book_ref
    ) AS count_tickets(book_ref, num_tickets)
GROUP BY num_tickets
ORDER BY num_tickets DESC;

SET enable_hashjoin = On;
SET enable_nestloop = on;



CREATE TABLE nulls AS
SELECT num::INTEGER, 'TEXT' || num::TEXT AS txt
FROM generate_series(1, 200000) AS gen_ser(num);
CREATE INDEX nulls_ind ON nulls(num);
INSERT INTO nulls VALUES(NULL, 'TEXT');
EXPLAIN
SELECT * FROM nulls ORDER BY num;
SELECT * FROM nulls ORDER BY num OFFSET 199995;
EXPLAIN SELECT * FROM nulls ORDER BY num NULLS FIRST;
EXPLAIN ANALYZE SELECT * FROM nulls ORDER BY num DESC NULLS FIRST;
EXPLAIN ANALYZE SELECT * FROM nulls ORDER BY num DESC NULLS LAST;


SET enable_hashjoin = on;
SET enable_mergejoin = on;
SET enable_nestloop = on;
SET enable_seqscan = on;
SET enable_indexscan = on;

EXPLAIN ANALYZE
SELECT a.model, count(*)
FROM aircrafts a, seats s
WHERE a.aircraft_code = s.aircraft_code
GROUP BY a.aircraft_code, a.model;

SET jit = true;
SET geqo = true;
EXPLAIN ANALYZE
SELECT departure_city, count(*)
FROM routes
GROUP BY departure_city 
HAVING departure_city = ANY (
    SELECT city FROM airports
    WHERE coordinates[1] > 60
)
ORDER BY count DESC;
SELECT attname, inherited, n_distinct,
       array_to_string(most_common_vals, E'\n') as most_common_vals
FROM pg_stats
WHERE tablename = 'seats';

EXPLAIN (ANALYZE, BUFFERS)
SELECT t.passenger_name, b.seat_no
FROM (ticket_flights tf
        JOIN tickets t ON tf.ticket_no = t.ticket_no)
JOIN boarding_passes b
ON tf.ticket_no = b.ticket_no
AND tf.flight_id = b.flight_id
WHERE tf.flight_id = 27584
ORDER BY t.passenger_name;


CREATE TEMP TABLE test_ (
    num INTEGER,
    tex TEXT
);

CREATE INDEX index ON test_(num);
BEGIN; ROLLBACK;
EXPLAIN (ANALYZE, BUFFERS)
INSERT INTO test_ (
    SELECT num::INTEGER, num::text || 'TEXT' as mode
    FROM generate_series(1, 100000) AS gen_ser(num)
);
