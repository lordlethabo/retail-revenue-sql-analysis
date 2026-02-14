# Retail Revenue & Returns Impact Analysis (BigQuery SQL)

## Project Overview

This project analyzes retail transactional data using Google BigQuery to
assess: - Data quality issues - Financial impact of product returns -
Revenue trends and seasonality - Customer and product performance

------------------------------------------------------------------------

## Dataset Summary

-   Total Records: 541,909
-   Missing Customer IDs: 135,080 (\~24.9%)
-   Negative Quantity Transactions (Returns): 10,624
-   Returns Rate: 1.96%

------------------------------------------------------------------------

## Financial Impact of Returns

-   Positive Revenue: 10,644,560.42
-   Return Revenue: -896,812.49
-   Returns Impact: 8.42% of total positive revenue

### Business Insight

Although returns account for only 1.96% of transactions, they represent
8.42% of total revenue impact, highlighting material financial risk in
return behavior.

------------------------------------------------------------------------

## Revenue Trend Analysis

-   Monthly revenue aggregated and analyzed.
-   Peak revenue observed in November 2011 (\~1.5M).
-   Clear seasonal uplift in Q4.

------------------------------------------------------------------------

## Advanced Analytics

### Month-over-Month Growth

Calculated using window functions (LAG) to identify revenue acceleration
and volatility.

### Rolling 3-Month Average

Implemented using: AVG(total_revenue) OVER ( ORDER BY year_month ROWS
BETWEEN 2 PRECEDING AND CURRENT ROW )

This smooths fluctuations and highlights sustained performance trends.

------------------------------------------------------------------------

## Technical Implementation

-   Google BigQuery (Cloud Data Warehouse)
-   SQL Aggregation & GROUP BY
-   Window Functions (LAG, AVG OVER)
-   Conditional Aggregation (CASE)
-   Data Cleaning via SQL Views
-   Revenue Feature Engineering

------------------------------------------------------------------------

## Conclusion

This project demonstrates an end-to-end analytics workflow: Raw Data →
Cleaning Layer → Data Validation → Revenue Modeling → Trend Analysis →
Executive Insights

Author: Lethabo Mafihle James Moshabane
