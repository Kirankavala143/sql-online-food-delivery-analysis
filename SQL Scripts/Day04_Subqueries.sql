USE online_food_del;

-- 1: Customer's Last Order Date
SELECT customer_id,order_id,
    MAX(order_date) OVER(PARTITION BY customer_id) AS last_order_date
FROM orders;

-- GROUP BY
SELECT
    customer_id,
    MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;

-- 2: Identify Repeat Customers (More Than 1 Order)
SELECT *
FROM (
    SELECT customer_id,order_id,order_date,
        COUNT(order_id) OVER(PARTITION BY customer_id) AS total_orders
    FROM orders
) AS sub
WHERE total_orders > 1;

-- group by version
SELECT customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 3: Get Previous and Next Order for Each Customer
SELECT customer_id,order_id,order_date,
LAG(order_id) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_order_id,
LEAD(order_id) OVER(PARTITION BY customer_id ORDER BY order_date) AS next_order_id
FROM orders;

-- 1: Previous Order Date for Each Customer
SELECT customer_id,order_id,order_date,
    LAG(order_date) OVER(
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date
FROM orders;

-- 2: Next Order Date for Each Customer
SELECT customer_id,order_id,order_date,
    LEAD(order_date) OVER(
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date
FROM orders;

-- 3: Find the Cheapest Item per Restaurant
SELECT *
FROM
(
    SELECT restaurant_id,item_id,item_name,price,
        RANK() OVER(
            PARTITION BY restaurant_id
            ORDER BY price ASC
        ) AS rnk
    FROM menu_item
) AS sub
WHERE rnk = 1;

-- 4: Percentile Bucket for Customers (Top/Bottom Tiers)
SELECT customer_id,
    COUNT(order_id) AS total_orders,
    NTILE(5) OVER(
        ORDER BY COUNT(order_id) DESC
    ) AS customer_bucket
FROM orders
GROUP BY customer_id;

-- 5: Rank Restaurants by Total Revenue Without Gaps
SELECT *
FROM
(
    SELECT
        r.restaurant_id,
        SUM(m.price * od.quantity) AS total_revenue,
        DENSE_RANK() OVER(
            ORDER BY SUM(m.price * od.quantity) DESC
        ) AS revenue_rank
    FROM restaurant r
    JOIN menu_item m
        ON r.restaurant_id = m.restaurant_id
    JOIN order_details od
        ON m.item_id = od.item_id
    GROUP BY r.restaurant_id
) AS sub;
