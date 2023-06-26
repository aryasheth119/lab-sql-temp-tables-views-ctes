USE sakila;

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

SELECT c.customer_id, c.first_name, c.last_name, c.email FROM sakila.customer AS c
JOIN sakila.rental AS r
ON c.customer_id = r.customer_id;

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM
    customer AS c
    INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;
    
    
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.
    
SELECT * from sakila.customer;

CREATE TEMPORARY TABLE temp_customer_payments AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count,
    SUM(p.amount) AS total_paid
FROM
    customer AS c
    JOIN rental AS r ON c.customer_id = r.customer_id
    JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY
    c.customer_id;
    
-- Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report, 
-- which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, 
-- this last column is a derived column from total_paid and rental_count.
 
 WITH customer_summary AS (
  SELECT
    customer_name,
    email,
    rental_count,
    total_paid,
    total_paid / rental_count AS average_payment_per_rental
  FROM temp_customer_payments
)SELECT
  customer_name,
  email,
  rental_count,
  total_paid,
  average_payment_per_rental
FROM customer_summary;

