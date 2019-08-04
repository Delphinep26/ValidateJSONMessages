BEGIN
 
WITH limits AS
(
	SELECT MIN(id) as id01, MAX(id) AS id02
	FROM (SELECT TOP 2 id, type from messages WHERE type = 0 ORDER BY id) first2_0s
)
, first_bulk AS (
	SELECT m.* FROM (
			SELECT ID, ROW_NUMBER() OVER (ORDER BY ID) AS ROW_NUM,
			type, LEAD(type) over(ORDER BY id) AS next_type,
			msg, lead(msg) over(ORDER BY id) AS next_msg  
			FROM messages m
	) m
	WHERE id > (SELECT id01 from limits)
    AND id < (SELECT id02 from limits)
)
SELECT 
	CASE 
		WHEN not exists(SELECT 1 FROM first_bulk WHERE row_num != id) THEN 
		REPLACE ( CONCAT (msg, CASE WHEN next_type = 84 THEN next_msg ELSE '' END),' ','') 
		ELSE 'Missing ID in the first bulk'		
	END 

FROM first_bulk
WHERE TYPE = 83
END
