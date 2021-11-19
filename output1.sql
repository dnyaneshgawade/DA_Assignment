/*creating and use database*/
create database data_analysis;

use data_analysis;


/* retrive user_id */
select user_id FROM transaction_log_loyalty_lineitem  GROUP BY user_id ;


/* retriving total spend for user */
select user_id,sum(net_amount-discount)  FROM transaction_log_loyalty_lineitem  GROUP BY user_id order by user_id;



/* retriving total bills for user */
SELECT user_id ,COUNT(bill_number)
FROM transaction_log_loyalty
GROUP BY user_id;


/* retriving total visits by user */
select sum(visit_rank) 
FROM transaction_log_loyalty
GROUP BY user_id;



/* retriving first and last transaction date */
select user_id,min(bill_date),max(bill_date)
from transaction_log_loyalty_lineitem group by user_id order by user_id;



/* retriving first and first transaction store */
select distinct user_id,store_name from transaction_log_loyalty_lineitem 
group by user_id 
having (select min(transaction_log_loyalty_lineitem.bill_date) );



/* retriving first and last transaction store */
select distinct user_id,store_name from transaction_log_loyalty_lineitem 
group by user_id 
having (select max(transaction_log_loyalty_lineitem.bill_date) );



/* retriving total quantity purchased by user */
select sum(qty)  FROM transaction_log_loyalty_lineitem  GROUP BY user_id ;







/* Complex query to retrive date as output format */

select 'User_Id','Total_Spend','Total_Bills','Total_Visits','Last_Transaction_Date','First_Transaction_Date','First_Transaction_Store','Last_Transaction_Store','Total_Qty_Purchased'
union all
(
select b.user_id,
sum(b.net_amount-b.discount),
COUNT(a.bill_number),
count(a.visit_rank),
min(b.bill_date),
max(b.bill_date),
(select b.store_name where b.bill_date= min(b.bill_date)),
(select b.store_name where b.bill_date= max(b.bill_date)),
sum(b.qty)
from transaction_log_loyalty a inner join transaction_log_loyalty_lineitem b on 
a.user_id=b.user_id
group by b.user_id
order by b.user_id asc
);






/* export data to csv file */
select 'User_Id','Total_Spend','Total_Bills','Total_Visits','Last_Transaction_Date','First_Transaction_Date','First_Transaction_Store','Last_Transaction_Store','Total_Qty_Purchased'
union all
(
select b.user_id,
sum(b.net_amount-b.discount),
COUNT(a.bill_number),
count(a.visit_rank),
min(b.bill_date),
max(b.bill_date),
(select b.store_name where b.bill_date= min(b.bill_date)),
(select b.store_name where b.bill_date= max(b.bill_date)),
sum(b.qty)
from transaction_log_loyalty a inner join transaction_log_loyalty_lineitem b on 
a.user_id=b.user_id
group by b.user_id
order by b.user_id asc
)
into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '\n';

