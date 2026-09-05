-- Inserting Raw Data into the analytical Tables

INSERT INTO analytics.dim_customer (
    customer_id,
    signup_date,
    city,
    state,
    region,
    gender,
    customer_segment,
    acquisition_channel
)
SELECT
    customer_id,
    signup_date,
    city,
    state,
    region,
    gender,
    customer_segment,
    acquisition_channel
FROM raw.customers;


INSERT INTO analytics.dim_product (
    product_id,
    product_name,
    category,
    sub_category,
    brand,
    unit_price,
    cost_price
)
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    brand,
    unit_price,
    cost_price
FROM raw.products;


INSERT INTO analytics.dim_campaign (
    campaign_id,
    campaign_name,
    channel,
    start_date,
    end_date,
    budget
)
SELECT
    campaign_id,
    campaign_name,
    channel,
    start_date,
    end_date,
    budget
FROM raw.marketing_campaigns;

INSERT INTO analytics.dim_date (
    date_key,
    date,
    year,
    quarter,
    month,
    month_name,
    week,
    day,
    day_name,
    is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d::DATE AS date,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(QUARTER FROM d)::INT AS quarter,
    EXTRACT(MONTH FROM d)::INT AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(WEEK FROM d)::INT AS week,
    EXTRACT(DAY FROM d)::INT AS day,
    TO_CHAR(d, 'Day') AS day_name,
    EXTRACT(ISODOW FROM d) IN (6, 7) AS is_weekend
FROM generate_series(
    '2024-01-01'::DATE,
    '2025-12-31'::DATE,
    '1 day'
) AS d;

