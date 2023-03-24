-- Top 10 Countries by Visitors
SELECT
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  IFNULL(geoNetwork.country, "") AS country
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
GROUP BY country
ORDER BY unique_visitors DESC
Limit 10;