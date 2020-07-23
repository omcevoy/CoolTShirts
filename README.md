# CoolTShirts - Touch Attribution

**TLDR**: I used SQL to perform a touch attribution analysis of a marketing campaign

This project was completed as a part of the Codecademy Data Science Path. The problem at hand here is the CoolTShirts, an apparel company, recently began a few marketing campaigns with the intention of driving additional traffic to their website. The goal is to optimize their marketing campaigns using touch attribution, to see which campaigns generate the most clicks and purchases. Feel free to refer to the [Queries File](https://github.com/omcevoy/CoolTShirts/blob/master/queries.sql "Relevant Queries") to see all of the queries used for this project. 

The table used, **page_visits**, had 5 columns: *page_name*, *timestamp*, *user_id*, *utm_campaign*, & *utm_source*

``` 
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attributes AS (SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT utm_campaign, COUNT(*) AS "First Touches"
FROM ft_attributes
GROUP BY utm_campaign
ORDER BY 2 desc;
```
![Results Returned By Query](https://github.com/omcevoy/CoolTShirts/blob/master/firstTouchVals.png)

As shown in the above image, this query returns the campaigns and the amount of first touches the campaign generated. While first touches and page visits are certainly important, what truly matters is whether or not these visitors are making purchases. To better gauge this I looked at the last touch of the users, instead of first touch, and specifically the users whose last touch occurred on the purchase page. 

```
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name LIKE '4%'
    GROUP BY user_id),
lt_attributes AS (SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT utm_campaign, COUNT(*)
FROM lt_attributes
GROUP BY utm_campaign
ORDER BY 2 desc;
```
![Results Returned By Query](https://github.com/omcevoy/CoolTShirts/blob/master/lastToPurch.png)

My immediate take away from these results is that despite the marketing campaign generating a lot of first touches, none of them led to a significant amount of purchases. 
