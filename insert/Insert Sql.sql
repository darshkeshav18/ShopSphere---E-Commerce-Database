USE shopsphere;

-- =========================================================
-- ShopSphere: E-Commerce Order and Inventory Database
-- Full sample dataset (~150 rows across all 11 tables)
-- =========================================================

-- ---------------------------------------------------------
-- 1. CUSTOMERS (12 rows)
-- ---------------------------------------------------------
INSERT INTO customers (customer_id, name, email, phone, created_at) VALUES
(1, 'Aarav Sharma', 'aarav.sharma@gmail.com', '9876543210', '2026-01-05 09:15:00'),
(2, 'Riya Nair', 'riya.nair@gmail.com', '9876543211', '2026-01-07 11:30:00'),
(3, 'Karan Mehta', 'karan.mehta@gmail.com', '9876543212', '2026-01-09 14:20:00'),
(4, 'Ananya Rao', 'ananya.rao@gmail.com', '9876543213', '2026-01-12 10:45:00'),
(5, 'Arjun Kumar', 'arjun.kumar@gmail.com', '9876543214', '2026-01-15 16:10:00'),
(6, 'Meera Iyer', 'meera.iyer@gmail.com', '9876543215', '2026-01-18 12:25:00'),
(7, 'Vikram Singh', 'vikram.singh@gmail.com', '9876543216', '2026-01-20 09:50:00'),
(8, 'Sneha Patel', 'sneha.patel@gmail.com', '9876543217', '2026-01-23 18:05:00'),
(9, 'Rahul Verma', 'rahul.verma@gmail.com', '9876543218', '2026-01-25 13:40:00'),
(10, 'Ishita Kapoor', 'ishita.kapoor@gmail.com', '9876543219', '2026-01-27 15:15:00'),
(11, 'Dev Malhotra', 'dev.malhotra@gmail.com', '9876543220', '2026-01-29 10:10:00'),
(12, 'Nisha Menon', 'nisha.menon@gmail.com', '9876543221', '2026-02-01 17:30:00');

-- ---------------------------------------------------------
-- 2. ADDRESSES (13 rows)
-- ---------------------------------------------------------
INSERT INTO addresses (address_id, customer_id, line1, city, state, pincode) VALUES
(1, 1, '12 MG Road', 'Bengaluru', 'Karnataka', '560001'),
(2, 1, '45 Park Street', 'Bengaluru', 'Karnataka', '560025'),
(3, 2, '22 Brigade Road', 'Bengaluru', 'Karnataka', '560025'),
(4, 3, '18 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040'),
(5, 4, '7 Indiranagar', 'Bengaluru', 'Karnataka', '560038'),
(6, 5, '31 Koramangala', 'Bengaluru', 'Karnataka', '560034'),
(7, 6, '15 HSR Layout', 'Bengaluru', 'Karnataka', '560102'),
(8, 7, '28 Andheri West', 'Mumbai', 'Maharashtra', '400058'),
(9, 8, '41 Vastrapur', 'Ahmedabad', 'Gujarat', '380015'),
(10, 9, '9 Salt Lake', 'Kolkata', 'West Bengal', '700091'),
(11, 10, '56 Banjara Hills', 'Hyderabad', 'Telangana', '500034'),
(12, 11, '14 Koregaon Park', 'Pune', 'Maharashtra', '411001'),
(13, 12, '8 Kakkanad', 'Kochi', 'Kerala', '682030');

-- ---------------------------------------------------------
-- 3. CATEGORIES (7 rows)
-- ---------------------------------------------------------
INSERT INTO categories (category_id, name, parent_category_id) VALUES
(1, 'Electronics', NULL),
(2, 'Fashion', NULL),
(3, 'Home & Kitchen', NULL),
(4, 'Books', NULL),
(5, 'Mobiles', 1),
(6, 'Laptops', 1),
(7, 'Audio', 1);

-- ---------------------------------------------------------
-- 4. PRODUCTS (16 rows)
-- ---------------------------------------------------------
INSERT INTO products (product_id, name, category_id, price, stock_qty) VALUES
(1, 'Samsung Galaxy S24', 5, 69999.00, 12),
(2, 'iPhone 15', 5, 59999.00, 8),
(3, 'OnePlus Nord CE 4', 5, 24999.00, 18),
(4, 'Dell Inspiron Laptop', 6, 64999.00, 5),
(5, 'HP Pavilion Laptop', 6, 58999.00, 3),
(6, 'Lenovo IdeaPad Slim', 6, 52999.00, 7),
(7, 'Wireless Headphones', 7, 2999.00, 25),
(8, 'Bluetooth Speaker', 7, 1999.00, 18),
(9, 'Smart Watch', 1, 4499.00, 6),
(10, 'Running Shoes', 2, 2499.00, 20),
(11, 'Mens T-Shirt', 2, 799.00, 30),
(12, 'Womens Hoodie', 2, 1499.00, 14),
(13, 'Coffee Maker', 3, 3499.00, 4),
(14, 'Air Fryer', 3, 5999.00, 9),
(15, 'Python Programming Book', 4, 899.00, 15),
(16, 'Data Science Handbook', 4, 1199.00, 10);

-- ---------------------------------------------------------
-- 5. SUPPLIERS (6 rows)
-- ---------------------------------------------------------
INSERT INTO suppliers (supplier_id, name, contact_email, city) VALUES
(1, 'TechSource India', 'techsource@gmail.com', 'Bengaluru'),
(2, 'MobileHub Distributors', 'mobilehub@gmail.com', 'Mumbai'),
(3, 'HomeStyle Supplies', 'homestyle@gmail.com', 'Delhi'),
(4, 'FashionKart Wholesale', 'fashionkart@gmail.com', 'Bengaluru'),
(5, 'BookWorld Distributors', 'bookworld@gmail.com', 'Chennai'),
(6, 'AudioMax Suppliers', 'audiomax@gmail.com', 'Hyderabad');

-- ---------------------------------------------------------
-- 6. PRODUCT_SUPPLIERS (10 rows)
-- ---------------------------------------------------------
INSERT INTO product_suppliers (product_id, supplier_id, supply_price) VALUES
(1, 2, 62000.00),
(2, 2, 53000.00),
(3, 2, 21500.00),
(4, 1, 57000.00),
(5, 1, 51000.00),
(6, 1, 45000.00),
(7, 6, 2200.00),
(8, 6, 1400.00),
(9, 1, 3300.00),
(10, 4, 1800.00);

-- ---------------------------------------------------------
-- 7. ORDERS (16 rows)
-- Note: customer 11 and 12 have no orders intentionally.
-- ---------------------------------------------------------
INSERT INTO orders (order_id, customer_id, address_id, order_date, status) VALUES
(1, 1, 1, '2026-02-02 10:15:00', 'Delivered'),
(2, 2, 3, '2026-02-03 14:20:00', 'Delivered'),
(3, 1, 2, '2026-02-05 18:10:00', 'Shipped'),
(4, 3, 4, '2026-02-08 11:30:00', 'Confirmed'),
(5, 4, 5, '2026-02-10 09:45:00', 'Pending'),
(6, 5, 6, '2026-02-12 16:25:00', 'Delivered'),
(7, 6, 7, '2026-02-14 13:10:00', 'Delivered'),
(8, 7, 8, '2026-02-16 17:40:00', 'Shipped'),
(9, 8, 9, '2026-02-18 12:05:00', 'Confirmed'),
(10, 9, 10, '2026-02-20 15:50:00', 'Delivered'),
(11, 10, 11, '2026-02-22 10:35:00', 'Delivered'),
(12, 2, 3, '2026-02-24 19:15:00', 'Shipped'),
(13, 3, 4, '2026-02-26 09:20:00', 'Delivered'),
(14, 5, 6, '2026-02-28 14:45:00', 'Cancelled'),
(15, 1, 1, '2026-03-02 11:10:00', 'Delivered'),
(16, 7, 8, '2026-03-04 16:30:00', 'Pending');

-- ---------------------------------------------------------
-- 8. ORDER_ITEMS (23 rows)
-- ---------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 69999.00),
(1, 7, 2, 2999.00),

(2, 10, 1, 2499.00),
(2, 11, 2, 799.00),

(3, 2, 1, 59999.00),
(3, 8, 1, 1999.00),

(4, 15, 2, 899.00),

(5, 13, 1, 3499.00),
(5, 11, 2, 799.00),

(6, 4, 1, 64999.00),
(6, 7, 1, 2999.00),

(7, 14, 1, 5999.00),
(7, 12, 1, 1499.00),

(8, 3, 1, 24999.00),
(8, 8, 2, 1999.00),

(9, 16, 2, 1199.00),

(10, 5, 1, 58999.00),

(11, 10, 2, 2499.00),
(11, 7, 1, 2999.00),

(12, 1, 1, 69999.00),

(13, 6, 1, 52999.00),
(13, 15, 1, 899.00),

(14, 9, 1, 4499.00);

-- ---------------------------------------------------------
-- 9. PAYMENTS (16 rows)
-- Amounts match order item totals.
-- ---------------------------------------------------------
INSERT INTO payments (payment_id, order_id, amount, method, status) VALUES
(1, 1, 75997.00, 'UPI', 'Paid'),
(2, 2, 4097.00, 'Card', 'Paid'),
(3, 3, 61998.00, 'UPI', 'Paid'),
(4, 4, 1798.00, 'Net Banking', 'Paid'),
(5, 5, 5097.00, 'Card', 'Pending'),
(6, 6, 67998.00, 'UPI', 'Paid'),
(7, 7, 7498.00, 'Card', 'Paid'),
(8, 8, 28997.00, 'UPI', 'Paid'),
(9, 9, 2398.00, 'Net Banking', 'Paid'),
(10, 10, 58999.00, 'Card', 'Paid'),
(11, 11, 7997.00, 'UPI', 'Paid'),
(12, 12, 69999.00, 'Card', 'Paid'),
(13, 13, 53898.00, 'UPI', 'Paid'),
(14, 14, 4499.00, 'Card', 'Refunded'),
(15, 15, 2499.00, 'UPI', 'Paid'),
(16, 16, 1499.00, 'Card', 'Pending');

-- ---------------------------------------------------------
-- 10. SHIPMENTS (16 rows)
-- ---------------------------------------------------------
INSERT INTO shipments (shipment_id, order_id, courier, shipped_date, delivered_date) VALUES
(1, 1, 'Delhivery', '2026-02-03', '2026-02-06'),
(2, 2, 'Blue Dart', '2026-02-04', '2026-02-08'),
(3, 3, 'DTDC', '2026-02-06', NULL),
(4, 4, 'Delhivery', '2026-02-09', NULL),
(5, 5, 'Blue Dart', NULL, NULL),
(6, 6, 'Delhivery', '2026-02-13', '2026-02-16'),
(7, 7, 'DTDC', '2026-02-15', '2026-02-18'),
(8, 8, 'Blue Dart', '2026-02-17', NULL),
(9, 9, 'Delhivery', '2026-02-19', NULL),
(10, 10, 'DTDC', '2026-02-21', '2026-02-25'),
(11, 11, 'Blue Dart', '2026-02-23', '2026-02-27'),
(12, 12, 'Delhivery', '2026-02-25', NULL),
(13, 13, 'DTDC', '2026-02-27', '2026-03-02'),
(14, 14, 'Blue Dart', NULL, NULL),
(15, 15, 'Delhivery', '2026-03-03', '2026-03-06'),
(16, 16, 'DTDC', NULL, NULL);

-- ---------------------------------------------------------
-- 11. REVIEWS (11 rows)
-- Multiple reviews on selected products for rating analysis.
-- ---------------------------------------------------------
INSERT INTO reviews (review_id, customer_id, product_id, rating, comment) VALUES
(1, 1, 1, 5, 'Excellent phone and very smooth performance'),
(2, 2, 1, 4, 'Very good performance and camera'),
(3, 3, 1, 5, 'Great phone with useful features'),
(4, 4, 7, 5, 'Excellent sound quality'),
(5, 5, 7, 4, 'Good headphones and comfortable fit'),
(6, 6, 7, 5, 'Clear audio and good battery life'),
(7, 7, 10, 4, 'Comfortable running shoes'),
(8, 8, 10, 3, 'Good shoes but average cushioning'),
(9, 9, 15, 5, 'Very useful programming book'),
(10, 10, 16, 4, 'Helpful introduction to data science'),
(11, 2, 11, 3, 'Good quality but basic design');

-- =========================================================
-- TOTAL ROWS = 150
-- customers        12
-- addresses        13
-- categories        7
-- products         16
-- suppliers         6
-- product_suppliers 10
-- orders           16
-- order_items      23
-- payments         16
-- shipments        16
-- reviews          11
-- =========================================================
