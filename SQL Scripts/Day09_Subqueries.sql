use online_food_del;

-- orders for a specific customer

delimiter //
create procedure prderbycustomer(in cust_id int)
begin
select * from orders where customer_id= cust_id;
end//
delimiter ;

call prderbycustomer (30) ;

-- customers in a speciifc city

delimiter //
create procedure custbycity( in city_name varchar(5))
begin
select * from customers
where city= city_name;
end//
delimiter ;

call custbycity ('delhi');

-- best selling menu items

DROP PROCEDURE IF EXISTS bestsellingitems;

DELIMITER //

CREATE PROCEDURE bestsellingitems(IN limit_num INT)
BEGIN
    SELECT
        m.item_name,
        SUM(od.quantity) AS total_sold
    FROM menu_item m
    JOIN order_details od
        ON m.item_id = od.item_id
    GROUP BY m.item_name
    ORDER BY total_sold DESC
    LIMIT limit_num;
END //

DELIMITER ;

CALL bestsellingitems(2);

-- 1. Restaurants in a Specific City
DELIMITER //
CREATE PROCEDURE GetRestaurantsByCity(IN city_name VARCHAR(100))
BEGIN
    SELECT
        restaurant_id,
        rest_name,
        city
    FROM restaurant
    WHERE city = city_name;
END //

DELIMITER ;
CALL GetRestaurantsByCity('Hyderabad');

-- 2. Revenue Between Two Dates
DELIMITER //
CREATE PROCEDURE GetRevenueBetweenDates(
    IN start_date DATE,IN end_date DATE)
BEGIN
    SELECT
        SUM(m.price * od.quantity) AS total_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN menu_item m
        ON od.item_id = m.item_id
    WHERE o.order_date BETWEEN start_date AND end_date;
END //
DELIMITER ;
CALL GetRevenueBetweenDates('2024-01-01','2024-12-31');

-- 3. Top N Customers by Orders
DELIMITER //
CREATE PROCEDURE TopCustomers(IN limit_num INT)
BEGIN
    SELECT c.customer_name,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    ORDER BY total_orders DESC
    LIMIT limit_num;
END //
DELIMITER ;
CALL TopCustomers(5);

-- 4. Orders for a Specific Restaurant
DELIMITER //
CREATE PROCEDURE RestaurantOrders(IN rest_id INT)
BEGIN
    SELECT
        order_id,
        customer_id,
        restaurant_id,
        order_date
    FROM orders
    WHERE restaurant_id = rest_id;
END //

DELIMITER ;
CALL RestaurantOrders(3);

-- 5. First Order Date for Each Customer
DELIMITER //

CREATE PROCEDURE FirstOrderDate()
BEGIN
    SELECT
        customer_id,
        MIN(order_date) AS first_order
    FROM orders
    GROUP BY customer_id;
END //

DELIMITER ;
CALL FirstOrderDate();
