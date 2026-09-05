import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from scipy.stats import ttest_ind, mannwhitneyu


# Load order data
df = pd.read_csv("../data/raw/orders.csv")

df["order_date"] = pd.to_datetime(df["order_date"])


# Create May 2024 and May 2025 datasets
may_2024 = df[
    (df["order_date"].dt.year == 2024) &
    (df["order_date"].dt.month == 5)
]

may_2025 = df[
    (df["order_date"].dt.year == 2025) &
    (df["order_date"].dt.month == 5)
]


# Calculate AOV
aov_2024 = may_2024["revenue"].mean()
aov_2025 = may_2025["revenue"].mean()

aov_change = ((aov_2025 - aov_2024) / aov_2024) * 100

print("\nAOV Comparison")
print(f"May 2024 AOV: ₹{aov_2024:,.2f}")
print(f"May 2025 AOV: ₹{aov_2025:,.2f}")
print(f"AOV change: {aov_change:.2f}%")


# Compare order value distributions
plt.figure(figsize=(10, 6))

sns.histplot(
    may_2024["revenue"],
    bins=50,
    kde=True,
    label="May 2024"
)

sns.histplot(
    may_2025["revenue"],
    bins=50,
    kde=True,
    label="May 2025"
)

plt.title("Order Value Distribution: May 2024 vs May 2025")
plt.xlabel("Order Value")
plt.ylabel("Number of Orders")
plt.legend()

plt.tight_layout()
plt.show()


# Compare mean and median
print("\nMean vs Median")
print(f"May 2024 mean: ₹{may_2024['revenue'].mean():,.2f}")
print(f"May 2024 median: ₹{may_2024['revenue'].median():,.2f}")
print(f"May 2025 mean: ₹{may_2025['revenue'].mean():,.2f}")
print(f"May 2025 median: ₹{may_2025['revenue'].median():,.2f}")


# Test whether the difference in AOV is statistically significant
t_stat, p_value = ttest_ind(
    may_2024["revenue"],
    may_2025["revenue"],
    equal_var=False
)

print("\nWelch's t-test")
print(f"T-statistic: {t_stat:.2f}")
print(f"P-value: {p_value:.6f}")


# Non-parametric test for the skewed distribution
u_stat, mw_p_value = mannwhitneyu(
    may_2024["revenue"],
    may_2025["revenue"],
    alternative="two-sided"
)

print("\nMann-Whitney U test")
print(f"U-statistic: {u_stat:.2f}")
print(f"P-value: {mw_p_value:.6f}")


# Monthly revenue trend
monthly_revenue = (
    df.groupby(df["order_date"].dt.to_period("M"))["revenue"]
    .sum()
    .reset_index()
)

monthly_revenue["order_date"] = monthly_revenue["order_date"].dt.to_timestamp()


# Plot monthly revenue trend
plt.figure(figsize=(12, 6))

sns.lineplot(
    data=monthly_revenue,
    x="order_date",
    y="revenue"
)

plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")

plt.xticks(rotation=45)
plt.tight_layout()
plt.show()


# Monthly order volume
monthly_orders = (
    df.groupby(df["order_date"].dt.to_period("M"))
    .size()
    .reset_index(name="orders")
)

monthly_orders["order_date"] = monthly_orders["order_date"].dt.to_timestamp()


# Plot monthly order volume
plt.figure(figsize=(12, 6))

sns.lineplot(
    data=monthly_orders,
    x="order_date",
    y="orders"
)

plt.title("Monthly Order Volume")
plt.xlabel("Month")
plt.ylabel("Number of Orders")

plt.xticks(rotation=45)
plt.tight_layout()
plt.show()


# Compare May order volume
orders_2024 = len(may_2024)
orders_2025 = len(may_2025)

order_change = ((orders_2025 - orders_2024) / orders_2024) * 100

print("\nOrder Volume Comparison")
print(f"May 2024 orders: {orders_2024:,}")
print(f"May 2025 orders: {orders_2025:,}")
print(f"Order change: {order_change:.2f}%")


from scipy.stats import chi2_contingency

# Compare order status distribution between May 2024 and May 2025
may_comparison = df[
    (df["order_date"].dt.month == 5) &
    (df["order_date"].dt.year.isin([2024, 2025]))
].copy()

may_comparison["year"] = may_comparison["order_date"].dt.year

status_table = pd.crosstab(
    may_comparison["order_status"],
    may_comparison["year"]
)

print("\nOrder Status Comparison")
print(status_table)


# Test whether order status changed significantly between the two years
chi2_stat, chi2_p_value, dof, expected = chi2_contingency(status_table)

print("\nChi-square Test")
print(f"Chi-square statistic: {chi2_stat:.2f}")
print(f"P-value: {chi2_p_value:.6f}")

payments = pd.read_csv("../data/raw/payments.csv")

print(payments.columns)


from statsmodels.stats.proportion import proportions_ztest


# Load payment data
payments = pd.read_csv("../data/raw/payments.csv")

payments["payment_date"] = pd.to_datetime(payments["payment_date"])


# Filter May 2024 and May 2025 payments
may_payments = payments[
    (payments["payment_date"].dt.month == 5) &
    (payments["payment_date"].dt.year.isin([2024, 2025]))
].copy()

may_payments["year"] = may_payments["payment_date"].dt.year


# Calculate payment failure rates
payment_summary = (
    may_payments.groupby("year")["payment_status"]
    .agg(
        total_payments="count",
        failed_payments=lambda x: (x == "Failed").sum()
    )
    .reset_index()
)

payment_summary["failure_rate"] = (
    payment_summary["failed_payments"] /
    payment_summary["total_payments"] * 100
)

print("\nPayment Failure Comparison")
print(payment_summary)


# Test whether payment failure rates changed significantly
failed_counts = payment_summary["failed_payments"].values
total_counts = payment_summary["total_payments"].values

z_stat, z_p_value = proportions_ztest(
    failed_counts,
    total_counts
)

print("\nTwo-Proportion Z-Test")
print(f"Z-statistic: {z_stat:.2f}")
print(f"P-value: {z_p_value:.10f}")


# Visualize payment failure rates
plt.figure(figsize=(8, 5))

sns.barplot(
    data=payment_summary,
    x="year",
    y="failure_rate"
)

plt.title("Payment Failure Rate: May 2024 vs May 2025")
plt.xlabel("Year")
plt.ylabel("Failure Rate (%)")

plt.tight_layout()
plt.show()


# Calculate monthly payment failure rates
payments["year_month"] = payments["payment_date"].dt.to_period("M")

monthly_payment_failure = (
    payments.groupby("year_month")["payment_status"]
    .agg(
        total_payments="count",
        failed_payments=lambda x: (x == "Failed").sum()
    )
    .reset_index()
)

monthly_payment_failure["failure_rate"] = (
    monthly_payment_failure["failed_payments"] /
    monthly_payment_failure["total_payments"] * 100
)

monthly_payment_failure["year_month"] = (
    monthly_payment_failure["year_month"].dt.to_timestamp()
)


# Plot monthly payment failure rate
plt.figure(figsize=(12, 6))

sns.lineplot(
    data=monthly_payment_failure,
    x="year_month",
    y="failure_rate",
    marker="o"
)

plt.title("Monthly Payment Failure Rate")
plt.xlabel("Month")
plt.ylabel("Failure Rate (%)")

plt.xticks(rotation=45)
plt.tight_layout()
plt.show()


# Show the months with the highest failure rates
print("\nHighest Payment Failure Rates")

print(
    monthly_payment_failure
    .sort_values("failure_rate", ascending=False)
    .head(5)
    .to_string(index=False)
)