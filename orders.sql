-- Table 2: Orders
CREATE TABLE orders (
    order_id     NUMBER PRIMARY KEY,
    customer_id  NUMBER,
    order_date   DATE,
    total_amount NUMBER(10,2),
    order_status VARCHAR2(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
