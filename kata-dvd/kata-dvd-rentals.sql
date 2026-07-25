

select * 
from customer c
join rental r
on c.customer_id = r.customer_id;

select c.customer_id, r.customer_id, c.first_name
from customer c
left join rental r
on c.customer_id = r.customer_id;