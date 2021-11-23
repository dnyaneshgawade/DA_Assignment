
/* retive data as per category penetration */

select distinct a.category, 
count( b.bill_number),
count(distinct b.user_id ),
sum(b.amount-b.discount),
count(c.qty)
from product_master a 
join transaction_log_loyalty b 
on a.id=b.store_id
join transaction_log_loyalty_lineitem c
on  b.user_id=c.user_id
group by category;







/* export data to csv file */
select 'Category','Bills','Customers','Salse','Quantity Sold'
union all
(
select distinct a.category, 
count( b.bill_number),
count(distinct b.user_id ),
sum(b.amount-b.discount),
count(c.qty)
from product_master a 
join transaction_log_loyalty b 
on a.id=b.store_id
join transaction_log_loyalty_lineitem c
on  b.user_id=c.user_id
group by category
)
into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Category_Penetration.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '\n';
