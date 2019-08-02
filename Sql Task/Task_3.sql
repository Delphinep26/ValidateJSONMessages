CREATE PROCEDURE Client_GetDescendant
    @ClientId INT
AS
BEGIN
	WITH ClientCTE AS
	(
		SELECT  c1.Client_ID, c1.owner,c1.Client_Descr, 0 as level
		FROM  clients c1
		WHERE c1.Client_ID = @ClientId

		UNION

		SELECT   c2.Client_ID ,c2.owner,c2.Client_Descr, 1 as level
		FROM clients c2
		WHERE c2.owner = @ClientId

		UNION ALL

		SELECT c2.Client_ID , c2.owner, c2.Client_Descr , cte.level + 1
		FROM clients c2 JOIN ClientCTE cte ON c2.owner = cte.Client_ID
	)

	SELECT distinct Client_ID , owner, Client_Descr , level
	FROM ClientCTE
	ORDER BY level, owner;

END

EXEC Client_GetDescendant @ClientId = 2





