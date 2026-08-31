-- ============================================================
-- 02 CREATE RAW TABLE
-- ============================================================
-- Purpose:
-- Store original sales data from the source of CSV files
-- ============================================================

Create table (DDL — Data Definition Language)
CREATE TABLE raw.sales (
    product_id VARCHAR(50),
    sale_date VARCHAR(50),
    sales_rep VARCHAR(100),
    region VARCHAR(50),
    sales_amount VARCHAR(50),
    quantity_sold VARCHAR(50),
    product_category VARCHAR(100),
    unit_cost VARCHAR(50),
    unit_price VARCHAR(50),
    customer_type VARCHAR(50),
    discount VARCHAR(50),
    payment_method VARCHAR(100),
    sales_channel VARCHAR(50),
    region_and_sales_rep VARCHAR(150)
);

-- ============================================================
-- Preview Raw Data
-- ============================================================
SELECT *
FROM raw.sales
LIMIT 10;

-- ============================================================
-- Check Total number of records
-- ============================================================
SELECT COUNT(*)
FROM raw.sales;

-- ============================================================
-- DATA PROFILING
-- ============================================================
-- Purpose:
-- Understand the values before transformation.
-- ============================================================

-- ============================================================
-- Check number of unique values
-- ============================================================

SELECT
    COUNT(*) AS Total,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT sales_rep) AS unique_sales_reps,
    COUNT(DISTINCT region) AS unique_regions,
    COUNT(DISTINCT product_category) AS unique_categories,
    COUNT(DISTINCT customer_type) AS unique_customer_types,
    COUNT(DISTINCT payment_method) AS unique_payment_methods,
    COUNT(DISTINCT sales_channel) AS unique_sales_channels
FROM raw.sales;

-- ============================================================
-- Check for NULL values
-- Purpose:
-- Identify missing values in each column.
-- ============================================================
-- COUNT(column) counts only non-NULL values.
-- If the result is less than total_records, the column
-- contains NULL values.
-- ============================================================

SELECT
    COUNT(product_id) AS missing_product_id,
    COUNT(sale_date) AS missing_sale_date,
    COUNT(sales_rep) AS missing_sales_rep,
    COUNT(region) AS missing_region,
    COUNT(sales_amount) AS missing_sales_amount,
    COUNT(quantity_sold) AS missing_quantity,
    COUNT(product_category) AS missing_category,
    COUNT(unit_cost) AS missing_unit_cost,
    COUNT(unit_price) AS missing_unit_price,
    COUNT(customer_type) AS missing_customer_type,
    COUNT(discount) AS missing_discount,
    COUNT(payment_method) AS missing_payment_method,
    COUNT(sales_channel) AS missing_sales_channel
FROM raw.sales;

-- ============================================================
-- Sales Transaction by sales representative
-- ============================================================
SELECT
    sales_rep,
    COUNT(*) AS sales_count
FROM raw.sales
GROUP BY sales_rep
ORDER BY sales_count DESC;

-- ============================================================
-- Sales Transaction by Region
-- ============================================================
SELECT
    region,
    COUNT(*) AS region_count
FROM raw.sales
GROUP BY region
ORDER BY region_count DESC;

-- ============================================================
-- Sales Transaction by category
-- ============================================================
SELECT
	product_category,
	COUNT(*) AS ProductCategory_count
FROM raw.sales
GROUP BY product_category
ORDER BY ProductCategory_count;

-- ============================================================
-- Sales Transaction by customer type
-- ============================================================

SELECT
    customer_type,
    COUNT(*) AS sales_count
FROM raw.sales
GROUP BY customer_type
ORDER BY sales_count DESC;

-- ============================================================
-- CHECK FOR EXACT DUPLICATE RECORDS
-- ============================================================
-- Purpose:
-- Identify records where every column contains the exact same value.
--
-- Duplicate records may indicate accidentally duplicated transactions in the source data.
-- ============================================================

SELECT
    product_id,
    sale_date,
    sales_rep,
    region,
    sales_amount,
    quantity_sold,
    product_category,
    unit_cost,
    unit_price,
    customer_type,
    discount,
    payment_method,
    sales_channel,
    region_and_sales_rep,
    COUNT(*) AS duplicate_count
FROM raw.sales
GROUP BY
    product_id,
    sale_date,
    sales_rep,
    region,
    sales_amount,
    quantity_sold,
    product_category,
    unit_cost,
    unit_price,
    customer_type,
    discount,
    payment_method,
    sales_channel,
    region_and_sales_rep
HAVING COUNT(*) > 1;

-- ============================================================
-- VALIDATE SALES DATE
-- ============================================================
-- Purpose:
-- Check the earliest and latest transaction dates
--
-- As the dataset is expected to contain 2023 transaction, any records outside 2023 will be investigate during staging
-- ============================================================
SELECT
    MIN(CAST(sale_date AS DATE)) AS earliest_sale,
    MAX(CAST(sale_date AS DATE)) AS latest_sale
FROM raw.sales;

-- ============================================================
-- IDENTIFY TRANSACTIONS OUTSIDE 2023
-- ============================================================
-- Purpose:
-- Identify records before 2023 or on/after 2024-01-01.
--
-- These records are NOT deleted from the raw layer because the raw layer should preserve the original source data for traceability.
-- ============================================================
SELECT *
FROM raw.sales
WHERE
    CAST(sale_date AS DATE) < DATE '2023-01-01'
    OR CAST(sale_date AS DATE) >= DATE '2024-01-01';

-- ============================================================
-- VALIDATION
-- ============================================================
-- Purpose:
-- Check whether the values are logic or not.
-- ============================================================

-- ============================================================
-- VALIDATE QUANTITY SOLD
-- ============================================================

SELECT
    MIN(CAST(quantity_sold AS INTEGER)) AS min_quantity,
    MAX(CAST(quantity_sold AS INTEGER)) AS max_quantity
FROM raw.sales;

-- ============================================================
-- VALIDATE SALES AMOUNT
-- ============================================================

SELECT
    MIN(CAST(sales_amount AS NUMERIC)) AS min_sales,
    MAX(CAST(sales_amount AS NUMERIC)) AS max_sales
FROM raw.sales;

-- ============================================================
-- VALIDATE UNIT COST
-- ============================================================

SELECT
    MIN(CAST(unit_cost AS NUMERIC)) AS min_cost,
    MAX(CAST(unit_cost AS NUMERIC)) AS max_cost
FROM raw.sales;


-- ============================================================
-- VALIDATE UNIT PRICE
-- ============================================================

SELECT
    MIN(CAST(unit_price AS NUMERIC)) AS min_price,
    MAX(CAST(unit_price AS NUMERIC)) AS max_price
FROM raw.sales;

-- ============================================================
-- CHECK UNIT PRICE VS UNIT COST
-- ============================================================
-- Purpose:
-- Identify records where unit price is less than or equal to unit cost.
--
-- A zero result indicates all records have a unit price greater than the unit cost.
-- ============================================================

SELECT
    COUNT(*) AS invalid_unitprice
FROM raw.sales
WHERE
    CAST(unit_price AS NUMERIC)
    <=
    CAST(unit_cost AS NUMERIC);

-- ============================================================
-- VALIDATE DISCOUNT
-- ============================================================
-- Purpose:
-- Check the minimum and maximum discount values.
-- ============================================================

SELECT
    MIN(CAST(discount AS NUMERIC)) AS minimum_discount,
    MAX(CAST(discount AS NUMERIC)) AS maximum_discount
FROM raw.sales;