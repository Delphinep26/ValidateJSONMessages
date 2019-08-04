
SELECT m.*
INTO first_bulk_tmp
	FROM (
	SELECT 
		     m.type,m.msg,m.id,
			 ROW_NUMBER() OVER(ORDER BY id) AS row_num,
             LEAD(type) OVER (ORDER BY id) as next_type,
             LEAD(msg) OVER (ORDER BY id) as next_msg,
             SUM(CASE WHEN type = 0 THEN 1 ELSE 0 END) OVER (ORDER BY id) AS num_0s
      FROM Messages m
	  ) m
WHERE num_0s = 1 

IF NOT EXISTS(SELECT 1 FROM first_bulk_tmp WHERE row_num != id) 
BEGIN
    SELECT 
	REPLACE(CONCAT(msg, CASE WHEN next_type = 84 THEN next_msg ELSE '' END),' ','') 
	FROM first_bulk_tmp
	WHERE TYPE = 83
END
ELSE
BEGIN
   PRINT 'Missing ID in the first bulk' 
END


