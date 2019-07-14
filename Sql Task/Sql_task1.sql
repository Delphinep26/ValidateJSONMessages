 SELECT 
	case  
		WHEN type = 84 and prev_type = 83 THEN REPLACE(CONCAT(PREV_MSG,MSG),' ', '')
		WHEN type = 83 and prev_type = 84 THEN MSG
	END AS MSG
FROM (
		SELECT id,ROW_NUMBER() OVER(order by id ) as row_num ,type,LAG(type) OVER(order by id ) as prev_type , msg ,LAG(msg) over(order by id) as prev_msg  
		FROM 
		(
				SELECT * ---id ,type , msg 
				FROM 
		        (
					SELECT min(ID) as start_bulk  , max(ID) as  end_bulk
					FROM(
						SELECT top 2 id , type FROM Messages WHERE type = '000'
						order by id ASC) as tmp
					GROUP BY type
					
				) as bulk_num , Messages

				WHERE id > start_bulk and id < end_bulk
	    ) as first_bulk

		)
as final_result
WHERE row_num = id