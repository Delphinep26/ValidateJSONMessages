BEGIN
 
with limits as
(
  select min(id) as id01, max(id) as id02
  from (select top 2 id, type from messages where type = 0 order by id) first2
)
, first_bulk as (
	SELECT m.* FROM (
		select ID, ROW_NUMBER() OVER (ORDER BY ID) AS ROW_NUM,
			type, LEAD(type) over(order by id) as next_type,
			msg, lead(msg) over(order by id) as next_msg  
			from messages m
  
	)  m
	where id > (select id01 from limits)
    and id < (select id02 from limits)
)
SELECT 
	CASE 
		WHEN not exists(SELECT 1 FROM first_bulk WHERE row_num != id) THEN 
		REPLACE ( CONCAT (msg, CASE WHEN next_type = 84 THEN next_msg ELSE '' END),' ','') 
		else 'Missing ID in the first bulk'		
	END 
from first_bulk
WHERE TYPE = 83

END
