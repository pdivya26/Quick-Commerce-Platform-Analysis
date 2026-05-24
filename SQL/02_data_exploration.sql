-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 02_data_exploration.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Understanding the dataset structure
-- BUSINESS QUESTION: What does the raw dataset look like ? 
--                    How many records exist, what are the columns ?,
--                    What is the data quality, and are there nulls, duplicates, or inconsistencies to address ?
-- ============================================

-- 1. Total row count
SELECT COUNT(*) FROM quick_commerce;

-- FINDING: 1,000,000 rows imported successfully

-- 2. Check nulls in every column
SELECT 
	COUNT(*) - COUNT(order_id) AS null_order_id,
	COUNT(*) - COUNT(company) AS null_company,
	COUNT(*) - COUNT(city) AS null_city,
	COUNT(*) - COUNT(customer_age) AS null_customer_age,
	COUNT(*) - COUNT(order_value) AS null_order_value,
	COUNT(*) - COUNT(delivery_time_min) AS null_delivery_time_min,
	COUNT(*) - COUNT(distance_km) AS null_distance_km,
	COUNT(*) - COUNT(items_count) AS null_items_count,
	COUNT(*) - COUNT(product_category) AS null_product_category,
	COUNT(*) - COUNT(payment_method) AS null_payment_method,
	COUNT(*) - COUNT(customer_rating) AS null_customer_rating,
	COUNT(*) - COUNT(discount_applied) AS null_discount_applied,
	COUNT(*) - COUNT(delivery_partner_rating) AS null_delivery_partner_rating
FROM quick_commerce;

-- FINDING: Nulls found in:
-- city: 52,000 | items_count: 35,000 | customer_rating: 47,000 | delivery_partner_rating: 104,137
-- All other columns have zero nulls

-- 3. Check distinct companies (platforms)
SELECT DISTINCT company FROM quick_commerce ORDER BY company;

-- FINDING: 8 platforms — Amazon Now, BigBasket, Blinkit, Dunzo, Flipkart Minutes, JioMart, Swiggy Instamart, Zepto

-- 4. Check distinct cities
SELECT DISTINCT city FROM quick_commerce ORDER BY city;

-- FINDING: 12 cities — Amritsar, Bengaluru, Chennai, Delhi, Gurgaon, Haridwar, Hyderabad, Jaipur, Kolkata, Mumbai, Noida, Pune
-- Note: 52,000 rows have NULL city values

-- 5. Check distinct product categories
SELECT DISTINCT product_category FROM quick_commerce ORDER BY product_category;

-- FINDING: 7 categories — Beverages, Dairy, Fruits & Vegetables, Groceries, Household, Personal Care, Snacks

-- 6. Check distinct payment methods
SELECT DISTINCT payment_method FROM quick_commerce ORDER BY payment_method;

-- FINDING: 5 payment methods — Cash on Delivery, Credit Card, Debit Card, UPI, Wallet

-- 7. Check rating ranges
SELECT 
	MIN(customer_rating) AS min_customer_rating,
	MAX(customer_rating) AS max_customer_rating,
	MIN(delivery_partner_rating) AS min_delivery_partner_rating,
	MAX(delivery_partner_rating) AS max_delivery_partner_rating
FROM quick_commerce;

-- FINDING: Customer rating 1-5 | Delivery partner rating 2.5-5
-- Note: Partner rating minimum is 2.5, not 1 
-- No extremely poor partner ratings exist in this dataset

-- 8. Check numeric column ranges
SELECT 
	MIN(customer_age) AS min_customer_age,
	MAX(customer_age) AS max_customer_age,
	ROUND(AVG(customer_age)) AS avg_customer_age,
	
	MIN(order_value) AS min_order_value,
	MAX(order_value) AS max_order_value,
	ROUND(AVG(order_value), 2) AS avg_order_value,

	MIN(delivery_time_min) AS min_delivery_time_min,
	MAX(delivery_time_min) AS max_delivery_time_min,
	ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time_min,
	
	MIN(distance_km) AS min_distance_km,
	MAX(distance_km) AS max_distance_km,
	ROUND(AVG(distance_km), 2) AS avg_distance_km,

	MIN(items_count) AS min_items_count,
	MAX(items_count) AS max_items_count,
	ROUND(AVG(items_count)) AS avg_items_count
FROM quick_commerce;

-- FINDING: Age: 18-59 (avg 38)
-- Order value: INR 50-13,877 (avg 571.64)
-- Delivery time: 5-40 min (avg 16.45 min)
-- Distance: 0.5-15 km (avg 7.75 km)
-- Items per order: 1-19 (avg 10)

-- 9. Check discount_applied values (0 or 1)
SELECT DISTINCT discount_applied FROM quick_commerce ORDER BY discount_applied;

-- FINDING: Only 0 and 1 present — binary flag confirmed, no corrupt values

-- 10. Order count per platform
SELECT company, COUNT(*) AS total_orders FROM quick_commerce GROUP BY company ORDER BY total_orders DESC;

-- FINDING: Orders nearly equal across all platforms (124,471 - 125,542)
-- Flipkart Minutes leads marginally with 125,542 orders
-- Confirms highly competitive, balanced market

-- 11. Order count per city
SELECT city, COUNT(*) AS total_orders FROM quick_commerce GROUP BY city ORDER BY total_orders DESC;

-- FINDING: Orders nearly equal across all cities (78,580 - 79,481)
-- Hyderabad leads with 79,481, Pune lowest with 78,580
-- Plus 52,000 rows with NULL city

-- ============================================
-- KEY INSIGHTS SUMMARY: Data Exploration
-- ============================================

-- Dataset: 1,000,000 rows, 13 columns
-- Platforms: 8 | Cities: 12 | Categories: 7 | Payment Methods: 5
-- Nulls: city (52,000), items_count (35,000), customer_rating (47,000), delivery_partner_rating (104,137)
-- Data ranges all appear realistic except partner rating minimum of 2.5 — no poor partner ratings exist, suggesting synthetic data
-- Order distribution perfectly balanced across platforms and cities confirming synthetic dataset with no natural market skew
-- These findings directly informed the cleaning strategy
-- ============================================