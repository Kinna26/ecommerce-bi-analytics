import os
import pandas as pd

DATA_DIR = "../data/raw"

files = [
    "customers.csv",
    "products.csv",
    "orders.csv",
    "order_items.csv",
    "payments.csv",
    "deliveries.csv",
    "marketing_campaigns.csv",
    "marketing_performance.csv",
    "support_tickets.csv"
]


def load_file(file_name):
    path = os.path.join(DATA_DIR, file_name)

    if not os.path.exists(path):
        print(f"Missing file: {file_name}")
        return None

    return pd.read_csv(path)


def check_data(df, table_name):
    print(f"\n{table_name}")
    print("-" * len(table_name))

    print(f"Rows: {len(df):,}")
    print(f"Columns: {len(df.columns)}")

    missing = df.isna().sum()
    missing = missing[missing > 0]

    if missing.empty:
        print("Missing values: none")
    else:
        print("Missing values:")
        print(missing.to_string())

    duplicate_rows = df.duplicated().sum()
    print(f"Duplicate rows: {duplicate_rows:,}")


def main():
    print("Running basic data quality checks...")

    for file_name in files:
        df = load_file(file_name)

        if df is not None:
            table_name = file_name.replace(".csv", "")
            check_data(df, table_name)

    print("\nChecks completed.")


if __name__ == "__main__":
    main()