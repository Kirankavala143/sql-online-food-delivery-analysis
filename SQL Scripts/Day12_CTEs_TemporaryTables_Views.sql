use online_food_del;

-- 1. Restaurant Size Category
SELECT r.restaurant_id,r.rest_name,
    COUNT(m.item_id) AS total_items,
    CASE
        WHEN COUNT(m.item_id) < 5 THEN 'Small'
        WHEN COUNT(m.item_id) BETWEEN 5 AND 10 THEN 'Medium'
        ELSE 'Large'
    END AS restaurant_size
FROM restaurant r
JOIN menu_item m
ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id,

r.rest_name;

-- 2. Orders per Customer with Rank (Using CTE)
WITH customer_orders AS
(
SELECT customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
)
SELECT customer_id,total_orders,
    RANK() OVER
    (
        ORDER BY total_orders DESC
    ) AS customer_rank
FROM customer_orders;

-- 3. Store Top 3 Restaurants by Revenue (Temporary Table)
DROP TEMPORARY TABLE IF EXISTS top3_restaurants;
CREATE TEMPORARY TABLE top3_restaurants AS
SELECT r.restaurant_id,r.rest_name,
    SUM(m.price * od.quantity) AS total_revenue
FROM restaurant r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN menu_item m
ON od.item_id = m.item_id
GROUP BY r.restaurant_id,r.rest_name
ORDER BY total_revenue DESC
LIMIT 3;
SELECT * FROM top3_restaurants;

-- 4. Store Orders from Last 7 Days (Temporary Table)
DROP TEMPORARY TABLE IF EXISTS last7days_orders;
CREATE TEMPORARY TABLE last7days_orders AS
SELECT *
FROM orders
WHERE order_date >= (
    SELECT DATE_SUB(MAX(order_date), INTERVAL 7 DAY)
    FROM orders
);
SELECT * FROM last7days_orders;

-- 5. Create View for Customer Spend
CREATE VIEW customer_spend AS
SELECT c.customer_id,c.customer_name,
    SUM(m.price * od.quantity) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN menu_item m ON od.item_id = m.item_id
GROUP BY c.customer_id,c.customer_name;
SELECT * FROM customer_spend;
