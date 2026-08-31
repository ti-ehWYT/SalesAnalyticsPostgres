-- ============================================================
-- 04 URATED LAYER
-- ============================================================
-- Purpose:
-- Create the cleaned analytical dataset from the staging layer.
--
-- curated = trusted data used for analytics and reporting.
--
-- Only transactions within the expected 2023 reporting period are included.
-- ============================================================


-- ============================================================
-- CREATE CLEANED SALES TABLE
-- ============================================================
-- Exclude records marked as INVALID_DATE during staging.
-- ============================================================

CREATE TABLE curated.sales AS
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
    sales_channel
FROM staging.sales_quality
WHERE data_quality_status = 'VALID';


-- ============================================================
-- CHECK CURATED DATA
-- ============================================================

SELECT *
FROM curated.sales
LIMIT 10;


-- ============================================================
-- CHECK TOTAL CURATED RECORDS
-- ============================================================

SELECT COUNT(*) AS curated_records
FROM curated.sales;


-- ============================================================
-- CHECK CURATED DATE RANGE
-- ============================================================
-- Confirm that only 2023 transactions remain.
-- ============================================================

SELECT
    MIN(sale_date) AS earliest_sale,
    MAX(sale_date) AS latest_sale
FROM curated.sales;


-- ============================================================
-- CHECK SALES BY REGION
-- ============================================================

SELECT
    region,
    COUNT(*) AS sales_count,
    SUM(sales_amount) AS total_sales
FROM curated.sales
GROUP BY region
ORDER BY total_sales DESC;