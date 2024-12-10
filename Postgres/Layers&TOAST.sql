-- Layers and files
-- Toast

SELECT now();

SHOW server_version;



CREATE UNLOGGED TABLE t(
    a integer,
    b numeric,
    c text,
    d json
);
INSERT INTO t VALUES (1, 2.0, 'foo', '{}');





-------------------------layers and files------------------------------------




SELECT pg_relation_filepath('t');
-- base => pg_default tablespace
SELECT oid FROM pg_database WHERE datname = 'demo';
SELECT relfilenode FROM pg_class WHERE relname = 't';

SELECT size
FROM pg_stat_file('/var/lib/postgresql/15/main/base/16390/16517');

SELECT size FROM pg_stat_file('/var/lib/postgresql/15/main/base/16390/16517_init')

VACUUM t;
SELECT size FROM pg_stat_file('/var/lib/postgresql/15/main/base/16390/16517_fsm');

SELECT size FROM pg_stat_file('/var/lib/postgresql/15/main/base/16390/16517_vm');





-- pages




---- ---------TOAST_-------------------


SELECT attname, atttypid::regtype,
CASE attstorage
    WHEN 'p' THEN 'plain'
    WHEN 'e' THEN 'external'
    WHEN 'm' THEN 'main'
    WHEN 'x' THEN 'extended'
END AS storage
FROM pg_attribute
WHERE attrelid = 't'::regclass AND attnum > 0;

ALTER TABLE t ALTER COLUMN d SET STORAGE external;

SELECT relnamespace::regnamespace, relname
FROM pg_class WHERE oid = (
    SELECT reltoastrelid FROM pg_class WHERE relname = 't'
);  -- pg_toast; pg_toast_16517

-- show toast table for 't' table
-- \d+ pg_toast.pg_toast_16517

SELECT indexrelid::regclass FROM pg_index
WHERE indrelid = (
    SELECT oid FROM pg_class WHERE relname = 'pg_toast_16517'
); -- pg_toast.pg_toast_16517_index

-- \d pg_toast.pg_toast_16517_index
-- columns for toast table index


UPDATE t SET c = repeat('A', 5000);
SELECT * FROM pg_toast.pg_toast_16517;      -- nothing, values comprassed

UPDATE t SET c = (
    SELECT string_agg(chr(trunc(65 + random() * 26)::integer), '')
    FROM generate_series(1, 5000)
)
RETURNING left(c, 10) || '...' || right(c, 10);

SELECT chunk_id, chunk_seq, length(chunk_data),
        left(encode(chunk_data, 'escape')::text, 10) || '...' ||
        right(encode(chunk_data, 'escape')::text, 10)
FROM pg_toast.pg_toast_16517;
