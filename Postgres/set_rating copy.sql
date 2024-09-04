CREATE OR REPLACE FUNCTION set_rating() RETURNS VOID AS $$
DECLARE 
    i RECORD;
    tag text;
BEGIN
    FOR i IN 
        SELECT tags FROM comments
    LOOP
        FOREACH tag in ARRAY i.tags
        LOOP
            UPDATE actors
            SET rating = rating + 1
            WHERE actors.name @@ tag;
        END LOOP;
    END LOOP;
END;    
$$ LANGUAGE plpgsql;