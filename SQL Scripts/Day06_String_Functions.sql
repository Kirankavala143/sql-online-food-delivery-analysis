USE online_food_del;

-- Find cities with more than 5 total orders
SELECT r.city,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN restaurant r
    ON o.restaurant_id = r.restaurant_id
GROUP BY r.city
HAVING COUNT(o.order_id) > 5;

-- Food items earning more than ₹1000 revenue:
SELECT m.item_name,
    SUM(m.price * od.quantity) AS revenue
FROM menu_item m
JOIN order_details od
    ON m.item_id = od.item_id
GROUP BY m.item_name
HAVING SUM(m.price * od.quantity) > 1000;

-- 1. List Customers Who Placed More Than 3 Orders

SELECT c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 3;

-- 2. Display Menu Items Ordered More Than 2 Times
SELECT m.item_name,
    COUNT(od.item_id) AS total_orders
FROM menu_item m
JOIN order_details od
    ON m.item_id = od.item_id
GROUP BY m.item_name
HAVING COUNT(od.item_id) > 2;

-- 3. Find Restaurants With Total Revenue Above ₹5000
SELECT r.rest_name,
    SUM(m.price * od.quantity) AS total_revenue
FROM restaurant r
JOIN menu_item m
    ON r.restaurant_id = m.restaurant_id
JOIN order_details od
    ON m.item_id = od.item_id
GROUP BY r.rest_name
HAVING SUM(m.price * od.quantity) > 5000;
