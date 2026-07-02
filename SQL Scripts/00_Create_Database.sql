-- CREATE ONLINE_FOOD_DEL DATABASE
CREATE DATABASE ONLINE_FOOD_DEL;
USE ONLINE_FOOD_DEL;

-- CUSTOMER Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60),
    email VARCHAR(60),
    city VARCHAR(60),
    signup_date DATE
);

-- Restaurant Table
CREATE TABLE restaurant (
    restaurant_id INT PRIMARY KEY,
    rest_name VARCHAR(60),
    city VARCHAR(60),
    reg_date DATE
);

-- Menu Item Table
CREATE TABLE menu_item (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(60),
    price DECIMAL(10,2),
    CONSTRAINT fk_menu_rest
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant(restaurant_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    CONSTRAINT fk_order_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),
    CONSTRAINT fk_order_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant(restaurant_id)
);

-- Order Details Table
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    CONSTRAINT fk_orderdetail_order
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    CONSTRAINT fk_orderdetail_item
    FOREIGN KEY (item_id)
    REFERENCES menu_item(item_id)
);
