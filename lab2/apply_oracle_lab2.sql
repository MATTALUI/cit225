-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab2.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  17-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  13-Aug-2019    Incorporate diagnostic scripts.
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
--   sql> @apply_oracle_lab2.sql
--
-- ------------------------------------------------------------------

-- Set SQL*Plus environmnet variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- ------------------------------------------------------------------
--  Cleanup prior installations and run previous lab scripts.
-- ------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab1/apply_oracle_lab1.sql

-- Open log file.
SPOOL apply_oracle_lab2.txt

-- Enter code below.
-- ------------------------------------------------------------------

-- STEP 1  ----------------------------------------------------------
COL account_number        FORMAT A12    HEADING "Account|Number"
COL credit_card_number    FORMAT A22    HEADING "Credit|Card Number"

SELECT
        account_number,
        credit_card_number
FROM    member;

-- STEP 2  ----------------------------------------------------------
COL first_name   FORMAT A12  HEADING "First Name"
COL middle_name  FORMAT A12  HEADING "Middle Name"
COL last_name    FORMAT A12  HEADING "Last Name"

SELECT
          first_name,
          middle_name,
          last_name
FROM      contact
ORDER BY  last_name;

-- STEP 3  ----------------------------------------------------------
COL city            FORMAT A14  HEADING "City"
COL state_province  FORMAT A8   HEADING "State|Province"
COL postal_code     FORMAT A6   HEADING "Postal|Code"

SELECT
        city,
        state_province,
        postal_code
FROM    address;

-- STEP 4  ----------------------------------------------------------
COL check_out_date  FORMAT A12  HEADING "Check Out|Date"
COL return_date     FORMAT A12  HEADING "Return|Date"

SELECT
        check_out_date,
        return_date
FROM    rental;

-- STEP 5  ----------------------------------------------------------
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_rating        FORMAT A10  HEADING "Item|Rating"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"

SELECT
        item_title,
        item_rating,
        item_release_date
FROM    item;

-- STEP 6  ----------------------------------------------------------
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_rating        FORMAT A15  HEADING "Item|Rating"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"

SELECT
          item_title,
          item_rating,
          item_release_date
FROM      item
WHERE     item_rating = 'PG'
ORDER BY  item_title;

-- STEP 7  ----------------------------------------------------------
COL first_name   FORMAT A12  HEADING "First Name"
COL middle_name  FORMAT A12  HEADING "Middle Name"
COL last_name    FORMAT A12  HEADING "Last Name"

SELECT
        first_name,
        middle_name,
        last_name
FROM    contact
WHERE   last_name = 'Sweeney'
AND     middle_name IS NULL;

-- STEP 8  ----------------------------------------------------------
COL first_name   FORMAT A12  HEADING "First Name"
COL last_name    FORMAT A12  HEADING "Last Name"

SELECT
        first_name,
        middle_name,
        last_name
FROM    contact
WHERE   UPPER(last_name) LIKE UPPER('ViZ%');
-- Made ViZ weird cased so I know the case insesitivity works as expected

-- STEP 9  ----------------------------------------------------------
COL city            FORMAT A14  HEADING "City"
COL state_province  FORMAT A8   HEADING "State|Province"
COL postal_code     FORMAT A6   HEADING "Postal|Code"

SELECT
        city,
        state_province,
        postal_code
FROM    address
WHERE   city IN ('Provo', 'San Jose');

-- STEP 10 ----------------------------------------------------------
COL item_title         FORMAT A30  HEADING "Item Title"
COL item_release_date  FORMAT A12  HEADING "Item|Release|Date"

SELECT
        item_title,
        item_release_date
FROM    item
WHERE   item_release_date BETWEEN '01-JAN-2003' AND '31-DEC-2003';

-- ------------------------------------------------------------------
-- Enter lab code above.

-- Close log file.
SPOOL OFF
