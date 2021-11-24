use data_analysis;


/* create temporary table */
create temporary table brand_lapsation(
days_since_last_visit varchar(50),
no_of_bills int,
bill_percentage double
);


/* create procedure to count no of bill regarding days */
DELIMITER $$
CREATE PROCEDURE brand_lapsation_loop()
BEGIN
	DECLARE x,days   INT;
	SET x = 1;
	SET days = 30;
	
	loop_label:  LOOP
		IF  x > 12 THEN 
			LEAVE  loop_label;
		END  IF;
         
        insert into brand_lapsation (days_since_last_visit,no_of_bills,bill_percentage)
        ((select CONCAT('<', days),
	count(bill_number),
	(100 * count(bill_number)/(select count( distinct bill_number) from transaction_log_loyalty))  
	from transaction_log_loyalty where days_since_last_visit <=days)); 
	SET  x = x + 1;
        SET days=days+30;
	END LOOP;
END$$

/* procedure call */
call brand_lapsation_loop();



/* retriving data as per output format and export to csv file */
select 'Days_Since_Last_Visit','No_of_Bills','Bill_Percentage'
union all 
(
	select days_since_last_visit,no_of_bills,bill_percentage
	from brand_lapsation
) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/brand_lapsation.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';
