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
        a.addressid,
        'no address' as issue
    from filtered_data fd
    left join addresses a
    on fd.customerid = a.customerid
    where a.addressid is null
),

wrong_address_customers AS (
    select 
        fd.customerid,
        fd.total_price,
        s.addressid,
        'wrong_address' as issue
    from filtered_data fd
    where exists (
    select 1
    from sales s
    where s.customerid = fd.customerid
    left join addresses a
    on s.addressid = a.addressid
)
    )
    left join sales s
    on fd.customerid = s.customerid
    left join addresses a
    on s.addressid = a.addressid
    and s.customerid = a.customerid
    where a.addressid is null
    group by fd.customerid, fd.total_price, s.addressid
    order by fd.customerid, fd.total_price, s.addressid
),

customers_to_contact as (
    select 
        fd.customerid,
        fd.total_price,
        fd.issue
    from no_address_customers fd
    union all
    select 
        fd.customerid,
        fd.total_price,
        fd.issue
    from wrong_address_customers fd
)

select *
from customers_to_contact
