-- Visitors by Channel Grouping
SELECT
  COUNT(DISTINCT fullVisitorId) AS unique_visitors,
  channelGrouping AS channel
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
GROUP BY channel
ORDER BY channel DESC;