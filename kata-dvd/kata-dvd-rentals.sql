with customer_one AS(
    select
        customer_id,
        rental_date
    from rental
    where customer_id = 1 
),
date_rental AS(
    select distinct
        r.customer_id,
        c.first_name || ' ' || c.last_name AS name,
        r.rental_date::date AS date_rental_occurred
    from customer_one r
    JOIN customer c
        ON r.customer_id = c.customer_id
),
previous_date AS(
     select 
         name,
         customer_id,
         date_rental_occurred,
         LAG(date_rental_occurred) OVER (ORDER BY date_rental_occurred asc
         ) as previous_rental_date
     from date_rental
),
starts_group AS(
      select  
        name,
        customer_id,
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
        name,
        customer_id,
        date_rental_occurred,
        sum(starts_group) over (order by date_rental_occurred asc) as group_id
    from starts_group
),
consecutive_counts AS(
    select 
        name,
        customer_id,
        date_rental_occurred,
        group_id,
        count(*) over (partition by group_id)  as consecutive_days
    from grouped_dates
),
consecutive_days_dvd_rentals AS(
    select 
        name,
        customer_id,
        date_rental_occurred,
        group_id,
        consecutive_days
    from consecutive_counts
)
select * from consecutive_days_dvd_rentals;