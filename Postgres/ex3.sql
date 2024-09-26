-- Active: 1727185462921@@127.0.0.1@5432@edu@public
CREATE TABLE students (
    record_book NUMERIC(5) NOT NULL,
    name TEXT NOT NULL,
    doc_ser NUMERIC(4),
    doc_num NUMERIC(6),
    PRIMARY KEY (record_book)
);
CREATE TABLE progress (
    record_book NUMERIC(5) NOT NULL,
    subject TEXT NOT NULL,
    acad_year TEXT NOT NULL,
    term NUMERIC(1) NOT NULL CHECK (term = 1 OR term = 2),
    mark NUMERIC(1) NOT NULL CHECK (mark >= 3 AND mark <= 5) DEFAULT 5,
    FOREIGN KEY (record_book) REFERENCES students(record_book)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
ALTER TABLE students ADD COLUMN
    who_adds_row TEXT DEFAULT current_user;
INSERT INTo students (record_book, name, doc_ser, doc_num)
    VALUES (12300, 'Hi Hey Ho', 0402, 543281);
ALTER TABLE students ADD COLUMN 
    when_it_added TIMESTAMP DEFAULT current_timestamp;
INSERT INTO students (record_book, name, doc_ser, doc_num)
    VALUES (11000, 'Hu', 1332, 121311);
ALTER TABLE progress ADD COLUMN test_form VARCHAR(10);
ALTER TABLE progress ADD CHECK (test_form in ('examine', 'test'));
ALTER TABLE progress
ADD CHECK (
    (test_form = 'examine' AND mark IN (3,4,5))
    OR
    (test_form = 'test' AND mark IN (0, 1))
);
INSERT INTO progress 
VALUES ('12300', 'math', 'spring', '1', '4', 'examine');
ALTER TABLE progress DROP CONSTRAINT progress_mark_check;
INSERT INTO progress 
VALUES ('12300', 'math', 'spring', '1', '1', 'test');
ALTER TABLE progress ALTER COLUMN mark DROP NOT NULL;
INSERT INTO progress (record_book, subject, acad_year, term, test_form)
VALUES ('12300', 'physics', '2016/2017', 1, 'test');

ALTER TABLE students ADD UNIQUE(doc_ser, doc_num);
INSERT INTO students VALUES ('23000', 'HUSE', 444, 555);
INSERT INTO students VALUES ('2300', 'HUSE', 44, 555);
INSERT INTO students(record_book, name, doc_ser) VALUES ('23', 'HUSE', 444);
INSERT INTO students(record_book, name) VALUES ('2233', 'HUSE');
SELECT (null=null);
