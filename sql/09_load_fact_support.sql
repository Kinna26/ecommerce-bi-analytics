-- Load support tickets into the analytics layer.

INSERT INTO analytics.fact_support (
    ticket_id,
    order_id,
    customer_key,
    date_key,
    issue_type,
    priority,
    resolution_time_hours,
    satisfaction_score
)
SELECT
    s.ticket_id,
    s.order_id,
    dc.customer_key,
    dd.date_key,
    s.issue_type,
    s.priority,
    s.resolution_hours,
    s.csat
FROM raw.support_tickets s
JOIN raw.orders o
    ON s.order_id = o.order_id
JOIN analytics.dim_customer dc
    ON o.customer_id = dc.customer_id
JOIN analytics.dim_date dd
    ON s.ticket_date = dd.date;