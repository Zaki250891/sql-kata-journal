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
        'wrong_address' as issue
    from filtered_data fd
    where exists (
        select 1
        from sales s
        where s.customerid = fd.customerid
        and s.addressid is not null
        and s.addressid not in (
            select addressid 
            from addresses a
            where a.addressid = s.addressid
            and a.customerid = s.customerid   
        )
    )
     and fd.customerid not in (
        select customerid 
        from no_address_customers
    )
),
customers_to_contact as (
    select 
        nac.customerid,
        nac.total_price,
        nac.issue
    from no_address_customers nac
    union all
    select 
        wac.customerid,
        wac.total_price,
        wac.issue
    from wrong_address_customers wac
),

ordered_customers as (
    select 
        customerid,
        total_price,
        issue
    from customers_to_contact
    order by total_price desc
)

select *
from ordered_customers;