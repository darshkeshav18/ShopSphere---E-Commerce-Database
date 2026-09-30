## ShopSphere — E-Commerce Database

> A relational database project for an e-commerce platform, designed using **MySQL 8+** with ER modelling, normalization, integrity constraints, sample data, validation queries, and business-oriented SQL analytics.

---

### Project Overview

**ShopSphere** is a relational database designed to model the core operations of an e-commerce platform.

The database represents the complete order lifecycle — from customer and address management to products, categories, orders, payments, shipments, reviews, and suppliers.

The project demonstrates important **Database Management System (DBMS)** concepts including:

- Relational database design
- Entity-Relationship (ER) modelling
- Primary and foreign keys
- Composite keys
- One-to-one relationships
- One-to-many relationships
- Many-to-many relationships
- Self-referencing relationships
- Database normalization
- 3NF-oriented schema design
- Referential integrity
- Domain constraints
- SQL joins
- Aggregate functions
- Business analytics
- Data validation



---

### Project Objectives

The main objectives of ShopSphere are:

1. Design a structured relational database for an e-commerce platform.
2. Represent real-world e-commerce entities using relational tables.
3. Reduce data redundancy through normalization.
4. Maintain data consistency using primary and foreign keys.
5. Implement appropriate integrity constraints.
6. Populate the database with realistic sample data.
7. Perform business-oriented analysis using SQL.
8. Validate the database for duplicate and orphan records.
9. Demonstrate practical SQL joins and aggregate functions.
10. Build a database structure that can be extended into a larger e-commerce application.

---

### Database Architecture

The database is organized around the following major entities:

```text
                         ┌──────────────┐
                         │  CUSTOMERS   │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │  ADDRESSES   │
                         └──────────────┘

CUSTOMERS
    │
    └─────────────── ORDERS
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
    ORDER_ITEMS       PAYMENTS      SHIPMENTS
          │
          ▼
      PRODUCTS
          │
     ┌────┴────┐
     ▼         ▼
CATEGORIES   REVIEWS
     │
     ▼
SUB-CATEGORIES

PRODUCTS
    │
    ▼
PRODUCT_SUPPLIERS
    │
    ▼
SUPPLIERS
```

---
### Database Schema

ShopSphere contains **11 relational tables**.

| # | Table | Purpose |
|---|---|---|
| 1 | `CUSTOMERS` | Stores customer information |
| 2 | `ADDRESSES` | Stores customer addresses |
| 3 | `CATEGORIES` | Stores product categories and hierarchy |
| 4 | `PRODUCTS` | Stores products, prices and inventory |
| 5 | `SUPPLIERS` | Stores supplier information |
| 6 | `PRODUCT_SUPPLIERS` | Connects products and suppliers |
| 7 | `ORDERS` | Stores customer orders |
| 8 | `ORDER_ITEMS` | Stores products included in orders |
| 9 | `PAYMENTS` | Stores payment information |
| 10 | `SHIPMENTS` | Stores shipment information |
| 11 | `REVIEWS` | Stores customer product reviews |

---

### Customers

The `CUSTOMERS` table stores information about users registered on the platform.

### Attributes

- `customer_id` — Primary Key
- `name`
- `email`
- `phone`
- `created_at`

A customer can have multiple addresses, orders, and reviews.

---

### Addresses

The `ADDRESSES` table stores addresses associated with customers.

### Attributes

- `address_id` — Primary Key
- `customer_id` — Foreign Key
- `line1`
- `city`
- `state`
- `pincode`

### Relationship

```text
CUSTOMERS 1 ─────────── M ADDRESSES
One-Many
```

---

### Categories

The `CATEGORIES` table organizes products into different categories.

### Attributes

- `category_id` — Primary Key
- `name`
- `parent_category_id` — Foreign Key

The table supports a self-referencing relationship.

Example:

```text
Electronics
├── Mobiles
├── Laptops
└── Audio
```

---

### Products

The `PRODUCTS` table contains the main product catalogue.

### Attributes

- `product_id` — Primary Key
- `name`
- `category_id` — Foreign Key
- `price`
- `stock_qty`

### Constraints

```text
price >= 0
stock_qty >= 0
```

---

### Suppliers

The `SUPPLIERS` table stores supplier information.

### Attributes

- `supplier_id` — Primary Key
- `name`
- `contact_email`
- `city`

A supplier can provide multiple products.

---

### Product Suppliers

`PRODUCT_SUPPLIERS` is a junction table that resolves the many-to-many relationship between products and suppliers.

### Attributes

- `product_id` — Foreign Key
- `supplier_id` — Foreign Key
- `supply_price`

### Composite Primary Key

```text
(product_id, supplier_id)
```

### Relationship

```text
PRODUCTS M ───────── N SUPPLIERS
             │
             ▼
      PRODUCT_SUPPLIERS
```

---

### Orders

The `ORDERS` table stores customer orders.

### Attributes

- `order_id` — Primary Key
- `customer_id` — Foreign Key
- `address_id` — Foreign Key
- `order_date`
- `status`

### Order Statuses

- Delivered
- Shipped
- Confirmed
- Pending
- Cancelled

### Relationships

```text
CUSTOMERS 1 ─────────── M ORDERS
ADDRESSES 1 ─────────── M ORDERS
```

---

### Order Items

The `ORDER_ITEMS` table stores individual products included in an order.

### Attributes

- `order_id` — Foreign Key
- `product_id` — Foreign Key
- `quantity`
- `unit_price`

### Composite Primary Key

```text
(order_id, product_id)
```

### Relationships

```text
ORDERS 1 ─────────── M ORDER_ITEMS
PRODUCTS 1 ───────── M ORDER_ITEMS
```

---

### Payments

The `PAYMENTS` table stores payment information.

### Attributes

- `payment_id` — Primary Key
- `order_id` — Foreign Key
- `amount`
- `method`
- `status`

### Payment Methods

- UPI
- Card
- Net Banking

---

### Shipments

The `SHIPMENTS` table tracks order delivery information.

### Attributes

- `shipment_id` — Primary Key
- `order_id` — Foreign Key
- `courier`
- `shipped_date`
- `delivered_date`

---

### Reviews

The `REVIEWS` table stores customer feedback about products.

### Attributes

- `review_id` — Primary Key
- `customer_id` — Foreign Key
- `product_id` — Foreign Key
- `rating`
- `comment`

### Rating Constraint

```text
1 ≤ rating ≤ 5
```

---

Keys Used

### Primary Keys

```text
CUSTOMERS       → customer_id
ADDRESSES       → address_id
CATEGORIES      → category_id
PRODUCTS        → product_id
SUPPLIERS       → supplier_id
ORDERS          → order_id
PAYMENTS        → payment_id
SHIPMENTS       → shipment_id
REVIEWS         → review_id
```

### Composite Keys

```text
ORDER_ITEMS
→ (order_id, product_id)

PRODUCT_SUPPLIERS
→ (product_id, supplier_id)
```

### Foreign Keys

```text
orders.customer_id
        ↓
customers.customer_id

orders.address_id
        ↓
addresses.address_id

products.category_id
        ↓
categories.category_id

reviews.product_id
        ↓
products.product_id
```

---

### Relationship Types

### One-to-Many

```text
CUSTOMER 1 ─────── M ORDERS
CUSTOMER 1 ─────── M ADDRESSES
CATEGORY 1 ─────── M PRODUCTS
ORDER 1 ────────── M ORDER_ITEMS
PRODUCT 1 ──────── M REVIEWS
```

### One-to-One

```text
ORDER 1 ───────── 1 PAYMENT
ORDER 1 ───────── 1 SHIPMENT
```

### Many-to-Many

```text
PRODUCT M ─────── N SUPPLIER
             │
             ▼
      PRODUCT_SUPPLIERS
```

---

### Database Normalization

ShopSphere follows a **3NF-oriented relational design**.

### 1NF — First Normal Form

Repeating and multi-valued information is separated into individual records.

For example, products within an order are stored in:

```text
ORDER_ITEMS
```

instead of storing multiple products directly inside the `ORDERS` table.

### 2NF — Second Normal Form

Composite-key tables ensure that non-key attributes depend on the complete key.

Example:

```text
ORDER_ITEMS

Primary Key:
(order_id, product_id)

Attributes:
quantity
unit_price
```

### 3NF — Third Normal Form

### Independent entities are separated into their own tables.

Examples:

```text
CUSTOMERS
PRODUCTS
SUPPLIERS
CATEGORIES
ORDERS
```

### This reduces redundancy and helps prevent update anomalies.

---

### Integrity Constraints

ShopSphere uses several database constraints.

### Primary Key

Ensures every record has a unique identifier.

### Foreign Key

Maintains relationships between tables.

### NOT NULL

Ensures required values are provided.

### UNIQUE

Prevents duplicate values where uniqueness is required.

### CHECK

Protects valid domain values.

Examples:

```text
price >= 0
stock_qty >= 0
quantity > 0
rating BETWEEN 1 AND 5
```

---

### Dataset Summary

The sample dataset contains **150 records** across 11 tables.

| Table | Records |
|---|---:|
| Customers | 12 |
| Addresses | 13 |
| Categories | 7 |
| Products | 16 |
| Suppliers | 6 |
| Product Suppliers | 10 |
| Orders | 16 |
| Order Items | 23 |
| Payments | 16 |
| Shipments | 16 |
| Reviews | 11 |
| **Total** | **150** |

---

### Business Analytics

The project contains **10 business-oriented SQL queries**.

### 1. Best-Selling Products

Calculates total units sold for each product using:

```sql
SUM(quantity)
```

Cancelled orders are excluded.

| Product | Units Sold |
|---|---:|
| Wireless Headphones | 4 |
| Mens T-Shirt | 4 |
| Bluetooth Speaker | 3 |
| Running Shoes | 3 |
| Python Programming Book | 3 |
| Samsung Galaxy S24 | 2 |
| Data Science Handbook | 2 |

### 2. Most Valuable Customers

Ranks customers based on total amount paid on valid, non-cancelled orders.

| Customer | Total Paid |
|---|---:|
| Aarav Sharma | ₹140,494 |
| Riya Nair | ₹74,096 |
| Arjun Kumar | ₹67,998 |
| Rahul Verma | ₹58,999 |
| Karan Mehta | ₹55,696 |

### 3. Revenue by Category

Revenue is calculated as:

```text
quantity × unit_price
```

| Category | Revenue |
|---|---:|
| Mobiles | ₹224,996 |
| Laptops | ₹176,997 |
| Audio | ₹17,993 |
| Fashion | ₹12,192 |
| Home & Kitchen | ₹9,498 |
| Books | ₹5,095 |

### 4. Average Order Value

```text
Average Order Value = ₹34,367.00
```

### 5. Low Inventory Products

Low inventory is defined as:

```sql
stock_qty < 10
```

Products identified include:

- HP Pavilion Laptop
- Coffee Maker
- Dell Inspiron Laptop
- Smart Watch
- Lenovo IdeaPad Slim
- iPhone 15
- Air Fryer

### 6. Highest-Rated Products

| Product | Average Rating | Reviews |
|---|---:|---:|
| Samsung Galaxy S24 | 4.67 | 3 |
| Wireless Headphones | 4.67 | 3 |
| Running Shoes | 3.50 | 2 |

### 7. Customers with No Orders

A `LEFT JOIN` is used to identify customers without associated orders.

Sample results:

- Dev Malhotra
- Nisha Menon

### 8. Orders by Status

| Status | Orders |
|---|---:|
| Delivered | 8 |
| Shipped | 3 |
| Confirmed | 2 |
| Pending | 2 |
| Cancelled | 1 |

### 9. Orders Awaiting Payment

| Order | Customer | Amount | Method |
|---:|---|---:|---|
| 5 | Ananya Rao | ₹5,097 | Card |
| 16 | Vikram Singh | ₹1,499 | Card |

### 10. Supplier/Product Relationships

Demonstrates the many-to-many relationship between:

```text
PRODUCTS
    ↕
PRODUCT_SUPPLIERS
    ↕
SUPPLIERS
```

---

### Database Validation

A dedicated validation script is included to check database quality and consistency.

The project contains **14 validation checks**:

1. Duplicate order items
2. Invalid customer references
3. Address/customer consistency
4. Orphan products in order items
5. Orphan orders in order items
6. Orphan categories
7. Orphan shipments
8. Orphan payments
9. Orphan reviews
10. Orphan product-supplier relationships
11. Duplicate shipments
12. Duplicate payments
13. Duplicate reviews
14. Duplicate product-supplier relationships

The expected clean-state result is **zero rows returned** for each validation query.

---

SQL Concepts Demonstrated

### DDL

```sql
CREATE DATABASE
CREATE TABLE
DROP DATABASE
```

### DML

```sql
INSERT INTO
```

### DQL

```sql
SELECT
```

### Joins

```sql
INNER JOIN
LEFT JOIN
```

### Aggregate Functions

```sql
SUM()
AVG()
COUNT()
ROUND()
```

### Grouping

```sql
GROUP BY
HAVING
```

### Filtering

```sql
WHERE
```

### Sorting

```sql
ORDER BY
```

### Constraints

```sql
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
```

---

Repository Structure

```text
ShopSphere---E-Commerce-Database/
│
├── Diagram/
│   └── ER_Diagram.png
│
├── Normalisation.new/
│   └── Normalization related files
│
├── data/
│   └── Sample dataset / INSERT scripts
│
├── queries/
│   └── Business SQL queries
│
├── schema/
│   └── Database and table creation scripts
│
├── README.md
│
└── ShopSphere_Normalization_Validation.sql
```

---

How to Run the Project

### 1. Install MySQL

Install **MySQL 8+**.

You can use:

- MySQL Workbench
- MySQL CLI
- VS Code with a MySQL extension
- Any MySQL-compatible SQL client

### 2. Create the Database

```sql
CREATE DATABASE shopsphere;

USE shopsphere;
```

### 3. Create the Tables

Run the SQL files inside the `schema` folder.

### 4. Insert the Data

Run the SQL files inside the `data` folder.

### 5. Run Validation

Execute:

```text
ShopSphere_Normalization_Validation.sql
```

### 6. Run Business Queries

Execute the SQL files inside the `queries` folder.

---

### Technology Stack

| Technology | Purpose |
|---|---|
| **MySQL 8+** | Database management |
| **SQL** | Database queries and analysis |
| **ER Diagram** | Database modelling |
| **GitHub** | Version control and documentation |
| **Markdown** | Project documentation |

---

### Future Enhancements

Possible future improvements include:

- Shopping cart functionality
- Multiple payment attempts
- Discounts and coupon management
- Returns and refunds
- Advanced delivery tracking
- Product image management
- Advanced business analytics
- Authentication and user management

---

DBMS Concepts Covered

```text
✓ Relational Database
✓ ER Modelling
✓ Entities
✓ Attributes
✓ Primary Keys
✓ Foreign Keys
✓ Composite Keys
✓ 1:1 Relationships
✓ 1:M Relationships
✓ M:N Relationships
✓ Self-Referencing Relationships
✓ Normalization
✓ 1NF
✓ 2NF
✓ 3NF
✓ Referential Integrity
✓ Domain Constraints
✓ CHECK Constraints
✓ SQL Joins
✓ Aggregate Functions
✓ GROUP BY
✓ HAVING
✓ Data Validation
✓ Business Analytics
```

---

Project Highlights

| Metric | Value |
|---|---:|
| Database | ShopSphere |
| DBMS | MySQL 8+ |
| Tables | 11 |
| Sample Records | 150 |
| Business Queries | 10 |
| Validation Checks | 14 |
| Normalization | 3NF-oriented |
| Relationship Types | 1:1, 1:M, M:N |

---

### Academic Purpose

ShopSphere was developed as a **DBMS / Relational Database project** to demonstrate how real-world e-commerce operations can be converted into a structured relational data model.

The project follows this workflow:

```text
ER Modelling
      ↓
Relational Schema
      ↓
Normalization
      ↓
SQL Implementation
      ↓
Sample Dataset
      ↓
Validation
      ↓
Business Analytics
```

This project demonstrates both **database design concepts** and **practical SQL skills**.

---

### Documentation

The repository includes:

- ER Diagram
- Database schema
- Sample dataset
- SQL queries
- Validation script
- Normalization documentation
- Detailed project report
- README documentation

---

### Conclusion

**ShopSphere** demonstrates how a complete e-commerce system can be represented using a structured relational database.

The project combines:

```text
Customers
    ↓
Addresses
    ↓
Orders
    ↓
Order Items
    ↓
Products
    ↓
Payments / Shipments / Reviews
    ↓
Suppliers
```

Through its normalized schema, relational constraints, sample dataset, validation queries and business analytics, ShopSphere demonstrates the practical application of core **Database Management System (DBMS)** concepts in an e-commerce environment.

---

### Project Status

**Status:** Completed

**Database:** MySQL 8+

**Tables:** 11

**Sample Records:** 150

**Business Queries:** 10

**Validation Checks:** 14

**Normalization:** 3NF-oriented

---

### Project

**ShopSphere — E-Commerce Database**

A collaborative DBMS project focused on relational database design, SQL implementation, data validation, normalization and business analytics.
