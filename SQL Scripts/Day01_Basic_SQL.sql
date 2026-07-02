USE online_food_del;
-- 1: Top 5 Customers Based on Total Orders
SELECT
    c.customer_name,
    c.customer_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
ORDER BY total_orders DESC
LIMIT 5;

-- 2: Total Amount Spent by Each Customer
USE online_food_del;
SELECT
    r.rest_name,
    r.restaurant_id,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM restaurant r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
GROUP BY r.rest_name, r.restaurant_id
ORDER BY unique_customers DESC
LIMIT 1;

-- Top 3 Most Frequently Ordered Items
SELECT
    m.item_name,
    COUNT(od.item_id) AS total_orders
FROM menu_item m
JOIN order_details od
ON m.item_id = od.item_id
GROUP BY m.item_name
ORDER BY total_orders DESC
LIMIT 3;

-- Customers Who Placed More Than 3 Orders
SELECT
    c.customer_name,
    c.customer_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
HAVING COUNT(o.order_id) > 3;

-- Average Quantity Per Order Per Restaurant
SELECT
    r.rest_name,
    AVG(od.quantity) AS avg_quantity
FROM restaurant r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY r.rest_name;

-- Customers and Restaurants Ordered From More Than Once
SELECT
    c.customer_name,
    r.rest_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN restaurant r
ON o.restaurant_id = r.restaurant_id
GROUP BY c.customer_name, r.rest_name
HAVING COUNT(o.order_id) > 1;

-- Top 3 Revenue Generating Restaurants
SELECT
    r.rest_name,
    SUM(m.price * od.quantity) AS revenue
FROM restaurant r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN menu_item m
ON od.item_id = m.item_id
GROUP BY r.rest_name
ORDER BY revenue DESC
LIMIT 3;
