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
        rental_date::date as date_rental_ocurred
    from customer_one
),
previous_date AS(
     select 
         date_rental_ocurred,
         LAG(date_rental_ocurred) OVER (ORDER BY date_rental_ocurred asc
         ) as previous_rental_date
     from date_rental
on_a_roll AS(
    case 
        when previous_rental_date is null then 0
        when date_rental_ocurred - previous_rental_date = 1 then 1
        else 0
    end as on_a_roll
    from previous_date
)
select * from previous_date;

