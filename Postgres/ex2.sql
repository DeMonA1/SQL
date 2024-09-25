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




--SELECT 0.1::REAL * 10 = 1.0::REAL; --FALSE

--SELECT 'PostgreSQL';
--SELECT 'PGDAY''17';

--SELECT $$PGDAY'1709/$$;

SELECT E'PGDAY\'17';
SELECT
