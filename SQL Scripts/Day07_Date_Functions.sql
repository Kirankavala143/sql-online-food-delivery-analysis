USE online_food_del;

-- 1. Top 3 Customers by Total Spending
DROP TEMPORARY TABLE IF EXISTS temp_restaurant_revenue;
CREATE TEMPORARY TABLE temp_total_spending AS

SELECT c.customer_id,c.customer_name,
    SUM(m.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY c.customer_id, c.customer_name;

SELECT *
FROM temp_total_spending
ORDER BY total_spent DESC
LIMIT 3;

-- 2. Top 3 Restaurants by Revenue
DROP TEMPORARY TABLE IF EXISTS temp_restaurant_revenue;
CREATE TEMPORARY TABLE temp_restaurant_revenue AS

SELECT
    r.restaurant_id,
    r.rest_name,
    SUM(m.price * od.quantity) AS total_revenue
FROM restaurant r
JOIN orders o
    ON o.restaurant_id = r.restaurant_id
JOIN order_details od
    ON od.order_id = o.order_id
JOIN menu_item m
    ON m.item_id = od.item_id
GROUP BY r.restaurant_id, r.rest_name;

SELECT *
FROM temp_restaurant_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- 3. Customers Who Ordered from Multiple Restaurants (At least 5 different restaurants)
DROP TEMPORARY TABLE IF EXISTS temp_restaurant_revenue;
CREATE TEMPORARY TABLE temp_customer_spend AS

SELECT
    o.customer_id,
    COUNT(DISTINCT o.restaurant_id) AS distinct_rest
FROM orders o
GROUP BY o.customer_id;

SELECT
    c.customer_id,
    c.customer_name,
    t.distinct_rest
FROM temp_customer_spend t
JOIN customers c
    ON c.customer_id = t.customer_id
WHERE t.distinct_rest >= 5
ORDER BY t.distinct_rest DESC,
         c.customer_name;
         
-- Task 1: Customer Order Count  Create Temp Table
DROP TEMPORARY TABLE IF EXISTS temp_customer_orders;
CREATE TEMPORARY TABLE temp_customer_orders AS

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;
-- Customers with More Than 2 Orders
SELECT *
FROM temp_customer_orders
WHERE total_orders > 2;

-- Task 2: Restaurant Revenue   Create Temp Table
DROP TEMPORARY TABLE IF EXISTS temp_restaurant_revenue;
CREATE TEMPORARY TABLE temp_restaurant_revenue AS

SELECT
    r.restaurant_id,
    r.rest_name,
    SUM(m.price * od.quantity) AS total_revenue
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY r.restaurant_id, r.rest_name;

-- Revenue Above ₹20,000
SELECT *
FROM temp_restaurant_revenue
WHERE total_revenue > 20000;

-- Task 3: High Value Orders Create Temp Table
DROP TEMPORARY TABLE IF EXISTS temp_order_value;
CREATE TEMPORARY TABLE temp_order_value AS

SELECT
    o.order_id,
    SUM(m.price * od.quantity) AS total_value
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY o.order_id;

-- Orders Above ₹1000
SELECT *
FROM temp_order_value
WHERE total_value > 1000;

-- Task 4: Popular Items Create Temp Table
DROP TEMPORARY TABLE IF EXISTS temp_popular_items;
CREATE TEMPORARY TABLE temp_popular_items AS

SELECT
    m.item_id,
    m.item_name,
    SUM(od.quantity) AS total_quantity
FROM menu_item m
JOIN order_details od
    ON m.item_id = od.item_id
GROUP BY m.item_id, m.item_name;

-- Top 5 Items
SELECT *
FROM temp_popular_items
ORDER BY total_quantity DESC
LIMIT 5;

-- Task 5: Big Cart Orders (5+ Items)  Create Temp Table
DROP TEMPORARY TABLE IF EXISTS temp_big_cart;
CREATE TEMPORARY TABLE temp_big_cart AS

SELECT
    order_id,
    SUM(quantity) AS total_items
FROM order_details
GROUP BY order_id;

-- Orders with 5+ Items
SELECT *
FROM temp_big_cart
WHERE total_items >= 5;
