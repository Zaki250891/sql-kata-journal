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
),

metrics_per_group as (
    select
        age_group,
        ROUND(AVG(pet_count)::numeric, 1) as avg_pet_count
    from group_by_age
    group by age_group
),

ranked_users as (
    select
        name AS max_pet_owner,
        pet_count AS max_pet_count,
        age_group,
        id,
        row_number() over (partition by age_group order by pet_count desc, id asc) as rank
    from group_by_age
),

top_users as (
    select
        age_group,
        max_pet_owner,
        max_pet_count
    from ranked_users
    where rank = 1
)

select
    m.age_group,
    m.avg_pet_count,
    t.max_pet_owner,
    t.max_pet_count
from metrics_per_group m
left join top_users t on m.age_group = t.age_group
order by m.avg_pet_count DESC, m.age_group ASC;


    