SELECT name,telephone,address,town,department,
	   IIF((manufacture IS NOT NULL),CONCAT(trim(manufacture),',',trim(model),','),'') AS device
     
FROM TBL_Employees 
LEFT JOIN TBL_Devices
ON TBL_Employees.device_id = TBL_Devices.id
LEFT JOIN TBL_Departments
ON TBL_Employees.department_Id = TBL_departments.ID