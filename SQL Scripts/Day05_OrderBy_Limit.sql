USE online_food_del;
-- 1. Customer Total Spend View
CREATE VIEW customer_total_spend AS

SELECT
    c.customer_id,
    c.customer_name,
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
FROM customer_total_spend
WHERE total_spent > 1000;

-- 2. Customer Order Count View
CREATE VIEW customer_order_count AS

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT *
FROM customer_order_count
WHERE total_orders > 5;

-- 3. Most Ordered Items View
CREATE VIEW most_ordered_item AS

SELECT
    m.item_id,
    m.item_name,
    SUM(od.quantity) AS total_ordered_quantity
FROM menu_item m
JOIN order_details od
    ON m.item_id = od.item_id
GROUP BY m.item_id, m.item_name
ORDER BY total_ordered_quantity DESC;

SELECT *
FROM most_ordered_item
LIMIT 3;

-- Query 1: avg_spend_per_order
CREATE VIEW avg_spend_per_order AS

SELECT
    o.order_id,
    o.customer_id,
    SUM(m.price * od.quantity) AS total_spend
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY o.order_id, o.customer_id;

SELECT * FROM avg_spend_per_order;

-- Query 2: restaurant_performance
CREATE VIEW restaurant_performance AS
SELECT r.restaurant_id,r.rest_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(m.price * od.quantity) AS total_revenue
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY r.restaurant_id, r.rest_name;

SELECT * FROM restaurant_performance;

-- Query 3: city_customer_spending
CREATE VIEW city_customer_spending AS
SELECT c.city,
    SUM(m.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY c.city;

SELECT * FROM city_customer_spending;

-- Query 4: top_high_value_orders
CREATE VIEW top_high_value_orders AS
SELECT o.order_id,c.customer_name,o.order_date,
    SUM(m.price * od.quantity) AS order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY o.order_id,
         c.customer_name,
         o.order_date
ORDER BY order_value DESC
LIMIT 5;

SELECT * FROM top_high_value_orders;

-- Query 5: customers_without_orders
CREATE VIEW customers_without_orders AS
SELECT c.customer_id,c.customer_name,c.email,c.city,c.signup_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT * FROM customers_without_orders;
