-- Cleaning and autocleaning
---- Horizon of the Data Base
-- Freezing
-- Rebuilding tables and indexes

---------------CLEANING AND AUTOCLEANING------------------------






CREATE TABLE vac(
    id integer,
    s char(100)
) WITH (autovacuum_enabled = off);
CREATE INDEX vac_s ON vac(s);

INSERT INTO vac(id, s) VALUES(1, 'A');
UPDATE vac SET s = 'B';
UPDATE vac SET s = 'C';

SELECT * FROM heap_page('vac', 0); -- 3 rows

SELECT * FROM index_page('vac_s', 1);   -- 3 rows

VACUUM vac;

SELECT * FROM heap_page('vac', 0);  -- 1 row
SELECT * FROM index_page('vac_s', 1);   -- 1 row


CREATE EXTENSION pg_visibility;
SELECT all_visible
FROM pg_visibility_map('vac', 0); -- all visible

SELECT flags & 4 > 0 AS all_visible
FROM page_header(get_raw_page('vac', 0));   -- all visible





-----------HORIZON of DATA BASE----------------------------




-- first
TRUNCATE vac;
INSERT INTO vac(id, s) VALUES (1, 'A');
UPDATE vac SET s = 'B';

-- second
-- BEGIN;
-- INSERT INTO accounts(id, client, amount)
-- VALUES (1, 'alice', 1000);

-- first
UPDATE vac SET s = 'C';

VACUUM vac;
SELECT * FROM heap_page('vac', 0);      -- 2 rows left

SELECT * FROM index_page('vac_s', 1);   -- 2 rows left

-- second
-- SELECT backend_xmin FROM pg_stat_activity
-- WHERE pid = pg_backend_pid();       -- 1003

-- first
VACUUM VERBOSE vac;

-- second
-- COMMIT;

-- first
VACUUM VERBOSE vac;     -- 1 removed

SELECT * FROM heap_page('vac', 0);      -- 1 row
SELECT * FROM index_page('vac_s', 1);






-----------AUTOCLEANING------------------------------------





CREATE FUNCTION p(param text, c pg_class) RETURNS float
AS $$
    SELECT coalesce(
        -- if the storage parameter is defined, then we take it
        (SELECT option_value
        FROM pg_options_to_table(c.reloptions)
        WHERE option_name = CASE
            -- for toast-tables parameter's name is differed
            WHEN c.relkind = 't' THEN 'toast.' ELSE ''
            END || param
        ),
        -- else we take the value of config param
        current_setting(param)
    )::float;
$$ LANGUAGE sql;


-- View for a cleaning
CREATE VIEW need_vacuum AS
WITH c AS (
    SELECT c.oid,
        greatest(c.reltuples, 0) reltuples,
        p('autovacuum_vacuum_threshold', c) threshold,
        p('autovacuum_vacuum_scale_factor', c) scale_factor,
        p('autovacuum_vacuum_insert_threshold', c) ins_threshold,
        p('autovacuum_vacuum_insert_scale_factor', c) ins_scale_factor
    FROM pg_class c
    WHERE c.relkind IN ('r', 'm', 't')  -- r - ordinary table; m - mat view; t - toast table
)
SELECT st.schemaname || '.' || st.relname AS tablename,
    st.n_dead_tup AS dead_tup,
    c.threshold + c.scale_factor * c.reltuples AS max_dead_tup,
    st.n_ins_since_vacuum AS ins_tup,
    c.ins_threshold + c.ins_scale_factor * c.reltuples AS max_ins_tup,
    st.last_autovacuum
FROM pg_stat_all_tables st
    JOIN c ON c.oid = st.relid;


-- view for an analyze
CREATE VIEW need_analyze AS
WITH c AS (
    SELECT c.oid,
        greatest(c.reltuples, 0) reltuples,
        p('autovacuum_analyze_threshold', c) threshold,
        p('autovacuum_analyze_scale_factor', c) scale_factor
    FROM pg_class c
    WHERE c.relkind IN ('r', 'm')
)
SELECT st.schemaname || '.' || st.relname AS tablename,
    st.n_mod_since_analyze AS mod_tup,
    c.threshold + c.scale_factor * c.reltuples AS max_mod_tup,
    st.last_autoanalyze
FROM pg_stat_all_tables st
    JOIN c ON c.oid = st.relid;






ALTER SYSTEM SET autovacuum_naptime = '1s';
SELECT pg_reload_conf();

TRUNCATE TABLE vac;
INSERT INTO vac(id, s)
SELECT id, 'A' FROM generate_series(1, 1000) id;

SELECT * FROM need_vacuum WHERE tablename = 'bookings.vac' 
\gx

SELECT reltuples FROM pg_class WHERE relname = 'vac'; -- -1 -> table without statistics

SELECT * FROM need_analyze WHERE tablename = 'bookings.vac' -- max_mod_tup = 50
\gx

ALTER TABLE vac SET (autovacuum_enabled = on);

SELECT reltuples FROM pg_class WHERE relname = 'vac';   -- 1000

SELECT * FROM need_analyze WHERE tablename = 'bookings.vac'     -- max_mod_tup = 150
\gx

SELECT * FROM need_vacuum WHERE tablename = 'bookings.vac' 
\gx     -- max_dead_tup = 250

-- add 251 row
ALTER TABLE vac SET (autovacuum_enabled = off);
UPDATE vac SET s = 'B' WHERE id <= 251;
SELECT * FROM need_vacuum WHERE tablename = 'bookings.vac' \gx      -- now dead_tup = 251 > 250

ALTER TABLE vac SET (autovacuum_enabled = on);
SELECT * FROM need_vacuum WHERE tablename = 'bookings.vac' \gx
-- dead_tup = 0




--------------------TRACKING THE MANUAL CLEANING-------------------------





TRUNCATE vac;
INSERT INTO vac(id, s)
SELECT id, 'A' FROM generate_series(1, 500000) id;
UPDATE vac SET s = 'B';

ALTER SYSTEM SET maintenance_work_mem = '1MB';  -- memory for array of identyfiers 
SELECT pg_reload_conf();

VACUUM VERBOSE vac;

-- second
-- SELECT * FROM pg_stat_progress_vacuum \gx



ALTER SYSTEM SET log_autovacuum_min_duration = 0;
SELECT pg_reload_conf();
UPDATE vac SET s = 'C';







---------------------------------FREEZING-------------------------
CREATE TABLE tfreeze(
    id integer,
    s char(300)
) WITH (fillfactor = 10, autovacuum_enabled = off);






CREATE FUNCTION heap_page(
    relname text, pageno_from integer, pageno_to integer
)
RETURNS TABLE(
    ctid tid, state text,
    xmin text, xmin_age integer, xmax text
) AS $$
SELECT (pageno, lp)::text::tid AS ctid,
    CASE lp_flags
        WHEN 0 THEN 'unused'
        WHEN 1 THEN 'normal'
        WHEN 2 THEN 'redirect to '||lp_off
        WHEN 3 THEN 'dead'
    END AS state,
    t_xmin || CASE
        WHEN (t_infomask & 256+512) = 256+512 THEN ' f'
        WHEN (t_infomask & 256) > 0 THEN ' c'
        WHEN (t_infomask & 512) > 0 THEN ' a'
        ELSE ''
    END AS xmin,
    age(t_xmin) AS xmin_age,
    t_xmax || CASE
        WHEN (t_infomask & 1024) > 0 THEN ' c'
        WHEN (t_infomask & 2048) > 0 THEN ' a'
        ELSE ''
        END AS xmax
FROM generate_series(pageno_from, pageno_to) p(pageno),
    heap_page_items(get_raw_page(relname, pageno))
ORDER BY pageno, lp;
$$ LANGUAGE sql;









CREATE EXTENSION IF NOT EXISTS pg_visibility;
INSERT INTO tfreeze(id, s)
SELECT id, 'FOO'||id FROM generate_series(1, 100) id;
VACUUM tfreeze;

SELECT * FROM generate_series(0, 1) g(blkno),
                pg_visibility_map('tfreeze', g.blkno)
ORDER BY g.blkno;       -- all visible, but are not frozen


SELECT * FROM heap_page('tfreeze', 0,1);    -- xmin_age = 1 for all of them -> last trans


ALTER SYSTEM SET vacuum_freeze_min_age = 1;
SELECT pg_reload_conf();

UPDATE tfreeze SET s = 'BAR' WHERE id = 1;

-- new transaction on the first page, because fillfactor too small
SELECT * FROM heap_page('tfreeze', 0, 1);

SELECT * FROM generate_series(0, 1) g(blkno),
    pg_visibility_map('tfreeze', g.blkno)
ORDER BY g.blkno;

VACUUM tfreeze;
SELECT * FROM heap_page('tfreeze', 0, 1);

SELECT * FROM generate_series(0, 1) g(blkno),
    pg_visibility_map('tfreeze', g.blkno)
ORDER BY g.blkno;



SELECT relfrozenxid, age(relfrozenxid)
FROM pg_class
WHERE relname = 'tfreeze';      -- 1029, age = 2

ALTER SYSTEM SET vacuum_freeze_table_age = 2;
SELECT pg_reload_conf();

VACUUM VERBOSE tfreeze;     -- agressive freezing

SELECT relfrozenxid, age(relfrozenxid)
FROM pg_class
WHERE relname = 'tfreeze';      -- 1030, age = 1

SELECT * FROM heap_page('tfreeze', 0, 1);   -- all of pages were freezed

SELECT * FROM generate_series(0, 1) g(blkno),
            pg_visibility_map('tfreeze', g.blkno)
ORDER BY g.blkno;                           -- seconds page is frozen


-- datfrozenxid - oldest transaction in DB
SELECT datname, datfrozenxid, age(datfrozenxid) FROM pg_database;


-- first
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT 1;

-- second
-- BEGIN;
-- TRUNCATE tfreeze;
-- COPY tfreeze FROM stdin WITH FREEZE;
-- -- 1 (tab) FOO ... \.
-- COMMIT;

-- first
SELECT count(*) FROM tfreeze;
COMMIT;


SELECT * FROM pg_visibility_map('tfreeze', 0);  -- all visible and frozen

SELECT flags & 4 > 0 AS all_visible
FROM page_header(get_raw_page('tfreeze', 0));






------------------REBUILDING TABLES and INDEXES----------------------





TRUNCATE vac;
INSERT INTO vac(id, s)
SELECT id, id::text FROM generate_series(1, 500000) id;

CREATE EXTENSION pgstattuple;
SELECT * FROM pgstattuple('vac') \gx    -- tuple_percent 91.33 -> % of space, that usefull files occupied

SELECT * FROM pgstatindex('vac_s') \gx  -- avg_leaf_density -- //--

SELECT pg_size_pretty(pg_table_size('vac')) AS table_size,
        pg_size_pretty(pg_indexes_size('vac')) AS index_size;

DELETE FROM vac WHERE id % 10 != 0;

VACUUM vac;
SELECT pg_size_pretty(pg_table_size('vac')) AS table_size,
    pg_size_pretty(pg_indexes_size('vac')) AS index_size;   -- same space as before deleting


 -- tuple_percent and avg_leaf_dencity are less in 10 times
SELECT vac.tuple_percent, vac_s.avg_leaf_density
FROM pgstattuple('vac') vac, pgstatindex('vac_s') vac_s;

-- vac_... -> base/16390/16665; and vac_s_... -> base/16390/16666
SELECT pg_relation_filepath('vac') AS vac_filepath,
    pg_relation_filepath('vac_s') AS vac_s_filepath \gx


VACUUM FULL vac;

-- vac_... -> base/16390/16677; and vac_s_... -> base/16390/16680
SELECT pg_relation_filepath('vac') AS vac_filepath,
    pg_relation_filepath('vac_s') AS vac_s_filepath \gx

-- 6904 kB and 6504 kB
SELECT pg_size_pretty(pg_table_size('vac')) AS table_size,
    pg_size_pretty(pg_indexes_size('vac')) AS index_size;

-- 91.23 and 91.08
SELECT vac.tuple_percent, vac_s.avg_leaf_density
FROM pgstattuple('vac') vac, pgstatindex('vac_s') vac_s;

-- all of rows varions are frozen
SELECT * FROM heap_page('vac', 0, 0) LIMIT 5;

-- but all_visible = false and all_frozen = false
SELECT * FROM pg_visibility_map('vac', 0);

SELECT flags & 4 > 0 all_visible
FROM page_header(get_raw_page('vac', 0)); -- false

VACUUM vac;

-- but all_visible = true and all_frozen = true
SELECT * FROM pg_visibility_map('vac', 0);

SELECT flags & 4 > 0 all_visible
FROM page_header(get_raw_page('vac', 0)); -- true



ALTER TABLE vac ADD processed boolean DEFAULT false;
SELECT pg_size_pretty(pg_table_size('vac'));    -- 6938 kB

UPDATE vac SET processed = true;
SELECT pg_size_pretty(pg_table_size('vac'));    -- 14MB

UPDATE vac SET processed = false;
VACUUM FULL vac;

WITH batch AS (
    SELECT id FROM vac WHERE NOT processed LIMIT 1000
    FOR UPDATE SKIP LOCKED
)
UPDATE vac SET processed = true
WHERE id IN (SELECT id FROM batch);
SELECT pg_size_pretty(pg_table_size('vac'));    -- 7072 kB

VACUUM vac;
WITH batch AS (
    SELECT id FROM vac WHERE NOT processed LIMIT 1000
    FOR UPDATE SKIP LOCKED
)
UPDATE vac SET processed = true
WHERE id IN (SELECT id FROM batch);
SELECT pg_size_pretty(pg_table_size('vac'));    -- 7208 kB