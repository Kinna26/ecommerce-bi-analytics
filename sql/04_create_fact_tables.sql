-- Sales fact table.
-- One row represents one product line within an order.

CREATE TABLE analytics.fact_sales (
    sales_key BIGSERIAL PRIMARY KEY,

    order_id BIGINT NOT NULL,
    order_item_id BIGINT NOT NULL,

    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    date_key INT NOT NULL,

    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2),
    gross_amount DECIMAL(14, 2),
    discount_amount DECIMAL(14, 2),
    revenue DECIMAL(14, 2),
    cost DECIMAL(14, 2),
    profit DECIMAL(14, 2)
);

-- One row represents one payment transaction.

CREATE TABLE analytics.fact_payments (
    payment_key BIGSERIAL PRIMARY KEY,

    payment_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,

    customer_key INT NOT NULL,
    date_key INT NOT NULL,

    payment_method VARCHAR(50),
    payment_status VARCHAR(50),

    amount DECIMAL(14, 2)
);


-- One row represents one delivery event.

CREATE TABLE analytics.fact_delivery (
    delivery_key BIGSERIAL PRIMARY KEY,

    delivery_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,

    customer_key INT NOT NULL,
    date_key INT NOT NULL,

    delivery_partner VARCHAR(100),
    promised_days INT,
    actual_delivery_days INT,
    delivery_status VARCHAR(50)
);


-- One row represents the performance of one campaign on one day.

CREATE TABLE analytics.fact_marketing (
    marketing_key BIGSERIAL PRIMARY KEY,

    campaign_key INT NOT NULL,
    date_key INT NOT NULL,

    spend DECIMAL(14, 2),
    impressions BIGINT,
    clicks BIGINT,
    conversions INT,
    revenue DECIMAL(14, 2)
);

-- One row represents one customer support ticket.

CREATE TABLE analytics.fact_support (
    ticket_key BIGSERIAL PRIMARY KEY,

    ticket_id BIGINT NOT NULL,
    order_id BIGINT,

    customer_key INT NOT NULL,
    date_key INT NOT NULL,

    issue_type VARCHAR(100),
    priority VARCHAR(30),
    resolution_time_hours DECIMAL(10, 2),
    satisfaction_score DECIMAL(5, 2),
    ticket_status VARCHAR(50)
);