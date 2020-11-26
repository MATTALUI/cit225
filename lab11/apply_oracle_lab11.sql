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
@/home/student/cit225/lab9/apply_oracle_lab9.sql

-- Spool log file.
SPOOL apply_oracle_lab11.txt

-- --------------------------------------------------------
--  Step #1 : Merge statement to the rental table.
-- --------------------------------------------------------
/*
-- Count rentals before insert.
SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

-- Merge transaction data into rental table.
MERGE INTO rental target
USING (
	SELECT   	DISTINCT
	         	r.rental_id,
	        	c.contact_id,
	        	tu.check_out_date AS check_out_date,
	        	tu.return_date AS return_date,
	        	1001 AS created_by,
	        	TRUNC(SYSDATE) AS creation_date,
	        	1001 AS last_updated_by,
	        	TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
, source.contact_id -- NOT THE NAME ON THE TABLE; COULD BE PROBLEMATIC
, source.check_out_date
, source.return_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);



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
USING (
	SELECT   ri.rental_item_id
	,        r.rental_id
	,        tu.item_id
	,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
	,        cl.common_lookup_id AS rental_item_type
	,        1001 AS created_by
	,        TRUNC(SYSDATE) AS creation_date
	,        1001 AS last_updated_by
	,        TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	JOIN		common_lookup cl
	ON      	cl.common_lookup_table = 'RENTAL_ITEM'
	AND     	cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
	AND     	cl.common_lookup_type = tu.rental_item_type
	LEFT JOIN	rental_item ri
	ON		ri.rental_id = r.rental_id
) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval                                                                                          
, source.rental_id                                                                                          
, source.item_id                                                                                            
, source.created_by                                                                                         
, source.creation_date                                                                                     
, source.last_updated_by                                                                                    
, source.last_update_date                                                                                   
, source.rental_item_price                                                                                  
, source.rental_item_type
);


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
USING (
	SELECT   t.transaction_id
	,        tu.payment_account_number AS transaction_account
	,        cl1.common_lookup_id AS transaction_type
	,        TRUNC(tu.transaction_date) AS transaction_date
	,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
	,        r.rental_id
	,        cl2.common_lookup_id AS payment_method_type
	,        m.credit_card_number AS payment_account_number
	,        1001 AS created_by
	,        TRUNC(SYSDATE) AS creation_date
	,        1001 AS last_updated_by
	,        TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	JOIN		common_lookup cl1
	ON      	cl1.common_lookup_table = 'TRANSACTION'
	AND     	cl1.common_lookup_column = 'TRANSACTION_TYPE'
	AND     	cl1.common_lookup_type = tu.transaction_type
	JOIN		common_lookup cl2
	ON      	cl2.common_lookup_table = 'TRANSACTION'
	AND     	cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
	AND     	cl2.common_lookup_type = tu.payment_method_type
	LEFT JOIN	transaction t
	ON		t.transaction_account = tu.payment_account_number
	AND		t.rental_id = r.rental_id
	AND		t.transaction_type = cl1.common_lookup_id
	AND		t.transaction_date = tu.transaction_date
	AND		t.payment_method_type = cl2.common_lookup_id
	AND		t.payment_account_number = m.credit_card_number
	GROUP BY t.transaction_id
	,        tu.payment_account_number
	,        cl1.common_lookup_id
	,        tu.transaction_date
	,        r.rental_id
	,        cl2.common_lookup_id
	,        m.credit_card_number
	,        1001
	,        TRUNC(SYSDATE)
	,        1001
	,        TRUNC(SYSDATE)
) source
ON (target.transaction_id = source.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
, source.transaction_account
, source.transaction_type
, source.transaction_date
, source.transaction_amount
, source.rental_id
, source.payment_method_type
, source.payment_account_number
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);


-- Count transactions after insert
SELECT   COUNT(*)
FROM     transaction;

*/
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
  USING (
  	SELECT   	DISTINCT
	         	r.rental_id,
	        	c.contact_id,
	        	tu.check_out_date AS check_out_date,
	        	tu.return_date AS return_date,
	        	1001 AS created_by,
	        	TRUNC(SYSDATE) AS creation_date,
	        	1001 AS last_updated_by,
	        	TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  ) source
  ON (target.rental_id = source.rental_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.NEXTVAL
  , source.contact_id -- NOT THE NAME ON THE TABLE; COULD BE PROBLEMATIC
  , source.check_out_date
  , source.return_date
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date);

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO rental_item target
  USING (
	SELECT   ri.rental_item_id
	,        r.rental_id
	,        tu.item_id
	,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
	,        cl.common_lookup_id AS rental_item_type
	,        1001 AS created_by
	,        TRUNC(SYSDATE) AS creation_date
	,        1001 AS last_updated_by
	,        TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	JOIN		common_lookup cl
	ON      	cl.common_lookup_table = 'RENTAL_ITEM'
	AND     	cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
	AND     	cl.common_lookup_type = tu.rental_item_type
	LEFT JOIN	rental_item ri
	ON		ri.rental_id = r.rental_id
  ) source
  ON (target.rental_item_id = source.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.nextval                                                                                          
  , source.rental_id                                                                                          
  , source.item_id                                                                                            
  , source.created_by                                                                                         
  , source.creation_date                                                                                     
  , source.last_updated_by                                                                                    
  , source.last_update_date                                                                                   
  , source.rental_item_price                                                                                  
  , source.rental_item_type
  );

  -- Insert or update the table, which makes this rerunnable when the file hasn't been updated.
  MERGE INTO transaction target
  USING (
	SELECT   t.transaction_id
	,        tu.payment_account_number AS transaction_account
	,        cl1.common_lookup_id AS transaction_type
	,        TRUNC(tu.transaction_date) AS transaction_date
	,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
	,        r.rental_id
	,        cl2.common_lookup_id AS payment_method_type
	,        m.credit_card_number AS payment_account_number
	,        1001 AS created_by
	,        TRUNC(SYSDATE) AS creation_date
	,        1001 AS last_updated_by
	,        TRUNC(SYSDATE) AS last_update_date
	FROM     	member m INNER JOIN contact c
	ON       	m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON       	c.first_name = tu.first_name
	AND      	NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
	AND      	c.last_name = tu.last_name
	LEFT JOIN	rental r
	ON		r.customer_id = c.contact_id
	AND		TRUNC(tu.return_date) = TRUNC(r.return_date)
	AND		TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
	JOIN		common_lookup cl1
	ON      	cl1.common_lookup_table = 'TRANSACTION'
	AND     	cl1.common_lookup_column = 'TRANSACTION_TYPE'
	AND     	cl1.common_lookup_type = tu.transaction_type
	JOIN		common_lookup cl2
	ON      	cl2.common_lookup_table = 'TRANSACTION'
	AND     	cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
	AND     	cl2.common_lookup_type = tu.payment_method_type
	LEFT JOIN	transaction t
	ON		t.transaction_account = tu.payment_account_number
	AND		t.rental_id = r.rental_id
	AND		t.transaction_type = cl1.common_lookup_id
	AND		t.transaction_date = tu.transaction_date
	AND		t.payment_method_type = cl2.common_lookup_id
	AND		t.payment_account_number = m.credit_card_number
	GROUP BY t.transaction_id
	,        tu.payment_account_number
	,        cl1.common_lookup_id
	,        tu.transaction_date
	,        r.rental_id
	,        cl2.common_lookup_id
	,        m.credit_card_number
	,        1001
	,        TRUNC(SYSDATE)
	,        1001
	,        TRUNC(SYSDATE)
  ) source
  ON (target.transaction_id = source.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET last_updated_by = source.last_updated_by
  ,          last_update_date = source.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( transaction_s1.nextval
  , source.transaction_account
  , source.transaction_type
  , source.transaction_date
  , source.transaction_amount
  , source.rental_id
  , source.payment_method_type
  , source.payment_account_number
  , source.created_by
  , source.creation_date
  , source.last_updated_by
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
--       8      13           0
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
--   4,689  11,533       4,681
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
--   4,689  11,533       4,681
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
COLUMN month 		FORMAT A15 HEADING "MONTH"
COLUMN base_revenue 	FORMAT A15 HEADING "BASE REVENUE"
COLUMN ten_plus 	FORMAT A15 HEADING "10% PLUS"
COLUMN twenty_plus 	FORMAT A15 HEADING "20% PLUS"
COLUMN ten_diff		FORMAT A15 HEADING "10% DIFFERENCE"
COLUMN twenty_diff	FORMAT A15 HEADING "20% DIFFERENCE"

SELECT 		TO_CHAR(TO_DATE(month_num, 'MM'), 'MONTH')||'-'||year AS month
,		TO_CHAR(base_revenue,'$9,999,999.00') AS base_revenue
,		TO_CHAR(base_revenue * 1.1,'$9,999,999.00') AS ten_plus
,		TO_CHAR(base_revenue * 1.2,'$9,999,999.00') AS twenty_plus
,		TO_CHAR(base_revenue * 1.1 - base_revenue,'$9,999,999.00') as ten_diff
,		TO_CHAR(base_revenue * 1.2 - base_revenue,'$9,999,999.00') as twenty_diff
FROM (	
	SELECT 		EXTRACT(MONTH FROM TO_DATE(t.transaction_date)) AS month_num
	,		EXTRACT(YEAR FROM TO_DATE(t.transaction_date))  AS year
	,		SUM(t.transaction_amount) AS base_revenue
	FROM		transaction t
	WHERE		EXTRACT(YEAR FROM TO_DATE(t.transaction_date)) = 2009
	GROUP BY 	EXTRACT(MONTH FROM TO_DATE(t.transaction_date))
	,		EXTRACT(YEAR FROM TO_DATE(t.transaction_date)) 
	ORDER BY 	month_num
);

SPOOL OFF
