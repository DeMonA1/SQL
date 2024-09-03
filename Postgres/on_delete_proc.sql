CREATE OR REPLACE RULE venues_delete AS ON DELETE TO venues DO INSTEAD
    UPDATE venues
    SET active=false
    WHERE venue_id=OLD.venue_id;