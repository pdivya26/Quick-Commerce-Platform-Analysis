-- ============================================
-- PROJECT : Quick Commerce Platform Analysis
-- FILE    : 05_delivery_analysis.sql
-- AUTHOR  : Divya Poojari
-- PURPOSE: Understand delivery performance
-- BUSINESS QUESTION: What affects delivery speed and satisfaction?
-- ============================================

-- 1. Delivery time distribution buckets
SELECT
	CASE
		WHEN delivery_time_min <= 10 THEN 'Under 10 mins'
		WHEN delivery_time_min <= 20 THEN '10 - 20 mins'
		WHEN delivery_time_min <= 30 THEN '20 - 30 mins'
		WHEN delivery_time_min <= 45 THEN '30 - 45 mins'
		ELSE 'Above 45 mins'
	END AS delivery_bucket,
	COUNT(*) AS total_orders,
	ROUND(AVG(customer_rating), 2) AS avg_ratings
FROM quick_commerce_clean 
GROUP BY delivery_bucket
ORDER BY MIN(delivery_time_min);

-- FINDING: Faster deliveries received higher customer ratings, while customer satisfaction gradually declined as delivery times increased.
-- Most orders were delivered within 10–20 minutes, highlighting customer preference and operational concentration around rapid delivery windows.

-- 2. At what delivery time do ratings start dropping? (pin-pointing rating drop)
SELECT 
	FLOOR(delivery_time_min / 5) * 5 AS delivery_time_window,
	COUNT(*) AS total_orders,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
GROUP BY delivery_time_window 
ORDER BY delivery_time_window;

-- FINDING: Ratings remain stable between 5-15 min windows (3.12 to 3.06),
-- then begin declining after the 20 min mark, dropping from 3.06 to 2.97.
-- Beyond 35 minutes ratings fall to 2.82. 
-- The 20-minute mark is the critical SLA threshold beyond which satisfaction measurably deteriorates.

-- 3. City wise average delivery time
SELECT 
	city, 
	COUNT(*) AS total_orders,
	ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
GROUP BY city
ORDER BY avg_delivery_time;

-- FINDING: Delhi recorded the fastest average delivery times, while Haridwar experienced the slowest deliveries among all cities.
-- Bengaluru and Mumbai maintained comparatively higher customer ratings despite moderate delivery times.

-- 4. Does distance affect delivery time? (correlation check)
SELECT
	CASE
		WHEN distance_km <= 2 THEN '0 - 2 km'
		WHEN distance_km <= 5 THEN '2 - 5 km'
		WHEN distance_km <= 8 THEN '5 - 8 km'
		WHEN distance_km <= 12 THEN '8 - 12 km'
		ELSE 'Above 12 km'
	END AS distance_bucket,
	COUNT(*) AS total_orders,
	ROUND(AVG(delivery_time_min), 2) AS avg_delivery_time,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
GROUP BY distance_bucket
ORDER BY MIN(distance_km);

-- FINDING: Average delivery time increased consistently with distance, while customer ratings remained relatively stable across all delivery ranges.

-- 5. Delivery partner rating vs customer rating relationship
SELECT 
	delivery_partner_rating,
	COUNT(*) AS total_orders,
	ROUND(AVG(customer_rating), 2) AS avg_customer_rating
FROM quick_commerce_clean
GROUP BY delivery_partner_rating
ORDER BY delivery_partner_rating DESC;

-- FINDING: Customer ratings remain nearly constant across all delivery partner rating levels, indicating weak correlation between partner ratings and customer satisfaction.

-- 6. Which platform delivers fastest in each city?
WITH platform_city_speed AS (
	SELECT 
		city,
		company,
		ROUND(AVG(delivery_time_min), 2) as avg_delivery_time,
		RANK() OVER(PARTITION BY city ORDER BY ROUND(AVG(delivery_time_min), 2)) AS speed_rank
	FROM quick_commerce_clean
	WHERE city IS NOT NULL
    GROUP BY city, company
)
SELECT * FROM platform_city_speed
WHERE speed_rank = 1
ORDER BY avg_delivery_time;

-- FINDING: Zepto is the fastest delivery platform in all 12 cities.
-- Most cities see Zepto averaging 8-10 min delivery.
-- Delhi shows an anomalous 5 min average likely due to very few data points pulling the average down — not representative.
-- Haridwar is the slowest city even for Zepto at 20.14 min.

-- ============================================
-- KEY INSIGHTS SUMMARY: Delivery Analysis
-- ============================================

-- 1. DELIVERY BUCKETS: Most orders fall in the 10-20 min window, confirming operation within promised speed.
--    Ratings decline as delivery time increases beyond 20 min.

-- 2. RATING THRESHOLD: Customer satisfaction drops noticeably (from 3.06 to 2.97) after the 20 min mark and drops to 2.82 beyond 35 min. 
-- 	  The 20-minute mark is the critical SLA threshold platforms must target.

-- 3. CITY PERFORMANCE: Delhi delivers fastest, Haridwar slowest.
--    Bengaluru and Mumbai achieve better satisfaction despite not being the fastest, consistent with platform analysis findings.

-- 4. DISTANCE IMPACT: Delivery time increases with distance as expected, 
--    but customer ratings remain relatively stable across distance buckets
--    indicating customers accept longer times for farther locations.

-- 5. PARTNER RATING: Weak correlation between delivery partner ratings and customer satisfaction,
--    suggesting customers rate the overall experience more than the delivery person alone.

-- 6. FASTEST PLATFORM BY CITY: Zepto dominates delivery speed across most cities. 
--    However as established in platform analysis, speed leadership does not translate to satisfaction leadership.

-- BOTTOM LINE: Delivery time matters but only up to a point.
-- Beyond 20-25 minutes satisfaction drops meaningfully.
-- Partner performance alone does not drive customer ratings.
-- City infrastructure and platform operations vary significantly.
-- ============================================