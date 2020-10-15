-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab5.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
-- This creates tables, sequences, indexes, and constraints necessary
-- to begin lesson #5. Demonstrates proper process and syntax.
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab5.sql
--
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab4/apply_oracle_lab4.sql

-- Open log file.
SPOOL apply_oracle_lab5.txt

-- Enter code below.
-- ------------------------------------------------------------------
-- STEP 1  ----------------------------------------------------------
COL system_user_id FORMAT 9999 HEADING "System|User|ID #"

SELECT DISTINCT	system_user_id
FROM		system_user
WHERE		system_user_name = 'DBA1';


-- STEP 2  ----------------------------------------------------------
COL system_user_id   FORMAT 9999 HEADING "System|User|ID #"
COL system_user_name FORMAT A20  HEADING "System|User|Name"

SELECT		system_user_id
,		system_user_name
FROM		system_user
WHERE		system_user_name = 'DBA1';

-- STEP 3  ----------------------------------------------------------
COL system_user_id1   FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT 9999 HEADING "System User|ID #"
COL system_user_id2   FORMAT 9999 HEADING "Created By|System User|ID #"
COL system_user_name2 FORMAT A12  HEADING "Created By|System User|Name"

SELECT		su1.system_user_id   as system_user_id1
,		su1.system_user_name as system_user_name1
,		su2.system_user_id   as system_user_id2
,		su2.system_user_name as system_user_name2
FROM		system_user su1
JOIN		system_user su2
ON		su1.created_by = su2.system_user_id
WHERE		su1.system_user_name = 'DBA1';


-- STEP 4  ----------------------------------------------------------
COL system_user_id1   FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT A12  HEADING "System User|Name"
COL system_user_id2   FORMAT 9999 HEADING "System User|Name"
COL system_user_name2 FORMAT A12  HEADING "Created By|System User|Name"
COL system_user_id3   FORMAT 9999 HEADING "Last|Updated By|System User|ID #"
COL system_user_name3 FORMAT A12  HEADING "Last|Updated By|System User|Name"


SELECT		su1.system_user_id   as system_user_id1
,		su1.system_user_name as system_user_name1
,		su2.system_user_id   as system_user_id2
,		su2.system_user_name as system_user_name2
,		su3.system_user_id   as sustem_user_id3
,		su3.system_user_name as system_user_name3
FROM		system_user su1
JOIN		system_user su2
ON		su1.created_by = su2.system_user_id
JOIN		system_user su3
ON		su1.last_updated_by = su3.system_user_id
WHERE		su1.system_user_name = 'DBA1';

-- STEP 5  ----------------------------------------------------------
COL system_user_id1   FORMAT 9999 HEADING "System User|ID #"
COL system_user_name1 FORMAT A12  HEADING "System User|Name"
COL system_user_id2   FORMAT 9999 HEADING "System User|Name"
COL system_user_name2 FORMAT A12  HEADING "Created By|System User|Name"
COL system_user_id3   FORMAT 9999 HEADING "Last|Updated By|System User|ID #"
COL system_user_name3 FORMAT A12  HEADING "Last|Updated By|System User|Name"


SELECT		su1.system_user_id   as system_user_id1
,		su1.system_user_name as system_user_name1
,		su2.system_user_id   as system_user_id2
,		su2.system_user_name as system_user_name2
,		su3.system_user_id   as sustem_user_id3
,		su3.system_user_name as system_user_name3
FROM		system_user su1
JOIN		system_user su2
ON		su1.created_by = su2.system_user_id
JOIN		system_user su3
ON		su1.last_updated_by = su3.system_user_id;

-- STEP 6  ----------------------------------------------------------
DROP   TABLE	rating_agency;
CREATE TABLE 	rating_agency
(	rating_agency_id INT
,	rating_agency_abbr VARCHAR(4)
,	rating_agency_name VARCHAR(40)
,	created_by INT
,	creation_date DATE
,	last_updated_by INT
,	last_update_date DATE
,	CONSTRAINT pk_rating_agency PRIMARY KEY (rating_agency_id)
,	CONSTRAINT uq_rating_agency UNIQUE (rating_agency_abbr)
,	CONSTRAINT fk_rating_agency1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
,	CONSTRAINT fk_rating_agency2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
,	CONSTRAINT nn_rating_agency_1 CHECK (rating_agency_abbr IS NOT NULL)
,	CONSTRAINT nn_rating_agency_2 CHECK (rating_agency_name IS NOT NULL)
,	CONSTRAINT nn_rating_agency_3 CHECK (created_by IS NOT NULL)
,	CONSTRAINT nn_rating_agency_4 CHECK (creation_date IS NOT NULL)
,	CONSTRAINT nn_rating_agency_5 CHECK (last_updated_by IS NOT NULL)
,	CONSTRAINT nn_rating_agency_6 CHECK (last_update_date IS NOT NULL)
);
DROP 		sequence rating_agency_s1;
CREATE 		sequence rating_agency_s1 start with 1001 increment by 1;

-- STEP 7  ----------------------------------------------------------
INSERT INTO		rating_agency
(	rating_agency_id
,	rating_agency_abbr
,	rating_agency_name
,	created_by
,	creation_date
,	last_updated_by
,	last_update_date
)
VALUES
(	rating_agency_s1.NEXTVAL
,	'ESRB'
,	'Entertainment Software Rating Board'
,	(
		SELECT system_user_id
		FROM system_user
		WHERE system_user_name = 'DBA2'
	)
,	SYSDATE
,	(
		SELECT system_user_id
		FROM system_user
		WHERE system_user_name='DBA2'
	)
,	SYSDATE
);

INSERT INTO		rating_agency
(	rating_agency_id
,	rating_agency_abbr
,	rating_agency_name
,	created_by
,	creation_date
,	last_updated_by
,	last_update_date
)
VALUES
(	rating_agency_s1.NEXTVAL
,	'MPAA'
,	'Motion Picture Association of America'
,	(
		SELECT system_user_id
		FROM system_user
		WHERE system_user_name = 'DBA2'
	)
,	SYSDATE
,	(
		SELECT system_user_id
		FROM system_user
		WHERE system_user_name='DBA2'
	)
,	SYSDATE
);

COL rating_agency_id    FORMAT 9999 HEADING "Rating|Agency|ID #"
COL rating_agency_abbr  FORMAT A6   HEADING "Rating|Agency|Abbr"
COL rating_agency_name  FORMAT A40  HEADING "Rating Agency"

SELECT		rating_agency_id
,		rating_agency_abbr
,		rating_agency_name
FROM		rating_agency;


-- STEP 8  ----------------------------------------------------------
DROP TABLE	rating;
CREATE TABLE	rating
(	rating_id INT
,	rating_agency_id INT
,	rating VARCHAR(10)
,	description VARCHAR(420)
,	created_by INT
,	creation_date DATE
,	last_updated_by INT
,	last_update_date DATE
,	CONSTRAINT pk_rating PRIMARY KEY (rating_id)
,	CONSTRAINT uq_rating UNIQUE (rating_agency_id, rating)
,	CONSTRAINT fk_rating_1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
,	CONSTRAINT fk_rating_2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
,	CONSTRAINT nn_rating_1 CHECK (rating_agency_id IS NOT NULL)
,	CONSTRAINT nn_rating_2 CHECK (rating IS NOT NULL)
,	CONSTRAINT nn_rating_3 CHECK (description IS NOT NULL)
,	CONSTRAINT nn_rating_4 CHECK (created_by IS NOT NULL)
,	CONSTRAINT nn_rating_5 CHECK (creation_date IS NOT NULL)
,	CONSTRAINT nn_rating_6 CHECK (last_updated_by IS NOT NULL)
,	CONSTRAINT nn_rating_7 CHECK (last_update_date IS NOT NULL)
);

-- STEP 9  ----------------------------------------------------------
DROP 		sequence rating_s1;
CREATE 		sequence rating_s1 start with 2001 increment by 1;
@/home/student/Data/cit225/oracle/lab5/rating_inserts.sql
UPDATE		rating
SET		description = 'Has content that is generally suitable for all ages. May contain minimal cartoon, fantasy or mild violence and/or infrequent use of mild language'
WHERE		rating = 'Everyone';

COL rating_id    FORMAT 9999 HEADING "Rating ID"
COL rating       FORMAT 9999 HEADING "Rating"
COL description  FORMAT A40  HEADING "Rating Description"

SELECT	rating_id
,	rating
,	description
FROM	rating
WHERE	rating = 'Everyone';

-- STEP 10 ----------------------------------------------------------
ALTER TABLE	rating
ADD		dummy INT;

UPDATE		rating
SET		dummy=
CASE
	WHEN	(rating_id = 2001) THEN 3001
	WHEN	(rating_id = 2002) THEN 3002
	ELSE	NULL
END;

COL rating_id    FORMAT 9999 HEADING "Rating ID"
COL rating       FORMAT 9999 HEADING "Rating"
COL dummy        FORMAT 9999 HEADING "Dummy column added"

SELECT	rating_id
,	rating
,	dummy
FROM	rating;


-- ------------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF
