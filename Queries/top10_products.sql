-- Top 10 products
SELECT P.v2ProductName,
  SUM(P.productQuantity) AS qty_sold,
  ROUND(SUM(P.localProductRevenue/1000000), 0) AS product_revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
UNNEST (hits) as H,
UNNEST (H.product) as P
GROUP BY P.v2ProductName
ORDER BY product_revenue DESC
LIMIT 10;