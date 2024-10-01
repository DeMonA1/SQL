

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





CREATE TABLE airports1 (
    airport_code char(3) NOT NULL,
    airport_name TEXT NOT NULL,
    city TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    timezone TEXT NOT NULL,
    PRIMARY KEY (airport_code)
);
COMMENT ON COLUMN airports1.city  IS 'Cicty';
CREATE TABLE flights1 (
    flight_id SERIAL NOT NULL,
    flight_no char(6) NOT NULL,
    scheduled_departure TIMESTAMP NOT NULL,
    scheduled_arrival TIMESTAMP NOT NULL,
    departure_airport CHAR(3) NOT NULL,
    arrival_airport CHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL,
    aircraft_code CHAR(3) NOT NULL,
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    CHECK (scheduled_arrival > scheduled_departure),
    CHECK (status IN ('On Time', 'Delayed', 'Departed',
                    'Arrived', 'Scheduled', 'Cancelled')),
    CHECK (actual_arrival IS NULL OR
            (actual_departure IS NOT NULL AND
            actual_arrival IS NOT NULL AND
            actual_arrival > actual_departure)),
    PRIMARY KEY (flight_id),
    UNIQUE (flight_no, scheduled_departure),
    FOREIGN KEY (aircraft_code) REFERENCES aircrafts1(aircraft_code),
    FOREIGN KEY (arrival_airport) REFERENCES airports1(airport_code),
    FOREIGN KEY (departure_airport) REFERENCES airports1(airport_code)
);
CREATE TABLE bookings1 (
    book_ref CHAR(6) NOT NULL,
    book_date TIMESTAMP NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY(book_ref)
);
CREATE TABLE tickets1 (
    ticket_no CHAR(13) NOT NULL,
    book_ref CHAR(6) NOT NULL,
    passenger_id VARCHAR(20) NOT NULL,
    passenger_name TEXT NOT NULL,
    contact_data JSONB,
    PRIMARY KEY (ticket_no),
    FOREIGN KEY (book_ref) REFERENCES bookings1 (book_ref)
);
CREATE TABLE ticket_flights (
    ticket_no CHAR(13) NOT NULL,
    flight_id INTEGER NOT NULL,
    fare_conditions VARCHAR(10) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    CHECK (amount >= 0),
    CHECK (fare_conditions IN ('Economy', 'Comfort', 'Business')),
    PRIMARY KEY (ticket_no, flight_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (ticket_no) REFERENCES tickets(ticket_no)
);
CREATE TABLE boarding_passes (
    ticket_no CHAR(13) NOT NULL,
    flight_id INTEGER NOT NULL,
    boarding_no INTEGER NOT NULL,
    seat_no VARCHAR(4) NOT NULL,
    PRIMARY KEY (ticket_no, flight_id),
    UNIQUE (flight_id, boarding_no),
    UNIQUE (flight_id, seat_no),
    FOREIGN KEY (ticket_no, flight_id) 
        REFERENCES ticket_flights(ticket_no, flight_id)
);
ALTER TABLE aircrafts1 ADD COLUMN speed INTEGER;
UPDATE aircrafts1 SET speed = 807 WHERE aircraft_code = '733';
UPDATE aircrafts1 SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts1 SET speed = 905 WHERE aircraft_code = '773';
UPDATE aircrafts1 SET speed = 840 WHERE aircraft_code IN ('319', '320', '321');
UPDATE aircrafts1 SET speed = 786 WHERE aircraft_code = 'CR2';
UPDATE aircrafts1 SET speed = 341 WHERE aircraft_code = 'CN1';
UPDATE aircrafts1 SET speed = 830 WHERE aircraft_code = 'SU9';
SELECT * FROM aircrafts1;
ALTER TABLE aircrafts1 ALTER COLUMN speed SET NOT NULL;UPDATE aircrafts1 SET speed = 807 WHERE aircraft_code = '733';
UPDATE aircrafts1 SET speed = 851 WHERE aircraft_code = '763';
UPDATE aircrafts1 SET speed = 905 WHERE aircraft_code = '773';
UPDATE aircrafts1 SET speed = 840 WHERE aircraft_code IN ('319', '320', '321');
UPDATE aircrafts1 SET speed = 786 WHERE aircraft_code = 'CR2';
UPDATE aircrafts1 SET speed = 341 WHERE aircraft_code = 'CN1';
UPDATE aircrafts1 SET speed = 830 WHERE aircraft_code = 'SU9';
UPDATE aircrafts1 SET speed = 807 WHERE aircraft_code = '764';
SELECT * FROM aircrafts1;
ALTER TABLE aircrafts1 ALTER COLUMN speed SET NOT NULL;
ALTER TABLE aircrafts1 ADD CHECK(speed >= 300);
ALTER TABLE aircrafts1 ALTER COLUMN speed DROP NOT NULL;
ALTER TABLE aircrafts1 DROP CONSTRAINT aircrafts1_speed_check1;
ALTER TABLE aircrafts1 DROP COLUMN speed;
SELECT * FROM airports;
ALTER TABLE airports1
    ALTER COLUMN longitude SET DATA TYPE NUMERIC(5, 2),
    ALTER COLUMN latitude SET DATA TYPE NUMERIC(5, 2);
SELECT * FROM airports1;
CREATE TABLE fare_conditions (
    fare_conditions_code INTEGER,
    fare_conditions_name VARCHAR(10) NOT NULL,
    PRIMARY KEY (fare_conditions_code)
);
INSERT INTO fare_conditions
VALUES (1, 'Economy'),
        (2, 'Business'),
        (3, 'Comfort');
ALTER TABLE seats1
    DROP CONSTRAINT seats1_fare_conditions_check,
    ALTER COLUMN fare_conditions SET DATA TYPE INTEGER
        USING (CASE WHEN fare_conditions = 'Economy' THEN 1
                    WHEN fare_conditions = 'Business' THEN 2
                    ELSE 3 END);
ALTER TABLE seats1 
    ADD FOREIGN KEY (fare_conditions)
        REFERENCES fare_conditions (fare_conditions_code);
ALTER TABLE seats1
    RENAME COLUMN fare_conditions TO fare_conditions_code;
ALTER TABLE seats1
    RENAME CONSTRAINT seats_fare_conditions_code_fkey
        TO seats1_fare_conditions_code_fkey;
ALTER TABLE fare_conditions ADD UNIQUE (fare_conditions_name);

--------------------------VIEW-------------------------

CREATE VIEW seats_by_fare_cond AS
SELECT aircraft_code, fare_conditions_code, count(*) FROM seats1
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;
SELECT * FROM seats_by_fare_cond;
DROP VIEW seats_by_fare_cond;
CREATE OR REPLACE VIEW seats_by_fare_cond AS
SELECT aircraft_code, fare_conditions_code, count(*) AS num_seats
FROM seats1
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;
DROP VIEW seats_by_fare_cond;
CREATE OR REPLACE VIEW seats_by_fare_cond (code, fare_cond, num_seats) AS
SELECT aircraft_code, fare_conditions_code, count(*) AS num_seats
FROM seats1
GROUP BY aircraft_code, fare_conditions_code
ORDER BY aircraft_code, fare_conditions_code;
SELECT * FROM flights_v;

ALTER TABLE flights1 DROP CONSTRAINT flights1_check1;
ALTER TABLE flights1
ADD CHECK (actual_arrival IS NULL OR
            (actual_departure IS NOT NULL AND
            actual_arrival > actual_departure));
INSERT INTO flights1 (flight_no, scheduled_departure, scheduled_arrival, departure_airport,
                    arrival_airport, status, aircraft_code, actual_departure, actual_arrival)
VALUES ('123', current_timestamp, '2024-09-30', 'TTT', 'TTT', 'On Time', '773', '2001-12-22'::timestamp, '2001-12-24'::timestamp);
INSERT INTO flights1 (flight_no, scheduled_departure, scheduled_arrival, departure_airport,
                    arrival_airport, status, aircraft_code, actual_departure)
VALUES ('123', current_timestamp, '2024-09-30', 'TTT', 'TTT', 'On Time', '773', '2001-12-22'::timestamp);

ALTER TABLE flights11 RENAME TO flights1;

CREATE OR REPLACE VIEW airc AS
SELECT * FROM tickets
WHERE contact_data ->> 'phone' LIKE '+707%';

UPDATE airc SET passenger_name = 'OOO' WHERE ticket_no = '0005432000304';
SELECT passenger_name FROM airc WHERE ticket_no = '0005432000284';
SELECT * FROM routes WHERE flight_no = 'PG1';
SELECT * FROM flights WHERE flight_no = 'PG1';
UPDATE flights SET flight_no = 'PG0001' WHERE flight_no = 'PG1';

CREATE OR REPLACE VIEW average AS
SELECT extract(MONTH FROM book_date) as MONTH, AVG(total_amount) as avg FROM bookings
GROUP BY extract(MONTH FROM book_date)
ORDER BY avg;
CREATE OR REPLACE VIEW status_fight AS
SELECT status, count(status) as status_of_flight FROM flights
GROUP BY status ORDER BY status_of_flight; 

ALTER TABLE aircrafts1 ADD COLUMN specifications jsonb;
UPDATE aircrafts1 SET specifications = 
    '{"crew": 2, "engines": {"type": "IAE V2500", "num": 2}}'::jsonb
WHERE aircraft_code = '320';
SELECT model, specifications FROM aircrafts1
WHERE aircraft_code = '320';
SELECT model, specifications -> 'engines' AS engines FROM aircrafts1
WHERE aircraft_code = '320';
SELECT model, specifications #> '{engines, type}' FROM aircrafts1
WHERE aircraft_code = '320';
ALTER TABLE seats ADD COLUMN description JSONB;
UPDATE seats SET description = '{"window": 1, "bathroom": 1, "TV":0}'
WHERE aircraft_code = '319' AND fare_conditions = 'Economy';
SELECT * FROM seats
WHERE aircraft_code = '319' AND fare_conditions = 'Economy';
SELECT * FROM seats WHERE description -> 'TV' = '0';


-----------QUERIES------------------------

SELECT count(*) FROM aircrafts;
SELECT count(*) FROM airports;
SELECT * FROM aircrafts WHERE model LIKE 'Аэробус%';
SELECT * FROM aircrafts 
WHERE model NOT LIKE 'Аэробус%' AND model NOT LIKE 'Боинг%';
SELECT * FROM airports WHERE airport_name LIKE '___';
SELECT * FROM aircrafts WHERE model ~ '^(Аэ|Бо)';
SELECT * FROM aircrafts WHERE model !~ '300$';
SELECT * FROM aircrafts WHERE range BETWEEN 3000 AND 6000;
SELECT model, range, range / 1.609 AS miles FROM aircrafts;
SELECT model, range, round(range / 1.609, 2) AS miles FROM aircrafts;
SELECT * FROM aircrafts ORDER BY range DESC;
SELECT timezone FROM airports;
SELECT DISTINCT timezone FROM airports ORDER BY 1;
SELECT airport_name, city, coordinates[1] as longitude FROM airports
ORDER BY longitude DESC LIMIT 3;
SELECT airport_name, city, coordinates[1] as longitude FROM airports
ORDER BY longitude DESC
LIMIT 3 OFFSET 3;
SELECT model, range,
CASE WHEN range < 2000 THEN 'Shortdistance'
     WHEN range < 5000 THEN 'Middledistance'
     ELSE 'Longdistance'
END AS type
FROM aircrafts
ORDER BY model;


SELECT a.aircraft_code, a.model, s.seat_no, s.fare_conditions
FROM seats AS s JOIN aircrafts AS a
ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Сессна'
ORDER BY s.seat_no;
SELECT * FROM seats WHERE aircraft_code = 'CN1';

SELECT s.seat_no, s.fare_conditions
FROM seats s JOIN aircrafts a ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Сессна'
ORDER BY s.seat_no;

SELECT a.aircraft_code, a.model, s.seat_no, s.fare_conditions
FROM seats s, aircrafts a
WHERE s.aircraft_code = a.aircraft_code AND a.model ~ '^Сессна'
ORDER BY s.seat_no;

CREATE OR REPLACE VIEW flights_v1 AS
SELECT f.flight_id,
        f.flight_no,
        f.scheduled_departure,
        timezone(dep.timezone, f.scheduled_departure)
            AS scheduled_departure_local,
        f.scheduled_arrival,
        timezone(arr.timezone, f.scheduled_arrival)
            AS scheduled_arrival_local,
        f.scheduled_arrival - f.scheduled_departure
            AS scheduled_duration,
        f.departure_airport,
        dep.airport_name AS departure_airport_name,
        dep.city AS departure_city,
        f.arrival_airport,
        arr.airport_name AS arrival_airport_name,
        arr.city AS arrival_city,
        f.status,
        f.aircraft_code,
        f.actual_departure,
        timezone(dep.timezone, f.actual_departure)
            AS actual_departure_local,
        f.actual_arrival,
        timezone(arr.timezone, f.actual_arrival)
            AS actual_arrival_local,
        f.actual_arrival - f.actual_departure AS actual_duration
FROM flights f, airports dep, airports arr
WHERE f.departure_airport = dep.airport_code
    AND f.arrival_airport = arr.airport_code;

SELECT count(*) FROM airports a1, airports a2
WHERE a1.city <> a2.city;
--OR
SELECT count(*) FROM airports a1
JOIN airports a2 ON a1.city <> a2.city;
--OR
SELECT count(*)
FROM airports a1 CROSS JOIN airports a2
WHERE a1.city <> a2.city;

SELECT r.aircraft_code, a.model, count(*) AS num_routes
FROM routes r
JOIN aircrafts a ON r.aircraft_code = a.aircraft_code
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT a.aircraft_code AS a_code,
        a.model,
        r.aircraft_code AS r_code,
        count(r.aircraft_code) AS num_routes
FROM aircrafts a
LEFT OUTER JOIN routes r ON r.aircraft_code = a.aircraft_code
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

SELECT count(*)
FROM (ticket_flights t JOIN flights f ON t.flight_id = f.flight_id)
LEFT OUTER JOIN boarding_passes b
ON t.ticket_no = b.ticket_no AND t.flight_id = b.flight_id
WHERE f.actual_departure IS NOT NULL AND b.flight_id IS NULL;

SELECT f.flight_no,
        f.scheduled_departure,
        f.flight_id,
        f.departure_airport,
        f.arrival_airport,
        f.aircraft_code,
        t.passenger_name,
        tf.fare_conditions AS fc_to_be,
        s.fare_conditions AS fc_fact,
        b.seat_no
FROM boarding_passes b
JOIN ticket_flights tf
ON b.ticket_no = tf.ticket_no AND b.flight_id = tf.flight_id
JOIN tickets t ON tf.ticket_no =  t.ticket_no
JOIN flights f ON tf.flight_id = f.flight_id
JOIN seats s
ON b.seat_no = s.seat_no AND f.aircraft_code = s.aircraft_code
WHERE tf.fare_conditions <> s.fare_conditions
ORDER BY f.flight_no, f.scheduled_departure;

SELECT r.min_sum, r.max_sum, count(b.*)
FROM bookings b
RIGHT OUTER JOIN 
(VALUES (       0, 100000), ( 100000, 200000 ),
        ( 200000, 300000 ), ( 300000, 400000 ),
        ( 400000, 500000 ), ( 500000, 600000 ),
        ( 600000, 700000 ), ( 700000, 800000 ),
        ( 800000, 900000 ), ( 900000, 1000000 ),
        ( 1000000, 1100000 ), ( 1100000, 1200000 ),
        ( 1200000, 1300000 )) AS r (min_sum, max_sum)
ON b.total_amount >= r.min_sum AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;

SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
UNION
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
INTERSECT
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
EXCEPT
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;



SELECT avg(total_amount) FROM bookings;
SELECT max(total_amount) FROM bookings;
SELECT min(total_amount) FROM bookings;

SELECT arrival_city, count(*)
FROM routes
WHERE departure_city = 'Москва'
GROUP BY arrival_city
ORDER BY count DESC;

SELECT array_length(days_of_week, 1) AS days_per_week,
        count(*) AS num_routes
FROM routes
GROUP BY days_per_week
ORDER BY 1 desc;

SELECT departure_city, count(*)
FROM routes
GROUP BY departure_city
HAVING count(*) >= 15
ORDER BY count DESC;

SELECT city, count(*) FROM airports
GROUP BY city HA                                                                                                                          VING count(*) > 1;

SELECT b.book_ref,
        b.book_date,
        extract('month' from b.book_date) as month,
        extract('day' from b.book_date) as day,
        count(*) OVER (PARTITION BY date_trunc('month', b.book_date)
                        ORDER BY b.book_date) as count
FROM ticket_flights tf
JOIN tickets t ON tf.ticket_no = t.ticket_no
JOIN bookings b ON t.book_ref = b.book_ref
WHERE tf.flight_id = 2
ORDER BY b.book_date;

SELECT airport_name,
        city,
        round(coordinates[1]::numeric, 2) as ltd,
        timezone,
        rank() OVER (
            PARTITION BY timezone
            ORDER BY coordinates[1] DESC
        )
FROM airports
WHERE timezone IN ('Asia/Irkutsk', 'Asia/Krasnoyarsk')
ORDER BY timezone, rank;

SELECT airport_name, city, timezone, coordinates[1],
        first_value(coordinates[1]) OVER tz AS first_in_timezone,
        coordinates[1] - first_value(coordinates[1]) OVER tz AS delta,
        rank() OVER tz
FROM airports
WHERE timezone IN ('Asia/Irkutsk', 'Asia/Krasnoyarsk')
WINDOW tz AS (PARTITION BY timezone ORDER BY coordinates[1] DESC)
ORDER BY timezone, rank;

-------------SUBQUERIES------------------
SELECT count(*) FROM bookings
WHERE total_amount > (SELECT avg(total_amount) FROM bookings);

SELECT flight_no, departure_city, arrival_city
FROM routes
WHERE departure_city IN (
    SELECT city FROM airports WHERE timezone ~ 'Krasnoyarsk'
)
AND arrival_city IN (
SELECT city FROM airports WHERE timezone ~ 'Krasnoyarsk');

SELECT airport_name, city, coordinates[1]
FROM airports
WHERE coordinates[1] IN (
    (SELECT max(coordinates[1]) FROM airports),
    (SELECT min(coordinates[1]) FROM airports)
)
ORDER BY coordinates[1];

SELECT DISTINCT a.city FROM airports a
WHERE NOT EXISTS (
    SELECT * FROM routes r
    WHERE r.departure_city = 'Москва'
    AND r.arrival_city = a.city
)
AND a.city <> 'Москва'
ORDER BY city;

SELECT a.model,
(SELECT count(*) FROM seats s WHERE s.aircraft_code = a.aircraft_code
    AND s.fare_conditions = 'Business') AS business,
(SELECT count(*) FROM seats s WHERE s.aircraft_code = a.aircraft_code
AND s.fare_conditions = 'Comfort') AS comfort,
(SELECT count(*) FROM seats s WHERE s.aircraft_code = a.aircraft_code
AND s.fare_conditions = 'Economy') AS economy
FROM aircrafts a ORDER BY 1;

SELECT s2.model, 
string_agg(s2.fare_conditions || ' (' || s2.num || ')', ', ')
FROM (SELECT a.model, s.fare_conditions, count(*) AS num
    FROM aircrafts a JOIN seats s ON a.aircraft_code = s.aircraft_code
    GROUP BY 1, 2 ORDER BY 1, 2) AS s2
GROUP BY s2.model ORDER BY s2.model;

SELECT aa.city, aa.airport_code, aa.airport_name
FROM (SELECT city, count(*) 
        FROM airports GROUP BY city HAVING count(*) > 1) AS a
JOIN airports AS aa ON a.city = aa.city
ORDER BY aa.city, aa.airport_name;

SELECT departure_airport, departure_city, count(*)
FROM routes
GROUP BY departure_airport, departure_city
HAVING departure_airport IN (
    SELECT airport_code FROM airports WHERE coordinates[1] > 65)
ORDER BY count DESC;

SELECT ts.flight_id,
        ts.flight_no,
        ts.scheduled_departure_local,
        ts.departure_city,
        ts.arrival_city,
        a.model,
        ts.fact_passengers,
        ts.total_seats,
        round(ts.fact_passengers::numeric /
                ts.total_seats::numeric, 2) AS fraction
FROM (SELECT f.flight_id,
            f.flight_no,
            f.scheduled_departure_local,
            f.departure_city,
            f.arrival_city,
            f.aircraft_code,
            count(tf.ticket_no) AS fact_passengers,
            (SELECT count(s.seat_no) FROM seats s
                WHERE s.aircraft_code = f.aircraft_code) AS total_seats
        FROM flights_v f
        JOIN ticket_flights tf ON f.flight_id = tf.flight_id
        WHERE f.status = 'Arrived'
        GROUP BY 1, 2, 3, 4, 5, 6) AS ts
JOIN aircrafts AS a ON ts.aircraft_code = a.aircraft_code
ORDER BY ts.scheduled_departure_local;

-- OR -- 

WITH ts AS
(SELECT f.flight_id,
        f.flight_no,
        f.scheduled_departure_local,
        f.departure_city,
        f.arrival_city,
        f.aircraft_code,
        count(tf.ticket_no) AS fact_passengers,
            (SELECT count(s.seat_no) FROM seats s
                WHERE s.aircraft_code = f.aircraft_code) AS total_seats
        FROM flights_v f
        JOIN ticket_flights tf ON f.flight_id = tf.flight_id
        WHERE f.status = 'Arrived'
        GROUP BY 1, 2, 3, 4, 5, 6)

SELECT ts.flight_id,
        ts.flight_no,
        ts.scheduled_departure_local,
        ts.departure_city,
        ts.arrival_city,
        a.model,
        ts.fact_passengers,
        ts.total_seats,
        round(ts.fact_passengers::numeric /
                ts.total_seats::numeric, 2) AS fraction
FROM ts
JOIN aircrafts AS a ON ts.aircraft_code = a.aircraft_code
ORDER BY ts.scheduled_departure_local;


WITH RECURSIVE ranges (min_sum, max_sum) AS
(VALUES (0, 100000) UNION ALL
SELECT min_sum + 100000, max_sum + 100000 FROM ranges
WHERE max_sum < 
    (SELECT max(total_amount) FROM bookings))
SELECT * FROM ranges;


WITH RECURSIVE ranges (min_sum, max_sum) AS
(VALUES (0, 100000) UNION ALL
SELECT min_sum + 100000, max_sum + 100000 FROM ranges
WHERE max_sum < 
    (SELECT max(total_amount) FROM bookings))
    
SELECT r.min_sum, r.max_sum, count(b.*) FROM bookings b
RIGHT OUTER JOIN ranges r
ON b.total_amount >= r.min_sum AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;

CREATE MATERIALIZED VIEW routes1 AS
    WITH f3 AS
        (
            SELECT f2.flight_no,
                f2.departure_airport,
                f2.arrival_airport,
                f2.aircraft_code,
                f2.duration,
                array_agg(f2.days_of_week) AS days_of_week
            FROM
            (SELECT f1.flight_no,
                    f1.departure_airport,
                    f1.arrival_airport,
                    f1.aircraft_code,
                    f1.duration,
                    f1.days_of_week
            FROM
            (SELECT flights.flight_no,
                    flights.departure_airport,
                    flights.arrival_airport,
                    flights.aircraft_code,
                    (flights.scheduled_arrival - flights.scheduled_departure) AS duration,
                    (to_char(flights.scheduled_departure, 'ID'::text))::integer AS days_of_week
            FROM flights) f1
            GROUP by f1.flight_no, f1.departure_airport,
                    f1.arrival_airport, f1.aircraft_code,
                    f1.duration, f1.days_of_week
            ORDER BY f1.flight_no, f1.departure_airport,
                    f1.arrival_airport, f1.aircraft_code,
                    f1.duration, f1.days_of_week
            ) f2
            GROUP BY f2.flight_no, f2.departure_airport,
                    f2.arrival_airport, f2.aircraft_code,
                    f2.duration
        )
SELECT f3.flight_no,
        f3.departure_airport,
        dep.airport_name AS departure_airport_name,
        dep.city AS departure_city,
        f3.arrival_airport,
        arr.airport_name AS arrival_airport_name,
        arr.city AS arrival_city,
        f3.aircraft_code,
        f3.duration,
        f3.days_of_week
FROM f3,
    airports dep,
    airports arr
WHERE f3.departure_airport = dep.airport_code
AND f3.arrival_airport = arr.airport_code;


SELECT count(*) FROM tickets;
SELECT count(*) FROM tickets WHERE passenger_name LIKE '% %';
SELECT count(*) FROM tickets WHERE passenger_name LIKE '% % %';
SELECT count(*) FROM tickets WHERE passenger_name LIKE '% %%';


SELECT passenger_name FROM tickets
WHERE passenger_name LIKE '___ %';

SELECT passenger_name FROM tickets
WHERE passenger_name SIMILAR TO '% _____';

SELECT passenger_name FROM tickets
WHERE passenger_name SIMILAR TO '% _{5}';

SELECT model, flight_no FROM aircrafts a, routes r
WHERE a.aircraft_code = r.aircraft_code AND model LIKE 'Боинг%';


SELECT DISTINCT 
    LEAST(r2.departure_city, r2.arrival_city) AS city1,
    GREATEST(r2.departure_city, r2.arrival_city) AS city2
FROM routes r2
JOIN aircrafts a ON r2.aircraft_code = a.aircraft_code
WHERE a.model = 'Боинг 777-300'
ORDER BY city1, city2;

SELECT fare_conditions_code, fare_conditions_name, aircraft_code, seat_no FROM fare_conditions
FULL OUTER JOIN seats ON fare_conditions = fare_conditions_name;

SELECT departure_city, arrival_city, count(*) FROM routes
WHERE departure_city = 'Москва'
  AND arrival_city = 'Санкт-Петербург'
GROUP BY departure_city, arrival_city;

SELECT departure_city, count(*) FROM (SELECT DISTINCT departure_city, arrival_city FROM routes)
GROUP BY departure_city ORDER BY count DESC;

SELECT arrival_city, count(*) FROM routes
WHERE array_length(days_of_week, 1) = 7 AND departure_city = 'Москва'
GROUP BY arrival_city ORDER BY count DESC LIMIT 5;

SELECT 'Monday' AS day_of_week, count(*) AS num_flights
FROM routes
WHERE departure_city = 'Москва' AND days_of_week @> '{1}'::integer[];

SELECT unnest(days_of_week) AS day_of_week,
        count(*) AS num_flights
FROM routes
WHERE departure_city = 'Москва'
GROUP BY day_of_week
ORDER BY day_of_week;

SELECT flight_no, unnest(days_of_week) AS day_of_week
FROM routes
WHERE departure_city = 'Москва'
ORDER BY flight_no;

SELECT dw.name_of_day, count(*) AS num_flights
FROM (
    SELECT unnest(days_of_week) AS num_of_day
    FROM routes
    WHERE departure_city = 'Москва'
) AS r,
unnest ('{1, 2, 3, 4, 5, 6, 7}'::integer[],
        '{ "Пн.", "Вт.", "Ср.", "Чт.", "Пт.", "Сб.", "Вс."}'::text[]
        ) AS dw(num_of_day, name_of_day)
WHERE r.num_of_day = dw.num_of_day
GROUP BY r.num_of_day, dw.name_of_day
ORDER BY r.num_of_day;

SELECT dw.name_of_day, count(*) AS num_flights
FROM (
    SELECT unnest(days_of_week) AS num_of_day
    FROM routes
    WHERE departure_city = 'Москва'
) AS r,
unnest (
        '{ "Пн.", "Вт.", "Ср.", "Чт.", "Пт.", "Сб.", "Вс."}'::text[]
        ) WITH ORDINALITY AS dw(name_of_day, num_of_day)
WHERE r.num_of_day = dw.num_of_day
GROUP BY r.num_of_day, dw.name_of_day
ORDER BY r.num_of_day;

SELECT f.departure_city, f.arrival_city,
        max(tf.amount), min(tf.amount)
FROM flights_v f
FULL OUTER JOIN ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT left(passenger_name, strpos(passenger_name, ' ') - 1)
    AS firstname, count(*)
FROM tickets
GROUP BY 1
ORDER BY 2 DESC;

SELECT substr(passenger_name, strpos(passenger_name, ' ') + 1)
    AS secondname, count(*)
FROM tickets
GROUP BY 1
ORDER BY 1;

SELECT DISTINCT extract('year' from b.book_date) AS year,
        extract('month' from b.book_date) AS month,
        sum(total_amount) OVER (PARTITION BY extract('year' from b.book_date) 
                                ORDER BY extract('month' from b.book_date))
FROM bookings b;

SELECT count(*) FILTER (WHERE total_amount > 110000) AS total_amount
FROM bookings;

SELECT a.aircraft_code, model, fare_conditions, count(*)
FROM seats s, aircrafts a WHERE s.aircraft_code = a.aircraft_code
GROUP BY (1, 2, 3)
ORDER BY aircraft_code;

WITH main AS
(SELECT a.aircraft_code, a.model, count(*) AS num_routes
FROM aircrafts a, routes r, (SELECT count(*) FROM routes) c
WHERE a.aircraft_code = r.aircraft_code
GROUP BY 1, 2)
SELECT aircraft_code, model, num_routes, round(num_routes::numeric/c.big::numeric, 4) AS fraction
FROM main, (SELECT count(*) as big FROM routes) c;
201

WITH RECURSIVE ranges (min_sum, max_sum, iteration)
AS (VALUES (0, 100000, 0.0),
            (100000, 200000, 0.0),
            (200000, 300000, 0.0)
    UNION ALL
    SELECT min_sum + 100000, max_sum + 100000, iteration + 1
    FROM ranges
    WHERE max_sum < (SELECT max(total_amount) FROM bookings))
SELECT min_sum, max_sum, round(iteration) FROM ranges;


WITH RECURSIVE ranges(min_sum, max_sum)
AS (
  VALUES (0, 100000)
  UNION ALL
    SELECT min_sum + 100000, max_sum + 100000
    FROM ranges
    WHERE max_sum < (SELECT max(total_amount) FROM bookings)
)
SELECT r.min_sum,
        r.max_sum,
        count(b.*)
FROM bookings b
RIGHT JOIN ranges r
    ON b.total_amount >= r.min_sum
    AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;


SELECT DISTINCT a.city
FROM airports a
WHERE NOT EXISTS (
    SELECT * FROM routes r
    WHERE r.departure_city = 'Москва'
        AND r.arrival_City = a.city
)
    AND a.city <> 'Москва'
ORDER BY city;

SELECT city
FROM airports
WHERE city <> 'Москва'
EXCEPT
SELECT arrival_city
FROM routes
WHERE departure_city = 'Москва'
ORDER BY city;

SELECT aa.city, aa.airport_code, aa.airport_name
FROM (SELECT city, count(*)
        FROM airports
        GROUP BY city
        HAVING count(*) > 1) AS a
JOIN airports AS aa ON a.city = aa.city
ORDER BY aa.city, aa.airport_name;

SELECT count(*)
FROM (SELECT DISTINCT city FROM airports) AS a1
JOIN (SELECT DISTINCT city FROM airports) AS a2
ON a1.city <> a2.city;

WITH ally AS (SELECT * FROM
    (SELECT DISTINCT city FROM airports) as a1,
    (SELECT DISTINCT city FROM airports) as a2
    WHERE a1.city <> a2.city)
SELECT count(*) FROM ally; 

SELECT * FROM airports
WHERE city IN ('Якутск','Южно-Сахалинск');

SELECT * FROM routes
WHERE departure_airport = ANY('{MJZ, PEZ}');

SELECT * FROM airports
WHERE timezone IN ('Asia/Novokuznetsk', 'Asia/Krasnoyarsk');

SELECT * FROM airports
WHERE timezone = ANY(VALUES('Asia/Novokuznetsk'), ('Asia/Krasnoyarsk'));

SELECT departure_city, count(*)
FROM routes
GROUP BY departure_city 
HAVING departure_city = ANY (
    SELECT city FROM airports
    WHERE coordinates[1] > 60
)
ORDER BY count DESC;


WITH tickets_seats AS 
(SELECT f.flight_id,
        f.flight_no,
        f.departure_city,
        f.arrival_city,
        f.aircraft_code,
        count(tf.ticket_no) AS fact_passengers,
        (SELECT count(s.seat_no) FROM seats s
        WHERE s.aircraft_code = f.aircraft_code) AS total_seats
    FROM flights_v f
    JOIN ticket_flights tf ON f.flight_id = tf.flight_id
    WHERE f.status = 'Arrived'
    GROUP BY 1, 2, 3, 4, 5)
SELECT ts.departure_city,
        ts.arrival_city,
        sum(ts.fact_passengers) AS sum_pass,
        sum(ts.total_seats) AS sum_seats,
        round(sum(ts.fact_passengers)::numeric /
                sum(ts.total_seats)::numeric, 2) AS frac
FROM tickets_seats ts
GROUP BY ts.departure_city, ts.arrival_city
ORDER BY ts.departure_city;
    
WITH tickets_seats AS 
(SELECT f.flight_id,
        f.flight_no,
        f.departure_city,
        f.arrival_city,
        f.aircraft_code,
        tf.fare_conditions,
        count(tf.ticket_no) AS fact_passengers,
        (SELECT count(s.seat_no) FROM seats s
        WHERE s.aircraft_code = f.aircraft_code AND s.fare_conditions = tf.fare_conditions) AS total_seats
    FROM flights_v f, ticket_flights tf
    WHERE f.status = 'Arrived' AND f.flight_id = tf.flight_id
    GROUP BY 1, 2, 3, 4, 5, 6)
SELECT ts.departure_city,
        ts.arrival_city,
        ts.fare_conditions,
        sum(ts.fact_passengers) AS sum_pass,
        sum(ts.total_seats) AS sum_seats,
        round(sum(ts.fact_passengers)::numeric /
                sum(ts.total_seats)::numeric, 2) AS frac
FROM tickets_seats ts
GROUP BY ts.departure_city, ts.arrival_city, ts.fare_conditions
ORDER BY ts.departure_city;

SELECT s.aircraft_code, fare_conditions, count(*) FROM seats s, flights_v f
WHERE s.aircraft_code = f.aircraft_code group by s.aircraft_code, fare_conditions
ORDER BY aircraft_code;
SELECT count(s.seat_no) FROM seats s, flights_v f
WHERE s.aircraft_code = f.aircraft_code


SELECT * FROM flights_v
WHERE departure_city = 'Кемерово' AND arrival_city = 'Москва'
AND actual_arrival < bookings.now();

SELECT t.passenger_name, b.seat_no
FROM (ticket_flights tf
        JOIN tickets t ON tf.ticket_no = t.ticket_no)
JOIN boarding_passes b
ON tf.ticket_no = b.ticket_no
AND tf.flight_id = b.flight_id
WHERE tf.flight_id = 27584
ORDER BY t.passenger_name;

SELECT t.passenger_name,
        substr(t.passenger_name, strpos(t.passenger_name, ' ') + 1) AS lastname,
        left(t.passenger_name, strpos(t.passenger_name, ' ') - 1) AS firstname,
        b.seat_no
FROM (ticket_flights tf JOIN tickets t ON tf.ticket_no = t.ticket_no)
JOIN boarding_passes b
ON tf.ticket_no = b.ticket_no AND tf.flight_id = b.flight_id
WHERE tf.flight_id = 27584
ORDER BY 2, 3;

SELECT s.seat_no, p.passenger_name
FROM seats s
LEFT OUTER JOIN (
    SELECT t.passenger_name, b.seat_no
    FROM (ticket_flights tf JOIN tickets t ON tf.ticket_no = t.ticket_no)
    JOIN boarding_passes b
    ON tf.ticket_no = b.ticket_no AND tf.flight_id = b.flight_id
    WHERE tf.flight_id = 27584
) AS p
ON s.seat_no = p.seat_no
WHERE s.aircraft_code = 'SU9'
ORDER BY s.seat_no;

SELECT s.seat_no, p.passenger_name, p.email, s.fare_conditions
FROM seats s
LEFT OUTER JOIN (
    SELECT t.passenger_name, b.seat_no, t.contact_data -> 'email' AS email
    FROM (ticket_flights tf JOIN tickets t ON tf.ticket_no = t.ticket_no)
    JOIN boarding_passes b
    ON tf.ticket_no = b.ticket_no AND tf.flight_id = b.flight_id
    WHERE tf.flight_id = 27584
) AS p
ON s.seat_no = p.seat_no
WHERE s.aircraft_code = 'SU9'
ORDER BY left(s.seat_no, length(s.seat_no) - 1)::integer,
    right(s.seat_no, 1);


WITH p AS 
(   SELECT t.passenger_name, b.seat_no, t.contact_data -> 'email' AS email
    FROM (ticket_flights tf JOIN tickets t ON tf.ticket_no = t.ticket_no)
    JOIN boarding_passes b
    ON tf.ticket_no = b.ticket_no AND tf.flight_id = b.flight_id
    WHERE tf.flight_id = 27584
)
SELECT s.seat_no, p.passenger_name, p.email, s.fare_conditions
FROM seats s
LEFT OUTER JOIN p
ON s.seat_no = p.seat_no
WHERE s.aircraft_code = 'SU9'
ORDER BY left(s.seat_no, length(s.seat_no) - 1)::integer,
    right(s.seat_no, 1);




----------------------DML---------------
CREATE TEMP TABLE aircrafts_tmp AS
SELECT * FROM aircrafts WITH NO DATA;

ALTER TABLE aircrafts_tmp
ADD PRIMARY KEY (aircraft_code);

ALTER TABLE aircrafts_tmp
ADD UNIQUE (model);

CREATE TEMP TABLE aircrafts_log AS
SELECT * FROM aircrafts WITH NO DATA;

ALTER TABLE aircrafts_log
ADD COLUMN when_add timestamp;

ALTER TABLE aircrafts_log
ADD COLUMN operation text;
