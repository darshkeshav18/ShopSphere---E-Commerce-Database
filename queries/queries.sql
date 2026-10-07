USE shopsphere;

-- =========================================================
-- ShopSphere - Section 6: Business Questions
-- Database: MySQL 8+
-- =========================================================
-- Assumptions used for analytical questions:
-- 1. Cancelled orders are excluded from sales/revenue calculations.
-- 2. For customer value, only payments with status = 'Paid' are counted.
-- 3. Low inventory means stock_qty < 10.
-- 4. A product must have at least 2 reviews to appear in the
--    highest-rated-products result.
-- =========================================================

-- Q1. What are the best-selling products?
SELECT
    p.product_id,
    p.name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC, p.product_id;


-- Q2. Who are the most valuable customers?
-- Ranked by total amount paid for non-cancelled orders.
SELECT
    c.customer_id,
    c.name,
    SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.status <> 'Cancelled'
  AND p.status = 'Paid'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.customer_id
LIMIT 10;


-- Q3. What is the revenue by category?
SELECT
    c.category_id,
    c.name AS category_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.category_id, c.name
ORDER BY revenue DESC, c.category_id;


-- Q4. What is the average order value?
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY o.order_id
) AS order_totals;


-- Q5. Which products have low inventory?
-- Low inventory threshold = fewer than 10 units.
SELECT
    product_id,
    name,
    stock_qty
FROM products
WHERE stock_qty < 10
ORDER BY stock_qty ASC, product_id;


-- Q6. Which products have the highest ratings?
-- Only products with at least 2 reviews are considered.
SELECT
    p.product_id,
    p.name,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM products p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.name
HAVING COUNT(r.review_id) >= 2
ORDER BY average_rating DESC, review_count DESC, p.product_id;


-- Q7. Which customers have never placed an order?

SELECT
    c.customer_id,
    c.name,
    c.email
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;



-- =========================================================
-- Additional Business Questions
-- =========================================================

-- Q8. How many orders are there for each order status?
SELECT
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC, status;


-- Q9. Which active orders are still awaiting payment?
-- Non-cancelled orders whose payment is not yet 'Paid'.
SELECT
    o.order_id,
    c.name AS customer_name,
    o.status AS order_status,
    p.amount,
    p.method,
    p.status AS payment_status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN payments p  ON p.order_id = o.order_id
WHERE p.status <> 'Paid'
  AND o.status <> 'Cancelled'
ORDER BY o.order_id;

-- Q10. Who is the cheapest supplier for each product, and what profit
-- margin does that give against the current selling price?
-- (RANK() keeps ties, so two equally cheap suppliers would both appear.)
SELECT
    product_id,
    product_name,
    selling_price,
    cheapest_supplier,
    supply_price,
    selling_price - supply_price AS margin_per_unit,
    ROUND((selling_price - supply_price) / selling_price * 100, 1) AS margin_percent
FROM (
    SELECT
        p.product_id,
        p.name  AS product_name,
        p.price AS selling_price,
        s.name  AS cheapest_supplier,
        ps.supply_price,
        RANK() OVER (PARTITION BY p.product_id ORDER BY ps.supply_price) AS price_rank
    FROM products p
    JOIN product_suppliers ps ON ps.product_id = p.product_id
    JOIN suppliers s          ON s.supplier_id = ps.supplier_id
) ranked
WHERE price_rank = 1
ORDER BY margin_percent DESC, product_id
 
