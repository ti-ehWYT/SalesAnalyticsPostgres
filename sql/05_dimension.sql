-- ============================================================
-- 05 DIMENSION TABLES
-- ============================================================
-- Purpose:
-- Create dimension tables for the star schema.
--
-- Dimension tables provide descriptive information used to
-- filter, group and analyse sales transactions.
--
-- Dimensions:
--   dim_date
--   dim_sales_rep
--   dim_region
--   dim_category
-- ============================================================


-- ============================================================
--  CREATE DATE DIMENSION
-- ============================================================
-- Purpose:
-- Provide calendar attributes for easier time-based analysis and Power BI visualisation.
-- ============================================================

CREATE TABLE curated.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name TEXT NOT NULL,
    day INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL,
    day_name TEXT NOT NULL
);


-- ============================================================
-- POPULATE DATE DIMENSION
-- ============================================================
-- Generate one record for every day in 2023.
--
-- date_key format:
-- YYYYMMDD
-- Example:
-- 2023-01-01 -> 20230101
-- ============================================================

INSERT INTO curated.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_of_week,
    day_name
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_key,
    d AS full_date,
    EXTRACT(YEAR FROM d)::INTEGER AS year,
    EXTRACT(QUARTER FROM d)::INTEGER AS quarter,
    EXTRACT(MONTH FROM d)::INTEGER AS month,
    TO_CHAR(d, 'FMMonth') AS month_name,
    EXTRACT(DAY FROM d)::INTEGER AS day,
    EXTRACT(ISODOW FROM d)::INTEGER AS day_of_week,
    TO_CHAR(d, 'FMDay') AS day_name
FROM generate_series(
    DATE '2023-01-01',
    DATE '2023-12-31',
    INTERVAL '1 day'
) AS d;


-- ============================================================
-- CHECK DATE DIMENSION
-- ============================================================

SELECT *
FROM curated.dim_date
ORDER BY full_date
LIMIT 10;


-- ============================================================
-- CREATE SALES REPRESENTATIVE DIMENSION
-- ============================================================

CREATE TABLE curated.dim_sales_rep (
    sales_rep_key SERIAL PRIMARY KEY,
    sales_rep TEXT NOT NULL UNIQUE
);


-- ============================================================
-- POPULATE SALES REPRESENTATIVE DIMENSION
-- ============================================================

INSERT INTO curated.dim_sales_rep (sales_rep)
SELECT DISTINCT
    TRIM(sales_rep)
FROM curated.sales
WHERE sales_rep IS NOT NULL;


-- ============================================================
-- CHECK SALES REPRESENTATIVE DIMENSION
-- ============================================================

SELECT *
FROM curated.dim_sales_rep
ORDER BY sales_rep_key;


-- ============================================================
-- CREATE REGION DIMENSION
-- ============================================================

CREATE TABLE curated.dim_region (
    region_key SERIAL PRIMARY KEY,
    region TEXT NOT NULL UNIQUE
);


-- ============================================================
-- POPULATE REGION DIMENSION
-- ============================================================

INSERT INTO curated.dim_region (region)
SELECT DISTINCT
    TRIM(region)
FROM curated.sales
WHERE region IS NOT NULL;


-- ============================================================
-- CHECK REGION DIMENSION
-- ============================================================

SELECT *
FROM curated.dim_region
ORDER BY region_key;


-- ============================================================
-- CREATE CATEGORY DIMENSION
-- ============================================================

CREATE TABLE curated.dim_category (
    category_key SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);


-- ============================================================
-- POPULATE CATEGORY DIMENSION
-- ============================================================
_
INSERT INTO curated.dim_category (category_name)
SELECT DISTINCT
    product_category
FROM curated.sales
WHERE product_category IS NOT NULL
ORDER BY product_category;


-- ============================================================
-- CHECK CATEGORY DIMENSION
-- ============================================================

SELECT *
FROM curated.dim_category
ORDER BY category_key;