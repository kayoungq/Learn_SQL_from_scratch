/*--------------------------------Question 1. A. ------------------------------*/
SELECT MIN(subscription_start),
       MAX(subscription_start)
FROM subscriptions;

/*-------------------------------Question 1. B.---------------------------------*/
SELECT DISTINCT subscription_end
FROM subscriptions
ORDER BY 1;

/*-------------------------------Question 1. C.---------------------------------*/
SELECT DISTINCT segment
FROM subscriptions
ORDER BY 1;

/*-------------------------------Question 2 Intro-------------------------------*/ 
/*------------ This is just to show what the currect table has for information -----*/ 
SELECT *
FROM subscriptions
Limit 100;

/*-------------------------------Question 2 Step 1--------------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day)
SELECT *
FROM months;


/*--------------------------------Question 2 Step 2 ----------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months)
SELECT *
FROM cross_join
LIMIT 200;


/*--------------------------------Question 2 Step 3 ----------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
         Subscription_start,
         Subscription_end,
         first_day AS month,
    CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)    
          THEN 1 
           ELSE 0
       END AS is_active, 
    CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
          THEN 1 
           ELSE 0
      END AS is_canceled 
  FROM cross_join) 
SELECT * 
FROM STATUS
LIMIT 200;


/*--------------------------------Question 2 Step 4 ----------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
          first_day AS month,
    CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)    
          THEN 1 
           ELSE 0
       END AS is_active, 
    CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
          THEN 1 
           ELSE 0
      END AS is_canceled 
  FROM cross_join),
status_aggregate AS (
   SELECT month,
          SUM(is_active) AS 'sum_active',
          SUM(is_canceled) AS 'sum_canceled' 
   FROM status
   GROUP BY month)
SELECT *     
FROM status_aggregate;



/*--------------------------------Question 2 Step 5 ----------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
         first_day AS month,
      CASE 
          WHEN (subscription_start < first_day) 
           AND (subscription_end > first_day 
           OR subscription_end IS NULL)    
          THEN 1 
           ELSE 0
       END AS is_active, 
      CASE 
          WHEN (subscription_end BETWEEN first_day and last_day) 
          THEN 1 
          ELSE 0
      END AS is_canceled 
  FROM cross_join),
status_aggregate AS (
   SELECT month,
          SUM(is_active) AS 'sum_active',
          SUM(is_canceled) AS 'sum_canceled' 
   FROM status
   GROUP BY month)      
SELECT month, 
       round (1.0*sum_canceled/sum_active,2) AS churn_rate
FROM status_aggregate;


/*--------------------------------Question 3:  Finding active and canceled status per segment per user per month :---------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
         Subscription_start,
         Subscription_end,
         first_day AS month,
    CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 87)
          THEN 1 
           ELSE 0
       END AS is_active_87, 
     CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 30)
          THEN 1 
           ELSE 0
       END AS is_active_30, 
    CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 87)
          THEN 1 
           ELSE 0
      END AS is_canceled_87, 
     CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 30)
          THEN 1 
           ELSE 0
      END AS is_canceled_30 
  FROM cross_join) 
SELECT * 
FROM STATUS
LIMIT 200;

/*--------------------------------Question 3:Finding total active and total canceled status per segment, per month:---------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
         first_day AS month,
    CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 87)
          THEN 1 
           ELSE 0
       END AS is_active_87, 
     CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 30)
          THEN 1 
           ELSE 0
       END AS is_active_30, 
    CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 87)
          THEN 1 
           ELSE 0
      END AS is_canceled_87, 
     CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 30)
          THEN 1 
           ELSE 0
      END AS is_canceled_30 
  FROM cross_join),
status_aggregate AS (
   SELECT month,
          SUM(is_active_87) AS 'sum_active_87',
          SUM(is_active_30) AS 'sum_active_30',
          SUM(is_canceled_87) AS 'sum_canceled_87',
          SUM(is_canceled_30) AS 'sum_canceled_30' 
 FROM status
 GROUP BY month)     
SELECT *
FROM status_aggregate;


/*--------------------------------Question 3: Churn rates - per segment per month---------------------------*/
WITH months AS (
  SELECT 
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
  UNION 
  SELECT
    '2017-02-01' AS first_day,
    '2017-02-28' AS last_day
  UNION 
  SELECT 
    '2017-03-01' AS first_day,
    '2017-03-31' AS last_day),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months),
status AS (
  SELECT id,
         first_day AS month,
    CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 87)
          THEN 1 
           ELSE 0
       END AS is_active_87, 
     CASE 
         WHEN (subscription_start < first_day) 
         AND (subscription_end > first_day 
             OR subscription_end IS NULL)   
         AND (segment = 30)
          THEN 1 
           ELSE 0
       END AS is_active_30, 
    CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 87)
          THEN 1 
           ELSE 0
      END AS is_canceled_87, 
     CASE 
         WHEN (subscription_end BETWEEN first_day and last_day) 
         AND (segment = 30)
          THEN 1 
           ELSE 0
      END AS is_canceled_30 
  FROM cross_join),
status_aggregate AS (
   SELECT month,
          SUM(is_active_87) AS 'sum_active_87',
          SUM(is_active_30) AS 'sum_active_30',
          SUM(is_canceled_87) AS 'sum_canceled_87',
          SUM(is_canceled_30) AS 'sum_canceled_30'  
   FROM status
   GROUP BY month)     
 SELECT month, 
   round (1.0*sum_canceled_87/sum_active_87, 3) AS churn_rate_87,
   round (1.0*sum_canceled_30/sum_active_30, 3) AS churn_rate_30
 FROM status_aggregate;


