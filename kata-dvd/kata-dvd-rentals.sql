select * 
from customer c
left join rental r
on c.customer_id = r.customer_id;