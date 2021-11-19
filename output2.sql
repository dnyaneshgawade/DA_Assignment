/* retriving total usres as per total vists */
select  distinct Total_visits As total_visits ,
count( user_id) As customer 
from output 
group by Total_visits 
order by Total_visits ;





/* retriving data as per output format and export to csv file */
select 'Total_visits','Customer'
union all 
(select  distinct Total_visits ,
 count( user_id)
 from output 
 group by Total_visits 
 order by Total_visits 
) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output2.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';
