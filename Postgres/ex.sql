------TEMPORARY TABLE, EXTRACT, CROSSTAB(), GENERATE_SERIES(a,b)---------------
--CREATE TEMPORARY TABLE month_count(month INT);
--INSERT INTO month_count VALUES (1), (2), (3), (4), (5), (6),
--(7), (8), (9), (10), (11), (12);

--SELECT * FROM crosstab(
--    'SELECT extract(year from starts) as year,
--        extract(month from starts) as month, count(*)
--    FROM events
--   GROUP BY year, month',
--    'SELECT * FROM month_count'
--) AS (
--    year int,
--    jan int, feb int, mar int, apr int, may int, jun int,
--    jul int, aug int, sep int, oct int, nov int, dec int
--) ORDER BY YEAR;

--SELECT * FROM crosstab(
--    'SELECT extract(year from starts) as year,
--        extract(month from starts) as month, count(*)
--    FROM events
--    GROUP BY year, month',
--    'SELECT * FROM generate_series(1, 12)'
--) AS (
--    year int,
--    jan int, feb int, mar int, apr int, may int, jun int,
--    jul int, aug int, sep int, oct int, nov int, dec int
--) ORDER BY year;

SELECT * FROM crosstab(
    'SELECT EXTRACT(WEEK FROM starts) as week,
            extract(ISODOW from starts) as day, 
            count(*)
    FROM events
    GROUP BY week, day',
    'SELECT * FROM generate_series(1, 7)'
) AS (week int,
        mon int, tu int, we int, thu int, fri int, sa int, su int
) ORDER BY week;


----------TRIGGER-----------------------
--CREATE TRIGGER log_events
--    AFTER UPDATE ON events
--        FOR EACH ROW EXECUTE PROCEDURE log_event();
