With ranked_sends AS(
   SELECT 
        id,
        user_id,
        campaign_id,
        sent_at,
        channel,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, campaign_id
            ORDER BY sent_at ASC
        ) AS rn
   FROM campaign_sends
),

   SELECT
        id,
        user_id,
        event_time,
        campaign_id,
        channel,
        event_type
   FROM engagement_events ee
   LEFT JOIN ranked_sends rs
   ON rs.user_id = ee.user_id
   WHERE rn = 1