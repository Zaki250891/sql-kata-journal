WITH ranked_sends AS (
    SELECT 
        user_id,
        campaign_id,
        sent_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, campaign_id
            ORDER BY sent_at
        ) AS rn
    FROM campaign_sends
    WHERE campaign_id = 'SUMMER2025'
),

cold_touch_cohort AS (
    SELECT
        user_id,
        campaign_id,
        sent_at
    FROM ranked_sends
    WHERE rn = 1
),

user_stage AS (
    SELECT
        ct.user_id,

        MAX(
            CASE
                WHEN ee.event_type = 'converted' THEN 4
                WHEN ee.event_type = 'click' THEN 3
                WHEN ee.event_type = 'open' THEN 2
                ELSE 1
            END
        ) AS stage_rank

    FROM cold_touch_cohort ct

    LEFT JOIN engagement_events ee
        ON ct.user_id = ee.user_id
       AND ct.campaign_id = ee.campaign_id
       AND ee.event_type IN ('open', 'click', 'converted')
       AND ee.event_time >= ct.sent_at

    GROUP BY ct.user_id
),

stages(stage, rank_order) AS (
    VALUES
        ('received', 1),
        ('opened', 2),
        ('clicked', 3),
        ('converted', 4)
)

SELECT
    s.stage,
    COUNT(us.user_id) AS users
FROM stages s

LEFT JOIN user_stage us
    ON s.rank_order = us.stage_rank

GROUP BY s.stage, s.rank_order
ORDER BY s.rank_order;