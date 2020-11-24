-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab11.sql
--  Lab Assignment: Lab #11
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
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
--   sql> @apply_oracle_lab11.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/cit225/lab10/apply_oracle_lab10.sql

-- Spool log file.
SPOOL apply_oracle_lab11.txt

-- --------------------------------------------------------
--  Step #1 : Merge statement to the rental table.
-- --------------------------------------------------------

-- Count rentals before insert.
SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

-- Merge transaction data into rental table.
MERGE INTO rental target
USING ( ... query_statement ... ) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
, source.column_name
...
, source.column_name);










-- Count rentals after insert.
SELECT   COUNT(*) AS "Rental after count"
FROM     rental;

-- --------------------------------------------------------
--  Step #2 : Merge statement to the rental_item table.
-- --------------------------------------------------------

-- Count rental items before insert.
SELECT   COUNT(*)
FROM     rental_item;

-- Merge transaction data into rental_item table.
MERGE INTO rental_item target
USING ( ... query_statement ... ) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval
, source.column_name
...
, source.column_name);










-- Count rental items after insert.
SELECT   COUNT(*) AS "After Insert"
FROM     rental_item;

-- --------------------------------------------------------
--  Step #3 : Merge statement to the transaction table.
-- --------------------------------------------------------

-- Count transactions before insert
SELECT   COUNT(*) AS "Before Insert"
FROM     transaction;

-- Merge transaction data into transaction table.
MERGE INTO transaction target
USING ( ... query_statement ... ) source
ON (target.transaction_id = source.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
, source.column_name
...
, source.column_name);










-- Count transactions after insert
SELECT   COUNT(*)
FROM     transaction;

-- --------------------------------------------------------
--  Step #4(a) : Put merge statements in a procedure.
-- --------------------------------------------------------

-- Create a procedure to wrap the transformation of import to normalized tables.
CREATE OR REPLACE PROCEDURE upload_transactions IS
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO rental target
  USING ( ... query_statement ... ) source
  ON (target.rental_id = source.rental_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.NEXTVAL
  , source.column_name
  ...
  , source.column_name)) source
  ON (target.rental_id = source.rental_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.nextval
  ...
  , source.last_update_date);

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO rental_item target
  USING ( ... query_statement ... ) source
  ON (target.rental_item_id = source.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.nextval
  , source.column_name
  ...
  , source.column_name)) source
  ON (target.rental_item_id = source.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT
  ( rental_item_id
  ...
  , last_update_date)
  VALUES
  ( rental_item_s1.nextval
  ...
  , source.last_update_date);

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO transaction target
  USING ( ... query_statement ... ) source
  ON (target.transaction_id = source.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( transaction_s1.nextval
  , source.column_name
  ...
  , source.column_name) source
  ON (target.transaction_id = source.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT
  ( transaction_id
  ...
  , last_update_date)
  VALUES
  ( transaction_s1.nextval
  , source.transaction_account
  ...
  , source.last_update_date);

  -- Save the changes.
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/

-- Show errors if any.
SHOW ERRORS

-- --------------------------------------------------------
--  Step #4(b) : Execute the procedure for the first time.
-- --------------------------------------------------------

-- Verify and execute procedure.
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"

-- Query for initial counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--       8      12           0
-- ----------------------------------------------
SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- Transform import source into normalized tables.
EXECUTE upload_transactions;

-- --------------------------------------------------------
--  Step #4(c) : Verify first merge statements results.
-- --------------------------------------------------------

-- Requery to see completed counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--   4,689  11,532       4,681
-- ----------------------------------------------
SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- --------------------------------------------------------
--  Step #4(d) : Execute the procedure for the second time.
-- --------------------------------------------------------

-- Transform import source into normalized tables.
EXECUTE upload_transactions;

-- --------------------------------------------------------
--  Step #4(e) : Verify second merge statements results.
-- --------------------------------------------------------

-- Requery to see completed counts, should return:
-- ----------------------------------------------
--          Rental
--  Rental    Item Transaction
--   Count   Count       Count
-- ------- ------- -----------
--   4,689  11,532       4,681
-- ----------------------------------------------

SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction);

-- --------------------------------------------------------
--  Step #5 : Demonstrate aggregation with sorting options.
-- --------------------------------------------------------
-- Expand line length in environment.
SET LINESIZE 150
COLUMN month FORMAT A10 HEADING "MONTH"

-- Query, aggregate, and sort data.
-- Query for initial counts, should return:
-- --------------------------------------------------------------------------------------------
-- MONTH      BASE_REVENUE   10_PLUS        20_PLUS        10_PLUS_LESS_B 20_PLUS_LESS_B
-- ---------- -------------- -------------- -------------- -------------- --------------
-- JAN-2009        $2,671.20      $2,938.32      $3,205.44        $267.12        $534.24
-- FEB-2009        $4,270.74      $4,697.81      $5,124.89        $427.07        $854.15
-- MAR-2009        $5,371.02      $5,908.12      $6,445.22        $537.10      $1,074.20
-- APR-2009        $4,932.18      $5,425.40      $5,918.62        $493.22        $986.44
-- MAY-2009        $2,216.46      $2,438.11      $2,659.75        $221.65        $443.29
-- JUN-2009        $1,208.40      $1,329.24      $1,450.08        $120.84        $241.68
-- JUL-2009        $2,404.08      $2,644.49      $2,884.90        $240.41        $480.82
-- AUG-2009        $2,241.90      $2,466.09      $2,690.28        $224.19        $448.38
-- SEP-2009        $2,197.38      $2,417.12      $2,636.86        $219.74        $439.48
-- OCT-2009        $3,275.40      $3,602.94      $3,930.48        $327.54        $655.08
-- NOV-2009        $3,125.94      $3,438.53      $3,751.13        $312.59        $625.19
-- DEC-2009        $2,340.48      $2,574.53      $2,808.58        $234.05        $468.10
-- --------------------------------------------------------------------------------------------














SPOOL OFF
