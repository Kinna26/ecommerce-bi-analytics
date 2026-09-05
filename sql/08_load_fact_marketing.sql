-- Load daily marketing performance into the analytics layer.

INSERT INTO analytics.fact_marketing (
    campaign_key,
    date_key,
    spend,
    impressions,
    clicks,
    conversions
)
SELECT
    dc.campaign_key,
    dd.date_key,
    mp.spend,
    mp.impressions,
    mp.clicks,
    mp.conversions
FROM raw.marketing_performance mp
JOIN analytics.dim_campaign dc
    ON mp.campaign_id = dc.campaign_id
JOIN analytics.dim_date dd
    ON mp.date = dd.date;