
-- ANALYSIS --

SELECT * FROM users
SELECT * FROM reviews
SELECT * FROM orders
SELECT * FROM products

-- DATA CLEANING.

SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id,
    SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END) AS created_at_null,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_null,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS email_null,
    SUM(CASE WHEN address IS NULL THEN 1 ELSE 0 END) AS address_null,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_null,
	SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS state_null,
    SUM(CASE WHEN zip IS NULL THEN 1 ELSE 0 END) AS zip_null,
	SUM(CASE WHEN birth_date IS NULL THEN 1 ELSE 0 END) AS birth_date_null,
	SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS latitude_null,
	SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS longitude_null,
	SUM(CASE WHEN password IS NULL THEN 1 ELSE 0 END) AS password_null,
	SUM(CASE WHEN source IS NULL THEN 1 ELSE 0 END) AS source_null
FROM users;



SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id,
    SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END) AS created_at_null,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS user_id_null,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_null,
    SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS discount_null,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_null,
	SUM(CASE WHEN subtotal IS NULL THEN 1 ELSE 0 END) AS subtotal_null,
    SUM(CASE WHEN tax IS NULL THEN 1 ELSE 0 END) AS tax_null,
	SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS total
FROM orders;




SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id,
    SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END) AS created_at_null,
    SUM(CASE WHEN reviewer IS NULL THEN 1 ELSE 0 END) AS reviewer_null,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_null,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_null,
    SUM(CASE WHEN body IS NULL THEN 1 ELSE 0 END) AS body_null
FROM reviews;

SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id,
    SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END) AS created_at_null,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_null,
    SUM(CASE WHEN ean IS NULL THEN 1 ELSE 0 END) AS ean_null,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_null,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_null,
	SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_null,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null,
	SUM(CASE WHEN vendor IS NULL THEN 1 ELSE 0 END) AS vendor_null
FROM products;

-- CHECK FOR INCONSISTENT DATA
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN subtotal IS NULL THEN 1 ELSE 0 END) AS missing_subtotal,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity
FROM orders;

-- 
SELECT *
FROM orders
WHERE quantity <= 0;

-- CHECKING FOR DUPLICATES.
SELECT id, COUNT(*) AS duplicate
FROM orders GROUP BY id
HAVING COUNT(*) > 1
 

 SELECT id, COUNT(*) AS duplicate
FROM reviews GROUP BY id
HAVING COUNT(*) > 1

SELECT id, COUNT(*) AS duplicate
FROM users GROUP BY id
HAVING COUNT(*) > 1

SELECT id, COUNT(*) AS duplicate
FROM products GROUP BY id
HAVING COUNT(*) > 1


SELECT 
SUM(subtotal) AS revenue
FROM orders o
JOIN 
 
-- 
 SELECT TOP 20
    o.quantity,
    p.price,
    o.subtotal,
    (o.quantity * p.price) AS calculated_subtotal
FROM orders o
JOIN products p 
    ON o.product_id = p.id;


-- SALES --
-- Product Quality vs Sales
SELECT 
    p.id AS product_id,
    p.category,
    AVG(r.rating) AS avg_rating,
    SUM(o.subtotal) AS revenue,
    COUNT(r.id) AS review_count
FROM products p
LEFT JOIN orders o 
    ON p.id = o.product_id
    AND o.quantity > 0
LEFT JOIN reviews r 
    ON p.id = r.product_id
GROUP BY p.id, p.category
ORDER BY revenue DESC;



 -- REVENUE --
SELECT SUM(subtotal) as Revenue
FROM orders
WHERE quantity > 0;

-- Revenue by Category
SELECT
p. category,
SUM (o. subtotal) AS Cat_Revenue
FROM orders o
JOIN products p ON o.product_id = p.id
WHERE o.quantity > 0 
GROUP BY p.category
ORDER BY Cat_Revenue DESC;


WITH ranked_products AS (
    SELECT 
        p.category,
        o.product_id,
        SUM(o.subtotal) AS revenue,
        SUM(o.quantity) AS units_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(o.subtotal) DESC) AS rnk
    FROM orders o
    JOIN products p ON o.product_id = p.id
	WHERE o.quantity > 0
    GROUP BY p.category, o.product_id
)
SELECT *
FROM ranked_products
WHERE rnk = 1;

--- Category Performance
SELECT 
    p.category,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(o.quantity) AS units_sold,
    SUM(o.subtotal) AS revenue,
    AVG(o.subtotal) AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.id
WHERE o.quantity > 0
GROUP BY p.category
ORDER BY revenue DESC;

-- Revenue by Year
SELECT 
    YEAR(o.created_at) AS year,
    SUM(o.subtotal) AS revenue
FROM orders o
WHERE o.quantity > 0
GROUP BY YEAR(o.created_at)
ORDER BY revenue DESC;

 -- Monthly trend
 SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    SUM(subtotal) AS revenue
FROM orders
WHERE quantity > 0
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;


-- CUSTOMER LIFETIME VALUE --
-- Customer Behaviour
SELECT 
    user_id,
    COUNT(id) AS order_count
FROM orders
WHERE quantity > 0
GROUP BY user_id;

-- Repeat Purchase Behavior 
SELECT 
    user_id,
    COUNT(DISTINCT id) AS total_orders,
    CASE 
        WHEN COUNT(id) = 1 THEN 'One-time'
        WHEN COUNT(id) BETWEEN 2 AND 5 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_type
FROM orders
WHERE quantity > 0
GROUP BY user_id;

-- Customer lifetime value
SELECT 
    user_id,
    SUM(subtotal) AS lifetime_value,
    COUNT(id) AS total_orders
FROM orders
WHERE quantity > 0
GROUP BY user_id
ORDER BY lifetime_value DESC;

-- MAX, MIN, AVG

WITH customer_ltv AS (
    SELECT
        user_id,
        SUM(subtotal) AS lifetime_value
    FROM orders
	WHERE quantity > 0
    GROUP BY user_id
)
SELECT
    MAX(lifetime_value) AS max_ltv,
    MIN(lifetime_value) AS min_ltv,
    AVG(lifetime_value) AS avg_ltv
FROM customer_ltv;

 -- CLTV Segmented
 WITH customer_ltv AS (
    SELECT 
        user_id,
        SUM(subtotal) AS lifetime_value
    FROM orders
	WHERE quantity > 0
    GROUP BY user_id
)
SELECT 
    user_id,
    lifetime_value,
    CASE 
        WHEN lifetime_value >= 2000 THEN 'VIP'
        WHEN lifetime_value >= 800 THEN 'Regular'
        WHEN lifetime_value >= 200 THEN 'Occasional'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_ltv; 

-- Count how many customers fall into these segments

WITH customer_ltv AS (
    SELECT 
        user_id,
        SUM(subtotal) AS lifetime_value
    FROM orders
	WHERE quantity > 0
    GROUP BY user_id
),
segmented_customers AS (
    SELECT 
        user_id,
        lifetime_value,
        CASE 
            WHEN lifetime_value >= 2000 THEN 'VIP'
            WHEN lifetime_value >= 800 THEN 'Regular'
            WHEN lifetime_value >= 100 THEN 'Occasional'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_ltv
)
SELECT 
    customer_segment,
    COUNT(user_id) AS customer_count
FROM segmented_customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Best Selling Products
SELECT 
    product_id,
    SUM(quantity) AS units_sold,
    SUM(subtotal) AS revenue
FROM orders
WHERE quantity > 0
GROUP BY product_id
ORDER BY revenue DESC;

-- Reviews vs Revenue

SELECT 
	r.rating ,
	SUM(o.  subtotal) AS revenue
FROM orders o
JOIN reviews r ON o. id = r.id
WHERE quantity > 0
GROUP BY r. rating
ORDER BY revenue ASC

SELECT 
    p.category,
    AVG(r.rating) AS avg_rating,
    SUM(o.subtotal) AS revenue
FROM products p
JOIN orders o ON p.id = o.product_id
JOIN reviews r ON p.id = r.product_id
GROUP BY p.category;


-- Pricing and discount Impact 
SELECT 
    discount,
    COUNT(*) AS orders,
    SUM(subtotal) AS revenue
FROM orders
WHERE quantity > 0
GROUP BY discount
ORDER BY discount;

-- Average Order Value
SELECT 
    SUM(subtotal) / COUNT(DISTINCT id) AS avg_order_value
FROM orders
WHERE quantity > 0; 

-- VIEWS --

CREATE VIEW vw_sales AS
SELECT
    o.id AS order_id,
    o.created_at,
    o.user_id,
    o.product_id,
    p.category,
    p.title,
    p.vendor,
    o.quantity,
    o.subtotal,
    o.discount
FROM orders o
JOIN products p 
    ON o.product_id = p.id
WHERE o.quantity > 0;


-- CLTV VIEWS
CREATE VIEW vw_customer_ltv AS
SELECT
    user_id,
    SUM(subtotal) AS lifetime_value,
    COUNT(id) AS total_orders
FROM orders
WHERE quantity > 0
GROUP BY user_id;

-- PRODUCTS VIEW
CREATE VIEW vw_product_performance AS
SELECT
    p.id AS product_id,
    p.title,
    p.category,
    SUM(o.quantity) AS units_sold,
    SUM(o.subtotal) AS revenue
FROM orders o
JOIN products p 
    ON o.product_id = p.id
WHERE o.quantity > 0
GROUP BY p.id, p.title, p.category;

-- Review and revenue 
CREATE VIEW vw_review_analysis AS
SELECT
    p.id AS product_id,
    p.title,
    p.category,
    AVG(r.rating) AS avg_rating,
    SUM(o.subtotal) AS revenue
FROM products p
LEFT JOIN reviews r 
    ON p.id = r.product_id
LEFT JOIN orders o 
    ON p.id = o.product_id
    AND o.quantity > 0
GROUP BY p.id, p.title, p.category;




SELECT * FROM reviews WHERE rating IS NULL

-- Monthly revenue 
CREATE VIEW vw_monthly_revenue AS
SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    SUM(subtotal) AS revenue
FROM orders
WHERE quantity > 0
GROUP BY YEAR(created_at), MONTH(created_at);


CREATE VIEW customer_segment AS
SELECT
    user_id,
    SUM(subtotal) AS lifetime_value,
    COUNT(id) AS total_orders,
    CASE
        WHEN SUM(subtotal) >= 2000 THEN 'VIP'
        WHEN SUM(subtotal) >= 800 THEN 'Regular'
        WHEN SUM(subtotal) >= 200 THEN 'Occasional'
        ELSE 'Low Value'
    END AS customer_segment
FROM orders
WHERE quantity > 0
GROUP BY user_id;

