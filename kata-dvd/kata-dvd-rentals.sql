with customer_one AS(
    select
        customer_id,
        rental_date
    from rental
    where customer_id = 1 
),
date_rental AS(
    select distinct
        customer_id,
        rental_date::date as date_rental_occurred
    from customer_one
),
previous_date AS(
     select 
         date_rental_occurred,
         LAG(date_rental_occurred) OVER (ORDER BY date_rental_occurred asc
         ) as previous_rental_date
     from date_rental
),
starts_group AS(
      select  
        date_rental_occurred,
        previous_rental_date,
        case 
        when previous_rental_date is null then 1
        when date_rental_occurred - previous_rental_date = 1 then 0
        else 1
    end as starts_group    
    from previous_date
),
grouped_dates AS(
    select 
        date_rental_occurred,
        sum(starts_group) over (order by date_rental_occurred asc) as group_id
    from starts_group
)
consecutive_counts AS(
    select 
        group_id,
        count(*) as consecutive_days
    from grouped_dates
    group by group_id
)
select * from consecutive_counts;