create database online_store ;
use online_store 

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(100)
);

CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(100),
    category      VARCHAR(100),
    price         DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE,
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY,
    order_id        INT,
    product_id      INT,
    quantity        INT,
    price_per_unit  DECIMAL(10,2),
    CONSTRAINT fk_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id) ;
CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY,
    order_id        INT,
    product_id      INT,
    quantity        INT,
    price_per_unit  DECIMAL(10,2),
    CONSTRAINT fk_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
INSERT INTO customers (customer_id, customer_name, city) VALUES
(1, 'Alice', 'London'),
(2, 'Bob',   'London'),
(3, 'Carol', 'Paris'),
(4, 'David', 'Berlin'),
(5, 'Eve',   'Rome');

INSERT INTO products (product_id, product_name, category, price) VALUES
(10, 'Phone',    'Electronics', 500),
(11, 'Mouse',    'Electronics', 20),
(12, 'Keyboard', 'Electronics', 40),
(13, 'Monitor',  'Electronics', 150),
(14, 'Headset',  'Electronics', 60);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(101, 1, '2024-01-05'),
(102, 1, '2024-02-10'),
(103, 2, '2024-01-15'),
(104, 3, '2024-02-20'),
(105, 3, '2024-02-25'),
(106, 4, '2024-03-05'),
(107, 5, '2024-03-10'),
(108, 1, '2024-03-15');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price_per_unit) VALUES
(1, 101, 10, 1, 500),
(2, 101, 11, 2, 20),
(3, 102, 10, 2, 480),
(4, 103, 12, 3, 40),
(5, 104, 13, 1, 150),
(6, 105, 10, 1, 500),
(7, 105, 14, 2, 55),
(8, 106, 11, 4, 18),
(9, 107, 14, 3, 60),
(10,108, 13, 2, 140);

select * 
From customers ; 
select * 
From products ;

select * 
from orders ; 
select * 
from order_items ;

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(oi.quantity * oi.price_per_unit) AS order_total
FROM orders o
JOIN customers c  ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_date, c.customer_name
ORDER BY o.order_id;

SELECT
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_name, o.order_date;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_spent
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_spent
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.price_per_unit) > 500
ORDER BY total_spent DESC;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_spent,
    CASE
        WHEN SUM(oi.quantity * oi.price_per_unit) >= 1000 THEN 'VIP'
        WHEN SUM(oi.quantity * oi.price_per_unit) >= 500  THEN 'Regular'
        ELSE 'Low'
    END AS customer_segment
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.price_per_unit) AS total_spent
    FROM customers c
    JOIN orders o      ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_totals
ORDER BY total_spent DESC;

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.price_per_unit) AS total_spent
    FROM customers c
    JOIN orders o      ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spent,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC)   AS row_num,
    RANK()       OVER (ORDER BY total_spent DESC)   AS rnk,
    DENSE_RANK() OVER (ORDER BY total_spent DESC)   AS dense_rnk
FROM customer_totals
ORDER BY total_spent DESC;

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.price_per_unit) AS total_spent
    FROM customers c
    JOIN orders o      ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
),
ranked_customers AS (
    SELECT
        customer_name,
        total_spent,
        DENSE_RANK() OVER (ORDER BY total_spent DESC) AS rnk
    FROM customer_totals
)
SELECT
    customer_name,
    total_spent
FROM ranked_customers
WHERE rnk = 2;

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.price_per_unit) AS total_spent
    FROM customers c
    JOIN orders o      ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.customer_name
),
ranked_customers AS (
    SELECT
        customer_name,
        total_spent,
        RANK() OVER (ORDER BY total_spent DESC) AS rnk
    FROM customer_totals
)
SELECT
    customer_name,
    total_spent,
    rnk
FROM ranked_customers
WHERE rnk <= 3
ORDER BY rnk, customer_name;

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month_start,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
ORDER BY month_start;

SELECT
    c.customer_name,
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month_start,
    SUM(oi.quantity * oi.price_per_unit) AS total_sales
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY
    c.customer_name,
    DATE_FORMAT(o.order_date, '%Y-%m-01')
ORDER BY
    c.customer_name,
    month_start;
    
    WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS month_start,
        SUM(oi.quantity * oi.price_per_unit) AS total_sales
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    month_start,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY month_start
    ) AS running_total_sales
FROM monthly_sales
ORDER BY month_start;
INSERT INTO customers (customer_id, customer_name, city)
VALUES (6, 'Alice', 'London');  

SELECT
    customer_name,
    city,
    COUNT(*) AS cnt
FROM customers
GROUP BY customer_name, city
HAVING COUNT(*) > 1;

SELECT *
FROM (
    SELECT
        customer_id,
        customer_name,
        city,
        ROW_NUMBER() OVER (
            PARTITION BY customer_name, city
            ORDER BY customer_id
        ) AS rn
    FROM customers
) t
WHERE rn > 1;