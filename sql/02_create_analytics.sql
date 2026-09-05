-- Analytical Tables for the Analysis purpose

CREATE TABLE analytics.dim_date (
    date_key INT PRIMARY KEY,
    date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    week INT NOT NULL,
    day INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE analytics.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    signup_date DATE,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    gender VARCHAR(20),
    customer_segment VARCHAR(30),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE analytics.dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(200),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    unit_price DECIMAL(12, 2),
    cost_price DECIMAL(12, 2)
);

CREATE TABLE analytics.dim_campaign (
    campaign_key SERIAL PRIMARY KEY,
    campaign_id INT NOT NULL,
    campaign_name VARCHAR(150),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(14, 2)
);





