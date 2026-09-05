# ShopSphere – Automated E-commerce BI Analytics

> From raw data to business decisions — automatically.

ShopSphere is an end-to-end **Automated Business Intelligence system** built for an e-commerce business.

The project transforms raw transactional and operational data into an analytical data model, business KPIs, automated Power BI reporting, and root-cause analysis.

The objective is not just to answer **"What happened?"**, but also:

- Why did it happen?
- Which business areas were affected?
- What should the business investigate next?

---

## 📌 Project Overview

E-commerce businesses generate large volumes of data across sales, customers, payments, delivery, marketing, and customer support.

ShopSphere brings these data sources together into a centralized analytics workflow.

### End-to-End Flow

**Raw Data → SQL Transformations → PostgreSQL Analytical Warehouse → KPI & Analytics Layer → Power BI → Business Insights**

The system was designed around a **Galaxy / Fact Constellation data model**, allowing multiple business processes to be analyzed using shared dimensions.

---

## 🎯 Business Problem

The business needed a centralized BI system to monitor performance across different functions and quickly investigate changes in important KPIs.

Key questions included:

- Is revenue growing or declining?
- What is driving changes in revenue?
- Which customer segments contribute the most revenue?
- Which product categories are performing differently?
- Are payment failures affecting orders?
- How are cancellations and deliveries performing?
- Which marketing campaigns generate conversions?
- What issues are customers raising?
- How quickly are support tickets being resolved?

---

## 💡 Solution

ShopSphere provides an integrated analytics system covering multiple business functions.

### Sales & Revenue
- Revenue
- Orders
- AOV
- Profit
- Profit Margin
- Monthly trends
- Product and customer analysis

### Customers
- Customer segments
- Customer activity
- Revenue per customer
- Order frequency

### Payments
- Payment method performance
- Payment failure rate
- Payment status analysis
- Failed-payment investigation

### Operations
- Delivery performance
- On-time delivery
- Late deliveries
- Cancellations
- Returns

### Marketing
- Campaign performance
- Marketing spend
- Impressions
- Clicks
- Conversions
- Conversion rate

### Customer Experience
- Support tickets
- Issue types
- Resolution time
- CSAT
- Priority analysis

---

## 🏗️ System Architecture

```text
                  RAW DATA
                     │
                     ▼
        ┌─────────────────────────┐
        │      CSV Data Sources   │
        │                         │
        │ Customers               │
        │ Products                │
        │ Orders                  │
        │ Payments                │
        │ Deliveries              │
        │ Marketing               │
        │ Support Tickets         │
        └────────────┬────────────┘
                     │
                     ▼
             SQL TRANSFORMATIONS
                     │
                     ▼
        ┌─────────────────────────┐
        │ PostgreSQL              │
        │                         │
        │ Raw Schema              │
        │          ↓              │
        │ Analytics Schema        │
        └────────────┬────────────┘
                     │
                     ▼
          ANALYTICAL DATA MODEL
                     │
                     ▼
        ┌─────────────────────────┐
        │ Galaxy / Fact           │
        │ Constellation Model     │
        └────────────┬────────────┘
                     │
                     ▼
             KPI & ANALYTICS
                     │
              ┌──────┴──────┐
              ▼             ▼
          SQL / Python    DAX
              │             │
              └──────┬──────┘
                     ▼
              POWER BI REPORT
                     │
                     ▼
             BUSINESS INSIGHTS


---

## 📊 Dashboard Preview

![ShopSphere Power BI Dashboard](path/to/your-dashboard-screenshot.png)

The dashboard provides an executive view of revenue, profit, orders, customers, AOV, and business trends.


---

## 🗄️ Data Model

The analytical layer uses a **Galaxy / Fact Constellation schema**.

### Dimensions

- `dim_date`
- `dim_customer`
- `dim_product`
- `dim_campaign`

### Fact Tables

- `fact_sales`
- `fact_payments`
- `fact_delivery`
- `fact_marketing`
- `fact_support`

Shared dimensions allow different business processes to be analyzed consistently.


---

## 📈 Key KPIs

The BI layer tracks:

- Total Revenue
- Total Orders
- Total Profit
- Average Order Value (AOV)
- Profit Margin
- Total Customers
- Cancellation Rate
- Payment Failure Rate
- On-Time Delivery Rate
- Marketing Spend
- Conversion Rate
- Average CSAT


---

## 🔎 Root Cause Analysis

A major analysis focused on understanding a significant revenue decline in May 2025.

The investigation followed a structured drill-down:

Revenue Decline
↓
Order Volume
↓
Customer Activity
↓
Customer Segments
↓
Product Categories
↓
Geography
↓
Order Status
↓
Payment Failures
↓
Payment Failure → Cancellation Relationship

### Key Findings

- Revenue declined approximately **24.1% YoY**
- Orders declined approximately **22.2%**
- Active customers declined approximately **20.2%**
- Cancellation rate increased from **4.36% to 9.26%**
- Payment failure rate increased from **5.13% to 16.42%**
- Failed-payment-linked cancellations increased from **3.30% to 11.93%**

The analysis indicated that the May revenue decline was significantly associated with a temporary system-wide payment-processing issue.

Python statistical analysis was used to validate the observed changes.

---

## 🐍 Python Statistical Analysis

Python was used to statistically investigate the revenue decline.

### Libraries

- Pandas
- NumPy
- Matplotlib
- Seaborn
- SciPy
- Statsmodels

### Statistical Tests

- Welch's t-test
- Mann-Whitney U test
- Chi-square test
- Two-proportion z-test

The tests were used to evaluate changes in AOV, order-status distribution, and payment failure rates.


---

## 🛠️ Tech Stack

**Database:** PostgreSQL  
**Querying & Transformation:** SQL  
**Analysis:** Python, Pandas, NumPy  
**Statistics:** SciPy, Statsmodels  
**Visualization:** Matplotlib, Seaborn  
**BI:** Power BI, DAX  
**Version Control:** Git, GitHub

---

## 📁 Project Structure

ecommerce-bi-analytics/
│
├── data/
├── data_generation/
├── documentation/
├── powerbi/
├── python/
├── sql/
├── .gitignore
└── README.md

---

## 👤 Author

**Krishna Parihar**

B.Tech – Electrical Engineering, NIT Bhopal

Business Analytics | Data Analytics | Business Intelligence | Data Engineering