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
select 
    email,
    total_bought,
    sales_rep as sales_rep_id,
    issue as script