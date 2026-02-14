CREATE OR REPLACE VIEW `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions` AS
SELECT
  InvoiceNo,
  StockCode,
  Description,
  Quantity,
  SAFE_CAST(InvoiceDate AS DATETIME) AS InvoiceDate,
  UnitPrice,
  CustomerID,
  Country,
  Quantity * UnitPrice AS Revenue
FROM `rugged-sunbeam-477718-k5.retail_dw.raw_transactions`
WHERE Quantity IS NOT NULL
  AND UnitPrice IS NOT NULL;

-- =============================================
-- Retail Data Warehouse Analysis
-- Author: Lethabo Moshabane
-- =============================================

-- 1. Data Quality Check
SELECT 
  COUNT(*) AS total_rows,
  COUNTIF(CustomerID IS NULL) AS missing_customer_ids
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`;

-- 2. Negative Quantity (Returns) Analysis
SELECT 
  COUNT(*) AS negative_quantity_transactions
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
WHERE Quantity < 0;

-- 3. Revenue Impact of Returns
SELECT
  SUM(CASE WHEN Quantity < 0 THEN Revenue ELSE 0 END) AS return_revenue,
  SUM(CASE WHEN Quantity > 0 THEN Revenue ELSE 0 END) AS positive_revenue
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`;

-- 4. Monthly Revenue Trend (Excluding Returns)
SELECT
  FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS year_month,
  SUM(Revenue) AS total_revenue
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
WHERE Quantity > 0
GROUP BY year_month
ORDER BY year_month;

SELECT
  Country,
  SUM(Revenue) AS total_revenue
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
WHERE Quantity > 0
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
  Description,
  SUM(Revenue) AS total_revenue
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
WHERE Quantity > 0
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;


SELECT
  CustomerID,
  SUM(Revenue) AS total_spent
FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
WHERE Quantity > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;


SELECT
  year_month,
  total_revenue,
  ROUND(
    (total_revenue - LAG(total_revenue) OVER (ORDER BY year_month))
    / LAG(total_revenue) OVER (ORDER BY year_month) * 100,
    2
  ) AS monthly_growth_percent
FROM (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS year_month,
    SUM(Revenue) AS total_revenue
  FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
  WHERE Quantity > 0
  GROUP BY year_month
)
ORDER BY year_month;

SELECT
  year_month,
  total_revenue,
  ROUND(
    SAFE_DIVIDE(
      total_revenue - LAG(total_revenue) OVER (ORDER BY year_month),
      LAG(total_revenue) OVER (ORDER BY year_month)
    ) * 100,
    2
  ) AS monthly_growth_percent
FROM (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS year_month,
    SUM(Revenue) AS total_revenue
  FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
  WHERE Quantity > 0
  GROUP BY year_month
)
ORDER BY year_month;

SELECT
  year_month,
  total_revenue,
  ROUND(
    AVG(total_revenue) OVER (
      ORDER BY year_month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),
    2
  ) AS rolling_3_month_avg
FROM (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(InvoiceDate)) AS year_month,
    SUM(Revenue) AS total_revenue
  FROM `rugged-sunbeam-477718-k5.retail_dw.cleaned_transactions`
  WHERE Quantity > 0
  GROUP BY year_month
)
ORDER BY year_month;

