use online_food_del;

-- 1. Customer Signups Category
SELECT customer_id,customer_name,signup_date,
    CASE
        WHEN signup_date < '2024-01-01' 
        THEN 'Early Bird'
        WHEN signup_date BETWEEN '2024-01-01'
        AND '2024-12-31'
        THEN 'Regular'
        ELSE 'New'
    END AS customer_category
FROM customers;

-- 2. Customers with Maximum Orders
SELECT c.customer_id,c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders on ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS t
);

-- 3. Menu Items Priced Above Global Average
SELECT item_id,item_name,price
FROM menu_item
WHERE price >
(
    SELECT AVG(price)
    FROM menu_item
);

-- 4. Restaurants With More Items Than Average
SELECT r.restaurant_id,r.rest_name,
    COUNT(m.item_id) AS total_items
FROM restaurant r
JOIN menu_item m ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.rest_name
HAVING COUNT(m.item_id) >
(
    SELECT AVG(item_count)
    FROM
    (
        SELECT COUNT(*) AS item_count
        FROM menu_item
        GROUP BY restaurant_id
    ) AS avg_items
);

-- 5. Monthly Order Summary (Using CTE)
WITH MonthlyOrders AS
(
    SELECT
        DATE_FORMAT(order_date,'%Y-%m') AS order_month,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY DATE_FORMAT(order_date,'%Y-%m')
)
SELECT *FROM MonthlyOrders WHERE total_orders > 50;
