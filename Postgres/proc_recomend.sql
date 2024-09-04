CREATE OR REPLACE FUNCTION film_recommendation (text) RETURNS SETOF text AS $$
    SELECT title FROM movies NATURAL JOIN movies_actors NATURAL JOIN actors
    WHERE name = $1
$$ LANGUAGE SQL STABLE;