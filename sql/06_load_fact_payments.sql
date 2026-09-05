-- Load payment transactions into the analytics layer.

INSERT INTO analytics.fact_payments (
    payment_id,
    order_id,
    customer_key,
    date_key,
    payment_method,
    payment_status,
    amount
)
SELECT
    p.payment_id,
    p.order_id,
    dc.customer_key,
    dd.date_key,
    p.payment_method,
    p.payment_status,
    p.amount
FROM raw.payments p
JOIN raw.orders o
    ON p.order_id = o.order_id
JOIN analytics.dim_customer dc
    ON o.customer_id = dc.customer_id
JOIN analytics.dim_date dd
    ON p.payment_date = dd.date;