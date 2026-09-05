import os
import random
import numpy as np
import pandas as pd

random.seed(42)
np.random.seed(42)

DATA_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "data",
    "raw"
)

N_CUSTOMERS = 100_000
N_PRODUCTS = 5_000
N_ORDERS = 500_000
N_SUPPORT_TICKETS = 120_000


def generate_customers(n):
    cities = [
        ("Mumbai", "Maharashtra", "West"),
        ("Pune", "Maharashtra", "West"),
        ("Indore", "Madhya Pradesh", "Central"),
        ("Bhopal", "Madhya Pradesh", "Central"),
        ("Delhi", "Delhi", "North"),
        ("Gurugram", "Haryana", "North"),
        ("Noida", "Uttar Pradesh", "North"),
        ("Jaipur", "Rajasthan", "North"),
        ("Bengaluru", "Karnataka", "South"),
        ("Hyderabad", "Telangana", "South"),
        ("Chennai", "Tamil Nadu", "South"),
        ("Kochi", "Kerala", "South"),
        ("Kolkata", "West Bengal", "East"),
        ("Bhubaneswar", "Odisha", "East"),
        ("Ahmedabad", "Gujarat", "West"),
        ("Surat", "Gujarat", "West")
    ]

    city_probabilities = np.array([
        0.12, 0.07, 0.045, 0.035,
        0.10, 0.045, 0.045, 0.04,
        0.12, 0.07, 0.06, 0.035,
        0.07, 0.025, 0.07, 0.04
    ])

    city_probabilities /= city_probabilities.sum()

    selected_cities = np.random.choice(
        len(cities),
        size=n,
        p=city_probabilities
    )

    customer_locations = [cities[i] for i in selected_cities]

    customers = pd.DataFrame({
        "customer_id": np.arange(1, n + 1),

        "signup_date": (
            pd.Timestamp("2023-01-01")
            + pd.to_timedelta(
                np.random.randint(0, 1096, n),
                unit="D"
            )
        ),

        "city": [location[0] for location in customer_locations],
        "state": [location[1] for location in customer_locations],
        "region": [location[2] for location in customer_locations],

        "gender": np.random.choice(
            ["Female", "Male", "Other"],
            size=n,
            p=[0.48, 0.50, 0.02]
        ),

        "customer_segment": np.random.choice(
            ["Standard", "Premium", "VIP"],
            size=n,
            p=[0.72, 0.23, 0.05]
        ),

        "acquisition_channel": np.random.choice(
            [
                "Organic",
                "Paid Search",
                "Social",
                "Referral",
                "Affiliate",
                "Email"
            ],
            size=n,
            p=[0.28, 0.22, 0.18, 0.12, 0.10, 0.10]
        )
    })

    return customers


def generate_products(n):
    category_map = {
        "Electronics": [
            "Mobiles",
            "Laptops",
            "Audio",
            "Accessories"
        ],
        "Fashion": [
            "Men",
            "Women",
            "Footwear",
            "Accessories"
        ],
        "Home & Kitchen": [
            "Appliances",
            "Kitchen",
            "Decor",
            "Furniture"
        ],
        "Beauty": [
            "Skincare",
            "Haircare",
            "Makeup",
            "Personal Care"
        ],
        "Grocery": [
            "Staples",
            "Snacks",
            "Beverages",
            "Household"
        ],
        "Sports": [
            "Fitness",
            "Outdoor",
            "Team Sports",
            "Sportswear"
        ],
        "Books": [
            "Fiction",
            "Non-Fiction",
            "Academic",
            "Children"
        ],
        "Toys": [
            "Educational",
            "Games",
            "Outdoor",
            "Collectibles"
        ]
    }

    categories = list(category_map.keys())

    category_probabilities = [
        0.17, 0.18, 0.16, 0.12,
        0.14, 0.09, 0.07, 0.07
    ]

    selected_categories = np.random.choice(
        categories,
        size=n,
        p=category_probabilities
    )

    selected_subcategories = [
        random.choice(category_map[category])
        for category in selected_categories
    ]

    brands = [
        "Nova",
        "UrbanX",
        "Prime",
        "Astra",
        "Zen",
        "Orion",
        "Vivo",
        "Apex",
        "FreshCo",
        "Vertex"
    ]

    selected_brands = np.random.choice(
        brands,
        size=n
    )

    # Product prices are right-skewed, similar to what we would
    # normally see in an e-commerce catalog.
    unit_prices = np.round(
        np.exp(
            np.random.normal(
                np.log(900),
                0.9,
                n
            )
        ),
        2
    )

    cost_prices = np.round(
        unit_prices * np.random.uniform(0.52, 0.82, n),
        2
    )

    products = pd.DataFrame({
        "product_id": np.arange(1, n + 1),

        "product_name": [
            f"{brand} {subcategory} Item {i}"
            for i, (brand, subcategory) in enumerate(
                zip(selected_brands, selected_subcategories),
                start=1
            )
        ],

        "category": selected_categories,
        "sub_category": selected_subcategories,
        "brand": selected_brands,
        "unit_price": unit_prices,
        "cost_price": cost_prices
    })

    return products


def generate_orders(n, customers):
    dates = pd.date_range(
        "2024-01-01",
        "2025-12-31",
        freq="D"
    )

    # Start with equal probability for each day.
    date_weights = np.ones(len(dates))

    # Weekend demand is slightly higher.
    date_weights *= np.where(
        dates.dayofweek >= 5,
        1.08,
        1.0
    )

    # Festive season gets higher demand.
    date_weights *= np.where(
        dates.month.isin([10, 11, 12]),
        1.12,
        1.0
    )

    # Business incident: checkout problems during May 2025.
    date_weights *= np.where(
        (dates >= "2025-05-01") &
        (dates <= "2025-05-31"),
        0.78,
        1.0
    )

    date_weights /= date_weights.sum()

    order_dates = np.random.choice(
        dates,
        size=n,
        p=date_weights
    )

    customer_ids = np.random.choice(
        customers["customer_id"],
        size=n
    )

    return pd.DataFrame({
        "order_id": np.arange(1, n + 1),
        "customer_id": customer_ids,
        "order_date": pd.to_datetime(order_dates)
    })


def generate_order_items(orders, products):
    # Most orders contain 1-3 products.
    item_counts = np.random.choice(
        [1, 2, 3, 4],
        size=len(orders),
        p=[0.60, 0.25, 0.11, 0.04]
    )

    order_ids = np.repeat(
        orders["order_id"].values,
        item_counts
    )

    product_ids = np.random.randint(
        1,
        len(products) + 1,
        size=len(order_ids)
    )

    quantities = np.random.choice(
        [1, 2, 3, 4],
        size=len(order_ids),
        p=[0.62, 0.25, 0.10, 0.03]
    )

    price_lookup = products.set_index("product_id")["unit_price"]

    unit_prices = price_lookup.reindex(
        product_ids
    ).to_numpy()

    discount_rates = np.random.choice(
        [0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30],
        size=len(order_ids),
        p=[0.38, 0.16, 0.18, 0.12, 0.08, 0.05, 0.03]
    )

    gross_amount = unit_prices * quantities

    discount_amount = np.round(
        gross_amount * discount_rates,
        2
    )

    line_revenue = np.round(
        gross_amount - discount_amount,
        2
    )

    order_items = pd.DataFrame({
        "order_item_id": np.arange(1, len(order_ids) + 1),
        "order_id": order_ids,
        "product_id": product_ids,
        "quantity": quantities,
        "unit_price": unit_prices,
        "discount_amount": discount_amount,
        "line_revenue": line_revenue
    })

    return order_items


def add_order_details(orders, order_items):
    # Aggregate item-level values back to the order level.
    order_totals = (
        order_items
        .groupby("order_id")
        .agg(
            gross_amount=("unit_price", lambda x: 0),
            discount_amount=("discount_amount", "sum"),
            revenue=("line_revenue", "sum")
        )
        .reset_index()
    )

    # Gross amount is easier to calculate from item price * quantity.
    gross_by_order = (
        order_items
        .assign(
            gross_line_amount=lambda x:
                x["unit_price"] * x["quantity"]
        )
        .groupby("order_id")["gross_line_amount"]
        .sum()
        .reset_index(name="gross_amount")
    )

    order_totals = order_totals.drop(
        columns=["gross_amount"]
    ).merge(
        gross_by_order,
        on="order_id"
    )

    orders = orders.merge(
        order_totals,
        on="order_id",
        how="left"
    )

    orders["order_status"] = np.random.choice(
        [
            "Delivered",
            "Cancelled",
            "Returned",
            "Failed"
        ],
        size=len(orders),
        p=[0.89, 0.045, 0.04, 0.025]
    )

    may_2025 = (
        (orders["order_date"] >= "2025-05-01") &
        (orders["order_date"] <= "2025-05-31")
    )

    # The incident also affects cancellations and failed orders.
    orders.loc[may_2025, "order_status"] = np.random.choice(
        [
            "Delivered",
            "Cancelled",
            "Returned",
            "Failed"
        ],
        size=may_2025.sum(),
        p=[0.82, 0.09, 0.045, 0.045]
    )

    orders["payment_method"] = np.random.choice(
        [
            "UPI",
            "Credit Card",
            "Debit Card",
            "Net Banking",
            "Wallet",
            "COD"
        ],
        size=len(orders),
        p=[0.42, 0.22, 0.12, 0.10, 0.08, 0.06]
    )

    orders["payment_status"] = np.where(
        orders["order_status"] == "Failed",
        "Failed",
        np.where(
            np.random.random(len(orders)) < 0.025,
            "Failed",
            "Paid"
        )
    )

    # Payment failures are intentionally higher during the incident.
    may_failure = (
        may_2025 &
        (np.random.random(len(orders)) < 0.10)
    )

    orders.loc[may_failure, "payment_status"] = "Failed"

    return orders


def generate_payments(orders):
    payments = pd.DataFrame({
        "payment_id": np.arange(1, len(orders) + 1),
        "order_id": orders["order_id"],
        "payment_date": orders["order_date"],
        "payment_method": orders["payment_method"],
        "amount": orders["revenue"],
        "payment_status": orders["payment_status"]
    })

    payments["transaction_id"] = [
        f"TXN{i:09d}"
        for i in payments["payment_id"]
    ]

    return payments


def generate_deliveries(orders):
    n = len(orders)

    promised_days = np.random.choice(
        [1, 2, 3, 4, 5],
        size=n,
        p=[0.08, 0.28, 0.38, 0.20, 0.06]
    )

    actual_days = np.clip(
        np.random.normal(2.8, 1.3, n),
        0.5,
        9
    )

    delivery_status = np.where(
        orders["order_status"] == "Delivered",
        np.where(
            actual_days <= promised_days,
            "On Time",
            "Late"
        ),
        "Not Delivered"
    )

    return pd.DataFrame({
        "delivery_id": np.arange(1, n + 1),
        "order_id": orders["order_id"],
        "delivery_partner": np.random.choice(
            [
                "Delhivery",
                "Ecom Express",
                "BlueDart",
                "XpressBees",
                "In-house"
            ],
            size=n
        ),
        "promised_days": promised_days,
        "actual_delivery_days": np.round(actual_days, 1),
        "delivery_status": delivery_status
    })


def generate_campaigns():
    return pd.DataFrame({
        "campaign_id": range(1, 7),
        "campaign_name": [
            "Summer Sale",
            "Festive Mega Sale",
            "New User Boost",
            "Winback",
            "Weekend Flash",
            "Search Always-On"
        ],
        "channel": [
            "Paid Search",
            "Paid Social",
            "Affiliate",
            "Email",
            "Paid Social",
            "Paid Search"
        ],
        "start_date": pd.to_datetime([
            "2024-04-01",
            "2024-10-01",
            "2025-01-01",
            "2025-02-01",
            "2025-05-01",
            "2024-01-01"
        ]),
        "end_date": pd.to_datetime([
            "2024-05-31",
            "2024-11-30",
            "2025-03-31",
            "2025-12-31",
            "2025-05-31",
            "2025-12-31"
        ]),
        "budget": [
            2_500_000,
            5_000_000,
            1_800_000,
            1_200_000,
            3_500_000,
            6_500_000
        ]
    })


def generate_marketing_performance(campaigns):
    rows = []

    for campaign in campaigns.itertuples(index=False):
        campaign_dates = pd.date_range(
            campaign.start_date,
            campaign.end_date
        )

        daily_budget = campaign.budget / len(campaign_dates)

        spend = np.maximum(
            5_000,
            np.random.normal(
                daily_budget,
                daily_budget * 0.18,
                len(campaign_dates)
            )
        )

        impressions = (
            spend *
            np.random.uniform(18, 35, len(campaign_dates))
        ).astype(int)

        clicks = (
            impressions *
            np.random.uniform(0.012, 0.045, len(campaign_dates))
        ).astype(int)

        conversions = (
            clicks *
            np.random.uniform(0.03, 0.11, len(campaign_dates))
        ).astype(int)

        campaign_data = pd.DataFrame({
            "campaign_id": campaign.campaign_id,
            "date": campaign_dates,
            "spend": np.round(spend, 2),
            "impressions": impressions,
            "clicks": clicks,
            "conversions": conversions
        })

        rows.append(campaign_data)

    marketing = pd.concat(
        rows,
        ignore_index=True
    )

    marketing.insert(
        0,
        "performance_id",
        np.arange(1, len(marketing) + 1)
    )

    return marketing


def generate_support_tickets(orders, n):
    ticket_order_ids = np.random.choice(
        orders["order_id"],
        size=n
    )

    order_dates = orders.set_index(
        "order_id"
    )["order_date"]

    ticket_dates = (
        order_dates
        .reindex(ticket_order_ids)
        .reset_index(drop=True)
        + pd.to_timedelta(
            np.random.randint(0, 15, n),
            unit="D"
        )
    )

    ticket_dates = ticket_dates.clip(
        lower=pd.Timestamp("2024-01-01"),
        upper=pd.Timestamp("2025-12-31")
    )

    return pd.DataFrame({
        "ticket_id": np.arange(1, n + 1),
        "order_id": ticket_order_ids,
        "ticket_date": ticket_dates,
        "issue_type": np.random.choice(
            [
                "Delivery Delay",
                "Payment Issue",
                "Refund",
                "Product Quality",
                "Wrong Item",
                "Cancellation",
                "Other"
            ],
            size=n,
            p=[0.25, 0.15, 0.17, 0.12, 0.10, 0.12, 0.09]
        ),
        "priority": np.random.choice(
            ["Low", "Medium", "High"],
            size=n,
            p=[0.45, 0.43, 0.12]
        ),
        "resolution_hours": np.round(
            np.clip(
                np.random.gamma(2.2, 10, n),
                1,
                240
            ),
            1
        ),
        "csat": np.random.choice(
            [1, 2, 3, 4, 5],
            size=n,
            p=[0.04, 0.08, 0.18, 0.36, 0.34]
        )
    })


def save_data(dataframes):
    os.makedirs(DATA_DIR, exist_ok=True)

    for name, df in dataframes.items():
        path = os.path.join(
            DATA_DIR,
            f"{name}.csv"
        )

        df.to_csv(
            path,
            index=False
        )

        print(f"{name}: {len(df):,} rows")


def main():
    print("Generating ShopSphere dataset...\n")

    customers = generate_customers(N_CUSTOMERS)
    products = generate_products(N_PRODUCTS)

    orders = generate_orders(
        N_ORDERS,
        customers
    )

    order_items = generate_order_items(
        orders,
        products
    )

    orders = add_order_details(
        orders,
        order_items
    )

    payments = generate_payments(orders)

    deliveries = generate_deliveries(orders)

    campaigns = generate_campaigns()

    marketing = generate_marketing_performance(
        campaigns
    )

    support = generate_support_tickets(
        orders,
        N_SUPPORT_TICKETS
    )

    dataframes = {
        "customers": customers,
        "products": products,
        "orders": orders,
        "order_items": order_items,
        "payments": payments,
        "deliveries": deliveries,
        "marketing_campaigns": campaigns,
        "marketing_performance": marketing,
        "support_tickets": support
    }

    save_data(dataframes)

    print("\nDataset generation completed.")


if __name__ == "__main__":
    main()