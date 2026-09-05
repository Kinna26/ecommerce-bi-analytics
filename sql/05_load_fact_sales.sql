-- Build the sales fact at order-item level.

INSERT INTO analytics.fact_sales (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    date_key,
    quantity,
    unit_price,
    gross_amount,
    discount_amount,
    revenue,
    cost,
    profit
)
SELECT
    o.order_id,
    oi.order_item_id,

    dc.customer_key,
    dp.product_key,

    dd.date_key,

    oi.quantity,
    oi.unit_price,

    oi.unit_price * oi.quantity AS gross_amount,

    oi.discount_amount,

    oi.line_revenue AS revenue,

    oi.quantity * dp.cost_price AS cost,

    oi.line_revenue -
        (oi.quantity * dp.cost_price) AS profit

FROM raw.order_items oi

JOIN raw.orders o
    ON oi.order_id = o.order_id

JOIN analytics.dim_customer dc
    ON o.customer_id = dc.customer_id

JOIN analytics.dim_product dp
    ON oi.product_id = dp.product_id

JOIN analytics.dim_date dd
    ON o.order_date = dd.date;