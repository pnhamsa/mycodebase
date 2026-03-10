-- Table 1: Customers
CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    email         VARCHAR2(100),
    region        VARCHAR2(50),
    status        VARCHAR2(20) DEFAULT 'ACTIVE'
);
