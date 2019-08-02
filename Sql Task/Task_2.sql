SELECT REPLACE(concat(msg, (CASE WHEN next_type = 84 THEN next_msg ELSE '' END)),' ','')
FROM (SELECT m.*,
		     ROW_NUMBER() OVER (ORDER BY id ) AS row_num,
             LEAD(type) OVER (ORDER BY id) AS next_type,
             LEAD(msg) OVER (ORDER BY id) AS next_msg,
             SUM(CASE WHEN TYPE = 0 THEN 1 ELSE 0 END) OVER (ORDER BY id) AS num_0s
      from Messages m
     ) m
WHERE num_0s = 1 and 
      type = 83 and 
	  row_num = id;