-- ============================================================
-- ShopSphere Database - Normalization Validation
-- Contributor: Hemanth Singh
-- Contribution: Normalization analysis and validation
-- ============================================================

USE shopsphere;


-- 1. Check duplicate order items (1NF/2NF)
SELECT order_id, product_id, COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- 2. Check invalid customer references
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 3. Check address-customer consistency (3NF)
SELECT o.order_id,
       o.customer_id AS order_customer,
       a.customer_id AS address_customer,
       o.address_id
FROM orders o
JOIN addresses a
    ON o.address_id = a.address_id
WHERE o.customer_id <> a.customer_id;


-- 4. Check orphan products in order items
SELECT oi.order_id, oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 5. Check orphan orders in order items
SELECT oi.order_id, oi.product_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 6. Check orphan categories
SELECT p.product_id, p.category_id
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;


-- 7. Check orphan shipments
SELECT s.shipment_id, s.order_id
FROM shipments s
LEFT JOIN orders o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 8. Check orphan payments
SELECT p.payment_id, p.order_id
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 9. Check orphan reviews
SELECT r.review_id, r.customer_id, r.product_id
FROM reviews r
LEFT JOIN customers c
    ON r.customer_id = c.customer_id
LEFT JOIN products p
    ON r.product_id = p.product_id
WHERE c.customer_id IS NULL
   OR p.product_id IS NULL;


-- 10. Check orphan product-supplier relationships
SELECT ps.product_id, ps.supplier_id
FROM product_suppliers ps
LEFT JOIN products p
    ON ps.product_id = p.product_id
LEFT JOIN suppliers s
    ON ps.supplier_id = s.supplier_id
WHERE p.product_id IS NULL
   OR s.supplier_id IS NULL;


-- 11. Check duplicate shipments
SELECT order_id, COUNT(*) AS shipment_count
FROM shipments
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 12. Check duplicate payments
SELECT order_id, COUNT(*) AS payment_count
FROM payments
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 13. Check duplicate reviews
SELECT customer_id, product_id, COUNT(*) AS review_count
FROM reviews
GROUP BY customer_id, product_id
HAVING COUNT(*) > 1;


-- 14. Check duplicate product-supplier relationships
SELECT product_id, supplier_id, COUNT(*) AS relationship_count
FROM product_suppliers
GROUP BY product_id, supplier_id
HAVING COUNT(*) > 1;


-- ============================================================
-- Validation Result:
-- All validation queries should return 0 rows
-- when the ShopSphere database has no normalization
-- or referential integrity violations.
-- ============================================================
