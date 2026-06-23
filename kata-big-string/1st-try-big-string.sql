WITH unnest_users AS (
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
        (xpath('/user/email_addresses/address[1]/text()', user_xml))[1]::text AS first_email_address
    FROM unnest_users
),

case_when_user_private AS (
    SELECT
        first_name,
        last_name,
        date_of_birth,
        is_private,
        first_email_address,
        CASE
            WHEN is_private = 'true' THEN 'Hidden'
            WHEN first_email_address IS NULL THEN 'None'
            ELSE first_email_address
        END AS email_address
    FROM user_nodo
),

age_calculation AS (
    SELECT
        first_name,
        last_name,
        date_of_birth,
        is_private,
        email_address,
        (
            EXTRACT(
                YEAR FROM
                AGE(
                    CURRENT_DATE,
                    date_of_birth::date
                )
            )
        )::int AS age
    FROM case_when_user_private
)

SELECT
    first_name,
    last_name,
    age,
    email_address
FROM age_calculation
ORDER BY
    first_name,
    last_name;