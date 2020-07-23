-- 1 - How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?

SELECT COUNT(DISTINCT utm_campaign) AS "Campaign_Count", COUNT(DISTINCT utm_source) AS "Source_Count" FROM page_visits;
SELECT DISTINCT utm_campaign, utm_source FROM page_visits;

-- 2 - What pages are on the CoolTShirts website?

SELECT DISTINCT page_name FROM page_visits;

-- 3 - How many first touches is each campaign responsible for?

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
SELECT utm_campaign, COUNT(*)
FROM ft_attributes
GROUP BY utm_campaign
ORDER BY 2 desc;

-- 4 - How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
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

- 5 - How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) as '# of Purchases' FROM page_visits
WHERE page_name LIKE '4%';


-- 6 - How many last touches on the purchase page is each campaign responsible for?
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

-- 7 - CoolTShirts can re-invest in 5 campaigns. Given your findings in the project, which should they pick and why?

-- CoolTShirts should re-invest in these 5 campaigns: weekly-newsletter, retargetting-ad, retargetting-campaign, 
-- paid-search, & getting-to-know-cool-tshirts. These 5 campaigns, returned in the previous query, resulted with the most purchases
