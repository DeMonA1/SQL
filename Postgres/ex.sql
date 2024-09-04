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


--SELECT * FROM crosstab(
--    'SELECT EXTRACT(WEEK FROM starts) as week,
--            extract(ISODOW from starts) as day, 
--            count(*)
--    FROM events
--    GROUP BY week, day',
--    'SELECT * FROM generate_series(1, 7)'
--) AS (week int,
--        mon int, tu int, we int, thu int, fri int, sa int, su int
--) ORDER BY week;



----------TRIGGER-----------------------
--CREATE TRIGGER log_events
--    AFTER UPDATE ON events
--        FOR EACH ROW EXECUTE PROCEDURE log_event();



-------------Fuzzy search---------------------------
--SELECT title FROM movies WHERE title ILIKE 'stardust%';
--SELECT title FROM movies WHERE title ILIKE 'stardust_%';


--SELECT COUNT(*) FROM movies WHERE title !~* '^the.*';
--CREATE INDEX movies_title_pattern ON movies (lower(title) text_pattern_ops);


--SELECT levenshtein('bat', 'fads');
--SELECT levenshtein('bat', 'fad') fad,
--		levenshtein('bat', 'fat') fat,
--		levenshtein('bat', 'bat') bat;
--SELECT movie_id, title FROM movies
--WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;


--SELECT show_trgm('Avatar');
--CREATE INDEX movies_title_trigram ON movies
--USING gist (title gist_trgm_ops);
--SELECT * FROM movies
--WHERE title % 'Avatre';


------------FULL-TEXT SEARCH---------------------
--SELECT title FROM movies WHERE title @@ 'night & day';
--SELECT title FROM movies
--WHERE to_tsvector(title) @@ to_tsquery('english', 'night & day');		
--SELECT to_tsvector('A Hard Day''s Night'),
--		to_tsquery('english', 'night & day');
--SELECT to_tsvector('simple', 'A Hard Day''s Night');


--SELECT ts_lexize('english_stem', 'Day''s');


--EXPLAIN SELECT * FROM movies WHERE title @@ 'night & day';
--CREATE INDEX movies_title_searchable ON movies
--USING gin(to_tsvector('english', title));
--EXPLAIN SELECT * FROM movies WHERE to_tsvector('english', title) @@ 'night & day';


--SELECT title FROM movies NATURAL JOIN movies_actors NATURAL JOIN actors
--WHERE metaphone(name, 6) = metaphone('Broos Wils', 6);
--SELECT name, dmetaphone(name), dmetaphone_alt(name), metaphone(name, 8),soundex(name)
--FROM actors;

--SELECT * FROM actors
--WHERE metaphone(name, 8) % metaphone('Robin Williams', 8)
--ORDER BY levenshtein(lower('Robin Williams'), lower(name));
--SELECT * FROM actors WHERE dmetaphone(name) % dmetaphone('Ron');



--SELECT name, cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) as score
--FROM genres g 
--WHERE cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;

--SELECT *, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
--FROM movies ORDER BY dist;

--SELECT cube_enlarge('(1,1)',1,2);

--SELECT title, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
--FROM movies
--WHERE cube_enlarge('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)'::cube, 5, 18) @> genre
--ORDER BY dist;

--SELECT m.movie_id, m.title
--FROM movies m, (SELECT genre, title FROM movies WHERE title = 'Mad Max') s
--WHERE cube_enlarge(s.genre, 5, 18) @> m.genre AND s.title <> m.title
--ORDER BY cube_distance(m.genre, s.genre)
--LIMIT 10;



CREATE TABLE comments(
    comment_id BIGSERIAL PRIMARY KEY,
    comment text NOT NULL,
    username text NOT NULL,
    movie_id INTEGER REFERENCES movies NOT NULL,
    tags text ARRAY CHECK (NOT (tags && ARRAY['the', 'is', 'at', 'which', 'on', 'and', 'a', 'to', 'in']))
);