with filtered_data as (
    select 
        customerid,
        SUM(price) as total_bought
    from sales
    group by customerid
    having SUM(price) >= 199
),
no_address_customers AS (
    select 
        fd.customerid,
        fd.total_bought,
        'no address' as issue
    from filtered_data fd
    left join addresses a
    on fd.customerid = a.customerid
    where a.addressid is null
),
wrong_address_customers AS (
    select 
        fd.customerid,
        fd.total_bought,
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
        nac.total_bought,
        nac.issue
    from no_address_customers nac
    union all
    select 
        wac.customerid,
        wac.total_bought,
        wac.issue
    from wrong_address_customers wac
),
ordered_customers as (
    select 
        customerid,
        total_bought,
        issue,
        row_number() over (order by total_bought desc) as rn
    from customers_to_contact
),
assigned_reps as (
    select 
        oc.customerid,
        oc.total_bought,
        oc.issue,
        oc.rn,
        case 
            when rn % 3 = 1 then 1
            when rn % 3 = 2 then 2
            else 3
        end as rep_number
    from ordered_customers oc
),
ordered_reps as (
    select 
        salesrepid,
        CONCAT(firstname, ' ', lastname) as sales_rep,
        row_number() over (order by hiredate asc) as rep_number
    from salesreps
),
final_report as (
    select 
        ar.total_bought,
        orp.salesrepid,
        orp.sales_rep,
        ar.customerid
    from assigned_reps ar
    join ordered_reps orp
    on ar.rep_number = orp.rep_number
    join customers c
    on ar.customerid = c.customerid
    group by ar.total_bought, orp.salesrepid, orp.sales_rep, ar.customerid
    order by ar.total_bought desc, email asc
),
script_messages as (
    select 
        customerid,
CASE
    WHEN issue = 'wrong_address' THEN 'You've spent enough money with us so we care about your business. Unfortunately you have selected a bad address. Please login to our site and select a good address.'
    WHEN issue = 'no address' THEN 'You've spent enough money with us so we care about your business. You don't have an address on file yet you've selected an address. Please login to our site and add an address so we may use it... Don't ask any questions on how this happened.'
END AS script
    from customers_to_contact
)
select 
    email,
    total_bought,
    sales_rep as rep_name,
    sm.script
from final_report fr
join customers c
on fr.customerid = c.customerid 
join script_messages sm
on c.customerid = sm.customerid