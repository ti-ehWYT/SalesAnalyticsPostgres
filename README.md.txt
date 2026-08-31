Dataset Source:
Kaggle – Sales Dataset
https://www.kaggle.com/datasets/vinothkannaece/sales-dataset

This is a project that demonstrates an end-to-end data workflow using PostgresSQL, SQL and PowerBI.
During this project, it transforms raw sales data into a clean, structure and analysis-ready dataset. It processed through RAW -> Staging -> Curated stages, followed by the development of Star Schema for future analysis reportin.
The final dataset is used to analyse sales performance across different regions, product categories, sales representatives, customer types and sales channels.

Project Objectives:
- Load and preserve original sales data in PostgreSQL.
- Perform data profiling and data quality checks.
- Validate business rules such as sales amount, quantity, unit cost, unit price and discount.
- Transform raw data into suitable data types
- Create cleaned and validated analytical dataset.
- Design a Star Schema for analytical reporting
- Use SQL to generate business insight

Tools & Technologies
PostgreSQL
SQL
PowerBI
GitHub

Data Pipeline
Raw Layer - stores the source data as received from CSV file
Staging Layer - Transform and standardized raw data
Curated Layer - Contains clean and validated data used for analysis

Data Quality Check
Record counts: 1000
Missing Value: None
Duplicate Records: None
Date Validation: 3 records was excluded in curated layer as the data was expected to contain transaction from 2023 only.

Business Logic Validation

The following checks were performed:
Quantity sold should not be negative
Sales amount should not be negative
Unit cost should be valid
Unit price should be valid
Unit price should be greater than unit cost
Discount should fall within a reasonable range

Results:
Quantity range: 1–49
Sales amount range: RM100.12–RM9,989.04
Unit cost range: RM60.28–RM4,995.30
Unit price range: RM167.12–RM5,442.15
Invalid unit price records: 0
Discount range: 0–30%

SQL Analysis Questions:

What are the total sales for 2023?
Which product category generates the highest sales?
Which region performs best?
Which sales representative generates the most sales?
How do sales change by month?
How do new and returning customers contribute to sales?
Which sales channel generates the most sales?
Which payment method is most commonly associated with sales?
What is the estimated gross profit?
Which categories perform best in each region?