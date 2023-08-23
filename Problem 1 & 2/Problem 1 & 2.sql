CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    shipping_address VARCHAR(100),
    contact_number VARCHAR(15)
);


CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);


CREATE TABLE Variants (
    variant_id INT PRIMARY KEY,
    product_id INT,
    variant_name VARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


CREATE TABLE dates (
    date_id INT PRIMARY KEY,
    date DATE
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    variant_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
   FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (variant_id) REFERENCES Variants(variant_id)
);


INSERT INTO Customers VALUES
    (1, 'John Doe', 'john@example.com', '123 Main St', '555-1234'),
    (2, 'Jane Smith', 'jane@example.com', '456 Elm St', '555-5678'),
    (3, 'Michael Johnson', 'michael@example.com', '789 Pine Rd', '555-9876'),
	(4, 'Emily Davis', 'emily@example.com', '101 Elm Ct', '555-4567'),
	(5, 'Robert Brown', 'robert@example.com', '234 Cedar Ln', '555-7890'),
	(6, 'Amanda Wilson', 'amanda@example.com', '567 Birch Rd', '555-2345'),
	(7, 'David Anderson', 'david@example.com', '890 Maple Ave', '555-6789'),
	(8, 'Jennifer Martinez', 'jennifer@example.com', '1234 Walnut St', '555-3456'),
	(9, 'William Thompson', 'william@example.com', '5678 Pine St', '555-8765'),
	(10, 'Jessica White', 'jessica@example.com', '9012 Oak Rd', '555-1234')
    ;


INSERT INTO Products VALUES
    (1, 'Product A'),
    (2, 'Product B'),
    (3, 'Product C'),
(4, 'Product D'),
(5, 'Product E'),
(6, 'Product F'),
(7, 'Product G'),
(8, 'Product H'),
(9, 'Product I'),
(10, 'Product J');


INSERT INTO Variants VALUES
    (1, 1, 'Variant 1A'),
    (2, 1, 'Variant 1B'),
    (3, 2, 'Variant 2A'),
(4, 2, 'Variant 2B'),
(5, 3, 'Variant 3A'),
(6, 3, 'Variant 3B'),
(7, 4, 'Variant 4A'),
(8, 4, 'Variant 4B'),
(9, 5, 'Variant 5A'),
(10, 5, 'Variant 5B');


INSERT INTO Dates VALUES
    (1, '2023-01-01'),
    (2, '2023-01-02'),
    (3, '2023-01-03'),
(4, '2023-01-04'),
(5, '2023-01-05'),
(6, '2023-01-06'),
(7, '2023-01-07'),
(8, '2023-01-08'),
(9, '2023-01-09'),
(10, '2023-01-10');
   


INSERT INTO Orders VALUES
    (1, 1, '2023-05-01', 100.00),
    (2, 2, '2023-04-02', 200.00),
    (3, 3, '2023-06-15', 150.00),
(4, 4, '2023-03-10', 75.00),
(5, 5, '2023-07-20', 300.00),
(6, 1, '2023-08-05', 120.00),
(7, 2, '2023-05-18', 180.00),
(8, 3, '2023-04-12', 160.00),
(9, 4, '2023-07-03', 90.00),
(10, 5, '2023-06-28', 250.00);


    

INSERT INTO Order_Details VALUES
    (1, 1, 1, 1, 1, 75.00),
    (2, 2, 2, 2, 1, 200.00),
    (3, 3, 3, 3, 2, 150.00),
(4, 4, 4, 4, 2, 50.00),
(5, 5, 5, 5, 3, 300.00),
(6, 1, 1, 1, 3, 120.00),
(7, 2, 2, 2, 4, 180.00),
(8, 3, 3, 3, 4, 160.00),
(9, 4, 4, 4, 5, 90.00),
(10, 5, 5, 5, 5, 250.00);

commit;


#1.Retrieve the top 5 customers with the highest average order amounts in the last 6 months:
SELECT
    c.name AS customer_name,
    AVG(o.total_amount) AS average_order_amount
FROM
    Customers c
JOIN
    Orders o ON c.customer_id = o.customer_id
WHERE
    o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
GROUP BY
    c.name
ORDER BY
    average_order_amount DESC
LIMIT 5;

#2.Retrieve the list of customer whose order value is lower this year as compared to previous year.
SELECT
    c.name AS customer_name,
    SUM(CASE WHEN YEAR(o.order_date) = YEAR(CURRENT_DATE) THEN o.total_amount ELSE 0 END) AS current_year_total,
    SUM(CASE WHEN YEAR(o.order_date) = YEAR(CURRENT_DATE) - 1 THEN o.total_amount ELSE 0 END) AS previous_year_total
FROM
    Customers c
JOIN
    Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.name
HAVING
    current_year_total < previous_year_total;

#3.Create a table showing cumulative purchase by a particular customer. Show the breakup of cumulative purchases by product category
SELECT
    c.name AS customer_name,
    v.variant_name,
    SUM(od.quantity) AS cumulative_quantity,
    SUM(od.unit_price * od.quantity) AS cumulative_amount
FROM
    Customers c
JOIN
    Orders o ON c.customer_id = o.customer_id
JOIN
    Order_Details od ON o.order_id = od.order_id
JOIN
    Variants v ON od.variant_id = v.variant_id
GROUP BY
    c.name, v.variant_name
ORDER BY
    customer_name, variant_name;
    

-- Retrieve the top 5 selling products and their sales by variants
SELECT
    p.product_name AS product,
    v.variant_name AS variant,
    SUM(od.quantity) AS total_quantity_sold
FROM
    Products p
JOIN
    Variants v ON p.product_id = v.product_id
JOIN
    Order_Details od ON v.variant_id = od.variant_id
GROUP BY
    p.product_name, v.variant_name
ORDER BY
    total_quantity_sold DESC
LIMIT
    5;


