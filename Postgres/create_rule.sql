CREATE OR REPLACE RULE update_holidays_1 AS ON UPDATE TO holidays DO INSTEAD
    UPDATE events
    SET title = NEW.name,
        starts = NEW.date,
        colors = NEW.colors
        WHERE title = OLD.name;