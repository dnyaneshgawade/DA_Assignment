/* retriving total usres as per total vists */
select distinct Total_visits ,
 count( user_id), sum((select count( user_id))) over (order by Total_Visits desc) as cumulative from output group by Total_visits ;




/* retriving data as per output format and export to csv file */
select 'Total_visits','Customer'
union all 
(select distinct Total_visits ,
 count( user_id), sum((select count( user_id))) over (order by Total_Visits desc) as cumulative from output group by Total_visits ; 
) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output2.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';









DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT;
	SET x = 1;
	
	loop_label:  LOOP
		IF  x > 9 THEN 
			LEAVE  loop_label;
		END  IF;
         
        insert into drop_rate
        ((select Total_Visits,count(user_id) from output where Total_Visits = x)); 
		SET  x = x + 1;
	END LOOP;
    insert into drop_rate
        ((select 10 ,count(user_id) from output where Total_Visits > 9));
END$$


call LoopDemo();



select distinct total_visits ,customer, sum(customer) over (order by Total_Visits desc) as cumulative, (select (select sum(customer) over (order by Total_Visits desc))/SUM(customer) * 100) AS percentage from drop_rate group by total_visits ;



/* retriving data as per output format and export to csv file */
select 'Total_visits','Customer','cumulative','cumulative %'
union all 
(
	select distinct total_visits ,
	customer, sum(customer) over (order by Total_Visits desc), 
	(select (select sum(customer) over (order by Total_Visits desc))/SUM(customer) * 100) 
	from drop_rate 
	group by total_visits 
) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output2.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';


