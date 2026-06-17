With unnest_users AS  (
  SELECT
      unnest(xpath('/data/user', data::xml)) AS user_xml
FROM users
),
user_nodo AS (
    SELECT
        (xpath('/user/first_name/text()', user_xml))[1]::text AS first_name,
        (xpath('/user/last_name/text()', user_xml))[1]::text AS last_name,
        (xpath('/user/date_of_birth/text()', user_xml))[1]::text AS date_of_birth,
        (xpath('/user/private/text()', user_xml))[1]::text AS is_private,
        (xpath('/user/email_addresses/address[1]/text()', user_xml))[1]::text AS first_address
    FROM unnest_users
)

SELECT *
FROM user_nodo;