-- ============================================================
-- 06 FACT SALES TABLE
-- ============================================================
-- Purpose:
-- Create the central fact table for the sales star schema.
--
-- The fact table stores measurable business events such as:
--   - sales amount
--   - quantity sold
--   - unit cost
--   - unit price
--   - discount
--
-- Foreign keys connect the fact table to the dimension tables.
-- ============================================================


-- ============================================================
-- CREATE FACT SALES TABLE
-- ============================================================

CREATE TABLE curated.fact_sales (
    sales_key SERIAL PRIMARY KEY,

    product_id INTEGER NOT NULL,

    date_key INTEGER NOT NULL,
    sales_rep_key INTEGER NOT NULL,
    region_key INTEGER NOT NULL,
    category_key INTEGER NOT NULL,

    sales_amount NUMERIC,
    quantity_sold INTEGER,
    unit_cost NUMERIC,
    unit_price NUMERIC,
    discount NUMERIC,

    CONSTRAINT fk_fact_date
        FOREIGN KEY (date_key)
        REFERENCES curated.dim_date(date_key),

    CONSTRAINT fk_fact_sales_rep
        FOREIGN KEY (sales_rep_key)
        REFERENCES curated.dim_sales_rep(sales_rep_key),

    CONSTRAINT fk_fact_region
        FOREIGN KEY (region_key)
        REFERENCES curated.dim_region(region_key),

    CONSTRAINT fk_fact_category
        FOREIGN KEY (category_key)
        REFERENCES curated.dim_category(category_key)
);


-- ============================================================
-- CHECK CURATED SALES TABLE STRUCTURE
-- ============================================================

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'curated'
  AND table_name = 'sales'
ORDER BY ordinal_position;


-- ============================================================
-- POPULATE FACT SALES TABLE
-- ============================================================
-- Join the cleaned sales data with each dimension table
-- to retrieve the corresponding keys.
-- ============================================================

INSERT INTO curated.fact_sales (
    product_id,
    date_key,
    sales_rep_key,
    region_key,
    category_key,
    sales_amount,
    quantity_sold,
    unit_cost,
    unit_price,
    discount
)
SELECT
    s.product_id,
    d.date_key,
    sr.sales_rep_key,
    r.region_key,
    c.category_key,
    s.sales_amount,
    s.quantity_sold,
    s.unit_cost,
    s.unit_price,
    s.discount
FROM curated.sales s

JOIN curated.dim_date d
    ON s.sale_date = d.full_date

JOIN curated.dim_sales_rep sr
    ON s.sales_rep = sr.sales_rep

JOIN curated.dim_region r
    ON s.region = r.region

JOIN curated.dim_category c
    ON s.product_category = c.category_name;


-- ============================================================
-- CHECK FACT TABLE RECORD COUNT
-- ============================================================

SELECT COUNT(*) AS fact_sales_records
FROM curated.fact_sales;


-- ============================================================
-- CHECK ANNUAL SALES
-- ============================================================

SELECT
    d.year,
    SUM(f.sales_amount) AS total_sales
FROM curated.fact_sales f
JOIN curated.dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;