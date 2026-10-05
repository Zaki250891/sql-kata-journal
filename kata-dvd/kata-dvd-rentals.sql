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
select * from previous_date;

