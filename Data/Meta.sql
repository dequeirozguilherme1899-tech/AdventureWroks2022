WITH Quotas AS (
    SELECT 
        BusinessEntityID,
        QuotaDate,
        SalesQuota,
        LEAD(QuotaDate) OVER (PARTITION BY BusinessEntityID ORDER BY QuotaDate) AS ProximaQuota
    FROM Sales.SalesPersonQuotaHistory
),
Calendario AS (
    SELECT CAST('2011-01-01' AS DATE) AS Mes
    UNION ALL
    SELECT DATEADD(MONTH, 1, Mes)
    FROM Calendario
    WHERE Mes < '2014-06-01'  -- até junho de 2014
)
SELECT 
    q.BusinessEntityID,
   FORMAT (c.Mes, 'dd/MM/yyyy') Mes,
   format (q.SalesQuota, 'c0') AS MetaMensal
FROM Quotas q
CROSS APPLY (
    SELECT Mes 
    FROM Calendario c
    WHERE c.Mes >= q.QuotaDate 
      AND (c.Mes < q.ProximaQuota OR q.ProximaQuota IS NULL)
) c
ORDER BY q.BusinessEntityID, c.Mes
OPTION (MAXRECURSION 0);
