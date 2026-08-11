with customer_one AS(
    select
        customer_id,
        rental_date
    from rental
    where customer_id = 1 
),
date_rental AS(
    select distinct
        CAST(rental_date AS DATE) as date_rental_occurred
    from customer_one   
),
previous_date AS(
     select
         date_rental_ocurred,
         LAG(date_rental_ocurred) OVER (ORDER BY date_rental_ocurred asc
         ) as previous_rental_date
     from date_rental
select * from previous_date;