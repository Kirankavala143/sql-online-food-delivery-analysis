USE online_food_del;

-- 1: Customers Who Placed More Orders Than Average Customer
USE online_food_del;
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) >
    (
        SELECT AVG(order_count)
        FROM
        (
            SELECT customer_id,
                   COUNT(order_id) AS order_count
            FROM orders
            GROUP BY customer_id
        ) AS customer_orders
    )
);

-- 2: Customers Who Never Ordered From Restaurant In Their City
SELECT customer_id,
       customer_name,
       city
FROM customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM orders o
    JOIN restaurant r
        ON o.restaurant_id = r.restaurant_id
    WHERE o.customer_id = c.customer_id
      AND r.city = c.city
);

-- 3: Restaurant With Highest Revenue In Each City
SELECT r.rest_name,
       r.city
FROM restaurant r
WHERE (r.restaurant_id, r.city) IN
(
    SELECT r2.restaurant_id,
           r2.city
    FROM restaurant r2
    JOIN orders o
        ON r2.restaurant_id = o.restaurant_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN menu_item m
        ON od.item_id = m.item_id
    GROUP BY r2.city, r2.restaurant_id
    HAVING SUM(m.price * od.quantity) =
    (
        SELECT MAX(total_revenue)
        FROM
        (
            SELECT r3.city,
                   r3.restaurant_id,
                   SUM(m.price * od.quantity) AS total_revenue
            FROM restaurant r3
            JOIN orders o
                ON r3.restaurant_id = o.restaurant_id
            JOIN order_details od
                ON o.order_id = od.order_id
            JOIN menu_item m
                ON od.item_id = m.item_id
            GROUP BY r3.city, r3.restaurant_id
        ) city_revenues
        WHERE city_revenues.city = r2.city
    )
);

-- Practice Task 1: Top 5 Most Expensive Menu Items
SELECT item_name,
       price
FROM menu_item
ORDER BY price DESC
LIMIT 5;

-- Practice Task 2: Restaurant With Highest Average Item Price
SELECT r.restaurant_id,
       r.rest_name,
       AVG(m.price) AS avg_price
FROM restaurant r
JOIN menu_item m
    ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id,
         r.rest_name
ORDER BY avg_price DESC
LIMIT 1;

-- Practice Task 3: Restaurants Having More Orders Than Average
SELECT r.restaurant_id,
       r.rest_name,
       COUNT(o.order_id) AS total_orders
FROM restaurant r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id,
         r.rest_name
HAVING COUNT(o.order_id) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT restaurant_id,
               COUNT(order_id) AS order_count
        FROM orders
        GROUP BY restaurant_id
    ) avg_orders
);

-- Practice Task 4: Most Frequently Ordered Menu Item
SELECT m.item_name,
       COUNT(*) AS times_ordered
FROM order_details od
JOIN menu_item m
    ON od.item_id = m.item_id
GROUP BY m.item_id,
         m.item_name
ORDER BY times_ordered DESC
LIMIT 1;

-- Practice Task 5: Customers With More Than 2 Orders
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
         c.customer_name
HAVING COUNT(o.order_id) > 2;
