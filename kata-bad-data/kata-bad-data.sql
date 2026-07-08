with filtered_data as (
    select 
        customerid,
        SUM(price) as total_price
    from sales
    group by customerid
    having SUM(price) >= 199
),
no_address_customers AS (
    select 
        fd.customerid,
        fd.total_price,
        a.addressid
    from filtered_data  
    left join addresses a
    on fd.customerid = a.customerid
    where a.addressid is null
)


select *
from no_address_customers
