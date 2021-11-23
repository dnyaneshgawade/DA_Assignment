

/* create temporary table*/
CREATE TEMPORARY TABLE drop_rate(
total_visits varchar(50), 
customer int
);




/* creating procedure to calculate total visits and count of customer */

DELIMITER $$
CREATE PROCEDURE LoopDemo1()
BEGIN
	DECLARE x  INT;
	SET x = 1;
	
	loop_label:  LOOP
		IF  x > 9 THEN 
			LEAVE  loop_label;
		END  IF;
         
        insert into drop_rate
        ((select x,(select count(SUBQUERY.user_id)
	from
	(select distinct user_id,sum(visit_rank) as total_visits
	FROM transaction_log_loyalty
	GROUP BY user_id)as SUBQUERY
	where total_visits=x
	))); 
	SET  x = x + 1;
	END LOOP;
    
	insert into drop_rate
        ((select '9+' ,(select count(SUBQUERY.user_id)
	from
	(select distinct user_id,sum(visit_rank) as total_visits
	FROM transaction_log_loyalty
	GROUP BY user_id)as SUBQUERY
	where total_visits>9
	)));
END$$



/* procedure call */
call LoopDemo();


/* retriving data as per output format */
select  distinct total_visits ,
	customer, sum(customer) over (order by Total_Visits desc) as cumulative
	from drop_rate 
	group by total_visits ;



/* retriving data as per output format and export to csv file */
select 'Total_visits','Customer','cumulative'
union all 
(
	select distinct total_visits ,
	customer, sum(customer) over (order by Total_Visits desc)
	from drop_rate 
	group by total_visits 
) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/drop_rate.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';


