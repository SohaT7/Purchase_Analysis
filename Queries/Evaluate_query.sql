SELECT
 precision,
 recall,
 accuracy,
 f1_score,
 log_loss,
 roc_auc,
 CASE
   WHEN roc_auc > 0.9 THEN 'great'
   WHEN roc_auc > 0.8 THEN 'fair'
   WHEN roc_auc > 0.7 THEN 'decent'
   WHEN roc_auc > 0.6 THEN 'not good'
 ELSE 'poor'
 END AS model_performance
FROM
 ML.EVALUATE(MODEL `ml_classification.model_0`, (
WITH transaction_info AS (
SELECT fullVisitorId,
   IF(COUNTIF(totals.transactions > 0) > 0, 1, 0) AS purchased
   FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
   GROUP BY fullVisitorId
)
-- Adding in features
SELECT * EXCEPT(unique_identifier) FROM (
SELECT
  CONCAT(fullVisitorId, CAST(visitID AS STRING)) AS
  unique_identifier,
  -- Label for our model
  purchased,
  -- Traffic type
  trafficSource.isTrueDirect AS traffic_direct,
  trafficSource.medium AS traffic_medium,
  trafficSource.source AS traffic_source,
  channelGrouping,
  -- Browser type
  IFNULL(device.browser, "") AS device_browser,
  -- Device type
  IFNULL(device.deviceCategory, "") AS device_category,
  -- Operating System
  IFNULL(device.operatingSystem, "") AS device_OS,
  -- Geographic location
  IFNULL(geoNetwork.region, "") AS region,
  -- Activity on site
  IFNULL(totals.bounces, 0) AS bounces,
  IFNULL(totals.newVisits, 0) AS new_visits,
  IFNULL(totals.pageviews, 0) AS page_views,
  IFNULL(totals.timeOnSite, 0) AS time_on_site,
  -- Advertisements
  IFNULL(trafficSource.adwordsClickInfo.gclId, "") AS ad_id,
  trafficSource.adwordsClickInfo.isVideoAd AS ad_video,
  IFNULL(trafficSource.adwordsClickInfo.page, 0) AS ad_on_pg_num,
  IFNULL(trafficSource.adwordsClickInfo.slot, "") AS ad_slot
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
JOIN transaction_info USING(fullVisitorId)
WHERE 1=1
AND date BETWEEN '20170501' AND '20170630'
GROUP BY
unique_identifier,
purchased,
traffic_direct,
traffic_medium,
traffic_source,
channelGrouping,
device_browser,
device_category,
device_OS,
region,
bounces,
new_visits,
page_views,
time_on_site,
ad_id,
ad_video,
ad_on_pg_num,
ad_slot
)
));
