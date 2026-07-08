with filtered_data as (
    select 
        customerid,
        SUM(price) as total_price
    from sales
    group by customerid
    having SUM(price) >= 199
)
