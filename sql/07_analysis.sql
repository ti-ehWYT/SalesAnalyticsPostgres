-- ============================================================
-- 07 SQL BUSINESS ANALYSIS
-- ============================================================
-- Purpose:
-- Analyse the curated star schema and answer key business
-- questions using SQL.
--
-- These queries can also be used to validate the results
-- displayed in Power BI.
-- ============================================================


-- ============================================================
-- 2023 TOTAL SALES PERFORMANCE
-- ============================================================
-- Business Question:
-- What was the total sales performance in 2023?
-- ============================================================

SELECT
    d.year,
    SUM(f.sales_amount) AS total_sales
FROM curated.fact_sales f
JOIN curated.dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;


-- ============================================================
-- SALES PERFORMANCE BY PRODUCT CATEGORY
-- ============================================================
-- Business Question:
-- Which product category generated the highest sales?
-- ============================================================

SELECT
    c.category_name,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity_sold
FROM curated.fact_sales f
JOIN curated.dim_category c
    ON f.category_key = c.category_key
GROUP BY c.category_name
ORDER BY total_sales DESC;


-- ============================================================
-- SALES PERFORMANCE BY REGION
-- ============================================================
-- Business Question:
-- Which region generated the highest sales?
-- ============================================================

SELECT
    r.region,
    SUM(f.sales_amount) AS total_sales
FROM curated.fact_sales f
JOIN curated.dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region
ORDER BY total_sales DESC;


-- ============================================================
-- SALES PERFORMANCE BY SALES REPRESENTATIVE
-- ============================================================
-- Business Question:
-- Which sales representative generated the highest sales?
-- ============================================================

SELECT
    sr.sales_rep,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity_sold
FROM curated.fact_sales f
JOIN curated.dim_sales_rep sr
    ON f.sales_rep_key = sr.sales_rep_key
GROUP BY sr.sales_rep
ORDER BY total_sales DESC;


-- ============================================================
-- MONTHLY SALES PERFORMANCE
-- ============================================================
-- Business Question:
-- How did sales perform throughout the year?
-- ============================================================

SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales
FROM curated.fact_sales f
JOIN curated.dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;


-- ============================================================
-- SALES BY CUSTOMER TYPE
-- ============================================================
-- Business Question:
-- How much sales came from new versus returning customers?
-- ============================================================
-- Note:
-- customer_type is currently stored in curated.sales rather
-- than the fact table, so this analysis uses curated.sales.
-- ============================================================

SELECT
    customer_type,
    COUNT(*) AS transaction_count,
    SUM(sales_amount) AS total_sales
FROM curated.sales
GROUP BY customer_type
ORDER BY total_sales DESC;


-- ============================================================
-- AVERAGE TRANSACTION VALUE
-- ============================================================
-- Business Question:
-- What is the average sales amount per transaction?
-- ============================================================

SELECT
    AVG(sales_amount) AS average_transaction_value
FROM curated.fact_sales;


-- ============================================================
-- TOTAL QUANTITY SOLD
-- ============================================================
-- Business Question:
-- How many units were sold in total?
-- ============================================================

SELECT
    SUM(quantity_sold) AS total_quantity_sold
FROM curated.fact_sales;


-- ============================================================
-- ESTIMATED GROSS PROFIT
-- ============================================================
-- Business Question:
-- What is the estimated gross profit based on unit price,
-- unit cost and quantity sold?
--
-- Formula:
-- Gross Profit =
-- (Unit Price - Unit Cost) × Quantity Sold
-- ============================================================

SELECT
    SUM(
        (unit_price - unit_cost) * quantity_sold
    ) AS estimated_gross_profit
FROM curated.fact_sales;


-- ============================================================
-- SALES BY REGION AND CATEGORY
-- ============================================================
-- Business Question:
-- Which product categories perform best in each region?
-- ============================================================

SELECT
    r.region,
    c.category_name,
    SUM(f.sales_amount) AS total_sales
FROM curated.fact_sales f
JOIN curated.dim_region r
    ON f.region_key = r.region_key
JOIN curated.dim_category c
    ON f.category_key = c.category_key
GROUP BY
    r.region,
    c.category_name
ORDER BY
    r.region,
    total_sales DESC;