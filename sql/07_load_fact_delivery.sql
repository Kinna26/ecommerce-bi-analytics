-- Load delivery data into the analytics layer.

INSERT INTO analytics.fact_delivery (
    delivery_id,
    order_id,
    customer_key,
    date_key,
    delivery_partner,
    promised_days,
    actual_delivery_days,
    delivery_status
)
SELECT
    d.delivery_id,
    d.order_id,
    dc.customer_key,
    dd.date_key,
    d.delivery_partner,
    d.promised_days,
    d.actual_delivery_days,
    d.delivery_status
FROM raw.deliveries d
JOIN raw.orders o
    ON d.order_id = o.order_id
JOIN analytics.dim_customer dc
    ON o.customer_id = dc.customer_id
JOIN analytics.dim_date dd
    ON o.order_date = dd.date;