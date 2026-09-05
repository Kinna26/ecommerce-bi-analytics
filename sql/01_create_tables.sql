-- Source tables for the ShopSphere project.

CREATE TABLE raw.customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    gender VARCHAR(20),
    customer_segment VARCHAR(30),
    acquisition_channel VARCHAR(50)
);


-- Product master data.

CREATE TABLE raw.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    unit_price DECIMAL(12, 2),
    cost_price DECIMAL(12, 2)
);


-- One row represents one order.

CREATE TABLE raw.orders (
    order_id BIGINT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(30),
    gross_amount DECIMAL(14, 2),
    discount_amount DECIMAL(14, 2),
    revenue DECIMAL(14, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES raw.customers(customer_id)
);


-- An order can contain multiple products.

CREATE TABLE raw.order_items (
    order_item_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2),
    discount_amount DECIMAL(12, 2),
    line_revenue DECIMAL(14, 2),

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES raw.products(product_id)
);


-- Keep payment attempts separate from the order.

CREATE TABLE raw.payments (
    payment_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    amount DECIMAL(14, 2),
    payment_status VARCHAR(30),
    transaction_id VARCHAR(100),

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);


-- Delivery information for each order.

CREATE TABLE raw.deliveries (
    delivery_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    delivery_partner VARCHAR(100),
    promised_days INT,
    actual_delivery_days DECIMAL(6, 2),
    delivery_status VARCHAR(30),

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);


-- Marketing campaign master data.

CREATE TABLE raw.marketing_campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(150) NOT NULL,
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(14, 2)
);


-- Daily performance for each marketing campaign.

CREATE TABLE raw.marketing_performance (
    performance_id BIGINT PRIMARY KEY,
    campaign_id INT NOT NULL,
    date DATE NOT NULL,
    spend DECIMAL(14, 2),
    impressions BIGINT,
    clicks BIGINT,
    conversions BIGINT,

    FOREIGN KEY (campaign_id)
        REFERENCES raw.marketing_campaigns(campaign_id)
);


-- Customer support tickets linked to orders.

CREATE TABLE raw.support_tickets (
    ticket_id BIGINT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    ticket_date DATE,
    issue_type VARCHAR(100),
    priority VARCHAR(30),
    resolution_hours DECIMAL(8, 2),
    csat INT,

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);


-- Indexes for common joins and date filters.

CREATE INDEX idx_orders_customer
    ON raw.orders(customer_id);

CREATE INDEX idx_orders_date
    ON raw.orders(order_date);

CREATE INDEX idx_order_items_order
    ON raw.order_items(order_id);

CREATE INDEX idx_order_items_product
    ON raw.order_items(product_id);

CREATE INDEX idx_payments_order
    ON raw.payments(order_id);

CREATE INDEX idx_deliveries_order
    ON raw.deliveries(order_id);

CREATE INDEX idx_marketing_campaign
    ON raw.marketing_performance(campaign_id);

CREATE INDEX idx_marketing_date
    ON raw.marketing_performance(date);

CREATE INDEX idx_support_order
    ON raw.support_tickets(order_id);

CREATE INDEX idx_support_date
    ON raw.support_tickets(ticket_date);