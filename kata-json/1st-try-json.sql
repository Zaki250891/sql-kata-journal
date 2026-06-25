with normalized_json as (
    select
        id,
        info ->> 'name' as name,
        (info ->> 'age')::integer as age,
        jsonb_array_length(info -> 'pets') as pet_count
    from users
),

group_by_age as (
    select
        id,
        name,
        age,
        pet_count,
        CASE
            WHEN age >=18 AND age <= 30 THEN '18-30'
            WHEN age >= 31 AND age <= 45 THEN '31-45'
            WHEN age >= 46 AND age <= 60 THEN '46-60'
            ELSE '61 and above'
        END as age_group
    from normalized_json
)


    