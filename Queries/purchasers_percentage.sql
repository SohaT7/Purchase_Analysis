WITH 
unique_visitors AS (
SELECT COUNT(DISTINCT fullVisitorId) AS all_visitors
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
),
purchasers AS (
SELECT COUNT(DISTINCT fullVisitorId) AS all_purchasers
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE totals.transactions IS NOT NULL
),
non_purchasers AS (
SELECT COUNT(DISTINCT fullVisitorId) AS all_non_purchasers
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE totals.transactions IS NULL
)
SELECT
  all_visitors,
  all_purchasers,
  all_non_purchasers,
  all_purchasers / all_visitors AS purchasers_per,
  all_non_purchasers / all_visitors AS non_purchasers_per
FROM unique_visitors, purchasers, non_purchasers;