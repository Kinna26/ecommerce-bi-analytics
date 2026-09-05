-- RCA 1: May 2025 vs May 2024
-- Compares sales performance to identify the main driver of the revenue decline.

SELECT
    d.year,
    d.month,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_units,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS aov
FROM analytics.fact_sales f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY d.year, d.month
ORDER BY d.year;

-- RCA 2: Customer segment contribution
-- Compares May 2024 and May 2025 performance across customer segments.

SELECT
    c.customer_segment,
    d.year,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_units,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS aov
FROM analytics.fact_sales f
JOIN analytics.dim_customer c
    ON f.customer_key = c.customer_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY c.customer_segment, d.year
ORDER BY c.customer_segment, d.year;


-- RCA 3: Product category contribution
-- Compares May 2024 and May 2025 performance across product categories.

SELECT
    p.category,
    d.year,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_units,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS aov
FROM analytics.fact_sales f
JOIN analytics.dim_product p
    ON f.product_key = p.product_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY p.category, d.year
ORDER BY p.category, d.year;


-- RCA 4: Geographic contribution
-- Compares May 2024 and May 2025 sales performance across states.

SELECT
    c.state,
    d.year,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_units,
    ROUND(SUM(f.revenue), 2) AS total_revenue,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS aov
FROM analytics.fact_sales f
JOIN analytics.dim_customer c
    ON f.customer_key = c.customer_key
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY c.state, d.year
ORDER BY c.state, d.year;

-- RCA 5: Customer activity
-- Compares the number of active customers and their purchasing behavior in May.

SELECT
    d.year,
    COUNT(DISTINCT f.customer_key) AS active_customers,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT f.order_id) * 1.0 / NULLIF(COUNT(DISTINCT f.customer_key), 0), 2) AS orders_per_customer,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.customer_key), 0), 2) AS revenue_per_customer,
    ROUND(SUM(f.revenue) / NULLIF(COUNT(DISTINCT f.order_id), 0), 2) AS aov
FROM analytics.fact_sales f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY d.year
ORDER BY d.year;

-- RCA 6: Order status analysis
-- Compares order volume and revenue by order status in May.

SELECT
    o.order_status,
    EXTRACT(YEAR FROM o.order_date) AS year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.revenue), 2) AS total_revenue
FROM raw.orders o
WHERE EXTRACT(MONTH FROM o.order_date) = 5
  AND EXTRACT(YEAR FROM o.order_date) IN (2024, 2025)
GROUP BY o.order_status, EXTRACT(YEAR FROM o.order_date)
ORDER BY o.order_status, year;

-- RCA 7: Cancellation and delivery rate
-- Compares cancellation and delivery rates between May 2024 and May 2025.

SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN order_status = 'Cancelled' THEN order_id END) AS cancelled_orders,
    ROUND(COUNT(DISTINCT CASE WHEN order_status = 'Cancelled' THEN order_id END) * 100.0 / COUNT(DISTINCT order_id), 2) AS cancellation_rate,
    COUNT(DISTINCT CASE WHEN order_status = 'Delivered' THEN order_id END) AS delivered_orders,
    ROUND(COUNT(DISTINCT CASE WHEN order_status = 'Delivered' THEN order_id END) * 100.0 / COUNT(DISTINCT order_id), 2) AS delivery_rate
FROM raw.orders
WHERE EXTRACT(MONTH FROM order_date) = 5
  AND EXTRACT(YEAR FROM order_date) IN (2024, 2025)
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

-- RCA 8: Payment failure rate
-- Compares payment failures and transaction performance between May 2024 and May 2025.

SELECT
    d.year,
    COUNT(f.payment_id) AS total_transactions,
    COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) AS failed_transactions,
    ROUND(COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) * 100.0 / COUNT(f.payment_id), 2) AS failure_rate,
    ROUND(SUM(f.amount), 2) AS total_amount
FROM analytics.fact_payments f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY d.year
ORDER BY d.year;


-- RCA 9: Failed payments and cancelled orders
-- Checks the relationship between payment failures and order cancellations in May.

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    COUNT(DISTINCT o.order_id) AS cancelled_orders,
    COUNT(DISTINCT CASE WHEN p.payment_status = 'Failed' THEN o.order_id END) AS cancelled_with_failed_payment,
    ROUND(COUNT(DISTINCT CASE WHEN p.payment_status = 'Failed' THEN o.order_id END) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS failed_payment_share
FROM raw.orders o
LEFT JOIN analytics.fact_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'Cancelled'
  AND EXTRACT(MONTH FROM o.order_date) = 5
  AND EXTRACT(YEAR FROM o.order_date) IN (2024, 2025)
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY year;


-- RCA 10: Payment failure by payment method
-- Identifies payment methods with unusually high failure rates in May.

SELECT
    f.payment_method,
    d.year,
    COUNT(f.payment_id) AS total_transactions,
    COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) AS failed_transactions,
    ROUND(COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) * 100.0 / COUNT(f.payment_id), 2) AS failure_rate,
    ROUND(SUM(f.amount), 2) AS total_amount
FROM analytics.fact_payments f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY f.payment_method, d.year
ORDER BY f.payment_method, d.year;

-- RCA 11: Monthly payment failure trend
-- Tracks payment failure rate over time to identify when the issue started.

SELECT
    d.year,
    d.month,
    COUNT(f.payment_id) AS total_transactions,
    COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) AS failed_transactions,
    ROUND(COUNT(CASE WHEN f.payment_status = 'Failed' THEN f.payment_id END) * 100.0 / COUNT(f.payment_id), 2) AS failure_rate
FROM analytics.fact_payments f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
GROUP BY d.year, d.month
ORDER BY d.year, d.month;

-- RCA 12: Potential revenue exposure from failed payments
-- Estimates the payment value potentially affected by failed transactions in May.

SELECT
    d.year,
    COUNT(f.payment_id) AS failed_transactions,
    ROUND(SUM(f.amount), 2) AS failed_payment_amount,
    ROUND(AVG(f.amount), 2) AS avg_failed_payment_value
FROM analytics.fact_payments f
JOIN analytics.dim_date d
    ON f.date_key = d.date_key
WHERE f.payment_status = 'Failed'
  AND d.month = 5
  AND d.year IN (2024, 2025)
GROUP BY d.year
ORDER BY d.year;


-- RCA 13: Payment failure exposure vs revenue decline
-- Compares the increase in failed payment value with the overall revenue decline.

WITH payment_failure AS (
    SELECT
        d.year,
        SUM(f.amount) AS failed_payment_amount
    FROM analytics.fact_payments f
    JOIN analytics.dim_date d
        ON f.date_key = d.date_key
    WHERE f.payment_status = 'Failed'
      AND d.month = 5
      AND d.year IN (2024, 2025)
    GROUP BY d.year
),
sales AS (
    SELECT
        d.year,
        SUM(f.revenue) AS revenue
    FROM analytics.fact_sales f
    JOIN analytics.dim_date d
        ON f.date_key = d.date_key
    WHERE d.month = 5
      AND d.year IN (2024, 2025)
    GROUP BY d.year
)
SELECT
    ROUND(s2024.revenue - s2025.revenue, 2) AS revenue_decline,
    ROUND(p2025.failed_payment_amount - p2024.failed_payment_amount, 2) AS additional_failed_payment_exposure,
    ROUND((p2025.failed_payment_amount - p2024.failed_payment_amount) * 100.0 / NULLIF(s2024.revenue - s2025.revenue, 0), 2) AS exposure_vs_revenue_decline_pct
FROM sales s2024
JOIN sales s2025 ON s2024.year = 2024 AND s2025.year = 2025
JOIN payment_failure p2024 ON p2024.year = 2024
JOIN payment_failure p2025 ON p2025.year = 2025;





--## Key Findings

* Orders declined by **22.2%**, while AOV declined only **2.5%**, showing that the decline was mainly volume-driven.
* Active customers declined by 20.2%.
* The decline was broad-based across **customer segments, product categories and states**.
* Cancellation rate increased from 4.36% to 9.26%.
* Payment failure rate increased sharply from **5.13% to 16.42%**.
* All payment methods showed a similar increase in failure rate, indicating a likely **system-wide payment issue**.
* Cancelled orders associated with failed payments increased from **3.30% to 11.93%**.
* Failed-payment value increased by approximately **₹4.57M**, equivalent to **30.54% of the revenue decline**.

-- RCA Conclusion

The May 2025 revenue decline appears to have been significantly influenced by a **temporary system-wide payment-processing issue**, which coincided with higher payment failures, increased cancellations and lower completed orders.

The payment failure rate returned to normal in June 2025, supporting the conclusion that the issue was temporary.
