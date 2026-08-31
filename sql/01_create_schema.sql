-- ============================================================
-- 01 CREATE DATABASE SCHEMAS
-- ============================================================
-- Purpose:
-- Separate the data pipeline into raw, staging and curated layers.
--
-- raw      = source data as received
-- staging  = transformed and validated data
-- curated  = cleaned analytical data and dimensional model
-- ============================================================

CREATE SCHEMA IF NOT EXISTS raw;

CREATE SCHEMA IF NOT EXISTS staging;

CREATE SCHEMA IF NOT EXISTS curated;