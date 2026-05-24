-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 01_create_table.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Creating the table and loading raw CSV data
-- ============================================

CREATE TABLE quick_commerce (
    order_id BIGINT,
    company VARCHAR(100),
    city VARCHAR(100),
    customer_age INT,
    order_value NUMERIC(12,4),
    delivery_time_min NUMERIC(10,4),
    distance_km NUMERIC(10,2),
    items_count NUMERIC(10,1),
    product_category VARCHAR(100),
    payment_method VARCHAR(50),
    customer_rating NUMERIC(3,1),
    discount_applied INT,
    delivery_partner_rating NUMERIC(3,1)
);

SELECT COUNT(*) FROM quick_commerce;

SELECT * FROM quick_commerce LIMIT 10;