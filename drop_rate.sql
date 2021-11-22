

/* create temporary table*/
CREATE TEMPORARY TABLE drop_rate(
total_visits varchar(50), 
customer int
);




/* creating procedure to calculate total visits and count of customer */

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
        ((select '9+' ,count(user_id) from output where Total_Visits > 9));
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


