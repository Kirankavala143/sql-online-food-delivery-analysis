USE online_food_del;

-- 1. First Order of Each Customer
SELECT *
FROM
(
    SELECT order_id,customer_id,restaurant_id,order_date,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS r_n
    FROM orders
) result
WHERE r_n = 1;

-- 2. Top 2 Most Expensive Items Per Restaurant
SELECT *
FROM
(
    SELECT restaurant_id,item_id,item_name,price,
        RANK() OVER(
            PARTITION BY restaurant_id
            ORDER BY price DESC
        ) AS rnk
    FROM menu_item
) sub
WHERE rnk <= 2;

-- 3. Frequent Diners Using NTILE()
SELECT customer_id,
    COUNT(order_id) AS total_orders,
    NTILE(4) OVER(
        ORDER BY COUNT(order_id) DESC
    ) AS quartile
FROM orders
GROUP BY customer_id;

-- 1: Assign Serial Number to All Orders
SELECT order_id,
    customer_id,
    restaurant_id,
    order_date,
    ROW_NUMBER() OVER(ORDER BY order_date) AS serial_no
FROM orders;

-- 2: Get First Item in the Menu Per Restaurant
SELECT *
FROM
(
    SELECT restaurant_id,item_id,item_name,
        ROW_NUMBER() OVER(
            PARTITION BY restaurant_id
            ORDER BY item_name
        ) AS rn
    FROM menu_item
) t
WHERE rn = 1;

-- 3: Total Number of Orders Each Customer Placed
SELECT customer_id,order_id,
    COUNT(*) OVER(
        PARTITION BY customer_id
    ) AS total_orders
FROM orders;

-- 4: Restaurant With Highest Price Menu Item
SELECT *
FROM
(
    SELECT restaurant_id,item_id,item_name,price,
        ROW_NUMBER() OVER(
            PARTITION BY restaurant_id
            ORDER BY price DESC
        ) AS rn
    FROM menu_item
) t
WHERE rn = 1;

-- 5: Average Price of Items for Each Restaurant
SELECT restaurant_id,item_id,item_name,price,
    AVG(price) OVER(
        PARTITION BY restaurant_id
    ) AS avg_price
FROM menu_item;

-- ref
SELECT restaurant_id,item_id,item_name,price,
    AVG(price) OVER(PARTITION BY restaurant_id) AS avg_price,
    CASE
        WHEN price >
             AVG(price) OVER(PARTITION BY restaurant_id)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS price_category
FROM menu_item;
