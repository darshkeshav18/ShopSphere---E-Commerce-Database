-- v3 of schema: v2 + stronger integrity constraints, design notes, and two views.
--
-- ---------------------------------------------------------------------
-- DESIGN NOTES (rationale for the choices that are not obvious)
-- ---------------------------------------------------------------------
-- 1. order_items.unit_price is a deliberate copy of the price at purchase
--    time. products.price is the CURRENT price and changes; the order line
--    must keep the price the customer actually paid. It depends on the whole
--    key (order_id, product_id), so the table stays in 2NF/3NF.
-- 2. Order totals are NOT stored in orders. A stored total would be derived
--    data that can drift from order_items. Use the view v_order_totals.
-- 3. payments.amount is stored (a payment is a real money event) but must
--    equal the order total. SQL CHECKs cannot look at other tables, so the
--    view v_payment_mismatches lists any payment that disagrees; it should
--    return 0 rows.
-- 4. products.stock_qty cannot go negative (CHECK). Reducing stock when an
--    order line is added is done by the application inside the same
--    transaction as the INSERT into order_items, for example:
--        START TRANSACTION;
--          INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (...);
--          UPDATE products SET stock_qty = stock_qty - <qty> WHERE product_id = <id>;
--        COMMIT;   -- if stock would go below 0 the CHECK fails and the whole
--                  -- transaction is rolled back, so an out-of-stock item is never sold.
-- 5. An order's delivery address must belong to the customer who placed it:
--    orders references addresses through the composite key (address_id, customer_id).
-- 6. Status / method lists use CHECK ... IN (...) rather than ENUM: portable,
--    visible in the DDL, and easy to change with one ALTER.
-- 7. Referential actions: personal data (addresses, reviews) cascades with the
--    customer; financial history (orders, sold products) is RESTRICTed so it can
--    never be deleted by accident; payment/shipment/order_items belong to their
--    order and cascade with it.
-- 8. One payment and one shipment per order (UNIQUE order_id) and one review per
--    customer per product (UNIQUE customer_id, product_id). Reviews are not
--    restricted to buyers.
-- 9. phone and pincode are VARCHAR (identifiers, not numbers). CHECK constraints
--    with REGEXP need MySQL 8.0.16 or later.
-- ---------------------------------------------------------------------

DROP DATABASE IF EXISTS shopsphere;
CREATE DATABASE shopsphere;
USE shopsphere;


-- =========================================
-- 1. CUSTOMERS
-- =========================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- 10-digit mobile number (phone is optional, NULL passes)
    CONSTRAINT chk_customers_phone
        CHECK (phone REGEXP '^[0-9]{10}$'),

    -- something@something.something, no spaces
    CONSTRAINT chk_customers_email
        CHECK (email REGEXP '^[^@ ]+@[^@ ]+[.][^@ ]+$')
);


-- =========================================
-- 2. ADDRESSES
-- =========================================

CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    line1 VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- Indian PIN codes are exactly 6 digits
    CONSTRAINT chk_addresses_pincode
        CHECK (pincode REGEXP '^[0-9]{6}$'),

    -- address_id is already unique; this pair-key exists only so that ORDERS
    -- can reference (address_id, customer_id) together (see orders below)
    CONSTRAINT uq_addresses_id_customer
        UNIQUE (address_id, customer_id)
);


-- =========================================
-- 3. CATEGORIES
-- =========================================

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INT,

    FOREIGN KEY (parent_category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- =========================================
-- 4. PRODUCTS
-- =========================================

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CHECK (price >= 0),
    CHECK (stock_qty >= 0)
);


-- =========================================
-- 5. ORDERS
-- =========================================

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    -- no total column on purpose: totals are derived (see v_order_totals)

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- Composite FK: the delivery address must belong to the SAME customer
    -- who placed the order (replaces the old single-column FK on address_id)
    CONSTRAINT fk_orders_address_owner
        FOREIGN KEY (address_id, customer_id)
        REFERENCES addresses(address_id, customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- fixed order lifecycle
    CONSTRAINT chk_orders_status
        CHECK (status IN ('Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled'))
);


-- =========================================
-- 6. ORDER ITEMS
-- =========================================

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,   -- price at purchase time (see design note 1)

    PRIMARY KEY (order_id, product_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CHECK (quantity > 0),
    CHECK (unit_price >= 0)
);


-- =========================================
-- 7. PAYMENTS
-- =========================================

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,       -- must equal the order total (see v_payment_mismatches)
    method VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (amount >= 0),

    CONSTRAINT chk_payments_method
        CHECK (method IN ('UPI', 'Card', 'Net Banking')),

    CHECK (
        status IN (
            'Pending',
            'Paid',
            'Failed',
            'Refunded'
        )
    )
);


-- =========================================
-- 8. SHIPMENTS
-- =========================================

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    courier VARCHAR(100),
    shipped_date DATE,
    delivered_date DATE,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- cannot be delivered before it was shipped, or delivered without a ship date
    CONSTRAINT chk_shipments_dates
        CHECK (
            delivered_date IS NULL
            OR (shipped_date IS NOT NULL AND delivered_date >= shipped_date)
        )
);


-- =========================================
-- 9. REVIEWS
-- =========================================

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(500),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (rating BETWEEN 1 AND 5),

    UNIQUE (customer_id, product_id)
);


-- =========================================
-- 10. SUPPLIERS
-- =========================================

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    city VARCHAR(100),

    CONSTRAINT chk_suppliers_email
        CHECK (contact_email REGEXP '^[^@ ]+@[^@ ]+[.][^@ ]+$')
);


-- =========================================
-- 11. PRODUCT SUPPLIERS
-- =========================================

CREATE TABLE product_suppliers (
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    supply_price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (product_id, supplier_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (supply_price >= 0)
);


-- =========================================
-- VIEWS (derived data, see design notes 2 and 3)
-- =========================================

-- Order totals computed from the order lines
CREATE VIEW v_order_totals AS
SELECT
    o.order_id,
    o.customer_id,
    o.status,
    COUNT(oi.product_id)                           AS line_items,
    COALESCE(SUM(oi.quantity), 0)                  AS units,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0)  AS order_total
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, o.status;


-- Payments whose amount differs from the order total (expected: 0 rows)
CREATE VIEW v_payment_mismatches AS
SELECT
    p.payment_id,
    p.order_id,
    p.amount      AS paid_amount,
    t.order_total AS expected_amount
FROM payments p
JOIN v_order_totals t ON t.order_id = p.order_id
WHERE p.amount <> t.order_total;


-- =========================================
-- INDEXES FOR QUERY OPTIMIZATION
-- =========================================

-- Helps category-based product queries
-- Used in revenue-by-category joins
CREATE INDEX idx_products_category
ON products(category_id);


-- Helps low-inventory queries
-- Example: WHERE stock_qty < 10
CREATE INDEX idx_products_stock
ON products(stock_qty);


-- Helps customer order aggregation
-- Useful for finding valuable customers
CREATE INDEX idx_orders_customer_status
ON orders(customer_id, status);


-- Helps filtering orders by status and date
-- Useful for sales/revenue analysis
CREATE INDEX idx_orders_status_date
ON orders(status, order_date);


-- Helps product-based order item aggregation
-- Useful for best-selling product queries
CREATE INDEX idx_order_items_product
ON order_items(product_id);


-- Helps filter payments by payment status
-- Useful when calculating paid revenue
CREATE INDEX idx_payments_status
ON payments(status);


-- Helps product rating and review aggregation
-- Useful for highest-rated product queries
CREATE INDEX idx_reviews_product_rating
ON reviews(product_id, rating);


-- Helps supplier-based product searches
-- product_id is already indexed by the composite primary key,
-- but supplier_id is the second column, so this index is useful
-- when searching by supplier_id.
CREATE INDEX idx_product_suppliers_supplier
ON product_suppliers(supplier_id);
