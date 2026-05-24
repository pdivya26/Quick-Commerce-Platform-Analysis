-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 04_platform_analysis.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE : Compare performance across platforms
-- BUSINESS QUESTION: Which platform is best?
-- ============================================

-- 1. Order volume per platform
SELECT 
	company, 
	COUNT(*) AS total_orders, 
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as market_share_prct
FROM quick_commerce_clean 
GROUP BY company 
ORDER BY total_orders DESC;

-- FINDING: Flipkart Minutes recorded the highest market share - 12.56%, 
-- though all platforms showed nearly equal order distribution, 
-- indicating a highly competitive quick-commerce market.

-- 2. Average delivery time per platform
SELECT 
	company, 
	ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time,
	MIN(delivery_time_min) AS min_delivery_time,
	MAX(delivery_time_min) AS max_delivery_time
FROM quick_commerce_clean 
GROUP BY company 
ORDER BY avg_delivery_time;

-- FINDING: Zepto achieved the fastest average delivery time (9.58 min), 
-- while JioMart recorded the slowest deliveries (22.97 min) among all platforms.

-- 3. Average customer rating per platform
SELECT 
	company,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
	MIN(customer_rating) AS min_customer_rating,
	MAX(customer_rating) AS max_customer_rating
FROM quick_commerce_clean 
WHERE customer_rating IS NOT NULL
GROUP BY company 
ORDER BY avg_customer_rating DESC;

-- FINDING: Blinkit received the highest average customer ratings, 
-- while Dunzo recorded the lowest customer satisfaction among all platforms.

-- 4. Discount usage per platform
SELECT
	company,
	COUNT(*) AS total_orders,
	SUM(discount_applied) AS discounted_order,
	ROUND(SUM(discount_applied) * 100.0 / COUNT(*), 2) AS discount_rate_percent
FROM quick_commerce_clean 
GROUP BY company 
ORDER BY discount_rate_percent DESC;

-- FINDING: Most platforms maintained a similar discount rate (~39–40%), 
-- indicating consistent promotional strategies across the quick-commerce market.

-- 5. Platform performance score (combining multiple metrics)
-- Lower delivery time is better, higher rating is better
SELECT 
	company,
	ROUND(AVG(order_value), 2) AS avg_order_value,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating,
	ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time_min,
	ROUND(
		(AVG(customer_rating) * 20) - (AVG(delivery_time_min) * 0.5) -- rating out of 100 for interpretability and penalize slow delivery
		, 2) AS performance_score
FROM quick_commerce_clean 
WHERE customer_rating IS NOT NULL
GROUP BY company 
ORDER BY performance_score DESC;

-- FINDING: Blinkit achieved the highest overall performance score due to strong customer ratings and relatively efficient delivery times,
-- while JioMart and Dunzo lagged behind because of lower ratings and slower operations.

-- 6. Platform performance by city
SELECT
	city, company,
	COUNT(*) AS total_orders,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM quick_commerce_clean 
WHERE city IS NOT NULL AND customer_rating IS NOT NULL
GROUP BY city, company 
ORDER BY city, avg_rating DESC;

-- FINDING: Blinkit leads customer satisfaction in 9 out of 10 cities.
-- Hyderabad is a clear outlier — even Blinkit, which tops every other city, scores only 2.99 there.
-- All platforms score lower in Hyderabad than their national averages, suggesting city-level factors beyond platform control. 
-- Dunzo consistently ranks last in every single city.
-- Note: Near-equal order volumes (~8,300-8,600 per platform per city) indicate synthetic data generation with balanced distribution.

-- ============================================
-- KEY INSIGHTS SUMMARY: Platform Analysis
-- ============================================

-- 1. MARKET SHARE: All platforms compete almost equally with ~12% market
--    share each, indicating no single dominant player in quick commerce.
--    Flipkart Minutes leads marginally at 12.56%.

-- 2. DELIVERY SPEED: Zepto is fastest (9.58 min avg) but ranks below
--    Blinkit in ratings. JioMart is slowest at 22.97 min avg.
--    Speed alone does not determine customer satisfaction.

-- 3. CUSTOMER SATISFACTION: Blinkit leads ratings nationally despite
--    not being the fastest. Dunzo consistently ranks last in every
--    single city across India.

-- 4. DISCOUNTS: All platforms offer similar discount rates (39-40%),
--    suggesting discounting is now table stakes in quick commerce,
--    not a differentiator.

-- 5. OVERALL PERFORMANCE: Blinkit scores highest on combined
--    performance index (63.56). JioMart and Dunzo rank last —
--    JioMart due to slowest delivery (22.97 min) and low ratings (2.82),
--    Dunzo due to lowest customer satisfaction across all platforms (2.45)
--    despite relatively fast delivery (14.13 min).

-- 6. CITY PATTERNS: Blinkit leads in 9 out of 10 cities. Hyderabad
--    is a market-wide outlier with suppressed ratings across all
--    platforms, warranting deeper investigation.

-- BOTTOM LINE: Blinkit is the strongest overall performer (score 63.56).
-- Zepto wins on speed (9.58 min) but trails Blinkit on satisfaction.
-- Dunzo has the worst ratings (2.45) despite decent delivery speed,
-- suggesting serious non-delivery related service issues.
-- JioMart is slowest at 22.97 min and also rated poorly (2.82).
-- Hyderabad is an anomaly worth investigating separately.
-- ============================================