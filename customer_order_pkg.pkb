CREATE OR REPLACE PACKAGE BODY customer_order_pkg AS

    -- -------------------------------------------------------
    -- Function 1: Get total order amount for a specific customer
    -- Joins: orders → customers
    -- Filter: customer_id, order_status
    -- -------------------------------------------------------
    FUNCTION get_customer_total(
        p_customer_id IN NUMBER,
        p_status      IN VARCHAR2 DEFAULT 'COMPLETED'
    ) RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(o.total_amount), 0)
        INTO   v_total
        FROM   orders o
        JOIN   customers c
               ON o.customer_id = c.customer_id
        WHERE  o.customer_id  = p_customer_id
        AND    o.order_status = p_status
        AND    c.status       = 'ACTIVE';

        RETURN v_total;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE;
    END get_customer_total;


    -- -------------------------------------------------------
    -- Function 2: Get all active orders with items for a region
    -- Joins: customers → orders → order_items
    -- Filter: region, order_date, order_status
    -- -------------------------------------------------------
    FUNCTION get_region_orders(
        p_region    IN VARCHAR2,
        p_from_date IN DATE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT c.customer_id,
                   c.customer_name,
                   c.region,
                   o.order_id,
                   o.order_date,
                   o.order_status,
                   oi.product_name,
                   oi.quantity,
                   oi.unit_price,
                   (oi.quantity * oi.unit_price) AS line_total
            FROM   customers  c
            JOIN   orders     o  ON c.customer_id = o.customer_id
            JOIN   order_items oi ON o.order_id   = oi.order_id
            WHERE  c.region       = p_region
            AND    c.status       = 'ACTIVE'
            AND    o.order_date  >= p_from_date
            AND    o.order_status = 'ACTIVE';

        RETURN v_cursor;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END get_region_orders;


    -- -------------------------------------------------------
    -- Function 3: Get full order summary with customer details
    -- Joins: orders → customers → order_items
    -- Filter: order_id
    -- -------------------------------------------------------
    FUNCTION get_order_summary(
        p_order_id IN NUMBER
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT c.customer_name,
                   c.email,
                   c.region,
                   o.order_id,
                   o.order_date,
                   o.total_amount,
                   o.order_status,
                   oi.product_name,
                   oi.quantity,
                   oi.unit_price,
                   (oi.quantity * oi.unit_price) AS line_total
            FROM   orders      o
            JOIN   customers   c  ON o.customer_id = c.customer_id
            JOIN   order_items oi ON o.order_id    = oi.order_id
            WHERE  o.order_id = p_order_id;

        RETURN v_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RAISE;
    END get_order_summary;

END customer_order_pkg;
/
