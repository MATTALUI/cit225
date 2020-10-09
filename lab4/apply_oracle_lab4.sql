-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab4.sql
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
-- to begin lesson #3. Demonstrates proper process and syntax.
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
--   sql> @apply_oracle_lab4.sql
--
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab3/apply_oracle_lab3.sql

-- Open log file.
SPOOL apply_oracle_lab4.txt

-- Enter code below.
-- ------------------------------------------------------------------

-- STEP 1  ----------------------------------------------------------
COL member_id FORMAT 9999 HEADING "Member|ID #"

SELECT		DISTINCT(m.member_id)
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
WHERE		c.last_name = 'Sweeney';

-- STEP 2  ----------------------------------------------------------
COL last_name 	       FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"

SELECT		c.last_name
,		m.account_number
,		m.credit_card_number
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
WHERE		UPPER(c.last_name) = UPPER('SwEeNeY');

-- STEP 3  ----------------------------------------------------------
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"

SELECT DISTINCT	c.last_name
,		m.account_number
,		m.credit_card_number
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
WHERE		UPPER(c.last_name) = UPPER('SwEeNeY');

-- STEP 4  ----------------------------------------------------------
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
COL address            FORMAT A22 HEADING "Address"

SELECT DISTINCT	c.last_name
,		m.account_number
,		m.credit_card_number
,		a.city||', '||a.state_province||' '||a.postal_code as address
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
WHERE		c.last_name = 'Vizquel';

-- STEP 5  ----------------------------------------------------------
SET PAGESIZE 99
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
COL address            FORMAT A22 HEADING "Address"

SELECT DISTINCT c.last_name
,		m.account_number
,		m.credit_card_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
WHERE		c.last_name = 'Vizquel';

-- STEP 6  ----------------------------------------------------------
SET PAGESIZE 99
COL last_name          FORMAT A10 HEADING "Last Name"
COL account_number     FORMAT A10 HEADING "Account|Number"
COL credit_card_number FORMAT A19 HEADING "Credit Card Number"
COL address            FORMAT A22 HEADING "Address"

SELECT DISTINCT c.last_name
,		m.account_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
,		'('||t.area_code||') '||t.telephone_number as telephone
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
JOIN		telephone t
ON		c.contact_id = t.contact_id
WHERE		c.last_name = 'Vizquel';

-- STEP 7  ----------------------------------------------------------
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL address        FORMAT A22 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"

SELECT DISTINCT c.last_name
,		m.account_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
,		'('||t.area_code||') '||t.telephone_number as telephone
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
JOIN		telephone t
ON		c.contact_id = t.contact_id;

-- STEP 8  ----------------------------------------------------------
SET PAGESIZE 99
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL address        FORMAT A22 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"

SELECT DISTINCT c.last_name
,		m.account_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
,		'('||t.area_code||') '||t.telephone_number as telephone
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
JOIN		telephone t
ON		c.contact_id = t.contact_id
RIGHT JOIN	rental r
ON		c.contact_id = r.customer_id
ORDER BY	c.last_name;

-- STEP 9  ----------------------------------------------------------
COL last_name      FORMAT A12 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL address        FORMAT A22 HEADING "Address"
COL telephone      FORMAT A14 HEADING "Telephone"

SELECT DISTINCT c.last_name
,		m.account_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
,		'('||t.area_code||') '||t.telephone_number as telephone
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
JOIN		telephone t
ON		c.contact_id = t.contact_id
FULL JOIN	rental r
ON		c.contact_id = r.customer_id
GROUP BY	c.last_name
,		m.account_number
,		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code
,		'('||t.area_code||') '||t.telephone_number
HAVING		COUNT(r.rental_id) = 0
ORDER BY	c.last_name;

-- STEP 10 ----------------------------------------------------------
COL full_name      FORMAT A16 HEADING "Last Name"
COL account_number FORMAT A10 HEADING "Account|Number"
COL address        FORMAT A25 HEADING "Address"
COL item_title     FORMAT A14 HEADING "Item Title"

SELECT DISTINCT c.last_name||', '||c.first_name as full_name
,		m.account_number
,		'('||t.area_code||') '||t.telephone_number||CHR(10)
||		s.street_address||CHR(10)
||		a.city||', '||a.state_province||' '||a.postal_code as address
,		i.item_title
FROM		member m
JOIN		contact c
ON		m.member_id = c.member_id
JOIN		address a
ON		c.contact_id = a.contact_id
JOIN		street_address s
ON		a.address_id = s.address_id
JOIN		telephone t
ON		c.contact_id = t.contact_id
RIGHT JOIN	rental r
ON		c.contact_id = r.customer_id
JOIN		rental_item ri
ON		ri.rental_id = r.rental_id
JOIN		item i
ON		i.item_id = ri.item_id
WHERE		i.item_title LIKE 'Stir Wars%'
OR		i.item_title LIKE 'Star Wars%'
ORDER BY	i.item_title;

---------------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF
