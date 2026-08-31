-- ============================================================
-- 03 STAGING LAYER
-- ============================================================
-- Purpose:
-- Transform the raw source data into appropriate data types,
-- clean text fields, and perform data quality validation.
--
-- staging = transformed and validated data
--
-- The raw layer remains unchanged so the original source data
-- can always be traced back if an issue is discovered.
-- ============================================================

-- ============================================================
-- CREATE STAGING SALES TABLE
-- ============================================================
-- Transform VARCHAR fields from the raw layer into appropriate PostgreSQL data types.
--
-- TRIM() is to removes unnecessary leading/trailing spaces.
--
-- region_and_sales_rep is excluded because it is redundant
-- and can be recreated from region and sales_rep if required.
-- ============================================================

CREATE TABLE staging.sales AS
SELECT
    CAST(product_id AS INTEGER) AS product_id,
    CAST(sale_date AS DATE) AS sale_date,
    TRIM(sales_rep) AS sales_rep,
    TRIM(region) AS region,
    CAST(sales_amount AS NUMERIC(14,2)) AS sales_amount,
    CAST(quantity_sold AS INTEGER) AS quantity_sold,
    TRIM(product_category) AS product_category,
    CAST(unit_cost AS NUMERIC(14,2)) AS unit_cost,
    CAST(unit_price AS NUMERIC(14,2)) AS unit_price,
    TRIM(customer_type) AS customer_type,
    CAST(discount AS NUMERIC(8,4)) AS discount,
    TRIM(payment_method) AS payment_method,
    TRIM(sales_channel) AS sales_channel
FROM raw.sales;

-- ============================================================
-- PREVIEW STAGING DATA
-- ============================================================

SELECT *
FROM staging.sales
LIMIT 10;


-- ============================================================
-- CREATE DATA QUALITY TABLE
-- ============================================================
-- Purpose:
-- Add a data quality status to identify transactions that
-- fall outside the expected 2023 reporting period.
--
-- VALID        = transaction occurred during 2023
-- INVALID_DATE = transaction occurred outside 2023
-- ============================================================

CREATE TABLE staging.sales_quality AS
SELECT
    *,
    CASE
        WHEN sale_date >= DATE '2023-01-01'
         AND sale_date < DATE '2024-01-01'
        THEN 'VALID'
        ELSE 'INVALID_DATE'
    END AS data_quality_status
FROM staging.sales;

-- ============================================================
-- CHECK DATA QUALITY STATUS
-- ============================================================

SELECT
    data_quality_status,
    COUNT(*) AS row_count
FROM staging.sales_quality
GROUP BY data_quality_status
ORDER BY data_quality_status;


-- ============================================================
-- CHECK INVALID DATE RECORDS
-- ============================================================
-- Purpose:
-- Review the records that will be excluded from the curated
-- analytical dataset.
-- ============================================================

SELECT *
FROM staging.sales_quality
WHERE data_quality_status = 'INVALID_DATE';