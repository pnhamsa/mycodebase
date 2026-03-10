-- Table 3: Order Items
CREATE TABLE order_items (
    item_id    NUMBER PRIMARY KEY,
    order_id   NUMBER,
    product_name VARCHAR2(100),
    quantity   NUMBER,
    unit_price NUMBER(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
