--
-- SHOPSPHERE BUSINESS KPIs


-- 1. Overall Sales KPIs
-- Business Question:
-- What is the overall sales performance of ShopSphere?

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100,2) AS profit_margin,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0),2) AS aov
FROM analytics.fact_sales;

-- 2. Monthly Sales KPIs
-- Business Question:
-- How does sales performance change over time?

SELECT
    d.year,
    d.month,
    COUNT(DISTINCT f.order_id) AS orders,
    SUM(f.quantity) AS units,
    ROUND(SUM(f.revenue), 2) AS revenue,
    ROUND(SUM(f.cost), 2) AS cost,
    ROUND(SUM(f.profit), 2) AS profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.revenue), 0) * 100, 2) AS profit_margin
FROM analytics.fact_sales f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month
ORDER BY
    d.year,
    d.month;


-- 3. Sales Performance by Customer Segment
-- Business Question:
-- How much revenue and profit does each customer segment generate?


SELECT
    c.customer_segment AS customer_segment,
    COUNT(DISTINCT s.order_id) AS total_orders,
    ROUND(SUM(s.revenue), 2) AS total_revenue,
    ROUND(SUM(s.profit), 2) AS total_profit,
    ROUND(SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100,) AS profit_margin
FROM analytics.dim_customer AS c
LEFT JOIN analytics.fact_sales AS s
    ON c.customer_key = s.customer_key
GROUP BY
    c.customer_segment
ORDER BY
    total_revenue DESC;

-- KPI 4: Sales performance by product category
-- Shows units sold, revenue, profit and profit margin for each category.

SELECT
    p.category AS product_category,
    SUM(s.quantity) AS total_units,
    ROUND(SUM(s.revenue), 2) AS total_revenue,
    ROUND(SUM(s.profit), 2) AS total_profit,
    ROUND( SUM(s.profit) / NULLIF(SUM(s.revenue), 0) * 100, 2) AS profit_margin
FROM analytics.dim_product AS p
LEFT JOIN analytics.fact_sales AS s
    ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_revenue DESC, total_profit DESC;

-- KPI 5: Payment performance by payment method
-- Shows transaction frequency, total payment amount and transaction share.

SELECT
    payment_method AS payment_method,
    COUNT(payment_id) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(COUNT(payment_id) * 100.0 / SUM(COUNT(payment_id)) OVER (), 2) AS transaction_share_pct
FROM analytics.fact_payments
GROUP BY payment_method
ORDER BY total_transactions DESC;


-- KPI 6: Payment status performance
-- Shows payment transactions and total amount by payment status.

SELECT
    payment_status,
    COUNT(payment_id) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(COUNT(payment_id) * 100.0 / SUM(COUNT(payment_id)) OVER (), 2) AS transaction_share_pct
FROM analytics.fact_payments
GROUP BY payment_status
ORDER BY total_transactions DESC;

-- KPI 7: Delivery performance
-- Shows delivery volume and average delivery time by status.

SELECT
    delivery_status,
    COUNT(delivery_id) AS total_deliveries,
    ROUND(AVG(actual_delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(promised_days), 2) AS avg_promised_days
FROM analytics.fact_delivery
GROUP BY delivery_status
ORDER BY total_deliveries DESC;

-- KPI 8: Overall marketing performance
-- Shows total spend, impressions, clicks and conversions.

SELECT
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 2) AS ctr,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(spend) / NULLIF(SUM(clicks), 0), 2) AS cpc,
    ROUND(SUM(spend) / NULLIF(SUM(conversions), 0), 2) AS cpa
FROM analytics.fact_marketing;


-- KPI 9: Marketing performance by campaign
-- Compares spend, clicks and conversions across campaigns.

SELECT
    c.campaign_name,
    c.channel,
    ROUND(SUM(f.spend), 2) AS total_spend,
    SUM(f.impressions) AS total_impressions,
    SUM(f.clicks) AS total_clicks,
    SUM(f.conversions) AS total_conversions,
    ROUND(SUM(f.clicks) * 100.0 / NULLIF(SUM(f.impressions), 0), 2) AS ctr,
    ROUND(SUM(f.conversions) * 100.0 / NULLIF(SUM(f.clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(f.spend) / NULLIF(SUM(f.conversions), 0), 2) AS cpa
FROM analytics.fact_marketing f
JOIN analytics.dim_campaign c
    ON f.campaign_key = c.campaign_key
GROUP BY c.campaign_name, c.channel
ORDER BY total_conversions DESC;

-- KPI 10: Customer support performance
-- Shows ticket volume, average resolution time and CSAT by issue type.

SELECT
    issue_type,
    COUNT(ticket_id) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(satisfaction_score), 2) AS avg_csat
FROM analytics.fact_support
GROUP BY issue_type
ORDER BY total_tickets DESC;


-- KPI 11: Support performance by priority
-- Helps identify workload and service quality across ticket priorities.

SELECT
    priority,
    COUNT(ticket_id) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(satisfaction_score), 2) AS avg_csat
FROM analytics.fact_support
GROUP BY priority
ORDER BY total_tickets DESC;